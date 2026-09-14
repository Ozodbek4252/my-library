import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n_extensions.dart';
import '../../../core/providers.dart';
import '../../../core/routing/routes.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/theme/typography.dart';
import '../../../core/utils/formatting.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../core/widgets/book_cover.dart';
import '../../../core/widgets/layout.dart';
import '../../../core/widgets/pills.dart';
import '../../../core/widgets/states.dart';
import '../../../domain/models/library_models.dart';
import 'reading_providers.dart';
import 'widgets/progress_sheet.dart';

/// Currently reading and reading history, as two tabs.
class ReadingScreen extends ConsumerStatefulWidget {
  const ReadingScreen({super.key});

  @override
  ConsumerState<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends ConsumerState<ReadingScreen> {
  bool _historyTab = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenH,
        AppSpacing.screenTop,
        AppSpacing.screenH,
        AppSpacing.navClearance,
      ),
      children: [
        Text(context.l10n.readingTitle, style: AppText.screenTitle),
        const SizedBox(height: 14),
        SizedBox(
          height: 34,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              AppChip(
                label: context.l10n.readingTabNow,
                selected: !_historyTab,
                onTap: () => setState(() => _historyTab = false),
              ),
              const SizedBox(width: 7),
              AppChip(
                label: context.l10n.readingTabHistory,
                selected: _historyTab,
                onTap: () => setState(() => _historyTab = true),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        if (_historyTab) const _HistoryTab() else const _NowTab(),
      ],
    );
  }
}

class _NowTab extends ConsumerWidget {
  const _NowTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reading = ref.watch(currentlyReadingProvider);
    final upNext = ref.watch(upNextProvider).value ?? const <LibraryEntry>[];

    return reading.when(
      loading: () => const Padding(
        padding: EdgeInsets.only(top: 40),
        child: Center(
          child: SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.accent,
            ),
          ),
        ),
      ),
      error: (error, _) => ErrorStateView(
        message: context.l10n.readingErrorMessage,
        onRetry: () => ref.invalidate(currentlyReadingProvider),
      ),
      data: (entries) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (entries.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 10),
              child: MessageState(
                title: context.l10n.readingEmptyTitle,
                message: upNext.isEmpty
                    ? context.l10n.readingEmptyNoShelves
                    : context.l10n.readingEmptyWithShelves,
                titleSize: 22,
                maxMessageWidth: 260,
                primaryLabel: upNext.isEmpty
                    ? context.l10n.actionAddBook
                    : context.l10n.actionGoToLibrary,
                onPrimary: () => context.go(
                  upNext.isEmpty ? Routes.library : Routes.library,
                ),
              ),
            )
          else
            for (final entry in entries) ...[
              _ReadingCard(entry: entry),
              const SizedBox(height: 14),
            ],
          if (upNext.isNotEmpty) ...[
            SectionLabel(context.l10n.readingUpNext, top: 6, bottom: 12),
            SizedBox(
              height: 93,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: upNext.length,
                separatorBuilder: (_, _) => const SizedBox(width: 11),
                itemBuilder: (context, index) {
                  final book = upNext[index];
                  return GestureDetector(
                    onTap: () => context.push(Routes.bookDetails(book.work.id)),
                    child: BookCover(
                      title: book.title,
                      colorIndex: book.edition?.coverColorIndex ?? 0,
                      coverUrl: book.edition?.coverUrl,
                      coverImagePath: book.edition?.coverImagePath,
                      width: 62,
                      height: 93,
                      titleSize: 9,
                      authorSize: 0,
                      spineWidth: 4,
                      shadows: const [
                        BoxShadow(
                          color: Color(0x291A1714),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ReadingCard extends ConsumerWidget {
  const _ReadingCard({required this.entry});

  final ReadingEntryView entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => context.push(Routes.bookDetails(entry.work.id)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.paperRaised,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.ruleStrong),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BookCover(
                  title: entry.work.title,
                  colorIndex: entry.edition?.coverColorIndex ?? 0,
                  coverUrl: entry.edition?.coverUrl,
                  coverImagePath: entry.edition?.coverImagePath,
                  width: 76,
                  height: 114,
                  titleSize: 11,
                  authorSize: 0,
                  spineWidth: 5,
                  shadows: const [
                    BoxShadow(
                      color: Color(0x2E1A1714),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.work.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.serif(size: 20, height: 1.15),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        context.l10n.authorsOf(entry.work.authors),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.sans(
                          size: 12.5,
                          color: AppColors.muted2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            entry.totalPages > 0
                                ? '${entry.percent}%'
                                : '${entry.currentPage}',
                            style: AppText.serif(size: 27, height: 1),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              entry.totalPages > 0
                                  ? context.l10n.readingPagesOf(
                                      entry.currentPage,
                                      entry.totalPages,
                                    )
                                  : context.l10n.readingPagesRead,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.sans(
                                size: 12.5,
                                color: AppColors.muted2,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 9),
                      ProgressTrack(value: entry.progress),
                      const SizedBox(height: 7),
                      Text(
                        entry.sinceLine(context.l10n),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.sans(size: 11, color: AppColors.faint),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    label: context.l10n.readingUpdatePage,
                    height: 42,
                    fontSize: 13.5,
                    onPressed: () =>
                        showProgressSheet(context, entry.work.id),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SecondaryButton(
                    label: context.l10n.readingMarkFinished,
                    height: 42,
                    fontSize: 13.5,
                    onPressed: () async {
                      await ref
                          .read(readingRepositoryProvider)
                          .finishReading(entry.work.id);
                      if (context.mounted) {
                        AppToast.show(
                          context,
                          context.l10n.toastFinished(
                            '${DateTime.now().year}',
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryTab extends ConsumerWidget {
  const _HistoryTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(readingHistoryProvider);

    return history.when(
      loading: () => const Padding(
        padding: EdgeInsets.only(top: 40),
        child: Center(
          child: SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.accent,
            ),
          ),
        ),
      ),
      error: (error, _) => ErrorStateView(
        message: context.l10n.readingHistoryError,
        onRetry: () => ref.invalidate(readingHistoryProvider),
      ),
      data: (entries) {
        if (entries.isEmpty) {
          return Padding(
            padding: const EdgeInsets.only(top: 40),
            child: MessageState(
              title: context.l10n.readingHistoryEmptyTitle,
              message: context.l10n.readingHistoryEmptyMessage,
              titleSize: 22,
              maxMessageWidth: 260,
            ),
          );
        }

        final year = DateTime.now().year;
        final thisYear =
            entries.where((e) => e.entry.finishDate.year == year).toList();
        final pages = thisYear.fold(0, (sum, e) => sum + e.entry.pagesRead);
        final rated = thisYear
            .map((e) => e.entry.rating ?? e.work.rating)
            .whereType<double>()
            .where((r) => r > 0)
            .toList();
        final average = rated.isEmpty
            ? null
            : rated.reduce((a, b) => a + b) / rated.length;

        // Group by the month the book was finished.
        final groups = <String, List<HistoryEntry>>{};
        for (final entry in entries) {
          groups
              .putIfAbsent(Fmt.monthYear(entry.entry.finishDate), () => [])
              .add(entry);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 11),
              margin: const EdgeInsets.only(bottom: 6),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: AppColors.ruleStrong),
                  bottom: BorderSide(color: AppColors.ruleStrong),
                ),
              ),
              child: Row(
                children: [
                  _HistoryStat(
                    value: '${thisYear.length}',
                    label: context.l10n.readingReadInYear(year),
                  ),
                  _HistoryStat(
                    value: Fmt.count(pages),
                    label: context.l10n.readingPagesLabel,
                  ),
                  _HistoryStat(
                    value: average == null ? '—' : average.toStringAsFixed(1),
                    label: context.l10n.readingAvgRating,
                  ),
                ],
              ),
            ),
            for (final group in groups.entries) ...[
              SectionLabel(group.key, top: 20, bottom: 4),
              for (final entry in group.value)
                _HistoryRow(entry: entry),
            ],
          ],
        );
      },
    );
  }
}

class _HistoryStat extends StatelessWidget {
  const _HistoryStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: AppText.statFigureSmall),
            const SizedBox(height: 2),
            Text(label.toUpperCase(), style: AppText.microLabel),
          ],
        ),
      );
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({required this.entry});

  final HistoryEntry entry;

  @override
  Widget build(BuildContext context) {
    final rating = entry.entry.rating ?? entry.work.rating;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.push(Routes.bookDetails(entry.work.id)),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.rule)),
        ),
        child: Row(
          children: [
            BookCover(
              title: entry.work.title,
              colorIndex: entry.edition?.coverColorIndex ?? 0,
              coverUrl: entry.edition?.coverUrl,
              coverImagePath: entry.edition?.coverImagePath,
              width: 34,
              height: 51,
              radius: AppRadius.thumb,
              shadows: AppShadows.thumb,
              showText: false,
              spineWidth: 3,
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.work.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.sans(size: 14, weight: 500, height: 1.25),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    context.l10n.authorsOf(entry.work.authors),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.sans(size: 12, color: AppColors.muted2),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    entry.datesLine(context.l10n),
                    style: AppText.sans(size: 11, color: AppColors.faint),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              Fmt.stars(rating),
              style: const TextStyle(
                fontSize: 11,
                letterSpacing: 1,
                color: AppColors.star,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
