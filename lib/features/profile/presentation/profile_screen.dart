import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers.dart';
import '../../../core/routing/routes.dart';
import '../../../core/settings.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/theme/typography.dart';
import '../../../core/utils/formatting.dart';
import '../../../core/widgets/app_icons.dart';
import '../../../core/widgets/app_sheet.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../core/widgets/layout.dart';
import '../../library/presentation/library_providers.dart';
import '../../statistics/presentation/statistics_screen.dart';

/// Identity, a shortcut into statistics, and the app's settings.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final total = ref.watch(libraryTotalProvider).value ?? 0;
    final shelves = ref.watch(shelfCountProvider).value ?? 0;
    final stats = ref.watch(statisticsProvider).value;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenH,
        AppSpacing.screenTop,
        AppSpacing.screenH,
        AppSpacing.navClearance,
      ),
      children: [
        Text('Profile', style: AppText.screenTitle),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.paperRaised,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: AppColors.ruleStrong),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.ink,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  'MK',
                  style: AppText.serif(size: 21, color: AppColors.paper),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My library',
                      style: AppText.sans(size: 15.5, weight: 600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      Fmt.dotted([
                        Fmt.pluralBooks(total),
                        shelves == 0
                            ? null
                            : '$shelves ${shelves == 1 ? 'shelf' : 'shelves'}',
                      ]),
                      style: AppText.sans(
                        size: 12.5,
                        color: AppColors.muted2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _TappableCard(
          title: 'Reading statistics',
          subtitle: stats == null
              ? 'Calculated from your reading log'
              : '${stats.booksReadThisYear} '
                  '${stats.booksReadThisYear == 1 ? 'book' : 'books'} this year '
                  '· ${Fmt.count(stats.pagesReadThisYear)} pages',
          onTap: () => context.push(Routes.statistics),
        ),
        const SectionLabel('Library', top: 24),
        PaperCard(
          children: [
            FieldRow(
              label: 'Shelves & locations',
              value: '$shelves',
              labelWidth: 160,
              verticalPadding: 14,
              onTap: () => _showShelves(context, ref),
            ),
            FieldRow(
              label: 'Book covers',
              value: settings.showCaptions ? 'With titles' : 'Covers only',
              labelWidth: 160,
              verticalPadding: 14,
              onTap: () => ref.read(settingsProvider.notifier).toggleCaptions(),
            ),
            FieldRow(
              label: 'Library stats strip',
              value: settings.showStatsStrip ? 'Shown' : 'Hidden',
              labelWidth: 160,
              verticalPadding: 14,
              onTap: () =>
                  ref.read(settingsProvider.notifier).toggleStatsStrip(),
              last: true,
            ),
          ],
        ),
        const SectionLabel('Data', top: 24),
        PaperCard(
          children: [
            FieldRow(
              label: 'Import & export',
              value: '',
              labelWidth: 160,
              verticalPadding: 14,
              onTap: () => context.push(Routes.importExport),
            ),
            FieldRow(
              label: 'Storage',
              value: 'On this device',
              labelWidth: 160,
              verticalPadding: 14,
              onTap: () => _showStorageInfo(context),
            ),
            FieldRow(
              label: 'Sample library',
              value: 'Reset',
              labelWidth: 160,
              verticalPadding: 14,
              onTap: () => _resetSampleLibrary(context, ref),
              last: true,
            ),
          ],
        ),
        const SectionLabel('App', top: 24),
        PaperCard(
          children: [
            FieldRow(
              label: 'Appearance',
              value: 'Paper',
              labelWidth: 160,
              verticalPadding: 14,
            ),
            FieldRow(
              label: 'Show onboarding again',
              value: '',
              labelWidth: 160,
              verticalPadding: 14,
              onTap: () async {
                await ref.read(settingsProvider.notifier).resetOnboarding();
                if (context.mounted) context.go(Routes.onboarding);
              },
            ),
            FieldRow(
              label: 'Version',
              value: '1.0',
              labelWidth: 160,
              verticalPadding: 14,
              last: true,
            ),
          ],
        ),
        const SizedBox(height: 28),
        Text(
          'Book Collection 1.0 · your library lives on your device',
          textAlign: TextAlign.center,
          style: AppText.sans(size: 11.5, color: AppColors.faintest),
        ),
      ],
    );
  }

  Future<void> _showShelves(BuildContext context, WidgetRef ref) async {
    final db = ref.read(databaseProvider);
    final copies = await db.select(db.copies).get();
    final counts = <String, int>{};
    for (final copy in copies) {
      final location = copy.location?.trim();
      if (location == null || location.isEmpty) continue;
      counts[location] = (counts[location] ?? 0) + 1;
    }
    final sorted = counts.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    if (!context.mounted) return;
    await showAppSheet<void>(
      context,
      builder: (_) => AppSheet(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Shelves & locations', style: AppText.sheetTitle),
            const SizedBox(height: 6),
            Text(
              'Where your copies live. Set a location on any copy from its '
              'edit screen.',
              style: AppText.sans(
                size: 13,
                height: 1.5,
                color: AppColors.muted,
              ),
            ),
            const SizedBox(height: 14),
            if (sorted.isEmpty)
              Text(
                'No locations recorded yet.',
                style: AppText.sans(size: 13.5, color: AppColors.faint),
              )
            else
              PaperCard(
                children: [
                  for (var i = 0; i < sorted.length; i++)
                    FieldRow(
                      label: sorted[i].key,
                      labelWidth: 200,
                      value: '${sorted[i].value}',
                      last: i == sorted.length - 1,
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _showStorageInfo(BuildContext context) => showAppSheet<void>(
        context,
        builder: (_) => AppSheet(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Where your library lives', style: AppText.sheetTitle),
              const SizedBox(height: 10),
              Text(
                'Everything — books, editions, copies, reading history and '
                'your wishlist — is stored in a local database on this device. '
                'It works with no signal, which is what the bookstore flow '
                'needs.\n\nThe only time the app reaches the network is to look '
                'up a book you have scanned but do not own. Even then, a '
                'bundled catalogue answers first.',
                style: AppText.sans(
                  size: 13.5,
                  height: 1.6,
                  color: AppColors.inkBody,
                ),
              ),
            ],
          ),
        ),
      );

  Future<void> _resetSampleLibrary(BuildContext context, WidgetRef ref) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Reset to the sample library?',
      message: 'Every book, edition, copy, note, photo link, reading entry and '
          'wishlist item you have added will be deleted and replaced with the '
          'sample collection. This cannot be undone.',
      confirmLabel: 'Delete everything and reset',
    );
    if (!confirmed || !context.mounted) return;

    final seeder = ref.read(seederProvider);
    await seeder.reset();
    await seeder.seed();
    if (!context.mounted) return;

    ref
      ..invalidate(libraryTotalProvider)
      ..invalidate(filterOptionsProvider)
      ..invalidate(shelfCountProvider);
    AppToast.show(context, 'Sample library restored');
  }
}

class _TappableCard extends StatelessWidget {
  const _TappableCard({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: AppColors.paperRaised,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: AppColors.ruleStrong),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppText.sans(size: 13.5, weight: 600)),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppText.sans(
                        size: 11.5,
                        color: AppColors.muted2,
                      ),
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
