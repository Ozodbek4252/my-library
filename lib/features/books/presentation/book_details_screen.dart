import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/l10n_extensions.dart';
import '../../../core/providers.dart';
import '../../../core/routing/routes.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/theme/typography.dart';
import '../../../core/utils/formatting.dart';
import '../../../core/utils/isbn.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/app_icons.dart';
import '../../../core/widgets/app_sheet.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../core/widgets/book_cover.dart';
import '../../../core/widgets/layout.dart';
import '../../../core/widgets/pills.dart';
import '../../../core/widgets/states.dart';
import '../../../data/local/database.dart';
import '../../../data/local/image_store.dart';
import '../../../data/repositories/collection_mutations.dart';
import '../../../domain/models/enums.dart';
import '../../../domain/models/library_models.dart';
import '../../reading/presentation/widgets/progress_sheet.dart';
import 'book_providers.dart';

/// The full record of one book: the edition on the shelf, the user's copy, and
/// everything they have added to it.
class BookDetailsScreen extends ConsumerWidget {
  const BookDetailsScreen({super.key, required this.workId});

  final String workId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final details = ref.watch(bookDetailsProvider(workId));

    return Scaffold(
      backgroundColor: AppColors.paper,
      body: details.when(
        loading: () => const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.accent,
            ),
          ),
        ),
        error: (error, _) => SafeArea(
          child: ErrorStateView(
            title: context.l10n.detailsErrorTitle,
            message: context.l10n.detailsErrorMessage,
            onRetry: () => ref.invalidate(bookDetailsProvider(workId)),
          ),
        ),
        data: (data) {
          if (data == null) {
            // The book was removed while this screen was open.
            return SafeArea(
              child: MessageState(
                title: context.l10n.detailsRemovedTitle,
                message: context.l10n.detailsRemovedMessage,
                titleSize: 22,
                primaryLabel: context.l10n.actionBackToLibrary,
                onPrimary: () => context.go(Routes.library),
              ),
            );
          }
          return _DetailsBody(details: data);
        },
      ),
    );
  }
}

class _DetailsBody extends ConsumerWidget {
  const _DetailsBody({required this.details});

  final BookDetails details;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final work = details.work;
    final edition = details.primaryEdition?.edition;
    final copy = details.primaryCopy;

    return ListView(
      padding: const EdgeInsets.only(bottom: AppSpacing.navClearance),
      children: [
        _Hero(details: details),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (details.status.isActive) ...[
                const SizedBox(height: 18),
                _ProgressCard(details: details),
              ],
              if ((work.description ?? '').isNotEmpty) ...[
                const SizedBox(height: 20),
                Text(work.description!, style: AppText.body),
              ],
              const SizedBox(height: 20),
              _EditionsRow(details: details),
              SectionLabel(context.l10n.sectionEditionYouOwn),
              if (edition == null)
                PaperCard(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Text(
                        context.l10n.detailsNoEdition,
                        style: AppText.sans(size: 13, color: AppColors.faint),
                      ),
                    ),
                  ],
                )
              else
                PaperCard(children: _editionRows(context.l10n, work, edition)),
              if (copy != null) ...[
                SectionLabel(context.l10n.sectionMyCopy),
                PaperCard(children: _copyRows(context.l10n, copy)),
                _TagsRow(details: details, copy: copy),
                if ((copy.notes ?? '').trim().isNotEmpty) ...[
                  const SizedBox(height: 22),
                  NoteBlock(
                    label: context.l10n.sectionPersonalNote,
                    text: copy.notes!,
                  ),
                ],
                SectionLabel(context.l10n.sectionPhotosOfMyCopy),
                _PhotoStrip(details: details, copy: copy),
              ],
              const SizedBox(height: 26),
              _StatusActions(details: details),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _editionRows(AppL10n l10n, Work work, Edition edition) {
    final rows = <(String, String)>[
      (l10n.fieldLanguage, edition.language ?? ''),
      (l10n.fieldPublisher, edition.publisher ?? ''),
      if ((edition.editionName ?? '').isNotEmpty)
        (l10n.fieldEdition, edition.editionName!),
      (l10n.fieldFormat, edition.format ?? ''),
      (
        l10n.fieldPublished,
        edition.publicationDate ?? '${edition.publishedYear ?? ''}'
      ),
      (l10n.fieldPages, edition.pageCount?.toString() ?? ''),
      (l10n.fieldGenre, work.genres.join(', ')),
      if ((work.seriesName ?? '').isNotEmpty)
        (
          l10n.detailsSeriesLabel,
          Fmt.dotted([
            work.seriesName,
            work.seriesIndex == null
                ? null
                : l10n.detailsBookNumber(work.seriesIndex!),
          ])
        ),
      if ((edition.translator ?? '').isNotEmpty)
        (l10n.fieldTranslator, edition.translator!),
      if (edition.illustrators.isNotEmpty)
        (l10n.fieldIllustrators, edition.illustrators.join(', ')),
      if ((work.originalTitle ?? '').isNotEmpty)
        (l10n.fieldOriginalTitle, work.originalTitle!),
      if ((work.originalLanguage ?? '').isNotEmpty)
        (l10n.fieldOriginalLanguage, work.originalLanguage!),
      if (work.firstPublished != null)
        (l10n.fieldFirstPublished, '${work.firstPublished}'),
      if ((edition.country ?? '').isNotEmpty)
        (l10n.fieldCountry, edition.country!),
      if ((edition.dimensions ?? '').isNotEmpty)
        (l10n.fieldDimensions, edition.dimensions!),
      if (edition.weightGrams != null)
        (l10n.fieldWeight, l10n.weightGrams(edition.weightGrams!.round())),
      (
        l10n.fieldIsbn,
        edition.isbn13 == null ? '' : Isbn.display(edition.isbn13!)
      ),
      if ((edition.isbn10 ?? '').isNotEmpty)
        (l10n.fieldIsbn10, Isbn.display(edition.isbn10!)),
    ];

    return [
      for (var i = 0; i < rows.length; i++)
        FieldRow(
          label: rows[i].$1,
          value: rows[i].$2,
          last: i == rows.length - 1,
        ),
    ];
  }

  List<Widget> _copyRows(AppL10n l10n, Copy copy) {
    final rows = <(String, String)>[
      (l10n.fieldPurchased, Fmt.date(copy.purchaseDate)),
      (l10n.fieldPrice, Fmt.money(copy.purchasePrice, copy.currency)),
      (l10n.fieldWhere, copy.store ?? ''),
      (
        l10n.fieldGift,
        copy.isGift
            ? l10n.detailsGiftFrom(copy.giftFrom ?? l10n.detailsGiftAFriend)
            : l10n.detailsGiftPurchased
      ),
      (
        l10n.sectionCondition,
        copy.condition == null
            ? ''
            : Condition.fromName(copy.condition).display(l10n)
      ),
      (l10n.sectionLocation, copy.location ?? ''),
      (l10n.sectionOwnership, Ownership.fromName(copy.ownership).display(l10n)),
      (l10n.fieldAdded, Fmt.date(copy.addedDate)),
    ];

    return [
      for (var i = 0; i < rows.length; i++)
        FieldRow(
          label: rows[i].$1,
          value: rows[i].$2,
          last: i == rows.length - 1,
        ),
    ];
  }
}

class _Hero extends ConsumerWidget {
  const _Hero({required this.details});

  final BookDetails details;

  /// The floating back / Edit / ⋯ row, measured from the safe area.
  static const _controlsTop = 12.0;
  static const _controlsSize = 36.0;

  /// Breathing room between that row and the cover. Derived rather than a
  /// fixed top padding, so the hero is only ever as tall as it needs to be —
  /// and stays correct on any status bar height, or if the controls change.
  static const _gapBelowControls = 20.0;

  static const _contentTop = _controlsTop + _controlsSize + _gapBelowControls;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final work = details.work;
    final edition = details.primaryEdition?.edition;
    final colorIndex = edition?.coverColorIndex ?? 0;
    final tint = AppColors
        .coverPalette[colorIndex.abs() % AppColors.coverPalette.length]
        .$1;
    final topInset = MediaQuery.paddingOf(context).top;

    return Stack(
      children: [
        Positioned.fill(child: ColoredBox(color: tint)),
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x6B0C0A08), Color(0xD10C0A08)],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(24, topInset + _contentTop, 24, 22),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              BookCover(
                title: work.title,
                author: Fmt.surname(work.authors),
                colorIndex: colorIndex,
                coverUrl: edition?.coverUrl,
                coverImagePath: edition?.coverImagePath,
                width: 108,
                height: 162,
                titleSize: 17,
                authorSize: 7.5,
                spineWidth: 7,
                shadows: AppShadows.coverLarge,
                border: Border.all(color: const Color(0x1FFFFFFF)),
              ),
              const SizedBox(width: 17),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        work.title,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.heroTitle.copyWith(
                          color: const Color(0xFFFAF6EE),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        context.l10n.authorsOf(work.authors),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.sans(
                          size: 14,
                          color: const Color(0xFFC4B9A9),
                        ),
                      ),
                      const SizedBox(height: 11),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          _GlassPill(
                            label: details.ownership.display(context.l10n),
                          ),
                          _GlassPill(
                            label: details.status.display(context.l10n),
                          ),
                          _GlassPill(
                            label: context.l10n.ratingOf(work.rating),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: topInset + _controlsTop,
          left: 16,
          right: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _GlassCircleButton(
                onTap: () =>
                    context.canPop() ? context.pop() : context.go(Routes.library),
                child: const AppIcon(
                  AppIcons.chevronLeft,
                  size: 17,
                  color: AppColors.paper,
                ),
              ),
              Row(
                children: [
                  _GlassButton(
                    label: context.l10n.actionEdit,
                    onTap: () => context.push(
                      details.primaryCopy == null
                          ? Routes.editBook(details.work.id)
                          : Routes.editCopy(
                              details.work.id,
                              details.primaryCopy!.id,
                            ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _GlassCircleButton(
                    onTap: () => _openMenu(context, ref, details),
                    child: const Text(
                      '⋯',
                      style: TextStyle(
                        fontSize: 17,
                        height: 1,
                        color: AppColors.paper,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Future<void> _openMenu(
  BuildContext context,
  WidgetRef ref,
  BookDetails details,
) async {
  await showAppSheet<void>(
    context,
    builder: (sheetContext) => AppSheet(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(details.work.title, style: AppText.sheetTitle),
          const SizedBox(height: 4),
          Text(
            context.l10n.authorsOf(details.work.authors),
            style: AppText.sans(size: 12.5, color: AppColors.muted2),
          ),
          const SizedBox(height: 18),
          _MenuRow(
            label: context.l10n.detailsMenuEditBook,
            onTap: () {
              Navigator.of(sheetContext).pop();
              context.push(Routes.editBook(details.work.id));
            },
          ),
          _MenuRow(
            label: context.l10n.detailsMenuAllEditions,
            onTap: () {
              Navigator.of(sheetContext).pop();
              context.push(Routes.bookEditions(details.work.id));
            },
          ),
          if (details.primaryCopy != null)
            _MenuRow(
              label: context.l10n.detailsMenuEditCopy,
              onTap: () {
                Navigator.of(sheetContext).pop();
                context.push(
                  Routes.editCopy(details.work.id, details.primaryCopy!.id),
                );
              },
            ),
          const SizedBox(height: 18),
          if (details.primaryCopy != null)
            DestructiveButton(
              label: context.l10n.detailsRemoveCopy,
              onPressed: () async {
                Navigator.of(sheetContext).pop();
                await confirmRemoveCopy(context, ref, details);
              },
            ),
        ],
      ),
    ),
  );
}

/// Destructive prompts name what is lost and what survives.
Future<void> confirmRemoveCopy(
  BuildContext context,
  WidgetRef ref,
  BookDetails details, {
  Copy? copy,
}) async {
  final target = copy ?? details.primaryCopy;
  if (target == null) return;

  final edition = details.editions
      .firstWhere(
        (e) => e.copies.any((c) => c.id == target.id),
        orElse: () => details.editions.first,
      )
      .edition;

  final descriptor = Fmt.dotted([
    edition.language,
    edition.publisher,
    edition.format?.toLowerCase(),
  ]);
  final otherEditions = details.editions.length - 1;
  final siblingCopies = details.editions
          .firstWhere((e) => e.edition.id == edition.id)
          .copies
          .length -
      1;

  final l10n = context.l10n;
  final survives = switch ((siblingCopies, otherEditions)) {
    (> 0, _) => l10n.survivesOtherCopy,
    (_, > 0) => l10n.survivesOtherEditions(otherEditions),
    _ => l10n.survivesNothing,
  };

  final confirmed = await showConfirmDialog(
    context,
    title: l10n.removeCopyTitle,
    message: l10n.removeCopyMessage(descriptor, details.work.title, survives),
    confirmLabel: l10n.removeCopyConfirm,
  );
  if (!confirmed || !context.mounted) return;

  final result = await ref.read(databaseProvider).removeCopy(target.id);

  // A cover the user photographed belongs to the edition; once the edition is
  // gone the file is an orphan.
  if (result.removedEdition) {
    await const ImageStore().delete(edition.coverImagePath);
  }
  if (!context.mounted) return;

  AppToast.show(context, _removeToast(l10n, result));
  if (result.removedWork) {
    context.go(Routes.library);
  }
}

/// What the toast says after a copy is removed: whether the edition, or the
/// whole book, went with it.
String _removeToast(AppL10n l10n, RemoveCopyResult result) {
  if (result.removedWork) return l10n.toastRemovedFromLibrary;
  if (!result.removedEdition) return l10n.toastCopyRemoved;
  return l10n.toastCopyRemovedEditionsLeft(result.remainingEditions);
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.rule)),
          ),
          child: Row(
            children: [
              Expanded(child: Text(label, style: AppText.sans(size: 15))),
              const AppIcon(
                AppIcons.chevronRight,
                size: 15,
                color: AppColors.chevron,
              ),
            ],
          ),
        ),
      );
}

class _GlassPill extends StatelessWidget {
  const _GlassPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            height: 25,
            padding: const EdgeInsets.symmetric(horizontal: 9),
            color: const Color(0x29FAF6EE),
            child: Align(
              widthFactor: 1,
              child: Text(
                label,
                style: AppText.sans(
                  size: 11.5,
                  weight: 600,
                  color: const Color(0xFFFAF6EE),
                ),
              ),
            ),
          ),
        ),
      );
}

class _GlassCircleButton extends StatelessWidget {
  const _GlassCircleButton({required this.child, required this.onTap});

  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Material(
            color: const Color(0x6B14110E),
            child: InkWell(
              onTap: onTap,
              child: SizedBox(
                width: 36,
                height: 36,
                child: Center(child: child),
              ),
            ),
          ),
        ),
      );
}

class _GlassButton extends StatelessWidget {
  const _GlassButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Material(
            color: const Color(0x6B14110E),
            child: InkWell(
              onTap: onTap,
              child: Container(
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                alignment: Alignment.center,
                child: Text(
                  label,
                  style: AppText.sans(
                    size: 13,
                    weight: 600,
                    color: AppColors.paper,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}

class _ProgressCard extends ConsumerWidget {
  const _ProgressCard({required this.details});

  final BookDetails details;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final total = details.pageCount ?? 0;
    final current = details.work.currentPage;
    final percent = (details.progress * 100).round();

    return PaperCard(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              total > 0
                  ? context.l10n.detailsPagesOf(current, total)
                  : context.l10n.detailsPageOnly(current),
              style: AppText.sans(size: 12.5, color: AppColors.muted),
            ),
            if (total > 0)
              Text('$percent%', style: AppText.serif(size: 22)),
          ],
        ),
        const SizedBox(height: 9),
        SizedBox(
          width: double.infinity,
          child: ProgressTrack(value: details.progress),
        ),
        const SizedBox(height: 13),
        SizedBox(
          width: double.infinity,
          child: SecondaryButton(
            label: context.l10n.detailsUpdateProgress,
            height: 42,
            fontSize: 13.5,
            fontWeight: 600,
            onPressed: () => showProgressSheet(context, details.work.id),
          ),
        ),
      ],
    );
  }
}

class _EditionsRow extends StatelessWidget {
  const _EditionsRow({required this.details});

  final BookDetails details;

  @override
  Widget build(BuildContext context) {
    final count = details.editions.length;
    final summary = details.editions
        .take(3)
        .map((e) => Fmt.dotted([e.edition.language, e.edition.publisher]))
        .where((e) => e.isNotEmpty)
        .join(' · ');

    return GestureDetector(
      onTap: () => context.push(Routes.bookEditions(details.work.id)),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.paperRaised,
          borderRadius: BorderRadius.circular(AppRadius.button),
          border: Border.all(color: AppColors.ruleStrong),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 33,
              height: 29,
              child: Stack(
                children: [
                  // Draw only spines that exist. A work can legitimately
                  // have no edition — one that was wishlisted, or whose
                  // editions were all removed — and clamping up to 1 here
                  // used to index an empty list and take the screen down.
                  for (var i = 0; i < count.clamp(0, 2); i++)
                    Positioned(
                      left: i * 13,
                      child: BookCover(
                        // The real artwork at spine size, falling back to the
                        // edition's colour when there is none.
                        title: details.work.title,
                        colorIndex: details.editions[i].edition.coverColorIndex,
                        coverUrl: details.editions[i].edition.coverUrl,
                        coverImagePath:
                            details.editions[i].edition.coverImagePath,
                        width: 20,
                        height: 29,
                        radius: 2,
                        showText: false,
                        shadows: const [],
                        // Separates the two spines where they overlap.
                        border: i == 1
                            ? const Border(
                                left: BorderSide(
                                  color: AppColors.paperRaised,
                                  width: 1.5,
                                ),
                              )
                            : null,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.detailsEditionsOfWork(count),
                    style: AppText.sans(size: 13.5, weight: 600),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    summary.isEmpty
                        ? context.l10n.detailsAddAnotherCopyOrTranslation
                        : summary,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.sans(size: 11.5, color: AppColors.muted2),
                  ),
                ],
              ),
            ),
            const AppIcon(
              AppIcons.chevronRight,
              size: 16,
              color: AppColors.faint,
            ),
          ],
        ),
      ),
    );
  }
}

class _TagsRow extends StatelessWidget {
  const _TagsRow({required this.details, required this.copy});

  final BookDetails details;
  final Copy copy;

  @override
  Widget build(BuildContext context) {
    final tags = details.tagsFor(copy.id);
    if (tags.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [for (final tag in tags) TagPill(label: tag.name)],
      ),
    );
  }
}

class _PhotoStrip extends ConsumerWidget {
  const _PhotoStrip({required this.details, required this.copy});

  final BookDetails details;
  final Copy copy;

  Future<void> _addPhoto(BuildContext context, WidgetRef ref) async {
    final type = await showAppSheet<PhotoType>(
      context,
      builder: (sheetContext) => AppSheet(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(context.l10n.photoSheetTitle, style: AppText.sheetTitle),
            const SizedBox(height: 4),
            Text(
              context.l10n.photoSheetSubtitle,
              style: AppText.sans(
                size: 12.5,
                height: 1.5,
                color: AppColors.muted,
              ),
            ),
            const SizedBox(height: 14),
            for (final type in PhotoType.values)
              _MenuRow(
                label: type.display(context.l10n),
                onTap: () => Navigator.of(sheetContext).pop(type),
              ),
          ],
        ),
      ),
    );
    if (type == null || !context.mounted) return;

    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1600,
        imageQuality: 85,
      );
      if (picked == null || !context.mounted) return;
      await ref.read(databaseProvider).addCopyPhoto(copy.id, picked.path, type);
      if (context.mounted) AppToast.show(context, context.l10n.toastPhotoAdded);
    } catch (_) {
      if (context.mounted) {
        AppToast.show(
          context,
          context.l10n.toastCouldNotOpenPhotos,
          success: false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photos = details.photosFor(copy.id);

    return SizedBox(
      height: 66,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (final photo in photos) ...[
            _PhotoTile(
              photo: photo,
              onRemove: () async {
                final l10n = context.l10n;
                final confirmed = await showConfirmDialog(
                  context,
                  title: l10n.photoDeleteTitle,
                  message: l10n.photoDeleteMessage(
                    PhotoType.fromName(photo.type)
                        .display(l10n)
                        .toLowerCase(),
                  ),
                  confirmLabel: l10n.photoDeleteConfirm,
                );
                if (!confirmed) return;
                await ref.read(databaseProvider).removeCopyPhoto(photo.id);
                if (context.mounted) {
                  AppToast.show(context, l10n.toastPhotoRemoved);
                }
              },
            ),
            const SizedBox(width: 9),
          ],
          GestureDetector(
            onTap: () => _addPhoto(context, ref),
            child: SizedBox(
              width: 66,
              height: 66,
              child: CustomPaint(
                painter: const DashedBorderPainter(radius: 10),
                child: const Center(
                  child: Text(
                    '+',
                    style: TextStyle(fontSize: 19, color: AppColors.muted2),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoTile extends StatelessWidget {
  const _PhotoTile({required this.photo, required this.onRemove});

  final CopyPhoto photo;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final file = File(photo.path);
    return GestureDetector(
      onLongPress: onRemove,
      child: SizedBox(
        width: 66,
        height: 66,
        child: OutlinedSurface(
          radius: 10,
          background: AppColors.paperChip,
          child: Stack(
          fit: StackFit.expand,
          children: [
            Image.file(
              file,
              fit: BoxFit.cover,
              // A photo whose file has since been deleted still renders as a
              // labelled tile rather than a crash.
              errorBuilder: (context, _, _) => Center(
                child: Text(
                  PhotoType.fromName(photo.type).display(context.l10n),
                  textAlign: TextAlign.center,
                  style: AppText.sans(size: 11, color: AppColors.muted2),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: const Color(0x8C1A1714),
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(
                  PhotoType.fromName(photo.type).display(context.l10n),
                  textAlign: TextAlign.center,
                  style: AppText.sans(
                    size: 9,
                    weight: 600,
                    color: AppColors.paper,
                  ),
                ),
              ),
            ),
          ],
          ),
        ),
      ),
    );
  }
}

/// Reading-status chips at the foot of the screen, so status can be changed
/// without opening the editor.
class _StatusActions extends ConsumerWidget {
  const _StatusActions({required this.details});

  final BookDetails details;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = details.status;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionLabel(context.l10n.sectionStatus, top: 0),
        ChipWrap(
          children: [
            for (final status in ReadingStatus.values)
              AppChip(
                label: status.display(context.l10n),
                selected: status == current,
                onTap: () async {
                  if (status == current) return;
                  await ref
                      .read(readingRepositoryProvider)
                      .setStatus(details.work.id, status);
                  if (context.mounted) {
                    AppToast.show(
                      context,
                      context.l10n.toastMarkedAs(
                        status.display(context.l10n).toLowerCase(),
                      ),
                    );
                  }
                },
              ),
          ],
        ),
        SectionLabel(context.l10n.sectionRating, top: 24),
        Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              StarRating(
                rating: details.work.rating ?? 0,
                onChanged: (value) => ref
                    .read(readingRepositoryProvider)
                    .setRating(details.work.id, value == 0 ? null : value),
              ),
              const SizedBox(width: 15),
              Text(
                details.work.rating == null || details.work.rating == 0
                    ? context.l10n.detailsNotRated
                    : details.work.rating!.toStringAsFixed(1),
                style: AppText.sans(size: 13, color: AppColors.muted2),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
