import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n_extensions.dart';
import '../../../core/providers.dart';
import '../../../core/routing/routes.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/theme/typography.dart';
import '../../../core/utils/formatting.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/app_sheet.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../core/widgets/layout.dart';
import '../../../core/widgets/pills.dart';
import '../../../core/widgets/states.dart';
import '../../../data/local/database.dart';
import '../../../data/repositories/collection_mutations.dart';
import '../../../domain/models/book_draft.dart';
import '../../../domain/models/enums.dart';
import '../../../domain/models/library_models.dart';
import 'book_details_screen.dart';
import 'widgets/editable_field.dart';

/// Everything that belongs to the user's physical copy: reading status and
/// rating (which live on the work), purchase, condition, location, notes, tags.
class EditCopyScreen extends ConsumerStatefulWidget {
  const EditCopyScreen({
    super.key,
    required this.workId,
    required this.copyId,
  });

  final String workId;
  final String copyId;

  @override
  ConsumerState<EditCopyScreen> createState() => _EditCopyScreenState();
}

class _EditCopyScreenState extends ConsumerState<EditCopyScreen> {
  final _store = TextEditingController();
  final _giftFrom = TextEditingController();
  final _price = TextEditingController();
  final _location = TextEditingController();
  final _notes = TextEditingController();
  final _tags = TextEditingController();

  CopyDraft? _copy;
  BookDetails? _details;
  ReadingStatus _status = ReadingStatus.unread;
  double _rating = 0;
  bool _loading = true;
  bool _saving = false;

  static const _currencies = ['GBP', 'USD', 'EUR', 'RUB', 'JPY', 'PLN'];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    for (final c in [_store, _giftFrom, _price, _location, _notes, _tags]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    final details =
        await ref.read(libraryRepositoryProvider).bookDetails(widget.workId);
    if (details == null) {
      if (mounted) setState(() => _loading = false);
      return;
    }

    Copy? target;
    for (final edition in details.editions) {
      for (final copy in edition.copies) {
        if (copy.id == widget.copyId) target = copy;
      }
    }
    if (target == null) {
      if (mounted) setState(() => _loading = false);
      return;
    }

    final tags = details.tagsFor(target.id).map((t) => t.name).toList();
    final draft = CopyDraft.fromRow(target, tags: tags);

    _store.text = draft.store ?? '';
    _giftFrom.text = draft.giftFrom ?? '';
    _price.text = draft.purchasePrice?.toString() ?? '';
    _location.text = draft.location ?? '';
    _notes.text = draft.notes ?? '';
    _tags.text = tags.join(', ');

    if (mounted) {
      setState(() {
        _details = details;
        _copy = draft;
        _status = details.status;
        _rating = details.work.rating ?? 0;
        _loading = false;
      });
    }
  }

  Future<void> _save() async {
    final l10n = context.l10n;
    final copy = _copy;
    if (copy == null) return;

    setState(() => _saving = true);

    copy
      ..store = _store.text.trim().isEmpty ? null : _store.text.trim()
      ..giftFrom = _giftFrom.text.trim().isEmpty ? null : _giftFrom.text.trim()
      ..purchasePrice = double.tryParse(_price.text.trim().replaceAll(',', '.'))
      ..location = _location.text.trim().isEmpty ? null : _location.text.trim()
      ..notes = _notes.text.trim().isEmpty ? null : _notes.text.trim()
      ..isGift = _giftFrom.text.trim().isNotEmpty || copy.isGift
      ..tags = _tags.text
          .split(RegExp(r'\s*[,;]\s*'))
          .map((t) => t.trim().replaceFirst(RegExp(r'^#'), ''))
          .where((t) => t.isNotEmpty)
          .toList();

    final db = ref.read(databaseProvider);
    await db.saveCopy(copy);

    final reading = ref.read(readingRepositoryProvider);
    if (_status != _details?.status) {
      await reading.setStatus(widget.workId, _status);
    }
    if (_rating != (_details?.work.rating ?? 0)) {
      await reading.setRating(widget.workId, _rating == 0 ? null : _rating);
    }

    if (!mounted) return;
    AppToast.show(context, l10n.toastCopyUpdated);
    context.pop();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _copy?.purchaseDate ?? now,
      firstDate: DateTime(1900),
      lastDate: now,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.ink,
            onPrimary: AppColors.paper,
            surface: AppColors.paperRaised,
            onSurface: AppColors.ink,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _copy?.purchaseDate = picked);
  }

  Future<void> _pickCurrency() async {
    final picked = await showAppSheet<String>(
      context,
      builder: (sheetContext) => AppSheet(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(context.l10n.fieldCurrency, style: AppText.sheetTitle),
            const SizedBox(height: 12),
            ChipWrap(
              children: [
                for (final code in _currencies)
                  AppChip(
                    label: code,
                    selected: _copy?.currency == code,
                    onTap: () => Navigator.of(sheetContext).pop(code),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
    if (picked != null) setState(() => _copy?.currency = picked);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: AppColors.paper,
        body: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.accent,
            ),
          ),
        ),
      );
    }

    final copy = _copy;
    if (copy == null) {
      return Scaffold(
        backgroundColor: AppColors.paper,
        body: SafeArea(
          child: MessageState(
            title: context.l10n.editCopyNotFoundTitle,
            message: context.l10n.editCopyNotFoundMessage,
            titleSize: 22,
            primaryLabel: context.l10n.actionBackToLibrary,
            onPrimary: () => context.go(Routes.library),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.paper,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.screenH,
            20,
            AppSpacing.screenH,
            AppSpacing.modalBottom + MediaQuery.viewInsetsOf(context).bottom,
          ),
          children: [
            ModalTopBar(
              title: context.l10n.editCopyTitle,
              onCancel: () => context.pop(),
              onSave: _save,
              saveEnabled: !_saving,
            ),
            SectionLabel(context.l10n.sectionStatus, top: 24),
            ChipWrap(
              children: [
                for (final status in ReadingStatus.values)
                  AppChip(
                    label: status.label,
                    selected: _status == status,
                    onTap: () => setState(() => _status = status),
                  ),
              ],
            ),
            SectionLabel(context.l10n.sectionRating, top: 24),
            Row(
              children: [
                StarRating(
                  rating: _rating,
                  onChanged: (value) => setState(() => _rating = value),
                ),
                const SizedBox(width: 15),
                Text(
                  _rating == 0
                      ? context.l10n.detailsNotRated
                      : _rating.toStringAsFixed(1),
                  style: AppText.sans(size: 13, color: AppColors.muted2),
                ),
              ],
            ),
            SectionLabel(context.l10n.sectionOwnership, top: 24),
            ChipWrap(
              children: [
                for (final ownership in Ownership.values)
                  AppChip(
                    label: ownership.label,
                    selected: copy.ownership == ownership,
                    onTap: () => setState(() => copy.ownership = ownership),
                  ),
              ],
            ),
            SectionLabel(context.l10n.sectionPurchase, top: 24),
            PaperCard(
              children: [
                PickerFieldRow(
                  label: context.l10n.fieldDate,
                  labelWidth: 100,
                  value: copy.purchaseDate == null
                      ? null
                      : Fmt.date(copy.purchaseDate),
                  placeholder: context.l10n.hintNotRecorded,
                  onTap: _pickDate,
                ),
                EditableFieldRow(
                  label: context.l10n.fieldPrice,
                  labelWidth: 100,
                  controller: _price,
                  hint: context.l10n.hintNotRecorded,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                  ],
                ),
                PickerFieldRow(
                  label: context.l10n.fieldCurrency,
                  labelWidth: 100,
                  value: copy.currency,
                  placeholder: context.l10n.hintChoose,
                  onTap: _pickCurrency,
                ),
                EditableFieldRow(
                  label: context.l10n.fieldStore,
                  labelWidth: 100,
                  controller: _store,
                  hint: context.l10n.hintWhereBought,
                  textCapitalization: TextCapitalization.words,
                ),
                EditableFieldRow(
                  label: context.l10n.fieldGiftFrom,
                  labelWidth: 100,
                  controller: _giftFrom,
                  hint: context.l10n.hintBlankIfPurchased,
                  textCapitalization: TextCapitalization.words,
                  last: true,
                ),
              ],
            ),
            SectionLabel(context.l10n.sectionCondition, top: 24),
            ChipWrap(
              children: [
                for (final condition in Condition.values)
                  AppChip(
                    label: condition.label,
                    selected: copy.condition == condition,
                    onTap: () => setState(
                      () => copy.condition =
                          copy.condition == condition ? null : condition,
                    ),
                  ),
              ],
            ),
            SectionLabel(context.l10n.sectionLocation, top: 24),
            PaperCard(
              padding: const EdgeInsets.all(14),
              children: [
                _LocationBreadcrumb(controller: _location),
              ],
            ),
            SectionLabel(context.l10n.sectionTags, top: 24),
            PaperCard(
              children: [
                EditableFieldRow(
                  label: context.l10n.sectionTags,
                  labelWidth: 60,
                  controller: _tags,
                  hint: 'dystopia, re-read',
                  textCapitalization: TextCapitalization.none,
                  last: true,
                ),
              ],
            ),
            SectionLabel(context.l10n.sectionPersonalNotes, top: 24),
            Container(
              constraints: const BoxConstraints(minHeight: 96),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.paperRaised,
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: Border.all(color: AppColors.ruleStrong),
              ),
              child: TextField(
                controller: _notes,
                maxLines: null,
                minLines: 3,
                cursorColor: AppColors.accent,
                cursorWidth: 1.5,
                style: AppText.serif(
                  size: 15,
                  height: 1.55,
                  color: const Color(0xFF332E28),
                  fontStyle: FontStyle.italic,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  hintText: context.l10n.hintNotes,
                  hintStyle: AppText.serif(
                    size: 15,
                    color: AppColors.faint,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 26),
            DestructiveButton(
              label: context.l10n.detailsRemoveCopy,
              onPressed: () async {
                final details = _details;
                if (details == null) return;
                await confirmRemoveCopy(
                  context,
                  ref,
                  details,
                  copy: details.editions
                      .expand((e) => e.copies)
                      .firstWhere((c) => c.id == widget.copyId),
                );
                if (context.mounted && context.canPop()) context.pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// The hierarchical location, shown as a breadcrumb and edited as one path.
class _LocationBreadcrumb extends StatefulWidget {
  const _LocationBreadcrumb({required this.controller});

  final TextEditingController controller;

  @override
  State<_LocationBreadcrumb> createState() => _LocationBreadcrumbState();
}

class _LocationBreadcrumbState extends State<_LocationBreadcrumb> {
  bool _editing = false;

  @override
  Widget build(BuildContext context) {
    final parts = widget.controller.text
        .split('›')
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .toList();

    if (_editing) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: widget.controller,
            autofocus: true,
            cursorColor: AppColors.accent,
            textCapitalization: TextCapitalization.words,
            style: AppText.sans(size: 13.5, weight: 500),
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              hintText: context.l10n.hintLocation,
              hintStyle: AppText.sans(size: 13.5, color: AppColors.faint),
            ),
            onSubmitted: (_) => setState(() => _editing = false),
          ),
          const SizedBox(height: 6),
          Text(
            context.l10n.locationHint,
            style: AppText.sans(size: 11.5, color: AppColors.muted2),
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: () => setState(() => _editing = true),
      behavior: HitTestBehavior.opaque,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (parts.isEmpty)
            Text(
              context.l10n.locationNone,
              style: AppText.sans(size: 13.5, weight: 500, color: AppColors.faint),
            )
          else
            Wrap(
              spacing: 7,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                for (var i = 0; i < parts.length; i++) ...[
                  if (i > 0)
                    Text(
                      '›',
                      style: AppText.sans(size: 13.5, color: AppColors.chevron),
                    ),
                  Text(
                    parts[i],
                    style: AppText.sans(size: 13.5, weight: 500),
                  ),
                ],
              ],
            ),
          const SizedBox(height: 6),
          Text(
            context.l10n.locationTapToChange,
            style: AppText.sans(size: 11.5, color: AppColors.muted2),
          ),
        ],
      ),
    );
  }
}
