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
import '../../../core/widgets/app_icons.dart';
import '../../../core/widgets/app_sheet.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../core/widgets/pills.dart';
import '../../../core/widgets/states.dart';
import '../../../data/repositories/collection_mutations.dart';
import '../../../domain/models/book_draft.dart';
import '../../../domain/models/enums.dart';
import '../../../domain/models/library_models.dart';
import 'add_book_screen.dart';
import 'book_details_screen.dart';
import 'book_providers.dart';

/// Every edition and copy of one work. This is where the data model becomes
/// visible: reading status belongs to the work, everything else to the copy.
class EditionsScreen extends ConsumerWidget {
  const EditionsScreen({super.key, required this.workId});

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
            message: context.l10n.editionsErrorMessage,
            onRetry: () => ref.invalidate(bookDetailsProvider(workId)),
          ),
        ),
        data: (data) => data == null
            ? SafeArea(
                child: MessageState(
                  title: context.l10n.detailsRemovedTitle,
                  message: context.l10n.detailsRemovedMessage,
                  titleSize: 22,
                  primaryLabel: context.l10n.actionBackToLibrary,
                  onPrimary: () => context.go(Routes.library),
                ),
              )
            : _EditionsBody(details: data),
      ),
    );
  }
}

class _EditionsBody extends ConsumerWidget {
  const _EditionsBody({required this.details});

  final BookDetails details;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final work = details.work;
    final copies = details.totalCopies;

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
            size: 34,
            border: Border.all(color: AppColors.ruleStrong),
            onPressed: () =>
                context.canPop() ? context.pop() : context.go(Routes.library),
            child: const AppIcon(AppIcons.chevronLeft, size: 16),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          work.title,
          style: AppText.serif(size: 29, height: 1.1, letterSpacing: -.01),
        ),
        const SizedBox(height: 3),
        Text(
          Fmt.dotted([
            context.l10n.authorsOf(work.authors),
            work.firstPublished == null
                ? null
                : context.l10n.editionsFirstPublished(work.firstPublished!),
          ]),
          style: AppText.sans(size: 13.5, color: AppColors.muted2),
        ),
        const SizedBox(height: 12),
        Text(
          details.editions.length == 1 && copies == 1
              ? context.l10n.editionsExplainerOne
              : context.l10n.editionsExplainerMany(
                  context.l10n.editionsCopyCount(copies),
                  context.l10n.editionsEditionCount(details.editions.length),
                ),
          style: AppText.sans(size: 12, height: 1.5, color: AppColors.faint),
        ),
        const SizedBox(height: 20),
        for (final edition in details.editions) ...[
          _EditionCard(details: details, edition: edition),
          const SizedBox(height: 11),
        ],
        const SizedBox(height: 5),
        DashedButton(
          label: context.l10n.editionsAddAnother,
          onPressed: () => context.push(
            Routes.addBook,
            extra: AddBookArgs(
              existingWorkId: details.work.id,
              prefill: BookDraft(
                workId: details.work.id,
                title: work.title,
                authors: [...work.authors],
                genres: [...work.genres],
                description: work.description,
                originalTitle: work.originalTitle,
                originalLanguage: work.originalLanguage,
                seriesName: work.seriesName,
                seriesIndex: work.seriesIndex,
                firstPublished: work.firstPublished,
                readingStatus: details.status,
              ),
            ),
          ),
        ),
      ],
    );
  }

}

class _EditionCard extends ConsumerWidget {
  const _EditionCard({required this.details, required this.edition});

  final BookDetails details;
  final EditionWithCopies edition;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final e = edition.edition;
    final isPrimary = e.id == details.primaryEditionId;
    final color = AppColors
        .coverPalette[e.coverColorIndex.abs() % AppColors.coverPalette.length]
        .$1;

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.paperRaised,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.ruleStrong),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 66,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(width: 4, color: const Color(0x47000000)),
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            e.language ?? context.l10n.editionsUnknownLanguage,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.sans(size: 14.5, weight: 600),
                          ),
                        ),
                        const SizedBox(width: 7),
                        if (isPrimary)
                          AppPill(
                            label: context.l10n.editionsReadingCopy,
                            background: AppColors.paperChip,
                            foreground: const Color(0xFF6B635A),
                          )
                        else if (edition.copies.any((c) => c.isGift))
                          AppPill(
                            label: context.l10n.editionsGiftTag,
                            background: AppColors.paperChip,
                            foreground: const Color(0xFF6B635A),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      Fmt.dotted([
                        e.editionName ?? e.publisher,
                        e.format,
                        e.publishedYear?.toString(),
                      ]),
                      style: AppText.sans(
                        size: 12.5,
                        height: 1.5,
                        color: AppColors.muted,
                      ),
                    ),
                    const SizedBox(height: 5),
                    for (final copy in edition.copies)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 3),
                        child: Text(
                          Fmt.dotted([
                            e.pageCount == null
                                ? null
                                : context.l10n
                                    .editionsPagesShort(e.pageCount!),
                            copy.isGift
                                ? context.l10n.editionsFromPerson(
                                    copy.giftFrom ??
                                        context.l10n.detailsGiftAFriend,
                                  )
                                : Fmt.money(copy.purchasePrice, copy.currency)
                                        == '—'
                                    ? null
                                    : Fmt.money(
                                        copy.purchasePrice,
                                        copy.currency,
                                      ),
                            copy.location,
                          ]),
                          style: AppText.sans(
                            size: 11.5,
                            color: AppColors.faint,
                          ),
                        ),
                      ),
                    if (edition.copies.isEmpty)
                      Text(
                        context.l10n.editionsNotOwnedYet,
                        style:
                            AppText.sans(size: 11.5, color: AppColors.faint),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (!isPrimary)
                Expanded(
                  child: SecondaryButton(
                    label: context.l10n.editionsShowAsMain,
                    height: 38,
                    fontSize: 13,
                    onPressed: () async {
                      await ref
                          .read(databaseProvider)
                          .setPrimaryEdition(details.work.id, e.id);
                      if (context.mounted) {
                        AppToast.show(
                          context,
                          context.l10n.toastMainEditionUpdated,
                        );
                      }
                    },
                  ),
                ),
              if (!isPrimary) const SizedBox(width: 8),
              Expanded(
                child: SecondaryButton(
                  label: context.l10n.editionsAddAnotherCopy,
                  height: 38,
                  fontSize: 13,
                  onPressed: () => _addCopy(context, ref),
                ),
              ),
              if (edition.copies.isNotEmpty) ...[
                const SizedBox(width: 8),
                SizedBox(
                  width: 44,
                  height: 38,
                  child: Material(
                    color: AppColors.accentWash,
                    borderRadius: BorderRadius.circular(AppRadius.button),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(AppRadius.button),
                      onTap: () => confirmRemoveCopy(
                        context,
                        ref,
                        details,
                        copy: edition.copies.last,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(AppRadius.button),
                          border: Border.all(color: AppColors.accentBorder),
                        ),
                        child: const Center(
                          child: AppIcon(
                            AppIcons.trash,
                            size: 16,
                            color: AppColors.accent,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  /// Adding a second physical copy of an edition you already own — the design's
  /// "Add another copy".
  Future<void> _addCopy(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final confirmed = await showConfirmDialog(
      context,
      title: l10n.editionsAddCopyTitle,
      message: l10n.editionsAddCopyMessage(
        edition.edition.format?.toLowerCase() ?? l10n.editionsGenericFormat,
      ),
      confirmLabel: l10n.editionsAddCopyConfirm,
      cancelLabel: l10n.actionCancel,
      destructive: false,
    );
    if (!confirmed || !context.mounted) return;

    await ref.read(databaseProvider).addCopyToEdition(
          edition.edition.id,
          CopyDraft(ownership: Ownership.owned),
        );
    if (context.mounted) AppToast.show(context, l10n.toastCopyAdded);
  }
}
