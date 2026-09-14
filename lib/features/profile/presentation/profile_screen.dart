import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n_extensions.dart';
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

  static const _version = '1.0';

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
        Text(context.l10n.profileTitle, style: AppText.screenTitle),
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
                      context.l10n.profileMyLibrary,
                      style: AppText.sans(size: 15.5, weight: 600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      Fmt.dotted([
                        context.l10n.bookCount(total),
                        shelves == 0 ? null : context.l10n.shelfCount(shelves),
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
          title: context.l10n.profileReadingStatistics,
          subtitle: stats == null
              ? context.l10n.profileStatsFallback
              : context.l10n.profileStatsSubtitle(
                  context.l10n.bookCount(stats.booksReadThisYear),
                  Fmt.count(stats.pagesReadThisYear),
                ),
          onTap: () => context.push(Routes.statistics),
        ),
        SectionLabel(context.l10n.profileGroupLibrary, top: 24),
        PaperCard(
          children: [
            FieldRow(
              label: context.l10n.profileShelves,
              value: '$shelves',
              labelWidth: 160,
              verticalPadding: 14,
              onTap: () => _showShelves(context, ref),
            ),
            FieldRow(
              label: context.l10n.profileCovers,
              value: settings.showCaptions
                  ? context.l10n.profileCoversWithTitles
                  : context.l10n.profileCoversOnly,
              labelWidth: 160,
              verticalPadding: 14,
              onTap: () => ref.read(settingsProvider.notifier).toggleCaptions(),
            ),
            FieldRow(
              label: context.l10n.profileStatsStrip,
              value: settings.showStatsStrip
                  ? context.l10n.profileShown
                  : context.l10n.profileHidden,
              labelWidth: 160,
              verticalPadding: 14,
              onTap: () =>
                  ref.read(settingsProvider.notifier).toggleStatsStrip(),
              last: true,
            ),
          ],
        ),
        SectionLabel(context.l10n.profileGroupData, top: 24),
        PaperCard(
          children: [
            FieldRow(
              label: context.l10n.profileImportExport,
              value: '',
              labelWidth: 160,
              verticalPadding: 14,
              onTap: () => context.push(Routes.importExport),
            ),
            FieldRow(
              label: context.l10n.profileStorage,
              value: context.l10n.profileStorageValue,
              labelWidth: 160,
              verticalPadding: 14,
              onTap: () => _showStorageInfo(context),
            ),
            FieldRow(
              label: context.l10n.profileSampleLibrary,
              value: context.l10n.profileSampleReset,
              labelWidth: 160,
              verticalPadding: 14,
              onTap: () => _resetSampleLibrary(context, ref),
              last: true,
            ),
          ],
        ),
        SectionLabel(context.l10n.profileGroupApp, top: 24),
        PaperCard(
          children: [
            FieldRow(
              label: context.l10n.profileLanguage,
              value: settings.language.endonym,
              labelWidth: 160,
              verticalPadding: 14,
              onTap: () => _showLanguages(context, ref, settings.language),
            ),
            FieldRow(
              label: context.l10n.profileAppearance,
              value: context.l10n.profileAppearanceValue,
              labelWidth: 160,
              verticalPadding: 14,
            ),
            FieldRow(
              label: context.l10n.profileShowOnboarding,
              value: '',
              labelWidth: 160,
              verticalPadding: 14,
              onTap: () async {
                await ref.read(settingsProvider.notifier).resetOnboarding();
                if (context.mounted) context.go(Routes.onboarding);
              },
            ),
            FieldRow(
              label: context.l10n.profileVersion,
              value: _version,
              labelWidth: 160,
              verticalPadding: 14,
              last: true,
            ),
          ],
        ),
        const SizedBox(height: 28),
        Text(
          context.l10n.profileFooter(_version),
          textAlign: TextAlign.center,
          style: AppText.sans(size: 11.5, color: AppColors.faintest),
        ),
      ],
    );
  }

  /// The interface language. Each option is written in itself, so someone who
  /// has landed in a language they cannot read can still find their way back.
  Future<void> _showLanguages(
    BuildContext context,
    WidgetRef ref,
    AppLanguage current,
  ) async {
    final picked = await showAppSheet<AppLanguage>(
      context,
      builder: (sheetContext) => AppSheet(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(context.l10n.profileLanguageTitle, style: AppText.sheetTitle),
            const SizedBox(height: 6),
            Text(
              context.l10n.profileLanguageSubtitle,
              style: AppText.sans(size: 13, height: 1.5, color: AppColors.muted),
            ),
            const SizedBox(height: 14),
            PaperCard(
              children: [
                for (var i = 0; i < AppLanguage.values.length; i++)
                  FieldRow(
                    label: AppLanguage.values[i].endonym,
                    labelWidth: 200,
                    value: AppLanguage.values[i] == current ? '✓' : '',
                    verticalPadding: 14,
                    last: i == AppLanguage.values.length - 1,
                    onTap: () => Navigator.of(sheetContext)
                        .pop(AppLanguage.values[i]),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
    if (picked == null || picked == current) return;
    await ref.read(settingsProvider.notifier).setLanguage(picked);
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
            Text(context.l10n.profileShelvesTitle, style: AppText.sheetTitle),
            const SizedBox(height: 6),
            Text(
              context.l10n.profileShelvesSubtitle,
              style: AppText.sans(
                size: 13,
                height: 1.5,
                color: AppColors.muted,
              ),
            ),
            const SizedBox(height: 14),
            if (sorted.isEmpty)
              Text(
                context.l10n.profileShelvesEmpty,
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
              Text(
                context.l10n.profileStorageTitle,
                style: AppText.sheetTitle,
              ),
              const SizedBox(height: 10),
              Text(
                context.l10n.profileStorageBody,
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
    final l10n = context.l10n;
    final confirmed = await showConfirmDialog(
      context,
      title: l10n.profileResetTitle,
      message: l10n.profileResetMessage,
      confirmLabel: l10n.profileResetConfirm,
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
    AppToast.show(context, l10n.toastSampleRestored);
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
