import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers.dart';
import '../../../core/routing/routes.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/theme/typography.dart';
import '../../../core/utils/formatting.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/app_icons.dart';
import '../../../core/widgets/layout.dart';
import '../../../core/widgets/states.dart';
import '../../../domain/models/statistics.dart';

final statisticsProvider = StreamProvider<ReadingStatistics>(
  (ref) => ref.watch(statisticsRepositoryProvider).watchStatistics(),
);

/// Reading statistics for the current year, computed from the reading log.
class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  static const _monthLetters = [
    'J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(statisticsProvider);

    return Scaffold(
      backgroundColor: AppColors.paper,
      body: stats.when(
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
            message: 'Your statistics could not be calculated.',
            onRetry: () => ref.invalidate(statisticsProvider),
          ),
        ),
        data: (data) => _StatisticsBody(stats: data),
      ),
    );
  }
}

class _StatisticsBody extends StatelessWidget {
  const _StatisticsBody({required this.stats});

  final ReadingStatistics stats;

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
        Align(
          alignment: Alignment.centerLeft,
          child: CircleIconButton(
            border: Border.all(color: AppColors.ruleStrong),
            onPressed: () =>
                context.canPop() ? context.pop() : context.go(Routes.profile),
            child: const AppIcon(AppIcons.chevronLeft, size: 16),
          ),
        ),
        const SizedBox(height: 16),
        Text('This year', style: AppText.screenTitle),
        const SizedBox(height: 3),
        Text(
          '${Fmt.shortDate(stats.rangeStart)} – ${Fmt.date(stats.rangeEnd)}',
          style: AppText.sans(size: 12.5, color: AppColors.muted2),
        ),
        const SizedBox(height: 20),
        _MetricGrid(stats: stats),
        if (!stats.hasReadAnything) ...[
          const SizedBox(height: 40),
          const MessageState(
            title: 'No finished books yet',
            message: 'Mark a book as read and these figures start filling in. '
                'Nothing here is made up — it all comes from your own shelves.',
            titleSize: 22,
            maxMessageWidth: 270,
          ),
        ] else ...[
          const SectionLabel('Books finished per month', bottom: 12),
          _MonthChart(stats: stats),
          const SizedBox(height: 10),
          Text(
            _bestMonthCaption(stats),
            style: AppText.sans(size: 11.5, color: AppColors.muted2),
          ),
          if (stats.byLanguage.isNotEmpty) ...[
            const SectionLabel('By language', top: 28, bottom: 12),
            _LanguageBar(stats: stats),
          ],
          if (stats.byGenre.isNotEmpty) ...[
            const SectionLabel('By genre', top: 28),
            _GenreBars(stats: stats),
          ],
          if (stats.byAuthor.isNotEmpty) ...[
            const SectionLabel('Most read authors', top: 28),
            PaperCard(
              children: [
                for (var i = 0; i < stats.byAuthor.length; i++)
                  _AuthorRow(
                    rank: i + 1,
                    slice: stats.byAuthor[i],
                    last: i == stats.byAuthor.length - 1,
                  ),
              ],
            ),
          ],
        ],
      ],
    );
  }

  static String _bestMonthCaption(ReadingStatistics stats) {
    final index = stats.bestMonthIndex;
    if (index < 0) return 'No finished books yet this year.';
    final name = Fmt.monthYear(DateTime(stats.year, index + 1)).split(' ').first;
    final books = stats.booksPerMonth[index];
    final pages = stats.pagesPerMonth[index];
    return 'Best month: $name, $books ${books == 1 ? 'book' : 'books'} · '
        '${Fmt.count(pages)} pages';
  }
}

class _MetricGrid extends StatelessWidget {
  const _MetricGrid({required this.stats});

  final ReadingStatistics stats;

  @override
  Widget build(BuildContext context) {
    final cells = [
      (Fmt.count(stats.booksReadThisYear), 'Books read this year'),
      (Fmt.count(stats.pagesReadThisYear), 'Pages read'),
      (Fmt.count(stats.currentlyReading), 'Currently reading'),
      (
        stats.averageRating == null
            ? '—'
            : stats.averageRating!.toStringAsFixed(1),
        'Average rating'
      ),
    ];

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.ruleStrong,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.ruleStrong),
      ),
      child: Column(
        children: [
          for (var row = 0; row < 2; row++) ...[
            if (row > 0) const SizedBox(height: 1),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: _MetricCell(cell: cells[row * 2])),
                  const SizedBox(width: 1),
                  Expanded(child: _MetricCell(cell: cells[row * 2 + 1])),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MetricCell extends StatelessWidget {
  const _MetricCell({required this.cell});

  final (String, String) cell;

  @override
  Widget build(BuildContext context) => Container(
        color: AppColors.paperRaised,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(cell.$1, style: AppText.statFigure),
            const SizedBox(height: 4),
            Text(
              cell.$2,
              style: AppText.sans(
                size: 11,
                letterSpacing: .01,
                color: AppColors.muted2,
              ),
            ),
          ],
        ),
      );
}

class _MonthChart extends StatelessWidget {
  const _MonthChart({required this.stats});

  final ReadingStatistics stats;

  @override
  Widget build(BuildContext context) {
    final max = stats.maxBooksInMonth;
    final best = stats.bestMonthIndex;

    return Container(
      height: 118,
      padding: const EdgeInsets.only(bottom: 20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.ruleStrong)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < 12; i++)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 18),
                        height: max == 0
                            ? 3
                            : (stats.booksPerMonth[i] == 0
                                ? 3
                                : (stats.booksPerMonth[i] / max * 84)
                                    .clamp(4.0, 84.0)),
                        decoration: BoxDecoration(
                          color: stats.booksPerMonth[i] == 0
                              ? AppColors.barEmpty
                              : (i == best
                                  ? AppColors.barBest
                                  : AppColors.barDefault),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(3),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      StatisticsScreen._monthLetters[i],
                      maxLines: 1,
                      style: AppText.sans(size: 8.5, color: AppColors.faint),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _LanguageBar extends StatelessWidget {
  const _LanguageBar({required this.stats});

  final ReadingStatistics stats;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: SizedBox(
            height: 12,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < stats.byLanguage.length; i++)
                  Expanded(
                    flex: (stats.byLanguage[i].percent * 100).round().clamp(1, 100000),
                    child: ColoredBox(
                      color: AppColors.chart[i % AppColors.chart.length],
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 11),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            for (var i = 0; i < stats.byLanguage.length; i++)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: AppColors.chart[i % AppColors.chart.length],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${stats.byLanguage[i].label} '
                    '${stats.byLanguage[i].percent.round()}%',
                    style: AppText.sans(size: 12, color: AppColors.inkBody),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}

class _GenreBars extends StatelessWidget {
  const _GenreBars({required this.stats});

  final ReadingStatistics stats;

  @override
  Widget build(BuildContext context) {
    final max = stats.byGenre.fold(0, (a, s) => s.count > a ? s.count : a);

    return Column(
      children: [
        for (final slice in stats.byGenre)
          Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: Row(
              children: [
                SizedBox(
                  width: 88,
                  child: Text(
                    slice.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.sans(size: 12.5, color: AppColors.inkBody),
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: SizedBox(
                      height: 7,
                      child: Stack(
                        children: [
                          const Positioned.fill(
                            child: ColoredBox(color: AppColors.barEmpty),
                          ),
                          FractionallySizedBox(
                            widthFactor:
                                max == 0 ? 0 : (slice.count / max).clamp(0.0, 1.0),
                            heightFactor: 1,
                            child: const DecoratedBox(
                              decoration: BoxDecoration(
                                color: Color(0xFF5A5248),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 11),
                SizedBox(
                  width: 22,
                  child: Text(
                    '${slice.count}',
                    textAlign: TextAlign.end,
                    style: AppText.sans(size: 12, color: AppColors.muted2),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _AuthorRow extends StatelessWidget {
  const _AuthorRow({
    required this.rank,
    required this.slice,
    required this.last,
  });

  final int rank;
  final CountSlice slice;
  final bool last;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          border: last
              ? null
              : const Border(bottom: BorderSide(color: AppColors.ruleInner)),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 16,
              child: Text(
                '$rank',
                style: AppText.serif(size: 15, color: AppColors.chevron),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                slice.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.sans(size: 13.5, weight: 500),
              ),
            ),
            Text(
              slice.count == 1 ? '1 book' : '${slice.count} books',
              style: AppText.sans(size: 12.5, color: AppColors.muted2),
            ),
          ],
        ),
      );
}
