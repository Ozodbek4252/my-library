import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n_extensions.dart';
import '../../../core/routing/routes.dart';
import '../../../core/settings.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/theme/typography.dart';
import '../../../core/utils/formatting.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/app_icons.dart';
import '../../../core/widgets/app_sheet.dart';
import '../../../core/widgets/pills.dart';
import '../../../core/widgets/states.dart';
import '../../../data/repositories/library_repository.dart';
import '../../../domain/models/enums.dart';
import '../../../domain/models/library_models.dart';
import 'library_providers.dart';
import 'widgets/book_tile.dart';
import 'widgets/filter_sheet.dart';

/// The primary screen: header, stats strip, search/filter/sort controls, and
/// the collection as a grid or a list.
class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  /// Loads the next page shortly before the user reaches the end, so a large
  /// library never stalls at the bottom of the grid.
  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels < position.maxScrollExtent - 600) return;

    final loaded = ref.read(libraryEntriesProvider).value?.length ?? 0;
    final total = ref.read(libraryMatchCountProvider).value ?? 0;
    if (loaded > 0 && loaded < total) {
      ref.read(libraryPageProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final query = ref.watch(libraryQueryProvider);
    final entries = ref.watch(libraryEntriesProvider);
    final total = ref.watch(libraryTotalProvider).value ?? 0;
    final matches = ref.watch(libraryMatchCountProvider).value ?? 0;

    // A library that is genuinely empty gets its own screen, not an empty grid.
    if (total == 0 && !query.hasFilters && query.search.isEmpty) {
      if (entries.isLoading) {
        return const _LibraryLoading();
      }
      return const _EmptyLibrary();
    }

    return RefreshIndicator(
      color: AppColors.accent,
      backgroundColor: AppColors.paperRaised,
      onRefresh: () async {
        ref
          ..invalidate(libraryEntriesProvider)
          ..invalidate(filterOptionsProvider)
          ..invalidate(shelfCountProvider);
        await ref.read(filterOptionsProvider.future);
      },
      child: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenH,
              AppSpacing.screenTop,
              AppSpacing.screenH,
              0,
            ),
            sliver: SliverToBoxAdapter(
              child: _LibraryHeader(total: total, matches: matches),
            ),
          ),
          if (entries.isLoading && entries.value == null)
            const SliverToBoxAdapter(child: _GridSkeleton())
          else if (entries.hasError)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: ErrorStateView(
                  title: context.l10n.libraryErrorTitle,
                  message: context.l10n.libraryErrorMessage,
                  onRetry: () => ref.invalidate(libraryEntriesProvider),
                ),
              ),
            )
          else if ((entries.value ?? const []).isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.only(top: 60, bottom: 120),
                child: MessageState(
                  title: context.l10n.libraryNoMatchesTitle,
                  message: query.search.isNotEmpty
                      ? context.l10n.libraryNoMatchesFor(query.search)
                      : context.l10n.libraryNoFilterMatches,
                  icon: AppIcons.search,
                  titleSize: 22,
                  maxMessageWidth: 230,
                  primaryLabel: query.hasFilters
                      ? context.l10n.libraryClearFilters
                      : context.l10n.actionScanBarcode,
                  onPrimary: query.hasFilters
                      ? () => ref.read(libraryQueryProvider.notifier).clearFilters()
                      : () => context.push(Routes.scanner),
                  secondaryLabel: context.l10n.actionAddItManually,
                  onSecondary: () => context.push(Routes.addBook),
                ),
              ),
            )
          else if (settings.libraryView == LibraryView.grid)
            _BookGrid(
              entries: entries.value!,
              showCaptions: settings.showCaptions,
            )
          else
            _BookList(entries: entries.value!),
          SliverToBoxAdapter(
            child: _LoadMoreFooter(
              loaded: entries.value?.length ?? 0,
              total: matches,
            ),
          ),
        ],
      ),
    );
  }
}

class _LibraryHeader extends ConsumerWidget {
  const _LibraryHeader({required this.total, required this.matches});

  final int total;
  final int matches;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final query = ref.watch(libraryQueryProvider);
    final stats = ref.watch(libraryStatsProvider).value ?? LibraryStats.empty;
    final shelves = ref.watch(shelfCountProvider).value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.l10n.libraryTitle, style: AppText.screenTitle),
                  const SizedBox(height: 3),
                  Text(
                    Fmt.dotted([
                      context.l10n.bookCount(total),
                      shelves == null || shelves == 0
                          ? null
                          : context.l10n.libraryShelves(shelves),
                    ]),
                    style: AppText.sans(size: 12.5, color: AppColors.muted2),
                  ),
                ],
              ),
            ),
            _ViewToggle(
              view: settings.libraryView,
              onChanged: (view) =>
                  ref.read(settingsProvider.notifier).setLibraryView(view),
            ),
          ],
        ),
        if (settings.showStatsStrip) ...[
          const SizedBox(height: 18),
          GestureDetector(
            onTap: () => ref.read(settingsProvider.notifier).toggleStatsStrip(),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 11),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: AppColors.ruleStrong),
                  bottom: BorderSide(color: AppColors.ruleStrong),
                ),
              ),
              child: Row(
                children: [
                  _StatCell(value: stats.total, label: context.l10n.libraryStatTotal),
                  _StatCell(value: stats.unread, label: context.l10n.libraryStatUnread),
                  _StatCell(value: stats.reading, label: context.l10n.libraryStatReading),
                  _StatCell(value: stats.read, label: context.l10n.libraryStatRead),
                ],
              ),
            ),
          ),
        ],
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => context.push(Routes.search),
                child: Container(
                  height: 42,
                  padding: const EdgeInsets.symmetric(horizontal: 13),
                  decoration: BoxDecoration(
                    color: AppColors.paperRaised,
                    borderRadius: BorderRadius.circular(AppRadius.input),
                    border: Border.all(color: AppColors.ruleStrong),
                  ),
                  child: Row(
                    children: [
                      const AppIcon(
                        AppIcons.search,
                        size: 15,
                        color: AppColors.muted2,
                      ),
                      const SizedBox(width: 9),
                      Expanded(
                        child: Text(
                          query.search.isEmpty
                              ? context.l10n.librarySearchHint
                              : query.search,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.sans(
                            size: 14,
                            color: query.search.isEmpty
                                ? AppColors.muted2
                                : AppColors.ink,
                          ),
                        ),
                      ),
                      if (query.search.isNotEmpty)
                        GestureDetector(
                          onTap: () => ref
                              .read(libraryQueryProvider.notifier)
                              .setSearch(''),
                          child: const Padding(
                            padding: EdgeInsets.only(left: 6),
                            child: AppIcon(
                              AppIcons.close,
                              size: 14,
                              color: AppColors.faint,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            _SquareButton(
              icon: AppIcons.filter,
              active: query.hasFilters,
              onTap: () => showAppSheet(
                context,
                builder: (_) => const FilterSheet(),
              ),
            ),
            const SizedBox(width: 8),
            _SquareButton(
              icon: AppIcons.sort,
              active: false,
              onTap: () =>
                  showAppSheet(context, builder: (_) => const SortSheet()),
            ),
          ],
        ),
        if (query.hasFilters) ...[
          const SizedBox(height: 11),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (final (group, value) in query.activeFilters)
                RemovableFilterPill(
                  label: group == FilterGroup.status
                      ? ReadingStatus.fromName(value).display(context.l10n)
                      : value,
                  onRemove: () => ref
                      .read(libraryQueryProvider.notifier)
                      .toggleFilter(group, value),
                ),
              TextActionButtonSmall(
                label: context.l10n.actionClear,
                onPressed: () =>
                    ref.read(libraryQueryProvider.notifier).clearFilters(),
              ),
            ],
          ),
        ],
        const SizedBox(height: 14),
        Text(
          context.l10n.libraryCountLine(
            matches,
            total,
            query.sort.display(context.l10n).toLowerCase(),
          ),
          style: AppText.sans(
            size: 11,
            letterSpacing: .02,
            color: AppColors.muted2,
          ),
        ),
      ],
    );
  }
}

/// A compact rust text button used inline with filter pills.
class TextActionButtonSmall extends StatelessWidget {
  const TextActionButtonSmall({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Text(
            label,
            style: AppText.sans(size: 12, weight: 600, color: AppColors.accent),
          ),
        ),
      );
}

class _StatCell extends StatelessWidget {
  const _StatCell({required this.value, required this.label});

  final int value;
  final String label;

  @override
  Widget build(BuildContext context) => Expanded(
        child: Padding(
          padding: const EdgeInsets.only(left: 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(Fmt.count(value), style: AppText.statFigureSmall),
              const SizedBox(height: 2),
              Text(label.toUpperCase(), style: AppText.microLabel),
            ],
          ),
        ),
      );
}

class _ViewToggle extends StatelessWidget {
  const _ViewToggle({required this.view, required this.onChanged});

  final LibraryView view;
  final ValueChanged<LibraryView> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0xFFEBE4D7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _segment(AppIcons.grid, LibraryView.grid),
          const SizedBox(width: 4),
          _segment(AppIcons.list, LibraryView.list),
        ],
      ),
    );
  }

  Widget _segment(AppIconData icon, LibraryView target) {
    final active = view == target;
    return GestureDetector(
      onTap: () => onChanged(target),
      child: Container(
        width: 32,
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? AppColors.paperRaised : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: active ? AppShadows.segmentedThumb : null,
        ),
        child: AppIcon(
          icon,
          size: 15,
          color: active ? AppColors.ink : AppColors.muted2,
        ),
      ),
    );
  }
}

class _SquareButton extends StatelessWidget {
  const _SquareButton({
    required this.icon,
    required this.active,
    required this.onTap,
  });

  final AppIconData icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? AppColors.ink : AppColors.paperRaised,
          borderRadius: BorderRadius.circular(AppRadius.input),
          border: Border.all(
            color: active ? AppColors.ink : AppColors.ruleStrong,
          ),
        ),
        child: AppIcon(
          icon,
          size: 15,
          color: active ? AppColors.paper : AppColors.inkBody,
        ),
      ),
    );
  }
}

class _BookGrid extends StatelessWidget {
  const _BookGrid({required this.entries, required this.showCaptions});

  final List<LibraryEntry> entries;
  final bool showCaptions;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.screenH, 16, AppSpacing.screenH, 0),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 16,
          crossAxisSpacing: 12,
          childAspectRatio: showCaptions ? 2 / 3.42 : 2 / 3,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final entry = entries[index];
            return BookGridCell(
              entry: entry,
              showCaption: showCaptions,
              onTap: () => context.push(Routes.bookDetails(entry.work.id)),
            );
          },
          childCount: entries.length,
        ),
      ),
    );
  }
}

class _BookList extends StatelessWidget {
  const _BookList({required this.entries});

  final List<LibraryEntry> entries;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.screenH, 16, AppSpacing.screenH, 0),
      sliver: SliverList.builder(
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final entry = entries[index];
          return BookListRow(
            entry: entry,
            onTap: () => context.push(Routes.bookDetails(entry.work.id)),
          );
        },
      ),
    );
  }
}

class _LoadMoreFooter extends StatelessWidget {
  const _LoadMoreFooter({required this.loaded, required this.total});

  final int loaded;
  final int total;

  @override
  Widget build(BuildContext context) {
    if (loaded == 0 || loaded >= total) {
      return const SizedBox(height: AppSpacing.navClearance);
    }
    return const Padding(
      padding: EdgeInsets.only(top: 24, bottom: AppSpacing.navClearance),
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
    );
  }
}

class _GridSkeleton extends StatelessWidget {
  const _GridSkeleton();

  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.only(top: 16, bottom: AppSpacing.navClearance),
        child: LibrarySkeleton(),
      );
}

class _LibraryLoading extends StatelessWidget {
  const _LibraryLoading();

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: const EdgeInsets.only(
          top: AppSpacing.screenTop,
          bottom: AppSpacing.navClearance,
        ),
        child: LibrarySkeleton(message: context.l10n.libraryLoading),
      );
}

class _EmptyLibrary extends StatelessWidget {
  const _EmptyLibrary();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          // A minimum height alone leaves the Expanded below unbounded inside
          // a scroll view; IntrinsicHeight gives it something to expand into.
          child: IntrinsicHeight(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                26,
                64,
                26,
                AppSpacing.navClearance,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.libraryTitle,
                    style: AppText.serif(size: 30, letterSpacing: -.01),
                  ),
                  Expanded(
                    child: Center(
                      child: Transform.translate(
                        offset: const Offset(0, -40),
                        child: MessageState(
                          title: context.l10n.libraryEmptyTitle,
                          message: context.l10n.libraryEmptyMessage,
                          leading: const _DashedCovers(),
                          primaryLabel: context.l10n.actionScanBook,
                          onPrimary: () => context.push(Routes.scanner),
                          secondaryLabel: context.l10n.actionAddManually,
                          onSecondary: () => context.push(Routes.addBook),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DashedCovers extends StatelessWidget {
  const _DashedCovers();

  @override
  Widget build(BuildContext context) => const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _DashedCover(),
          SizedBox(width: 7),
          _DashedCover(),
          SizedBox(width: 7),
          _DashedCover(),
        ],
      );
}

class _DashedCover extends StatelessWidget {
  const _DashedCover();

  @override
  Widget build(BuildContext context) => const SizedBox(
        width: 52,
        height: 78,
        child: CustomPaint(
          painter: DashedBorderPainter(radius: AppRadius.cover),
        ),
      );
}
