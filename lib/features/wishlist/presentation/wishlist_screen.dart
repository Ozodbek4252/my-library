import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/routes.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/theme/typography.dart';
import '../../../core/utils/formatting.dart';
import '../../../core/widgets/book_cover.dart';
import '../../../core/widgets/pills.dart';
import '../../../core/widgets/states.dart';
import '../../../data/repositories/wishlist_repository.dart';
import '../../../domain/models/enums.dart';
import '../../../domain/models/library_models.dart';
import 'wishlist_providers.dart';

/// Books the user wants but does not own. No prices anywhere.
class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(wishlistProvider);
    final filters = ref.watch(wishlistFiltersProvider).value ?? const [];
    final selected = ref.watch(wishlistFilterProvider);
    final total = ref.watch(wishlistCountProvider).value ?? 0;
    final highPriority = (entries.value ?? const [])
        .where((e) => e.priority == Priority.high)
        .length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenH,
        AppSpacing.screenTop,
        AppSpacing.screenH,
        AppSpacing.navClearance,
      ),
      children: [
        Text('Wishlist', style: AppText.screenTitle),
        const SizedBox(height: 3),
        Text(
          Fmt.dotted([
            Fmt.pluralBooks(total),
            highPriority == 0 ? null : '$highPriority high priority',
          ]),
          style: AppText.sans(size: 12.5, color: AppColors.muted2),
        ),
        if (filters.length > 1) ...[
          const SizedBox(height: 16),
          SizedBox(
            height: 34,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: filters.length,
              separatorBuilder: (_, _) => const SizedBox(width: 7),
              itemBuilder: (context, index) {
                final filter = filters[index];
                final isAll = filter.kind == WishlistFilterKind.all;
                return AppChip(
                  label: filter.label,
                  selected: isAll ? selected == null : selected == filter,
                  onTap: () => ref
                      .read(wishlistFilterProvider.notifier)
                      .select(isAll ? null : filter),
                );
              },
            ),
          ),
        ],
        const SizedBox(height: 8),
        entries.when(
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
            message: 'Your wishlist could not be loaded.',
            onRetry: () => ref.invalidate(wishlistProvider),
          ),
          data: (items) {
            if (items.isEmpty) {
              return Padding(
                padding: const EdgeInsets.only(top: 50),
                child: MessageState(
                  title: selected == null
                      ? 'Nothing on the list yet'
                      : 'Nothing matches that',
                  message: selected == null
                      ? 'Scan a book you want but do not own, and it lands '
                          'here instead of on your shelves.'
                      : 'Try another filter.',
                  titleSize: 22,
                  maxMessageWidth: 260,
                  primaryLabel: selected == null ? 'Scan a book' : 'Show all',
                  onPrimary: () {
                    if (selected == null) {
                      context.push(Routes.scanner);
                    } else {
                      ref.read(wishlistFilterProvider.notifier).select(null);
                    }
                  },
                ),
              );
            }
            return Column(
              children: [
                for (final entry in items) _WishlistRow(entry: entry),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _WishlistRow extends StatelessWidget {
  const _WishlistRow({required this.entry});

  final WishlistEntry entry;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.push(Routes.wishlistDetail(entry.item.id)),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.rule)),
        ),
        child: Row(
          children: [
            BookCover(
              title: entry.work.title,
              colorIndex: entry.desiredEditionColor,
              width: 38,
              height: 57,
              radius: AppRadius.thumb,
              shadows: AppShadows.thumb,
              titleSize: 7.5,
              authorSize: 0,
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
                    style: AppText.listPrimary,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    Fmt.authors(entry.work.authors),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.listSecondary,
                  ),
                  if (entry.wantLine.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      entry.wantLine,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.metadata,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 10),
            AppPill.priority(entry.priority),
          ],
        ),
      ),
    );
  }
}
