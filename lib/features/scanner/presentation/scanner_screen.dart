import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/l10n_extensions.dart';
import '../../../core/providers.dart';
import '../../../core/routing/routes.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/theme/typography.dart';
import '../../../core/utils/isbn.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/app_icons.dart';
import '../../../core/widgets/app_sheet.dart';
import '../../../data/repositories/scan_service.dart';
import '../../../domain/models/enums.dart';
import '../../books/presentation/add_book_screen.dart';
import 'widgets/scan_result_sheet.dart';
import 'widgets/scanner_overlay.dart';

/// The camera screen. Point at a barcode, get a verdict in one sheet, and
/// carry on down the shelf with "Scan next".
class ScannerScreen extends ConsumerStatefulWidget {
  const ScannerScreen({super.key, this.captureOnly = false});

  /// Reads a barcode and hands the ISBN back to whoever pushed this screen,
  /// instead of looking the book up. Used by the editor, so a book being typed
  /// in by hand does not need its thirteen digits typed too.
  final bool captureOnly;

  @override
  ConsumerState<ScannerScreen> createState() => _ScannerScreenState();
}

enum _CameraState { starting, ready, denied, unsupported, failed }

class _ScannerScreenState extends ConsumerState<ScannerScreen>
    with WidgetsBindingObserver {
  MobileScannerController? _controller;
  StreamSubscription<BarcodeCapture>? _subscription;

  _CameraState _cameraState = _CameraState.starting;

  /// True from the moment a barcode is accepted until the user asks to scan
  /// again — this is what stops the same book being scanned over and over.
  bool _handling = false;
  bool _torchOn = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _subscription?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _controller;
    if (controller == null || _cameraState != _CameraState.ready) return;

    switch (state) {
      case AppLifecycleState.resumed:
        if (!_handling) unawaited(controller.start());
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
      case AppLifecycleState.detached:
        unawaited(controller.stop());
    }
  }

  Future<void> _startCamera() async {
    await _subscription?.cancel();
    await _controller?.dispose();
    _subscription = null;
    _controller = null;

    setState(() => _cameraState = _CameraState.starting);

    // Ask before starting, so a denial produces our own screen rather than a
    // platform error.
    final status = await Permission.camera.request();
    if (!mounted) return;

    if (status.isPermanentlyDenied || status.isDenied || status.isRestricted) {
      setState(() => _cameraState = _CameraState.denied);
      return;
    }

    final controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      // Book barcodes are EAN-13; ISBN-10 books sometimes carry EAN-8.
      formats: const [BarcodeFormat.ean13, BarcodeFormat.ean8],
      autoStart: false,
    );

    setState(() {
      _controller = controller;
      _subscription = controller.barcodes.listen(_onDetect);
    });

    // The controller can only be started once the MobileScanner widget that
    // owns the preview has been built, so wait for that frame first.
    WidgetsBinding.instance.addPostFrameCallback((_) => _attachCamera(controller));
  }

  Future<void> _attachCamera(MobileScannerController controller) async {
    try {
      await controller.start();
      if (mounted && _controller == controller) {
        setState(() => _cameraState = _CameraState.ready);
      }
    } on MobileScannerException catch (e) {
      if (!mounted || _controller != controller) return;
      setState(() {
        _cameraState = switch (e.errorCode) {
          MobileScannerErrorCode.permissionDenied => _CameraState.denied,
          MobileScannerErrorCode.unsupported => _CameraState.unsupported,
          _ => _CameraState.failed,
        };
      });
    } catch (e) {
      if (!mounted || _controller != controller) return;
      setState(() {
        _cameraState = _CameraState.failed;
      });
    }
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_handling) return;
    final raw = capture.barcodes
        .map((b) => b.rawValue)
        .whereType<String>()
        .firstWhere((v) => v.isNotEmpty, orElse: () => '');
    if (raw.isEmpty) return;

    if (widget.captureOnly) {
      final isbn = Isbn.fromBarcode(raw);
      if (isbn == null) {
        // Not a book barcode. Keep scanning rather than closing on a failure.
        return;
      }
      setState(() => _handling = true);
      await _controller?.stop();
      unawaited(HapticFeedback.mediumImpact());
      if (mounted) context.pop(isbn);
      return;
    }

    await _resolve(raw, fromCamera: true);
  }

  Future<void> _resolve(String raw, {required bool fromCamera}) async {
    setState(() => _handling = true);
    // Stop immediately so the shelf behind the sheet is not re-scanned.
    await _controller?.stop();
    unawaited(HapticFeedback.mediumImpact());

    try {
      final result = fromCamera
          ? await ref.read(scanServiceProvider).resolveBarcode(raw)
          : await ref.read(scanServiceProvider).resolveIsbn(raw);
      if (!mounted) return;

      final action = await showAppSheet<ScanNextAction>(
        context,
        builder: (_) => ScanResultSheet(result: result),
      );
      await _afterSheet(action, result);
    } on ScanFailure catch (failure) {
      if (!mounted) return;
      await showAppSheet<void>(
        context,
        builder: (sheetContext) => ScanErrorSheet(
          failure: failure,
          onRetry: () {
            Navigator.of(sheetContext).pop();
            _resume();
          },
          onManual: () {
            Navigator.of(sheetContext).pop();
            // A barcode that read fine but matched nothing does not need
            // typing again — carry the ISBN into the editor instead.
            if (failure.kind == ScanFailureKind.notFound &&
                failure.isbn != null) {
              _addByHand(failure.isbn!);
            } else {
              _enterManually(prefill: failure.isbn);
            }
          },
        ),
      );
      if (mounted && _handling) _resume();
    }
  }

  /// The sheet is gone by the time this runs, so this is where any navigation
  /// happens: a route pushed from the sheet's own context would be pushed from
  /// a deactivated element, and then popped again by the close below.
  Future<void> _afterSheet(ScanNextAction? action, ScanResult result) async {
    if (!mounted) return;

    switch (action) {
      case ScanNextAction.openBook:
        final workId = result.details?.work.id;
        if (context.canPop()) context.pop();
        if (workId != null && mounted) {
          context.push(Routes.bookDetails(workId));
        }

      case ScanNextAction.addWithDetails:
        final draft = result.toDraft()..ownership = Ownership.owned;
        if (context.canPop()) context.pop();
        if (mounted) {
          context.push(Routes.addBook, extra: AddBookArgs(prefill: draft));
        }

      case ScanNextAction.close:
        // The job is done — adding, wishlisting, or simply closing.
        if (context.canPop()) context.pop();

      case ScanNextAction.scanNext:
      case null:
        _resume();
    }
  }

  void _resume() {
    if (!mounted) return;
    setState(() => _handling = false);
    unawaited(_controller?.start());
  }

  Future<void> _toggleTorch() async {
    final controller = _controller;
    if (controller == null) return;
    try {
      await controller.toggleTorch();
      if (mounted) setState(() => _torchOn = !_torchOn);
    } catch (_) {
      // Not every camera has a torch; silently leave the button as it was.
    }
  }

  /// Opens the editor for an ISBN no provider could resolve. The scanner is
  /// closed behind it, so "Cancel" lands back on the library rather than on a
  /// camera the user has finished with.
  void _addByHand(String isbn) {
    if (!mounted) return;
    context.pop();
    context.push(
      Routes.addBook,
      extra: AddBookArgs(initialIsbn: isbn),
    );
  }

  Future<void> _enterManually({String? prefill}) async {
    final isbn = await showAppSheet<String>(
      context,
      builder: (_) => _ManualIsbnSheet(
        initial: prefill,
        captureOnly: widget.captureOnly,
      ),
    );
    if (!mounted) return;

    if (isbn == null) {
      if (_handling) _resume();
      return;
    }
    if (widget.captureOnly) {
      context.pop(isbn);
      return;
    }
    await _resolve(isbn, fromCamera: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkScene,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const _DarkScene(),
          if (_controller != null &&
              (_cameraState == _CameraState.starting ||
                  _cameraState == _CameraState.ready))
            MobileScanner(
              controller: _controller,
              fit: BoxFit.cover,
              errorBuilder: (context, error) => const _DarkScene(),
              placeholderBuilder: (context) => const _DarkScene(),
            ),
          switch (_cameraState) {
            _CameraState.ready => _ScannerChrome(
                handling: _handling,
                captureOnly: widget.captureOnly,
                torchOn: _torchOn,
                onClose: () => context.pop(),
                onToggleTorch: _toggleTorch,
                onSearch: () {
                  context.pop();
                  context.push(Routes.search);
                },
                onManual: _enterManually,
              ),
            _CameraState.starting => _CameraMessage(
                title: context.l10n.scannerStartingTitle,
                message: context.l10n.scannerStartingMessage,
                busy: true,
              ),
            _CameraState.denied => _CameraMessage(
                title: context.l10n.scannerDeniedTitle,
                message: context.l10n.scannerDeniedMessage,
                primaryLabel: context.l10n.scannerOpenSettings,
                onPrimary: openAppSettings,
                secondaryLabel: context.l10n.actionEnterIsbnManually,
                onSecondary: _enterManually,
                onClose: () => context.pop(),
              ),
            _CameraState.unsupported => _CameraMessage(
                title: context.l10n.scannerUnsupportedTitle,
                message: context.l10n.scannerUnsupportedMessage,
                primaryLabel: context.l10n.actionEnterIsbnManually,
                onPrimary: _enterManually,
                secondaryLabel: context.l10n.scannerAddByHand,
                onSecondary: () {
                  context.pop();
                  context.push(Routes.addBook);
                },
                onClose: () => context.pop(),
              ),
            _CameraState.failed => _CameraMessage(
                title: context.l10n.scannerFailedTitle,
                message: context.l10n.scannerFailedMessage,
                primaryLabel: context.l10n.actionTryAgain,
                onPrimary: _startCamera,
                secondaryLabel: context.l10n.actionEnterIsbnManually,
                onSecondary: _enterManually,
                onClose: () => context.pop(),
              ),
          },
        ],
      ),
    );
  }
}

/// The radial-gradient backdrop used whenever the preview is not showing.
class _DarkScene extends StatelessWidget {
  const _DarkScene();

  @override
  Widget build(BuildContext context) => const DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -.24),
            radius: 1.1,
            colors: [Color(0xFF3A332B), Color(0xFF17140F), Color(0xFF0C0A08)],
            stops: [0, .62, 1],
          ),
        ),
      );
}

class _ScannerChrome extends StatelessWidget {
  const _ScannerChrome({
    required this.handling,
    required this.captureOnly,
    required this.torchOn,
    required this.onClose,
    required this.onToggleTorch,
    required this.onSearch,
    required this.onManual,
  });

  final bool handling;
  final bool captureOnly;
  final bool torchOn;
  final VoidCallback onClose;
  final VoidCallback onToggleTorch;
  final VoidCallback onSearch;
  final VoidCallback onManual;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        final width = constraints.maxWidth;
        final top = MediaQuery.paddingOf(context).top;

        // The design's reticle inset, kept proportional so it still frames a
        // barcode on taller and shorter phones.
        final reticleTop = (height * .14).clamp(96.0, 180.0);
        final reticleBottom = (height * .34).clamp(220.0, 320.0);
        final reticle = Rect.fromLTRB(
          40,
          reticleTop,
          width - 40,
          height - reticleBottom,
        );

        return Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: ReticleDimPainter(reticle: reticle, radius: 16),
              ),
            ),
            Positioned.fromRect(
              rect: reticle,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const CornerBrackets(),
                  if (!handling)
                    ScanLine(travel: (reticle.height / 2 - 12).clamp(20, 90)),
                  if (handling)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xB3100E0C),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.highlightBright,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            captureOnly
                                ? context.l10n.scannerGotIt
                                : context.l10n.scannerLookingUp,
                            style: AppText.sans(
                              size: 13.5,
                              weight: 500,
                              color: AppColors.onboardingText,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Positioned(
              top: top + 14,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text(
                    captureOnly
                        ? context.l10n.scannerIsbnTitle
                        : context.l10n.scannerTitle,
                    style: AppText.serif(
                      size: 19,
                      color: AppColors.onboardingText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    captureOnly
                        ? context.l10n.scannerIsbnSubtitle
                        : context.l10n.scannerSubtitle,
                    style: AppText.sans(
                      size: 12.5,
                      color: const Color(0xFF8F857A),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: top + 6,
              left: 18,
              child: _RoundSceneButton(
                onTap: onClose,
                child: const AppIcon(
                  AppIcons.close,
                  size: 16,
                  color: AppColors.onboardingText,
                ),
              ),
            ),
            Positioned(
              top: top + 6,
              right: 18,
              child: _RoundSceneButton(
                onTap: onToggleTorch,
                active: torchOn,
                child: AppIcon(
                  AppIcons.flash,
                  size: 16,
                  color: torchOn ? AppColors.ink : AppColors.onboardingText,
                ),
              ),
            ),
            Positioned(
              left: 22,
              right: 22,
              bottom: MediaQuery.paddingOf(context).bottom + 40,
              child: Row(
                children: [
                  if (!captureOnly) ...[
                    Expanded(
                      child: ScannerButton(
                        label: context.l10n.scannerSearchByTitle,
                        onTap: onSearch,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: ScannerButton(
                      label: context.l10n.scannerTypeTheNumber,
                      onTap: onManual,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _RoundSceneButton extends StatelessWidget {
  const _RoundSceneButton({
    required this.child,
    required this.onTap,
    this.active = false,
  });

  final Widget child;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) => Material(
        color: active ? AppColors.highlightBright : const Color(0x1FF5EEE1),
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: SizedBox(width: 36, height: 36, child: Center(child: child)),
        ),
      );
}

class _CameraMessage extends StatelessWidget {
  const _CameraMessage({
    required this.title,
    required this.message,
    this.primaryLabel,
    this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
    this.onClose,
    this.busy = false,
  });

  final String title;
  final String message;
  final String? primaryLabel;
  final VoidCallback? onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  final VoidCallback? onClose;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          if (onClose != null)
            Positioned(
              top: 6,
              left: 18,
              child: _RoundSceneButton(
                onTap: onClose!,
                child: const AppIcon(
                  AppIcons.close,
                  size: 16,
                  color: AppColors.onboardingText,
                ),
              ),
            ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 34),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (busy)
                    const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.highlightBright,
                      ),
                    )
                  else
                    Container(
                      width: 44,
                      height: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0x1FF5EEE1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const AppIcon(
                        AppIcons.camera,
                        size: 21,
                        color: AppColors.highlightBright,
                      ),
                    ),
                  const SizedBox(height: 18),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: AppText.serif(
                      size: 22,
                      color: AppColors.onboardingText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: AppText.sans(
                      size: 13.5,
                      height: 1.5,
                      color: AppColors.onboardingSub,
                    ),
                  ),
                  if (primaryLabel != null) ...[
                    const SizedBox(height: 24),
                    SizedBox(
                      width: 260,
                      child: PrimaryButton(
                        label: primaryLabel!,
                        height: 50,
                        background: AppColors.onboardingText,
                        foreground: AppColors.ink,
                        onPressed: onPrimary,
                      ),
                    ),
                  ],
                  if (secondaryLabel != null) ...[
                    const SizedBox(height: 9),
                    SizedBox(
                      width: 260,
                      child: ScannerButton(
                        label: secondaryLabel!,
                        onTap: onSecondary ?? () {},
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Typing the 13 digits by hand — the escape hatch from every scanner failure.
class _ManualIsbnSheet extends StatefulWidget {
  const _ManualIsbnSheet({this.initial, this.captureOnly = false});

  final String? initial;
  final bool captureOnly;

  @override
  State<_ManualIsbnSheet> createState() => _ManualIsbnSheetState();
}

class _ManualIsbnSheetState extends State<_ManualIsbnSheet> {
  late final _controller = TextEditingController(text: widget.initial ?? '');
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final raw = _controller.text.trim();
    if (!Isbn.isValid(raw)) {
      setState(
        () => _error = raw.isEmpty
            ? context.l10n.isbnSheetEmpty
            : context.l10n.isbnSheetInvalid,
      );
      return;
    }
    Navigator.of(context).pop(Isbn.to13(raw) ?? Isbn.normalize(raw));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: AppSheet(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(context.l10n.isbnSheetTitle, style: AppText.sheetTitle),
            const SizedBox(height: 6),
            Text(
              context.l10n.isbnSheetSubtitle,
              style: AppText.sans(size: 13, color: AppColors.muted),
            ),
            const SizedBox(height: 16),
            Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: AppColors.paperRaised,
                borderRadius: BorderRadius.circular(AppRadius.input),
                border: Border.all(
                  color: _error == null ? AppColors.ink : AppColors.accent,
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  const AppIcon(
                    AppIcons.keyboard,
                    size: 17,
                    color: AppColors.muted2,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      cursorColor: AppColors.accent,
                      onChanged: (_) {
                        if (_error != null) setState(() => _error = null);
                      },
                      onSubmitted: (_) => _submit(),
                      style: AppText.sans(size: 16, weight: 500),
                      decoration: InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        hintText: '9780141036144',
                        hintStyle: AppText.sans(
                          size: 16,
                          color: AppColors.faint,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(
                _error!,
                style: AppText.sans(
                  size: 12.5,
                  height: 1.4,
                  color: AppColors.accent,
                ),
              ),
            ],
            const SizedBox(height: 16),
            PrimaryButton(
              label: widget.captureOnly
                  ? context.l10n.isbnSheetUseNumber
                  : context.l10n.isbnSheetLookUp,
              onPressed: _submit,
            ),
            // In capture mode the editor is already open behind this screen;
            // offering to open another one would only confuse.
            if (!widget.captureOnly) ...[
              const SizedBox(height: 9),
              SecondaryButton(
                label: context.l10n.isbnSheetAddWithout,
                height: 50,
                fontSize: 15,
                onPressed: () {
                  Navigator.of(context).pop();
                  context.pop();
                  context.push(Routes.addBook, extra: const AddBookArgs());
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
