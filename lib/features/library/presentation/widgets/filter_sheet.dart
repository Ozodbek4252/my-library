import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n_extensions.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/app_icons.dart';
import '../../../../core/widgets/app_sheet.dart';
import '../../../../core/widgets/layout.dart';
import '../../../../core/widgets/pills.dart';
import '../../../../domain/models/enums.dart';
import '../library_providers.dart';

/// Multi-select within a group, AND-ed across groups. The primary button
/// counts the result so the user knows what applying will do.
class FilterSheet extends ConsumerWidget {
  const FilterSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(libraryQueryProvider);
    final options = ref.watch(filterOptionsProvider);
    final matches = ref.watch(libraryMatchCountProvider).value;

    return AppSheet(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(context.l10n.filterTitle, style: AppText.sheetTitle),
              TextActionButton(
                label: context.l10n.actionReset,
                fontSize: 13.5,
                onPressed: query.hasFilters
                    ? () => ref.read(libraryQueryProvider.notifier).clearFilters()
                    : null,
              ),
            ],
          ),
          options.when(
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
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
            error: (error, _) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Text(
                context.l10n.filterLoadFailed,
                style: AppText.sans(size: 13.5, color: AppColors.muted),
              ),
            ),
            data: (groups) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final entry in groups.entries)
                  if (entry.value.isNotEmpty) ...[
                    SectionLabel(entry.key.display(context.l10n), top: 20, bottom: 9),
                    ChipWrap(
                      children: [
                        for (final option in entry.value)
                          AppChip(
                            // Status options are enum names; everything else is
                            // a value out of the collection and shows as-is.
                            label: entry.key == FilterGroup.status
                                ? ReadingStatus.fromName(option).display(context.l10n)
                                : option,
                            selected:
                                query.filters[entry.key]?.contains(option) ??
                                    false,
                            onTap: () => ref
                                .read(libraryQueryProvider.notifier)
                                .toggleFilter(entry.key, option),
                          ),
                      ],
                    ),
                  ],
              ],
            ),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            label: query.hasFilters
                ? context.l10n.filterShowBooks(matches ?? 0)
                : context.l10n.actionDone,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

/// Single-select, with a rust check on the active row; picking closes the
/// sheet.
class SortSheet extends ConsumerWidget {
  const SortSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(libraryQueryProvider).sort;

    return AppSheet(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(context.l10n.sortTitle, style: AppText.sheetTitle),
          ),
          for (final option in SortOption.values)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                ref.read(libraryQueryProvider.notifier).setSort(option);
                Navigator.of(context).pop();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppColors.rule)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        option.display(context.l10n),
                        style: AppText.sans(
                          size: 15,
                          weight: option == current ? 600 : 400,
                        ),
                      ),
                    ),
                    if (option == current)
                      const AppIcon(
                        AppIcons.check,
                        size: 17,
                        color: AppColors.accent,
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
