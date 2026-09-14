import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n_extensions.dart';
import '../../../../core/providers.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/utils/formatting.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/app_sheet.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/layout.dart';
import '../../../../data/local/database.dart';

/// The reading-progress sheet: a big page number, a −/+10/+25 stepper, and the
/// two ways out — save, or finish the book.
Future<void> showProgressSheet(BuildContext context, String workId) {
  return showAppSheet<void>(
    context,
    builder: (_) => _ProgressSheet(workId: workId),
  );
}

class _ProgressSheet extends ConsumerStatefulWidget {
  const _ProgressSheet({required this.workId});

  final String workId;

  @override
  ConsumerState<_ProgressSheet> createState() => _ProgressSheetState();
}

class _ProgressSheetState extends ConsumerState<_ProgressSheet> {
  int? _page;
  Work? _work;
  Edition? _edition;
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final details =
        await ref.read(libraryRepositoryProvider).bookDetails(widget.workId);
    if (!mounted) return;
    setState(() {
      _work = details?.work;
      _edition = details?.primaryEdition?.edition;
      _page = details?.work.currentPage ?? 0;
      _loading = false;
    });
  }

  int get _total => _edition?.pageCount ?? 0;

  void _step(int delta) {
    setState(() {
      final next = (_page ?? 0) + delta;
      _page = _total > 0 ? next.clamp(0, _total) : (next < 0 ? 0 : next);
    });
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    await ref
        .read(readingRepositoryProvider)
        .updateProgress(widget.workId, _page ?? 0);
    if (!mounted) return;
    AppToast.show(context, context.l10n.toastProgressSaved);
    Navigator.of(context).pop();
  }

  Future<void> _finish() async {
    setState(() => _saving = true);
    await ref.read(readingRepositoryProvider).finishReading(widget.workId);
    if (!mounted) return;
    AppToast.show(
      context,
      context.l10n.toastFinished('${DateTime.now().year}'),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const AppSheet(
        child: SizedBox(
          height: 180,
          child: Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.accent,
              ),
            ),
          ),
        ),
      );
    }

    final work = _work;
    if (work == null) {
      return AppSheet(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Text(
            context.l10n.progressGone,
            style: AppText.sans(size: 14, color: AppColors.muted),
          ),
        ),
      );
    }

    final page = _page ?? 0;
    final progress = _total > 0 ? (page / _total).clamp(0.0, 1.0) : 0.0;
    final percent = (progress * 100).round();
    final left = (_total - page).clamp(0, _total);

    return AppSheet(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            work.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppText.sheetTitle,
          ),
          const SizedBox(height: 2),
          Text(
            Fmt.dotted([
              work.startDate == null
                  ? context.l10n.readingNotStarted
                  : context.l10n.progressStarted(Fmt.date(work.startDate)),
              _total > 0 ? context.l10n.progressPagesTotal(_total) : null,
            ]),
            style: AppText.sans(size: 12.5, color: AppColors.muted2),
          ),
          const SizedBox(height: 26),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('$page', style: AppText.progressFigure),
              if (_total > 0) ...[
                const SizedBox(width: 9),
                Text(
                  '/ $_total',
                  style: AppText.sans(size: 17, color: AppColors.faint),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(
            _total > 0
                ? context.l10n.progressPercentToGo(percent, left)
                : context.l10n.progressNoPageCount,
            textAlign: TextAlign.center,
            style: AppText.sans(size: 13, color: AppColors.muted2),
          ),
          const SizedBox(height: 20),
          ProgressTrack(value: progress, height: 6),
          const SizedBox(height: 20),
          Row(
            children: [
              _StepButton(label: '−', onTap: () => _step(-10), width: 56),
              const SizedBox(width: 9),
              Expanded(
                child: _StepButton(
                  label: context.l10n.progressPlusTen,
                  onTap: () => _step(10),
                ),
              ),
              const SizedBox(width: 9),
              _StepButton(label: '+', onTap: () => _step(25), width: 56),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  label: context.l10n.progressSave,
                  busy: _saving,
                  onPressed: _save,
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: SecondaryButton(
                  label: context.l10n.progressFinished,
                  height: 52,
                  fontSize: 14.5,
                  onPressed: _saving ? null : _finish,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({required this.label, required this.onTap, this.width});

  final String label;
  final VoidCallback onTap;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final isSymbol = label.length <= 1;
    return SizedBox(
      width: width,
      child: Material(
        color: AppColors.paperRaised,
        borderRadius: BorderRadius.circular(AppRadius.button),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.button),
          child: Container(
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.button),
              border: Border.all(color: AppColors.starEmpty),
            ),
            child: Text(
              label,
              style: isSymbol
                  ? const TextStyle(fontSize: 20, color: AppColors.ink)
                  : AppText.sans(size: 14.5, weight: 600),
            ),
          ),
        ),
      ),
    );
  }
}
