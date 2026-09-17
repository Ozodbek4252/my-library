import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n_extensions.dart';
import '../../../../core/providers.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/utils/formatting.dart';
import '../../../../core/utils/isbn.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/app_icons.dart';
import '../../../../core/widgets/app_sheet.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/book_cover.dart';
import '../../../../core/widgets/layout.dart';
import '../../../../core/widgets/pills.dart';
import '../../../../data/metadata/book_metadata.dart';
import '../../../../data/repositories/collection_mutations.dart';
import '../../../../data/repositories/scan_service.dart';
import '../../../../domain/models/book_draft.dart';
import '../../../../domain/models/enums.dart';
import '../../../../domain/models/library_models.dart';

/// What the user chose to do next on a result sheet.
///
/// The sheet reports the choice and nothing more: it is about to be torn down,
/// and a route pushed from a dead context goes nowhere. The scanner is still
/// alive, still knows which book was scanned, and does the navigating.
enum ScanNextAction { scanNext, close, openBook, addWithDetails }

/// The verdict sheet. Owned and not-owned share one layout so the answer always
/// lands in the same place, and all five bookstore questions — own it, which
/// edition, read it, wishlisted, key details — are answered without leaving it.
class ScanResultSheet extends ConsumerStatefulWidget {
  const ScanResultSheet({super.key, required this.result});

  final ScanResult result;

  @override
  ConsumerState<ScanResultSheet> createState() => _ScanResultSheetState();
}

class _ScanResultSheetState extends ConsumerState<ScanResultSheet> {
  bool _busy = false;

  ScanResult get result => widget.result;

  Future<void> _add({bool withDetails = false}) async {
    if (withDetails) {
      Navigator.of(context).pop(ScanNextAction.addWithDetails);
      return;
    }

    final draft = result.toDraft()..ownership = Ownership.owned;
    final l10n = context.l10n;
    setState(() => _busy = true);
    try {
      // A scanned edition already on the shelves becomes a second copy of it;
      // a new ISBN becomes a new edition of the work it belongs to.
      final String message;
      if (result.verdict == ScanVerdict.ownedSameEdition &&
          result.matchedEdition != null) {
        await ref.read(databaseProvider).addCopyToEdition(
              result.matchedEdition!.id,
              CopyDraft(ownership: Ownership.owned),
            );
        message = l10n.toastAnotherCopyAdded;
      } else {
        final outcome = await ref.read(databaseProvider).addBook(draft);
        message = outcome.clearedWishlist
            ? l10n.toastAddedClearedWishlist
            : outcome.createdWork
                ? l10n.toastAddedToLibrary
                : l10n.toastEditionAdded;
      }

      if (!mounted) return;
      AppToast.show(context, message);
      Navigator.of(context).pop(ScanNextAction.close);
    } catch (_) {
      if (!mounted) return;
      setState(() => _busy = false);
      AppToast.show(context, l10n.toastCouldNotAdd, success: false);
    }
  }

  Future<void> _wishlist() async {
    final l10n = context.l10n;
    setState(() => _busy = true);
    try {
      await ref.read(wishlistRepositoryProvider).add(draft: result.toDraft());
      if (!mounted) return;
      AppToast.show(context, l10n.toastAddedToWishlist);
      Navigator.of(context).pop(ScanNextAction.close);
    } catch (_) {
      if (!mounted) return;
      setState(() => _busy = false);
      AppToast.show(context, l10n.toastCouldNotWishlist, success: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final owned = result.isOwned;
    final details = result.details;
    final metadata = result.metadata;

    return AppSheet(
      radius: AppRadius.sheet,
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 30),
      maxHeightFraction: .9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _VerdictBanner(owned: owned),
          const SizedBox(height: 20),
          _BookBlock(result: result),
          if (owned && details != null) ...[
            const SizedBox(height: 20),
            _CopiesCard(details: details, scannedEditionId: result.matchedEdition?.id),
          ],
          if (result.verdict == ScanVerdict.ownedOtherEdition) ...[
            const SizedBox(height: 12),
            _ScannedCopyCard(metadata: metadata, isbn: result.isbn),
          ],
          if (!owned && result.isWishlisted) ...[
            const SizedBox(height: 16),
            _InfoNote(
              text: context.l10n.scanWishlistNote(
                Fmt.monthShort(result.wishlistItem!.dateAdded),
              ),
            ),
          ],
          if (result.enrichment.isNotEmpty) ...[
            const SizedBox(height: 16),
            _InfoNote(
              icon: AppIcons.check,
              text: context.l10n.scanEnrichedNote(
                result.enrichment.filled.summary(context.l10n),
              ),
            ),
          ],
          const SizedBox(height: 18),
          PrimaryButton(
            label: switch (result.verdict) {
              ScanVerdict.ownedSameEdition => context.l10n.scanAddAnotherCopy,
              ScanVerdict.ownedOtherEdition =>
                context.l10n.scanAddAsAnotherEdition,
              ScanVerdict.notInLibrary => context.l10n.scanAddToLibrary,
            },
            busy: _busy,
            onPressed: _busy ? null : _add,
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  label: owned
                      ? context.l10n.actionOpenBook
                      : context.l10n.scanAddWithDetails,
                  onPressed: _busy
                      ? null
                      : () {
                          if (owned && details != null) {
                            Navigator.of(context).pop(ScanNextAction.openBook);
                          } else {
                            _add(withDetails: true);
                          }
                        },
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: SecondaryButton(
                  label: context.l10n.actionScanNext,
                  onPressed: _busy
                      ? null
                      : () => Navigator.of(context).pop(ScanNextAction.scanNext),
                ),
              ),
            ],
          ),
          if (!owned) ...[
            const SizedBox(height: 9),
            SecondaryButton(
              label: result.isWishlisted
                  ? context.l10n.scanAlreadyWishlisted
                  : context.l10n.scanWishlistIt,
              onPressed: _busy || result.isWishlisted ? null : _wishlist,
            ),
          ],
        ],
      ),
    );
  }
}

String _failureTitle(AppL10n l10n, ScanFailure failure) => switch (failure.kind) {
      ScanFailureKind.invalidBarcode => l10n.scanFailBarcodeTitle,
      ScanFailureKind.notFound => l10n.scanFailNotFoundTitle,
      ScanFailureKind.network => l10n.scanFailNetworkTitle,
      ScanFailureKind.unknown => l10n.scanFailUnknownTitle,
    };

String _failureMessage(AppL10n l10n, ScanFailure failure) =>
    switch (failure.kind) {
      ScanFailureKind.invalidBarcode => l10n.scanFailBarcodeMessage,
      ScanFailureKind.notFound =>
        l10n.scanFailNotFoundMessage(failure.isbn ?? l10n.scanFailThatCode),
      ScanFailureKind.network => l10n.scanFailNetworkMessage,
      ScanFailureKind.unknown => l10n.scanFailUnknownMessage,
    };

class _VerdictBanner extends StatelessWidget {
  const _VerdictBanner({required this.owned});

  final bool owned;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
      decoration: BoxDecoration(
        color: owned ? AppColors.successBg : AppColors.paperChip,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: owned ? AppColors.successBorder : AppColors.ruleStrong,
        ),
      ),
      child: Row(
        children: [
          AppIcon(
            owned ? AppIcons.check : AppIcons.plus,
            size: 18,
            color: owned ? AppColors.successFg : AppColors.inkBody,
            strokeWidth: owned ? 2.2 : 2,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              owned
                  ? context.l10n.scanOwnedBanner
                  : context.l10n.scanNewBanner,
              style: AppText.sans(
                size: 15.5,
                weight: 600,
                letterSpacing: -.005,
                color: owned ? AppColors.successInk : AppColors.ink2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BookBlock extends StatelessWidget {
  const _BookBlock({required this.result});

  final ScanResult result;

  @override
  Widget build(BuildContext context) {
    final metadata = result.metadata;
    final details = result.details;
    final work = details?.work;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BookCover(
          title: metadata.title,
          author: Fmt.surname(metadata.authors),
          colorIndex: metadata.toDraft().coverColorIndex,
          coverUrl: metadata.coverUrl,
          width: 96,
          height: 144,
          titleSize: 17,
          authorSize: 7,
          spineWidth: 6,
          shadows: const [
            BoxShadow(
              color: Color(0x381A1714),
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                metadata.title,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: AppText.serif(size: 25, height: 1.12, letterSpacing: -.01),
              ),
              const SizedBox(height: 3),
              Text(
                context.l10n.authorsOf(metadata.authors),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppText.sans(size: 14, color: AppColors.muted),
              ),
              const SizedBox(height: 12),
              if (work != null)
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    AppPill(
                      label: Fmt.dotted([
                        ReadingStatus.fromName(work.readingStatus)
                            .display(context.l10n),
                        work.finishDate == null
                            ? null
                            : Fmt.monthShort(work.finishDate!),
                      ]),
                      background: statusColors(
                        ReadingStatus.fromName(work.readingStatus),
                      ).bg,
                      foreground: statusColors(
                        ReadingStatus.fromName(work.readingStatus),
                      ).fg,
                      height: 26,
                      fontSize: 11.5,
                      horizontalPadding: 10,
                    ),
                    if ((work.rating ?? 0) > 0)
                      AppPill(
                        label: context.l10n.ratingOf(work.rating),
                        background: const Color(0xFFEFE7D8),
                        foreground: const Color(0xFF7A6136),
                        height: 26,
                        fontSize: 11.5,
                        horizontalPadding: 10,
                      ),
                  ],
                )
              else
                Text(
                  [
                    Fmt.dotted([metadata.language, metadata.publisher]),
                    Fmt.dotted([
                      metadata.format,
                      metadata.publishedYear?.toString(),
                      metadata.pageCount == null
                          ? null
                          : '${metadata.pageCount} pp',
                    ]),
                    'ISBN ${Isbn.display(result.isbn)}',
                  ].where((line) => line.isNotEmpty).join('\n'),
                  style: AppText.sans(
                    size: 12.5,
                    height: 1.6,
                    color: AppColors.muted,
                  ),
                ),
              if (details != null && details.editions.length > 1) ...[
                const SizedBox(height: 10),
                Text(
                  context.l10n.scanEditionsOnShelves(details.editions.length),
                  style: AppText.sans(
                    size: 12,
                    height: 1.45,
                    color: AppColors.faint,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _CopiesCard extends StatelessWidget {
  const _CopiesCard({required this.details, this.scannedEditionId});

  final BookDetails details;
  final String? scannedEditionId;

  @override
  Widget build(BuildContext context) {
    return OutlinedSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            color: AppColors.paperSunken,
            child: Text(
              context.l10n.scanYourCopies,
              style: AppText.sans(
                size: 10,
                weight: 600,
                letterSpacing: .14,
                color: AppColors.muted,
              ),
            ),
          ),
          for (var i = 0; i < details.editions.length; i++)
            _CopyRow(
              edition: details.editions[i],
              last: i == details.editions.length - 1,
              highlighted: details.editions[i].edition.id == scannedEditionId,
            ),
        ],
      ),
    );
  }
}

class _CopyRow extends StatelessWidget {
  const _CopyRow({
    required this.edition,
    required this.last,
    required this.highlighted,
  });

  final EditionWithCopies edition;
  final bool last;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final e = edition.edition;
    final color = AppColors
        .coverPalette[e.coverColorIndex.abs() % AppColors.coverPalette.length]
        .$1;
    final location = edition.copies
        .map((c) => c.location)
        .whereType<String>()
        .map((l) => l.split('›').map((p) => p.trim()).skip(1).join(', '))
        .where((l) => l.isNotEmpty)
        .firstOrNull;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: highlighted ? AppColors.highlightWash : null,
        border: last
            ? null
            : const Border(bottom: BorderSide(color: AppColors.ruleInner)),
      ),
      child: Row(
        children: [
          Container(
            width: 26,
            height: 38,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  edition.descriptor.isEmpty
                      ? context.l10n.scanEditionMissing
                      : edition.descriptor,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.sans(size: 13.5, weight: 600),
                ),
                const SizedBox(height: 2),
                Text(
                  Fmt.dotted([
                    e.publishedYear?.toString(),
                    e.pageCount == null
                        ? null
                        : context.l10n.editionsPagesShort(e.pageCount!),
                    location,
                    edition.copies.length > 1
                        ? context.l10n.scanCopiesSuffix(edition.copies.length)
                        : null,
                  ]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.sans(size: 11.5, color: AppColors.muted2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The scanned edition, marked out from the ones already owned.
class _ScannedCopyCard extends StatelessWidget {
  const _ScannedCopyCard({required this.metadata, required this.isbn});

  final BookMetadata metadata;
  final String isbn;

  @override
  Widget build(BuildContext context) {
    return OutlinedSurface(
      background: AppColors.highlightWash,
      border: Border.all(color: AppColors.highlight, width: 1.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            color: AppColors.progressBg,
            child: Text(
              context.l10n.scanScannedCopy,
              style: AppText.sans(
                size: 10,
                weight: 600,
                letterSpacing: .14,
                color: AppColors.progressFg,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Fmt.dotted([
                    metadata.language,
                    metadata.editionName ?? metadata.publisher,
                    metadata.format,
                  ]),
                  style: AppText.sans(size: 13.5, weight: 600),
                ),
                const SizedBox(height: 2),
                Text(
                  Fmt.dotted([
                    metadata.publishedYear?.toString(),
                    metadata.pageCount == null
                        ? null
                        : '${metadata.pageCount} pp',
                    'ISBN ${Isbn.display(isbn)}',
                  ]),
                  style: AppText.sans(size: 11.5, color: AppColors.muted2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoNote extends StatelessWidget {
  const _InfoNote({required this.text, this.icon = AppIcons.info});

  final String text;
  final AppIconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.highlightWash,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.highlightBorder),
      ),
      child: Row(
        children: [
          AppIcon(
            icon,
            size: 16,
            color: const Color(0xFF8A6B3A),
            strokeWidth: 2,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              text,
              style: AppText.sans(
                size: 12.5,
                height: 1.4,
                color: const Color(0xFF6B5B3E),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The failure sheet: named cause plus a manual escape hatch, in the same
/// position a success would have appeared.
class ScanErrorSheet extends StatelessWidget {
  const ScanErrorSheet({
    super.key,
    required this.failure,
    required this.onRetry,
    required this.onManual,
  });

  final ScanFailure failure;
  final VoidCallback onRetry;
  final VoidCallback onManual;

  @override
  Widget build(BuildContext context) {
    return AppSheet(
      radius: AppRadius.sheet,
      padding: const EdgeInsets.fromLTRB(24, 26, 24, 34),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.accentWashStrong,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const AppIcon(
                  AppIcons.alert,
                  size: 19,
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _failureTitle(context.l10n, failure),
                      style: AppText.serif(size: 22, height: 1.2),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _failureMessage(context.l10n, failure),
                      style: AppText.sans(
                        size: 13.5,
                        height: 1.5,
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            label: context.l10n.actionTryAgain,
            height: 50,
            onPressed: onRetry,
          ),
          const SizedBox(height: 9),
          SecondaryButton(
            label: context.l10n.actionEnterIsbnManually,
            height: 50,
            fontSize: 15,
            onPressed: onManual,
          ),
        ],
      ),
    );
  }
}
