import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n_extensions.dart';
import '../../../core/providers.dart';
import '../../../core/routing/routes.dart';
import '../../../core/utils/cover_picker.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/theme/typography.dart';
import '../../../core/utils/isbn.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/app_icons.dart';
import '../../../core/widgets/app_sheet.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../core/widgets/book_cover.dart';
import '../../../core/widgets/layout.dart';
import '../../../core/widgets/pills.dart';
import '../../../data/local/image_store.dart';
import '../../../data/metadata/book_metadata.dart';
import '../../../data/repositories/collection_mutations.dart';
import '../../../domain/models/book_draft.dart';
import '../../../domain/models/enums.dart';
import 'widgets/editable_field.dart';

/// What the Add/Edit screen was opened for.
class AddBookArgs {
  const AddBookArgs({
    this.prefill,
    this.existingWorkId,
    this.workId,
    this.initialIsbn,
    this.unknownToProviders = false,
  });

  /// Fields already known — from a scan or from the work being extended.
  final BookDraft? prefill;

  /// Adding another edition of a work already on the shelves.
  final String? existingWorkId;

  /// Editing the book and edition records of an existing work.
  final String? workId;

  /// Pre-filled ISBN from manual entry in the scanner.
  final String? initialIsbn;

  /// True when a lookup already came back empty for this ISBN, so the book is
  /// worth offering back to the shared database once the user has typed it in.
  final bool unknownToProviders;
}

/// Manual entry, and the editor for a book already in the library. The two are
/// the same form; only the title bar and the save action differ.
class AddBookScreen extends ConsumerStatefulWidget {
  const AddBookScreen({super.key, this.draft});

  final AddBookArgs? draft;

  @override
  ConsumerState<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends ConsumerState<AddBookScreen> {
  final _controllers = <String, TextEditingController>{};
  BookDraft _draft = BookDraft();
  bool _loading = true;
  bool _saving = false;
  bool _lookingUp = false;
  bool _pickingCover = false;

  /// Covers written during this edit that were then replaced or removed. They
  /// are only deleted once the user saves, so cancelling leaves the original
  /// file untouched.
  final _discardedCovers = <String>[];

  /// Covers stored during this edit. If the edit is abandoned none of them
  /// were ever referenced by a book, so they go with it.
  final _pickedCovers = <String>[];
  bool _saved = false;

  bool get _isEditing => widget.draft?.workId != null;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    // Nothing saved means nothing is pointing at the files this edit created.
    if (!_saved) {
      for (final path in _pickedCovers) {
        unawaited(const ImageStore().delete(path));
      }
    }
    super.dispose();
  }

  TextEditingController _controller(String key, String? initial) =>
      _controllers.putIfAbsent(
        key,
        () => TextEditingController(text: initial ?? ''),
      );

  Future<void> _load() async {
    final args = widget.draft;

    if (args?.workId != null) {
      final details = await ref
          .read(libraryRepositoryProvider)
          .bookDetails(args!.workId!);
      if (details != null) {
        _draft = BookDraft.fromRows(
          work: details.work,
          edition: details.primaryEdition?.edition,
          copy: details.primaryCopy,
        );
      }
    } else if (args?.prefill != null) {
      _draft = args!.prefill!.copy();
      if (args.existingWorkId != null) _draft.workId = args.existingWorkId;
    } else if (args?.initialIsbn != null) {
      _draft = BookDraft()..isbnInput = args!.initialIsbn!;
    }

    if (mounted) setState(() => _loading = false);
  }

  /// Filling in an ISBN by hand should still pull the metadata — the design's
  /// "Scanning fills every field below automatically" applies here too.
  Future<void> _lookupIsbn() async {
    final l10n = context.l10n;
    final raw = _controller('isbn', _draft.isbnDisplay).text;
    if (!Isbn.isValid(raw)) {
      AppToast.show(context, l10n.isbnInvalidToast, success: false);
      return;
    }

    setState(() => _lookingUp = true);
    try {
      final metadata =
          await ref.read(bookMetadataRepositoryProvider).lookupByIsbn(raw);
      if (!mounted) return;
      final found = metadata.toDraft()
        ..workId = _draft.workId
        ..editionId = _draft.editionId
        ..ownership = _draft.ownership
        ..readingStatus = _draft.readingStatus;
      setState(() {
        _draft = found;
        _controllers.clear();
      });
      AppToast.show(context, l10n.toastFilledFromIsbn(metadata.title));
    } on MetadataException catch (e) {
      if (!mounted) return;
      AppToast.show(
        context,
        switch (e.failure) {
          MetadataFailure.notFound => l10n.toastIsbnNotFound,
          MetadataFailure.network => l10n.toastIsbnOffline,
          _ => l10n.toastIsbnLookupFailed,
        },
        success: false,
      );
    } finally {
      if (mounted) setState(() => _lookingUp = false);
    }
  }

  void _collect() {
    String? read(String key) {
      final text = _controllers[key]?.text.trim();
      return text == null || text.isEmpty ? null : text;
    }

    _draft
      ..title = read('title') ?? _draft.title
      ..originalTitle = read('originalTitle')
      ..originalLanguage = read('originalLanguage')
      ..description = read('description')
      ..seriesName = read('series')
      ..seriesIndex = int.tryParse(read('seriesIndex') ?? '')
      ..firstPublished = int.tryParse(read('firstPublished') ?? '')
      ..publisher = read('publisher')
      ..publicationDate = read('published')
      ..publishedYear = int.tryParse(
        RegExp(r'(\d{4})').firstMatch(read('published') ?? '')?.group(1) ?? '',
      )
      ..language = read('language')
      ..format = read('format')
      ..editionName = read('editionName')
      ..pageCount = int.tryParse(read('pages') ?? '')
      ..country = read('country')
      ..translator = read('translator');

    final authors = read('author');
    if (authors != null) _draft.authorLine = authors;
    final genres = read('genre');
    _draft.genreLine = genres ?? '';
    final isbn = read('isbn');
    if (isbn != null) {
      _draft.isbnInput = isbn;
    } else {
      _draft
        ..isbn13 = null
        ..isbn10 = null;
    }
  }

  Future<void> _save() async {
    final l10n = context.l10n;
    _collect();
    if (!_draft.isValid) {
      AppToast.show(context, l10n.toastTitleRequired, success: false);
      return;
    }

    setState(() => _saving = true);
    final db = ref.read(databaseProvider);

    // The edit is going through, so the covers it replaced are now orphans,
    // and the one it kept must survive this screen.
    _saved = true;
    for (final path in _discardedCovers) {
      unawaited(const ImageStore().delete(path));
    }
    _discardedCovers.clear();
    _pickedCovers.removeWhere((path) => path == _draft.coverImagePath);

    try {
      if (_isEditing) {
        await db.saveDraft(_draft);
        if (!mounted) return;
        AppToast.show(context, l10n.toastChangesSaved);
        // Corrections are worth having: the cover this edit added, the page
        // count it fixed. Sent quietly — the user asked to save, not publish.
        final shared = _shareWithCatalogue(
          Navigator.of(context, rootNavigator: true).context,
          l10n,
          announce: false,
        );
        context.pop();
        unawaited(shared);
        return;
      }

      if (_draft.ownership == Ownership.wishlist) {
        await ref.read(wishlistRepositoryProvider).add(draft: _draft);
        if (!mounted) return;
        AppToast.show(context, l10n.toastAddedToWishlist);
        context.pop();
        return;
      }

      final result = await db.addBook(_draft);
      if (!mounted) return;
      AppToast.show(
        context,
        result.clearedWishlist
            ? l10n.toastAddedClearedWishlist
            : result.createdEdition && !result.createdWork
                ? l10n.toastEditionAdded
                : l10n.toastAddedToLibrary,
      );
      // Started before the pop, so the provider is read while this screen is
      // still alive, and handed a context that outlives it for the toast.
      final shared = (widget.draft?.unknownToProviders ?? false)
          ? _shareWithCatalogue(
              Navigator.of(context, rootNavigator: true).context,
              l10n,
              announce: true,
            )
          : Future<void>.value();
      context.pop();
      unawaited(shared);
    } catch (e) {
      // Nothing was written, so the cover this edit picked is still an orphan
      // and must be cleaned up if the screen is closed.
      _saved = false;
      if (!mounted) return;
      setState(() => _saving = false);
      AppToast.show(context, l10n.toastCouldNotSave, success: false);
    }
  }

  /// Reads the ISBN off the book rather than making the user type thirteen
  /// digits, then fills the rest of the form from it.
  Future<void> _scanIsbn() async {
    final isbn = await context.push<String>(Routes.scanIsbn);
    if (isbn == null || !mounted) return;

    _controller('isbn', '').text = Isbn.display(isbn);
    _draft.isbnInput = isbn;
    setState(() {});
    await _lookupIsbn();
  }

  /// A manually entered book has no cover to fetch, so the user supplies one.
  /// The picked file lives in a cache the system may clear, so it is copied
  /// into the app's own storage before it is recorded.
  Future<void> _pickCover() async {
    final l10n = context.l10n;
    final existing = _draft.coverImagePath;

    final action = await showAppSheet<_CoverAction>(
      context,
      builder: (sheetContext) => AppSheet(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(context.l10n.coverSheetTitle, style: AppText.sheetTitle),
            const SizedBox(height: 6),
            Text(
              context.l10n.coverSheetSubtitle,
              style: AppText.sans(
                size: 13,
                height: 1.5,
                color: AppColors.muted,
              ),
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              label: context.l10n.coverTakePhoto,
              onPressed: () =>
                  Navigator.of(sheetContext).pop(_CoverAction.camera),
            ),
            const SizedBox(height: 9),
            SecondaryButton(
              label: context.l10n.coverChoosePicture,
              height: 50,
              fontSize: 15,
              onPressed: () =>
                  Navigator.of(sheetContext).pop(_CoverAction.gallery),
            ),
            if (existing != null && existing.isNotEmpty) ...[
              const SizedBox(height: 9),
              SecondaryButton(
                label: context.l10n.coverAdjustCrop,
                height: 50,
                fontSize: 15,
                onPressed: () =>
                    Navigator.of(sheetContext).pop(_CoverAction.recrop),
              ),
              const SizedBox(height: 9),
              DestructiveButton(
                label: context.l10n.coverRemove,
                onPressed: () =>
                    Navigator.of(sheetContext).pop(_CoverAction.remove),
              ),
            ],
          ],
        ),
      ),
    );

    if (action == null || !mounted) return;

    if (action == _CoverAction.remove) {
      setState(() {
        if (existing != null) _discardedCovers.add(existing);
        _draft.coverImagePath = null;
      });
      return;
    }

    setState(() => _pickingCover = true);
    try {
      const picker = CoverPicker();

      // Re-framing works on the file already stored, so backing out of the
      // cropper leaves the existing cover exactly as it was.
      final cropped = action == _CoverAction.recrop
          ? await picker.crop(existing!, l10n: l10n)
          : await picker.pickAndCrop(
              l10n: l10n,
              source: action == _CoverAction.camera
                  ? CoverSource.camera
                  : CoverSource.gallery,
            );
      if (cropped == null || !mounted) return;

      final stored = await const ImageStore().save(cropped);
      if (!mounted) return;

      setState(() {
        if (existing != null && existing.isNotEmpty) {
          _discardedCovers.add(existing);
        }
        _pickedCovers.add(stored);
        _draft.coverImagePath = stored;
        // A picture the user chose outranks whatever a provider supplied.
        _draft.coverUrl = null;
      });
    } catch (_) {
      if (!mounted) return;
      AppToast.show(
        context,
        switch (action) {
          _CoverAction.camera => l10n.toastCouldNotOpenCamera,
          _CoverAction.gallery => l10n.toastCouldNotOpenPictures,
          _ => l10n.toastCouldNotOpenCropper,
        },
        success: false,
      );
    } finally {
      if (mounted) setState(() => _pickingCover = false);
    }
  }

  /// Sends the book to the shared catalogue.
  ///
  /// Two moments get here: a book a scan could not find, the first time it is
  /// saved, and every edit to a book already on the shelves — a cover added
  /// later, a page count corrected.
  ///
  /// [announce] is for the first case only. Volunteering an unknown book is
  /// something the reader did, so it is worth a word back; saving an edit is
  /// not, and a "queued for review" toast after changing a page count would
  /// only puzzle.
  ///
  /// Only the book's own facts travel — title, author and edition. Notes,
  /// purchase details, photos and shelves never leave the device.
  ///
  /// Everything up to the first await runs before the screen closes; the
  /// [context] is the root navigator's, which outlives it.
  Future<void> _shareWithCatalogue(
    BuildContext context,
    AppL10n l10n, {
    required bool announce,
  }) async {
    final scraper = ref.read(bookScraperSourceProvider);
    if (scraper == null || !scraper.isConfigured) return;

    // The ISBN is the identity the catalogue is built on. A book without one
    // would merge on a fuzzy fingerprint, so it stays on this device.
    final isbn = _draft.isbn13 ?? _draft.isbn10;
    if (isbn == null || !Isbn.isValid(isbn)) return;

    try {
      final message = await scraper.suggest(
        title: _draft.title,
        isbn: isbn,
        authors: _draft.authors,
        publisher: _draft.publisher,
        publishedYear: _draft.publishedYear,
        pages: _draft.pageCount,
        language: _draft.language,
        description: _draft.description,
        // A cover the reader photographed goes with it — often the only one
        // in existence for a book no shop has listed.
        coverImagePath: _draft.coverImagePath,
      );
      if (announce && context.mounted) AppToast.show(context, message);
    } on MetadataException catch (e) {
      // The book is saved either way; this only reports what the send did.
      if (!announce || !context.mounted) return;
      AppToast.show(
        context,
        e.failure == MetadataFailure.network
            ? l10n.shareOffline
            : e.message ?? l10n.shareRejected,
        success: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: AppColors.paper,
        body: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.accent,
            ),
          ),
        ),
      );
    }

    final addingEdition = widget.draft?.existingWorkId != null;

    return Scaffold(
      backgroundColor: AppColors.paper,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.screenH,
            20,
            AppSpacing.screenH,
            AppSpacing.modalBottom +
                MediaQuery.viewInsetsOf(context).bottom,
          ),
          children: [
            ModalTopBar(
              title: _isEditing
                  ? context.l10n.editBookTitle
                  : addingEdition
                      ? context.l10n.addEditionTitle
                      : context.l10n.addBookTitle,
              onCancel: () => context.pop(),
              onSave: _save,
              saveEnabled: !_saving,
            ),
            const SizedBox(height: 22),
            _CoverRow(
              draft: _draft,
              isEditing: _isEditing,
              busy: _pickingCover,
              onPickCover: _pickCover,
            ),
            SectionLabel(context.l10n.sectionTheBook),
            PaperCard(
              children: [
                EditableFieldRow(
                  label: context.l10n.fieldTitle,
                  controller: _controller('title', _draft.title),
                  hint: context.l10n.hintRequired,
                  textCapitalization: TextCapitalization.words,
                ),
                EditableFieldRow(
                  label: context.l10n.fieldAuthor,
                  controller: _controller('author', _draft.authorLine),
                  hint: context.l10n.hintAuthors,
                  textCapitalization: TextCapitalization.words,
                ),
                EditableFieldRow(
                  label: context.l10n.fieldOriginalTitle,
                  controller:
                      _controller('originalTitle', _draft.originalTitle),
                ),
                EditableFieldRow(
                  label: context.l10n.fieldGenre,
                  controller: _controller('genre', _draft.genreLine),
                  hint: context.l10n.hintGenres,
                  textCapitalization: TextCapitalization.words,
                ),
                EditableFieldRow(
                  label: context.l10n.fieldSeries,
                  controller: _controller('series', _draft.seriesName),
                ),
                EditableFieldRow(
                  label: context.l10n.fieldFirstPublished,
                  controller: _controller(
                    'firstPublished',
                    _draft.firstPublished?.toString(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                EditableFieldRow(
                  label: context.l10n.fieldDescription,
                  controller: _controller('description', _draft.description),
                  maxLines: 5,
                  last: true,
                ),
              ],
            ),
            SectionLabel(context.l10n.sectionThisEdition, top: 24),
            PaperCard(
              children: [
                EditableFieldRow(
                  label: context.l10n.fieldIsbn,
                  controller: _controller('isbn', _draft.isbnDisplay),
                  hint: context.l10n.hintIsbn,
                  keyboardType: TextInputType.number,
                  textCapitalization: TextCapitalization.none,
                  trailing: _ScanIsbnButton(onTap: _scanIsbn),
                ),
                EditableFieldRow(
                  label: context.l10n.fieldLanguage,
                  controller: _controller('language', _draft.language),
                  textCapitalization: TextCapitalization.words,
                ),
                EditableFieldRow(
                  label: context.l10n.fieldPublisher,
                  controller: _controller('publisher', _draft.publisher),
                  textCapitalization: TextCapitalization.words,
                ),
                EditableFieldRow(
                  label: context.l10n.fieldEdition,
                  controller: _controller('editionName', _draft.editionName),
                  textCapitalization: TextCapitalization.words,
                ),
                EditableFieldRow(
                  label: context.l10n.fieldFormat,
                  controller: _controller('format', _draft.format),
                  hint: context.l10n.hintFormats,
                  textCapitalization: TextCapitalization.words,
                ),
                EditableFieldRow(
                  label: context.l10n.fieldPublished,
                  controller: _controller(
                    'published',
                    _draft.publicationDate ??
                        _draft.publishedYear?.toString(),
                  ),
                ),
                EditableFieldRow(
                  label: context.l10n.fieldPages,
                  controller:
                      _controller('pages', _draft.pageCount?.toString()),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                EditableFieldRow(
                  label: context.l10n.fieldCountry,
                  controller: _controller('country', _draft.country),
                  textCapitalization: TextCapitalization.words,
                ),
                EditableFieldRow(
                  label: context.l10n.fieldTranslator,
                  controller: _controller('translator', _draft.translator),
                  textCapitalization: TextCapitalization.words,
                  last: true,
                ),
              ],
            ),
            const SizedBox(height: 10),
            SecondaryButton(
              label: _lookingUp
                  ? context.l10n.addLookingUp
                  : context.l10n.addFillFromIsbn,
              height: 44,
              fontSize: 13.5,
              fontWeight: 600,
              onPressed: _lookingUp ? null : _lookupIsbn,
            ),
            if (!_isEditing) ...[
              SectionLabel(context.l10n.sectionStatus, top: 24),
              ChipWrap(
                children: [
                  for (final ownership in Ownership.values)
                    AppChip(
                      label: ownership.display(context.l10n),
                      selected: _draft.ownership == ownership,
                      onTap: () =>
                          setState(() => _draft.ownership = ownership),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              ChipWrap(
                children: [
                  for (final status in ReadingStatus.values)
                    AppChip(
                      label: status.display(context.l10n),
                      selected: _draft.readingStatus == status,
                      onTap: () =>
                          setState(() => _draft.readingStatus = status),
                    ),
                ],
              ),
            ],
            const SizedBox(height: 26),
            PrimaryButton(
              label: _isEditing
                  ? context.l10n.addSaveChanges
                  : _draft.ownership == Ownership.wishlist
                      ? context.l10n.addToWishlist
                      : context.l10n.scanAddToLibrary,
              busy: _saving,
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }
}

/// The barcode button that sits in the ISBN row.
class _ScanIsbnButton extends StatelessWidget {
  const _ScanIsbnButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
        button: true,
        label: context.l10n.scanIsbnSemantic,
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: 34,
            height: 34,
            margin: const EdgeInsets.only(left: 6),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.ink,
              borderRadius: BorderRadius.circular(9),
            ),
            child: const AppIcon(
              AppIcons.barcode,
              size: 17,
              color: AppColors.paper,
            ),
          ),
        ),
      );
}

enum _CoverAction { camera, gallery, recrop, remove }

class _CoverRow extends StatelessWidget {
  const _CoverRow({
    required this.draft,
    required this.isEditing,
    required this.busy,
    required this.onPickCover,
  });

  final BookDraft draft;
  final bool isEditing;
  final bool busy;
  final VoidCallback onPickCover;

  @override
  Widget build(BuildContext context) {
    final hasCover = (draft.coverImagePath ?? '').isNotEmpty ||
        (draft.coverUrl ?? '').isNotEmpty;

    return Row(
      children: [
        GestureDetector(
          onTap: busy ? null : onPickCover,
          child: SizedBox(
            width: 76,
            height: 114,
            child: busy
                ? const Center(
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.accent,
                      ),
                    ),
                  )
                : hasCover
                    ? BookCover(
                        title: draft.title,
                        author: draft.authors.isEmpty
                            ? null
                            : draft.authors.first,
                        colorIndex: draft.coverColorIndex,
                        coverUrl: draft.coverUrl,
                        coverImagePath: draft.coverImagePath,
                        width: 76,
                        height: 114,
                        titleSize: 12,
                        authorSize: 6.5,
                        spineWidth: 5,
                      )
                    : draft.title.trim().isEmpty
                        ? CustomPaint(
                            painter: const DashedBorderPainter(
                              radius: AppRadius.cover,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const AppIcon(
                                  AppIcons.image,
                                  size: 18,
                                  color: AppColors.faint,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  context.l10n.coverSheetTitle,
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    color: AppColors.faint,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : BookCover(
                            title: draft.title,
                            author: draft.authors.isEmpty
                                ? null
                                : draft.authors.first,
                            colorIndex: draft.coverColorIndex,
                            width: 76,
                            height: 114,
                            titleSize: 12,
                            authorSize: 6.5,
                            spineWidth: 5,
                          ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: isEditing
              ? Text(
                  context.l10n.addEditHint,
                  style: AppText.sans(
                    size: 12.5,
                    height: 1.5,
                    color: AppColors.muted,
                  ),
                )
              : Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: '${context.l10n.addScanHint} '),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: GestureDetector(
                          onTap: () {
                            context.pop();
                            context.push(Routes.scanner);
                          },
                          child: Text(
                            context.l10n.addScanInstead,
                            style: AppText.sans(
                              size: 12.5,
                              weight: 600,
                              color: AppColors.accent,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  style: AppText.sans(
                    size: 12.5,
                    height: 1.5,
                    color: AppColors.muted,
                  ),
                ),
        ),
      ],
    );
  }
}
