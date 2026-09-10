import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
    AppToast.show(context, 'Copy updated');
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
            Text('Currency', style: AppText.sheetTitle),
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
            title: 'Copy not found',
            message: 'This copy is no longer in your library.',
            titleSize: 22,
            primaryLabel: 'Back to library',
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
              title: 'Edit copy',
              onCancel: () => context.pop(),
              onSave: _save,
              saveEnabled: !_saving,
            ),
            const SectionLabel('Reading status', top: 24),
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
            const SectionLabel('Rating', top: 24),
            Row(
              children: [
                StarRating(
                  rating: _rating,
                  onChanged: (value) => setState(() => _rating = value),
                ),
                const SizedBox(width: 15),
                Text(
                  _rating == 0 ? 'Not rated' : _rating.toStringAsFixed(1),
                  style: AppText.sans(size: 13, color: AppColors.muted2),
                ),
              ],
            ),
            const SectionLabel('Ownership', top: 24),
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
            const SectionLabel('Purchase', top: 24),
            PaperCard(
              children: [
                PickerFieldRow(
                  label: 'Date',
                  labelWidth: 100,
                  value: copy.purchaseDate == null
                      ? null
                      : Fmt.date(copy.purchaseDate),
                  placeholder: 'Not recorded',
                  onTap: _pickDate,
                ),
                EditableFieldRow(
                  label: 'Price',
                  labelWidth: 100,
                  controller: _price,
                  hint: 'Not recorded',
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                  ],
                ),
                PickerFieldRow(
                  label: 'Currency',
                  labelWidth: 100,
                  value: copy.currency,
                  placeholder: 'Choose',
                  onTap: _pickCurrency,
                ),
                EditableFieldRow(
                  label: 'Store',
                  labelWidth: 100,
                  controller: _store,
                  hint: 'Where you bought it',
                  textCapitalization: TextCapitalization.words,
                ),
                EditableFieldRow(
                  label: 'Gift from',
                  labelWidth: 100,
                  controller: _giftFrom,
                  hint: 'Leave blank if purchased',
                  textCapitalization: TextCapitalization.words,
                  last: true,
                ),
              ],
            ),
            const SectionLabel('Condition', top: 24),
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
            const SectionLabel('Location', top: 24),
            PaperCard(
              padding: const EdgeInsets.all(14),
              children: [
                _LocationBreadcrumb(controller: _location),
              ],
            ),
            const SectionLabel('Tags', top: 24),
            PaperCard(
              children: [
                EditableFieldRow(
                  label: 'Tags',
                  labelWidth: 60,
                  controller: _tags,
                  hint: 'dystopia, re-read',
                  textCapitalization: TextCapitalization.none,
                  last: true,
                ),
              ],
            ),
            const SectionLabel('Personal notes', top: 24),
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
                  hintText: 'Anything worth remembering about this copy…',
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
              label: 'Remove this copy',
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
              hintText: 'Home › Bedroom › Bookshelf 2 › Shelf 4',
              hintStyle: AppText.sans(size: 13.5, color: AppColors.faint),
            ),
            onSubmitted: (_) => setState(() => _editing = false),
          ),
          const SizedBox(height: 6),
          Text(
            'Separate each level with ›',
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
              'No location yet',
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
            'Tap to change it',
            style: AppText.sans(size: 11.5, color: AppColors.muted2),
          ),
        ],
      ),
    );
  }
}
