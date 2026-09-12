import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers.dart';
import '../../../core/routing/routes.dart';
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
    final raw = _controller('isbn', _draft.isbnDisplay).text;
    if (!Isbn.isValid(raw)) {
      AppToast.show(context, 'That ISBN is not valid', success: false);
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
      AppToast.show(context, 'Filled in from ${metadata.title}');
    } on MetadataException catch (e) {
      if (!mounted) return;
      AppToast.show(
        context,
        switch (e.failure) {
          MetadataFailure.notFound => "We don't know that ISBN — fill it in yourself",
          MetadataFailure.network => 'No connection — fill it in yourself',
          _ => 'Lookup failed — fill it in yourself',
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
    _collect();
    if (!_draft.isValid) {
      AppToast.show(context, 'A title is required', success: false);
      return;
    }

    setState(() => _saving = true);
    final db = ref.read(databaseProvider);

    try {
      if (_isEditing) {
        await db.saveDraft(_draft);
        if (!mounted) return;
        AppToast.show(context, 'Changes saved');
        context.pop();
        return;
      }

      if (_draft.ownership == Ownership.wishlist) {
        await ref.read(wishlistRepositoryProvider).add(draft: _draft);
        if (!mounted) return;
        AppToast.show(context, 'Added to your wishlist');
        context.pop();
        return;
      }

      final result = await db.addBook(_draft);
      if (!mounted) return;
      AppToast.show(
        context,
        result.clearedWishlist
            ? 'Added to your library · cleared from wishlist'
            : result.createdEdition && !result.createdWork
                ? 'Edition added to your library'
                : 'Added to your library',
      );
      context.pop();
      await _offerToShare();
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      AppToast.show(context, "Couldn't save this book", success: false);
    }
  }

  /// A book nobody could look up is worth sending back to the shared database
  /// — but it is the user's text, so it is never sent without asking.
  Future<void> _offerToShare() async {
    if (!(widget.draft?.unknownToProviders ?? false)) return;

    final scraper = ref.read(bookScraperSourceProvider);
    if (scraper == null || !scraper.isConfigured) return;

    final isbn = _draft.isbn13 ?? _draft.isbn10;
    if (isbn == null || !Isbn.isValid(isbn)) return;
    if (!mounted) return;

    final share = await showConfirmDialog(
      context,
      title: 'Share this book?',
      message: 'No lookup service knows ${Isbn.display(isbn)}. Sending the '
          'title, author and edition details you just entered would let the '
          'next person scanning this book find it. Your own notes, purchase '
          'details and shelves are never sent.',
      confirmLabel: 'Share it',
      cancelLabel: 'Keep it to myself',
      destructive: false,
    );
    if (!share || !mounted) return;

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
      );
      if (mounted) AppToast.show(context, message);
    } on MetadataException catch (e) {
      if (!mounted) return;
      AppToast.show(
        context,
        e.failure == MetadataFailure.network
            ? "Couldn't reach the book database — your book is saved anyway"
            : e.message ?? "The book database wouldn't accept it",
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
                  ? 'Edit book'
                  : addingEdition
                      ? 'Add edition'
                      : 'Add book',
              onCancel: () => context.pop(),
              onSave: _save,
              saveEnabled: !_saving,
            ),
            const SizedBox(height: 22),
            _CoverRow(draft: _draft, isEditing: _isEditing),
            const SectionLabel('The book'),
            PaperCard(
              children: [
                EditableFieldRow(
                  label: 'Title',
                  controller: _controller('title', _draft.title),
                  hint: 'Required',
                  textCapitalization: TextCapitalization.words,
                ),
                EditableFieldRow(
                  label: 'Author',
                  controller: _controller('author', _draft.authorLine),
                  hint: 'Separate several with a comma',
                  textCapitalization: TextCapitalization.words,
                ),
                EditableFieldRow(
                  label: 'Original title',
                  controller:
                      _controller('originalTitle', _draft.originalTitle),
                ),
                EditableFieldRow(
                  label: 'Genre',
                  controller: _controller('genre', _draft.genreLine),
                  hint: 'Fiction, History…',
                  textCapitalization: TextCapitalization.words,
                ),
                EditableFieldRow(
                  label: 'Series',
                  controller: _controller('series', _draft.seriesName),
                ),
                EditableFieldRow(
                  label: 'First published',
                  controller: _controller(
                    'firstPublished',
                    _draft.firstPublished?.toString(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                EditableFieldRow(
                  label: 'Description',
                  controller: _controller('description', _draft.description),
                  maxLines: 5,
                  last: true,
                ),
              ],
            ),
            const SectionLabel('This edition', top: 24),
            PaperCard(
              children: [
                EditableFieldRow(
                  label: 'ISBN',
                  controller: _controller('isbn', _draft.isbnDisplay),
                  hint: '978…',
                  keyboardType: TextInputType.number,
                  textCapitalization: TextCapitalization.none,
                ),
                EditableFieldRow(
                  label: 'Language',
                  controller: _controller('language', _draft.language),
                  textCapitalization: TextCapitalization.words,
                ),
                EditableFieldRow(
                  label: 'Publisher',
                  controller: _controller('publisher', _draft.publisher),
                  textCapitalization: TextCapitalization.words,
                ),
                EditableFieldRow(
                  label: 'Edition',
                  controller: _controller('editionName', _draft.editionName),
                  textCapitalization: TextCapitalization.words,
                ),
                EditableFieldRow(
                  label: 'Format',
                  controller: _controller('format', _draft.format),
                  hint: 'Paperback, Hardcover…',
                  textCapitalization: TextCapitalization.words,
                ),
                EditableFieldRow(
                  label: 'Published',
                  controller: _controller(
                    'published',
                    _draft.publicationDate ??
                        _draft.publishedYear?.toString(),
                  ),
                ),
                EditableFieldRow(
                  label: 'Pages',
                  controller:
                      _controller('pages', _draft.pageCount?.toString()),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                EditableFieldRow(
                  label: 'Country',
                  controller: _controller('country', _draft.country),
                  textCapitalization: TextCapitalization.words,
                ),
                EditableFieldRow(
                  label: 'Translator',
                  controller: _controller('translator', _draft.translator),
                  textCapitalization: TextCapitalization.words,
                  last: true,
                ),
              ],
            ),
            const SizedBox(height: 10),
            SecondaryButton(
              label: _lookingUp ? 'Looking up…' : 'Fill in from ISBN',
              height: 44,
              fontSize: 13.5,
              fontWeight: 600,
              onPressed: _lookingUp ? null : _lookupIsbn,
            ),
            if (!_isEditing) ...[
              const SectionLabel('Status', top: 24),
              ChipWrap(
                children: [
                  for (final ownership in Ownership.values)
                    AppChip(
                      label: ownership.label,
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
                      label: status.label,
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
                  ? 'Save changes'
                  : _draft.ownership == Ownership.wishlist
                      ? 'Add to wishlist'
                      : 'Add to library',
              busy: _saving,
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }
}

class _CoverRow extends StatelessWidget {
  const _CoverRow({required this.draft, required this.isEditing});

  final BookDraft draft;
  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (draft.title.trim().isEmpty && draft.coverUrl == null)
          SizedBox(
            width: 76,
            height: 114,
            child: CustomPaint(
              painter: const DashedBorderPainter(radius: AppRadius.cover),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppIcon(AppIcons.image, size: 18, color: AppColors.faint),
                  SizedBox(height: 5),
                  Text(
                    'Cover',
                    style: TextStyle(fontSize: 9.5, color: AppColors.faint),
                  ),
                ],
              ),
            ),
          )
        else
          BookCover(
            title: draft.title,
            author: draft.authors.isEmpty ? null : draft.authors.first,
            colorIndex: draft.coverColorIndex,
            coverUrl: draft.coverUrl,
            width: 76,
            height: 114,
            titleSize: 12,
            authorSize: 6.5,
            spineWidth: 5,
          ),
        const SizedBox(width: 14),
        Expanded(
          child: isEditing
              ? Text(
                  'Changes here apply to the book and the edition shown on its '
                  'details screen. Purchase details live on the copy.',
                  style: AppText.sans(
                    size: 12.5,
                    height: 1.5,
                    color: AppColors.muted,
                  ),
                )
              : Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Scanning fills every field below automatically. ',
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: GestureDetector(
                          onTap: () {
                            context.pop();
                            context.push(Routes.scanner);
                          },
                          child: Text(
                            'Scan instead →',
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
