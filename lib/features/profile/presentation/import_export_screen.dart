import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/providers.dart';
import '../../../core/routing/routes.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/theme/typography.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/app_icons.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../core/widgets/layout.dart';
import '../../../data/repositories/export_service.dart';

/// Export the collection to a file. Import is not built yet and says so
/// plainly rather than offering rows that do nothing.
class ImportExportScreen extends ConsumerStatefulWidget {
  const ImportExportScreen({super.key});

  @override
  ConsumerState<ImportExportScreen> createState() => _ImportExportScreenState();
}

class _ImportExportScreenState extends ConsumerState<ImportExportScreen> {
  String? _busyFormat;

  Future<void> _export({
    required String format,
    required String filename,
    required Future<String> Function(ExportService) build,
  }) async {
    setState(() => _busyFormat = format);
    try {
      final service = ExportService(ref.read(databaseProvider));
      final contents = await build(service);

      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/$filename');
      await file.writeAsString(contents);

      if (!mounted) return;
      final result = await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          fileNameOverrides: [filename],
          subject: 'My library',
        ),
      );

      if (!mounted) return;
      if (result.status == ShareResultStatus.success) {
        AppToast.show(context, 'Exported $filename');
      }
    } catch (e) {
      if (!mounted) return;
      AppToast.show(context, "Export failed — couldn't write the file",
          success: false);
    } finally {
      if (mounted) setState(() => _busyFormat = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenH,
          AppSpacing.screenTop,
          AppSpacing.screenH,
          AppSpacing.modalBottom,
        ),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: CircleIconButton(
              border: Border.all(color: AppColors.ruleStrong),
              onPressed: () =>
                  context.canPop() ? context.pop() : context.go(Routes.profile),
              child: const AppIcon(AppIcons.chevronLeft, size: 16),
            ),
          ),
          const SizedBox(height: 16),
          Text('Import & export', style: AppText.screenTitleSmall),
          const SizedBox(height: 6),
          Text(
            'Your library is yours. Take it out at any time.',
            style: AppText.sans(
              size: 13,
              height: 1.55,
              color: AppColors.muted,
            ),
          ),
          const SectionLabel('Export'),
          PaperCard(
            children: [
              _ExportRowTile(
                mark: 'CSV',
                label: 'CSV',
                subtitle: 'Every field, one row per copy',
                busy: _busyFormat == 'csv',
                onTap: () => _export(
                  format: 'csv',
                  filename: 'my-library.csv',
                  build: (s) => s.toCsv(),
                ),
              ),
              _ExportRowTile(
                mark: '{ }',
                label: 'JSON',
                subtitle: 'Full structure — works, editions and copies',
                busy: _busyFormat == 'json',
                onTap: () => _export(
                  format: 'json',
                  filename: 'my-library.json',
                  build: (s) => s.toJson(),
                ),
              ),
              _ExportRowTile(
                mark: '☰',
                label: 'Printable list',
                subtitle: 'A plain list of your shelves',
                busy: _busyFormat == 'txt',
                last: true,
                onTap: () => _export(
                  format: 'txt',
                  filename: 'my-library.txt',
                  build: (s) => s.toPrintableList(),
                ),
              ),
            ],
          ),
          const SectionLabel('Import'),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.highlightWash,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: AppColors.highlightBorder),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppIcon(
                  AppIcons.info,
                  size: 18,
                  color: Color(0xFF8A6B3A),
                  strokeWidth: 2,
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Not built yet',
                        style: AppText.sans(
                          size: 13.5,
                          weight: 600,
                          color: const Color(0xFF6B5B3E),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Importing from a Goodreads, LibraryThing or CSV file '
                        'is planned but not implemented. Until then, scanning '
                        'is the fastest way to fill a shelf — a barcode fills '
                        'in every field for you.',
                        style: AppText.sans(
                          size: 12.5,
                          height: 1.5,
                          color: const Color(0xFF6B5B3E),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SecondaryButton(
            label: 'Scan a book instead',
            height: 48,
            onPressed: () {
              context.pop();
              context.push(Routes.scanner);
            },
          ),
        ],
      ),
    );
  }
}

class _ExportRowTile extends StatelessWidget {
  const _ExportRowTile({
    required this.mark,
    required this.label,
    required this.subtitle,
    required this.onTap,
    this.busy = false,
    this.last = false,
  });

  final String mark;
  final String label;
  final String subtitle;
  final VoidCallback onTap;
  final bool busy;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: busy ? null : onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            border: last
                ? null
                : const Border(bottom: BorderSide(color: AppColors.ruleInner)),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.paperChip,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(
                  mark,
                  style: AppText.serif(
                    size: 13,
                    color: const Color(0xFF5A5248),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: AppText.sans(size: 14, weight: 500),
                    ),
                    const SizedBox(height: 1),
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
              if (busy)
                const SizedBox(
                  width: 15,
                  height: 15,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.accent,
                  ),
                )
              else
                const AppIcon(
                  AppIcons.chevronRight,
                  size: 15,
                  color: AppColors.chevron,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
