import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
import '../../../data/repositories/collection_mutations.dart';
import '../../../domain/models/book_draft.dart';
import '../../../domain/models/enums.dart';
import '../../../domain/models/library_models.dart';
import 'wishlist_providers.dart';

/// One wanted book: what edition is wanted, at what priority, and the two ways
/// off the list — buying it, or dropping it.
class WishlistDetailScreen extends ConsumerWidget {
  const WishlistDetailScreen({super.key, required this.itemId});

  final String itemId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entry = ref.watch(wishlistItemProvider(itemId));

    return Scaffold(
      backgroundColor: AppColors.paper,
      body: entry.when(
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
            message: 'This wishlist entry could not be loaded.',
            onRetry: () => ref.invalidate(wishlistItemProvider(itemId)),
          ),
        ),
        data: (data) => data == null
            ? SafeArea(
                child: MessageState(
                  title: 'No longer on your wishlist',
                  message: 'This entry has been removed.',
                  titleSize: 22,
                  primaryLabel: 'Back to wishlist',
                  onPrimary: () => context.go(Routes.wishlist),
                ),
              )
            : _WishlistDetailBody(entry: data),
      ),
    );
  }
}

class _WishlistDetailBody extends ConsumerWidget {
  const _WishlistDetailBody({required this.entry});

  final WishlistEntry entry;

  Future<void> _moveToLibrary(BuildContext context, WidgetRef ref) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Move to your library?',
      message: '${entry.work.title} will be added to your shelves as an owned '
          'copy and cleared from the wishlist. You can fill in the edition and '
          'purchase details next.',
      confirmLabel: 'Add to library',
      cancelLabel: 'Not yet',
      destructive: false,
    );
    if (!confirmed || !context.mounted) return;

    final db = ref.read(databaseProvider);
    final edition = entry.edition;
    final workId = entry.work.id;

    if (edition != null) {
      // The edition was captured when the book was wishlisted — ISBN, cover,
      // pages and all. Buying it adds a copy to that edition rather than
      // starting a blank one.
      await db.addCopyToEdition(
        edition.id,
        CopyDraft(ownership: Ownership.owned, purchaseDate: DateTime.now()),
      );
      await db.setPrimaryEditionIfUnset(workId, edition.id);
      await ref.read(wishlistRepositoryProvider).remove(entry.item.id);
    } else {
      // Nothing but a wish: build what little is known into a first edition.
      final draft = BookDraft(
        workId: workId,
        title: entry.work.title,
        authors: [...entry.work.authors],
        genres: [...entry.work.genres],
        description: entry.work.description,
        originalTitle: entry.work.originalTitle,
        originalLanguage: entry.work.originalLanguage,
        seriesName: entry.work.seriesName,
        seriesIndex: entry.work.seriesIndex,
        firstPublished: entry.work.firstPublished,
        language: entry.item.desiredLanguage,
        format: entry.item.desiredFormat,
        publisher: entry.item.desiredEdition,
        coverColorIndex: entry.desiredEditionColor,
        ownership: Ownership.owned,
      );
      await db.addBook(draft);
    }

    if (!context.mounted) return;

    AppToast.show(context, 'Moved to your library');
    context.go(Routes.library);
    context.push(Routes.bookDetails(workId));
  }

  Future<void> _remove(BuildContext context, WidgetRef ref) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Remove from wishlist?',
      message: '${entry.work.title} will be taken off your wishlist, along '
          'with the edition you wanted and your note. Your library is not '
          'affected.',
      confirmLabel: 'Remove from wishlist',
    );
    if (!confirmed || !context.mounted) return;

    await ref.read(wishlistRepositoryProvider).remove(entry.item.id);
    if (!context.mounted) return;
    AppToast.show(context, 'Removed from your wishlist');
    context.go(Routes.wishlist);
  }

  Future<void> _editPriority(BuildContext context, WidgetRef ref) async {
    final picked = await showAppSheet<Priority>(
      context,
      builder: (sheetContext) => AppSheet(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Priority', style: AppText.sheetTitle),
            const SizedBox(height: 14),
            ChipWrap(
              children: [
                for (final priority in Priority.values)
                  AppChip(
                    label: priority.label,
                    selected: entry.priority == priority,
                    onTap: () => Navigator.of(sheetContext).pop(priority),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
    if (picked == null) return;
    await ref
        .read(wishlistRepositoryProvider)
        .update(entry.item.id, priority: picked);
  }

  Future<void> _editField(
    BuildContext context,
    WidgetRef ref, {
    required String label,
    required String? value,
    required Future<void> Function(String?) save,
    int maxLines = 1,
  }) async {
    final controller = TextEditingController(text: value ?? '');
    final result = await showAppSheet<String>(
      context,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
        ),
        child: AppSheet(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(label, style: AppText.sheetTitle),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.paperRaised,
                  borderRadius: BorderRadius.circular(AppRadius.input),
                  border: Border.all(color: AppColors.ruleStrong),
                ),
                child: TextField(
                  controller: controller,
                  autofocus: true,
                  maxLines: maxLines,
                  minLines: 1,
                  cursorColor: AppColors.accent,
                  textCapitalization: TextCapitalization.sentences,
                  style: AppText.sans(size: 14.5),
                  decoration: const InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: 'Save',
                onPressed: () =>
                    Navigator.of(sheetContext).pop(controller.text.trim()),
              ),
            ],
          ),
        ),
      ),
    );
    controller.dispose();
    if (result == null) return;
    await save(result.isEmpty ? null : result);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = entry.item;
    final repository = ref.read(wishlistRepositoryProvider);

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
                context.canPop() ? context.pop() : context.go(Routes.wishlist),
            child: const AppIcon(AppIcons.chevronLeft, size: 16),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BookCover(
              title: entry.work.title,
              author: Fmt.surname(entry.work.authors),
              colorIndex: entry.coverColorIndex,
              coverUrl: entry.coverUrl,
              coverImagePath: entry.coverImagePath,
              width: 104,
              height: 156,
              titleSize: 16,
              authorSize: 7,
              spineWidth: 6,
              shadows: const [
                BoxShadow(
                  color: Color(0x331A1714),
                  blurRadius: 12,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 24,
                    padding: const EdgeInsets.symmetric(horizontal: 9),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3E7DC),
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Align(
                      widthFactor: 1,
                      child: Text(
                      'WISHLIST',
                      style: AppText.sans(
                        size: 11,
                        weight: 700,
                        letterSpacing: .06,
                        color: const Color(0xFF8A5B2C),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 9),
                  Text(
                    entry.work.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.serif(size: 25, height: 1.12),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    Fmt.authors(entry.work.authors),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.sans(size: 13.5, color: AppColors.muted),
                  ),
                  const SizedBox(height: 9),
                  Text(
                    'Added ${Fmt.date(item.dateAdded)}',
                    style: AppText.sans(size: 11.5, color: AppColors.faint),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SectionLabel('What I want'),
        PaperCard(
          children: [
            FieldRow(
              label: 'Language',
              labelWidth: 112,
              value: item.desiredLanguage ?? '',
              verticalPadding: 12,
              onTap: () => _editField(
                context,
                ref,
                label: 'Desired language',
                value: item.desiredLanguage,
                save: (v) =>
                    repository.update(item.id, desiredLanguage: v,
                        desiredFormat: item.desiredFormat,
                        desiredEdition: item.desiredEdition,
                        notes: item.notes),
              ),
            ),
            FieldRow(
              label: 'Format',
              labelWidth: 112,
              value: item.desiredFormat ?? '',
              verticalPadding: 12,
              onTap: () => _editField(
                context,
                ref,
                label: 'Desired format',
                value: item.desiredFormat,
                save: (v) => repository.update(item.id,
                    desiredLanguage: item.desiredLanguage,
                    desiredFormat: v,
                    desiredEdition: item.desiredEdition,
                    notes: item.notes),
              ),
            ),
            FieldRow(
              label: 'Edition',
              labelWidth: 112,
              value: item.desiredEdition ?? '',
              verticalPadding: 12,
              onTap: () => _editField(
                context,
                ref,
                label: 'Desired edition',
                value: item.desiredEdition,
                save: (v) => repository.update(item.id,
                    desiredLanguage: item.desiredLanguage,
                    desiredFormat: item.desiredFormat,
                    desiredEdition: v,
                    notes: item.notes),
              ),
            ),
            FieldRow(
              label: 'Priority',
              labelWidth: 112,
              value: entry.priority.label,
              verticalPadding: 12,
              onTap: () => _editPriority(context, ref),
            ),
            FieldRow(
              label: 'Added',
              labelWidth: 112,
              value: Fmt.date(item.dateAdded),
              verticalPadding: 12,
              last: entry.edition == null,
            ),
            // Everything below was captured when the book was identified, and
            // carries over the day it is bought.
            if (entry.edition != null) ...[
              if (entry.edition!.pageCount != null)
                FieldRow(
                  label: 'Pages',
                  labelWidth: 112,
                  value: '${entry.edition!.pageCount}',
                  verticalPadding: 12,
                ),
              if (entry.edition!.publishedYear != null)
                FieldRow(
                  label: 'Published',
                  labelWidth: 112,
                  value: '${entry.edition!.publishedYear}',
                  verticalPadding: 12,
                ),
              FieldRow(
                label: 'ISBN',
                labelWidth: 112,
                value: entry.edition!.isbn13 == null
                    ? ''
                    : Isbn.display(entry.edition!.isbn13!),
                verticalPadding: 12,
                last: true,
              ),
            ],
          ],
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => _editField(
            context,
            ref,
            label: 'Note',
            value: item.notes,
            maxLines: 5,
            save: (v) => repository.update(item.id,
                desiredLanguage: item.desiredLanguage,
                desiredFormat: item.desiredFormat,
                desiredEdition: item.desiredEdition,
                notes: v),
          ),
          child: NoteBlock(
            label: 'Note',
            text: (item.notes ?? '').trim().isEmpty
                ? 'Tap to add a note about the edition you are after.'
                : item.notes!,
          ),
        ),
        const SizedBox(height: 22),
        PrimaryButton(
          label: 'I bought it — move to library',
          onPressed: () => _moveToLibrary(context, ref),
        ),
        const SizedBox(height: 9),
        SecondaryButton(
          label: 'Remove from wishlist',
          foreground: const Color(0xFF5A5248),
          onPressed: () => _remove(context, ref),
        ),
      ],
    );
  }
}
