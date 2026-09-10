import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import '../theme/typography.dart';
import 'app_buttons.dart';

/// The 38×4 grabber every sheet in the design opens with.
class SheetGrabber extends StatelessWidget {
  const SheetGrabber({super.key, this.bottom = 18});

  final double bottom;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(bottom: bottom),
        child: Center(
          child: Container(
            width: 38,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.starEmpty,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      );
}

/// Sheet body: paper surface, rounded top corners, grabber, scrollable content.
class AppSheet extends StatelessWidget {
  const AppSheet({
    super.key,
    required this.child,
    this.radius = AppRadius.sheetSmall,
    this.padding = const EdgeInsets.fromLTRB(22, 20, 22, 30),
    this.maxHeightFraction = .88,
    this.background = AppColors.paper,
  });

  final Widget child;
  final double radius;
  final EdgeInsets padding;
  final double maxHeightFraction;
  final Color background;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return Container(
      constraints: BoxConstraints(
        maxHeight: media.size.height * maxHeightFraction,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(radius)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [const SheetGrabber(), child],
          ),
        ),
      ),
    );
  }
}

/// Presents a sheet with the design's scrim, curve and swipe-to-dismiss.
Future<T?> showAppSheet<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  bool dismissible = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: const Color(0x6B14110D),
    isScrollControlled: true,
    isDismissible: dismissible,
    enableDrag: dismissible,
    useRootNavigator: true,
    sheetAnimationStyle: AnimationStyle(
      duration: AppMotion.sheet,
      curve: AppMotion.sheetCurve,
      reverseDuration: const Duration(milliseconds: 220),
    ),
    builder: builder,
  );
}

/// The confirmation dialog. Destructive prompts always name what is lost and
/// what survives, so [message] is written per call site rather than reused.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  String cancelLabel = 'Keep it',
  bool destructive = true,
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierColor: const Color(0x8014110D),
    useRootNavigator: true,
    builder: (context) => Dialog(
      backgroundColor: AppColors.paper,
      insetPadding: const EdgeInsets.all(34),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.dialog),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 24, 22, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: AppText.serif(size: 22, height: 1.2)),
            const SizedBox(height: 9),
            Text(
              message,
              style: AppText.sans(
                size: 13.5,
                height: 1.55,
                color: AppColors.muted,
              ),
            ),
            const SizedBox(height: 20),
            if (destructive)
              DestructiveButton(
                label: confirmLabel,
                filled: true,
                onPressed: () => Navigator.of(context).pop(true),
              )
            else
              PrimaryButton(
                label: confirmLabel,
                height: 50,
                onPressed: () => Navigator.of(context).pop(true),
              ),
            const SizedBox(height: 8),
            SizedBox(
              height: 50,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF5A5248),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.button),
                  ),
                ),
                child: Text(
                  cancelLabel,
                  style: AppText.sans(
                    size: 15,
                    weight: 500,
                    color: const Color(0xFF5A5248),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
  return result ?? false;
}
