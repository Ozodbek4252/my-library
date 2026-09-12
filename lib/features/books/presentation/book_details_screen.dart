import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

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
            title: "This book couldn't be opened",
            message: 'Something went wrong reading it from your library.',
            onRetry: () => ref.invalidate(bookDetailsProvider(workId)),
          ),
        ),
        data: (data) {
          if (data == null) {
            // The book was removed while this screen was open.
            return SafeArea(
              child: MessageState(
                title: 'No longer in your library',
                message: 'This book has been removed.',
                titleSize: 22,
                primaryLabel: 'Back to library',
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
              const SectionLabel('The edition you own'),
              if (edition == null)
                PaperCard(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Text(
                        'No edition recorded yet.',
                        style: AppText.sans(size: 13, color: AppColors.faint),
                      ),
                    ),
                  ],
                )
              else
                PaperCard(children: _editionRows(work, edition)),
              if (copy != null) ...[
                const SectionLabel('My copy'),
                PaperCard(children: _copyRows(copy)),
                _TagsRow(details: details, copy: copy),
                if ((copy.notes ?? '').trim().isNotEmpty) ...[
                  const SizedBox(height: 22),
                  NoteBlock(label: 'Personal note', text: copy.notes!),
                ],
                const SectionLabel('Photos of my copy'),
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

  List<Widget> _editionRows(Work work, Edition edition) {
    final rows = <(String, String)>[
      ('Language', edition.language ?? ''),
      ('Publisher', edition.publisher ?? ''),
      if ((edition.editionName ?? '').isNotEmpty)
        ('Edition', edition.editionName!),
      ('Format', edition.format ?? ''),
      ('Published', edition.publicationDate ?? '${edition.publishedYear ?? ''}'),
      ('Pages', edition.pageCount?.toString() ?? ''),
      ('Genre', work.genres.join(', ')),
      if ((work.seriesName ?? '').isNotEmpty)
        (
          'Series',
          Fmt.dotted([
            work.seriesName,
            work.seriesIndex == null ? null : 'Book ${work.seriesIndex}',
          ])
        ),
      if ((edition.translator ?? '').isNotEmpty)
        ('Translator', edition.translator!),
      if (edition.illustrators.isNotEmpty)
        ('Illustrators', edition.illustrators.join(', ')),
      if ((work.originalTitle ?? '').isNotEmpty)
        ('Original title', work.originalTitle!),
      if ((work.originalLanguage ?? '').isNotEmpty)
        ('Original language', work.originalLanguage!),
      if (work.firstPublished != null)
        ('First published', '${work.firstPublished}'),
      if ((edition.country ?? '').isNotEmpty) ('Country', edition.country!),
      if ((edition.dimensions ?? '').isNotEmpty)
        ('Dimensions', edition.dimensions!),
      if (edition.weightGrams != null)
        ('Weight', '${edition.weightGrams!.round()} g'),
      ('ISBN', edition.isbn13 == null ? '' : Isbn.display(edition.isbn13!)),
      if ((edition.isbn10 ?? '').isNotEmpty)
        ('ISBN-10', Isbn.display(edition.isbn10!)),
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

  List<Widget> _copyRows(Copy copy) {
    final rows = <(String, String)>[
      ('Purchased', Fmt.date(copy.purchaseDate)),
      ('Price', Fmt.money(copy.purchasePrice, copy.currency)),
      ('Where', copy.store ?? ''),
      ('Gift', copy.isGift ? 'From ${copy.giftFrom ?? 'a friend'}' : 'Purchased'),
      (
        'Condition',
        copy.condition == null
            ? ''
            : Condition.fromName(copy.condition).label
      ),
      ('Location', copy.location ?? ''),
      ('Ownership', Ownership.fromName(copy.ownership).label),
      ('Added', Fmt.date(copy.addedDate)),
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
          padding: EdgeInsets.fromLTRB(24, topInset + 112, 24, 22),
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
                        Fmt.authors(work.authors),
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
                          _GlassPill(label: details.ownership.label),
                          _GlassPill(label: details.status.label),
                          _GlassPill(label: Fmt.rating(work.rating)),
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
          top: topInset + 12,
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
                    label: 'Edit',
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
            Fmt.authors(details.work.authors),
            style: AppText.sans(size: 12.5, color: AppColors.muted2),
          ),
          const SizedBox(height: 18),
          _MenuRow(
            label: 'Edit book details',
            onTap: () {
              Navigator.of(sheetContext).pop();
              context.push(Routes.editBook(details.work.id));
            },
          ),
          _MenuRow(
            label: 'All editions of this work',
            onTap: () {
              Navigator.of(sheetContext).pop();
              context.push(Routes.bookEditions(details.work.id));
            },
          ),
          if (details.primaryCopy != null)
            _MenuRow(
              label: 'Edit this copy',
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
              label: 'Remove this copy',
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

  final survives = switch ((siblingCopies, otherEditions)) {
    (> 0, _) => 'Your other copy of this edition stays.',
    (_, > 1) => 'Your other $otherEditions editions stay.',
    (_, 1) => 'Your other edition stays.',
    _ => 'The book will be removed from your library entirely.',
  };

  final confirmed = await showConfirmDialog(
    context,
    title: 'Remove this copy?',
    message: 'Your $descriptor copy of ${details.work.title} will be deleted, '
        'along with its purchase details and photos. $survives',
    confirmLabel: 'Remove copy',
  );
  if (!confirmed || !context.mounted) return;

  final result = await ref.read(databaseProvider).removeCopy(target.id);

  // A cover the user photographed belongs to the edition; once the edition is
  // gone the file is an orphan.
  if (result.removedEdition) {
    await const ImageStore().delete(edition.coverImagePath);
  }
  if (!context.mounted) return;

  AppToast.show(context, result.toastMessage);
  if (result.removedWork) {
    context.go(Routes.library);
  }
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
              total > 0 ? '$current of $total pages' : 'Page $current',
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
            label: 'Update progress',
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
                  for (var i = 0; i < (count.clamp(1, 2)); i++)
                    Positioned(
                      left: i * 13,
                      child: Container(
                        width: 20,
                        height: 29,
                        decoration: BoxDecoration(
                          color: AppColors.coverPalette[
                                  (details.editions[i].edition.coverColorIndex)
                                      .abs() %
                                      AppColors.coverPalette.length]
                              .$1,
                          borderRadius: BorderRadius.circular(2),
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
                    count == 1
                        ? '1 edition of this work'
                        : '$count editions of this work',
                    style: AppText.sans(size: 13.5, weight: 600),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    summary.isEmpty
                        ? 'Add another copy or translation'
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
            Text('Add a photo', style: AppText.sheetTitle),
            const SizedBox(height: 4),
            Text(
              'Photos of your copy are kept separate from the official cover.',
              style: AppText.sans(
                size: 12.5,
                height: 1.5,
                color: AppColors.muted,
              ),
            ),
            const SizedBox(height: 14),
            for (final type in PhotoType.values)
              _MenuRow(
                label: type.label,
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
      if (context.mounted) AppToast.show(context, 'Photo added');
    } catch (_) {
      if (context.mounted) {
        AppToast.show(context, "Couldn't open the photo library", success: false);
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
                final confirmed = await showConfirmDialog(
                  context,
                  title: 'Delete this photo?',
                  message:
                      'The ${PhotoType.fromName(photo.type).label.toLowerCase()} '
                      'photo of your copy will be removed. The book and its '
                      'details stay.',
                  confirmLabel: 'Delete photo',
                );
                if (!confirmed) return;
                await ref.read(databaseProvider).removeCopyPhoto(photo.id);
                if (context.mounted) AppToast.show(context, 'Photo removed');
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
      child: Container(
        width: 66,
        height: 66,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.paperChip,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.ruleStrong),
        ),
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
                  PhotoType.fromName(photo.type).label,
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
                  PhotoType.fromName(photo.type).label,
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
        const SectionLabel('Reading status', top: 0),
        ChipWrap(
          children: [
            for (final status in ReadingStatus.values)
              AppChip(
                label: status.label,
                selected: status == current,
                onTap: () async {
                  if (status == current) return;
                  await ref
                      .read(readingRepositoryProvider)
                      .setStatus(details.work.id, status);
                  if (context.mounted) {
                    AppToast.show(context, 'Marked as ${status.label.toLowerCase()}');
                  }
                },
              ),
          ],
        ),
        const SectionLabel('Rating', top: 24),
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
                    ? 'Not rated'
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
