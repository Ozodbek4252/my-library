import 'package:flutter/material.dart';

import '../../domain/models/enums.dart';
import '../l10n_extensions.dart';
import '../theme/tokens.dart';
import '../theme/typography.dart';

/// Colour pairs for the reading-status badges and pills.
({Color bg, Color fg}) statusColors(ReadingStatus status) => switch (status) {
      ReadingStatus.read =>
        (bg: AppColors.successBg, fg: AppColors.successFg),
      ReadingStatus.reading =>
        (bg: AppColors.progressBg, fg: AppColors.progressFg),
      ReadingStatus.unread =>
        (bg: AppColors.paperChip, fg: const Color(0xFF6B635A)),
      ReadingStatus.dnf =>
        (bg: const Color(0xFFEEE9E4), fg: const Color(0xFF8A7F74)),
      ReadingStatus.rereading =>
        (bg: AppColors.successBg, fg: AppColors.successFg),
    };

({Color bg, Color fg}) priorityColors(Priority priority) => switch (priority) {
      Priority.high =>
        (bg: AppColors.accentWashStrong, fg: AppColors.accent),
      Priority.medium =>
        (bg: AppColors.paperChip, fg: const Color(0xFF6B635A)),
      Priority.low => (bg: AppColors.paperChip, fg: AppColors.faint),
    };

/// A small rounded label. 24px tall by default, matching the design's pill.
class AppPill extends StatelessWidget {
  const AppPill({
    super.key,
    required this.label,
    required this.background,
    required this.foreground,
    this.height = 24,
    this.fontSize = 11,
    this.horizontalPadding = 9,
  });

  AppPill.status(ReadingStatus status, {required AppL10n l10n, super.key, this.height = 24})
      : label = status.display(l10n),
        background = statusColors(status).bg,
        foreground = statusColors(status).fg,
        fontSize = 11,
        horizontalPadding = 9;

  AppPill.priority(Priority priority, {required AppL10n l10n, super.key, this.height = 24})
      : label = priority.display(l10n),
        background = priorityColors(priority).bg,
        foreground = priorityColors(priority).fg,
        fontSize = 11,
        horizontalPadding = 9;

  final String label;
  final Color background;
  final Color foreground;
  final double height;
  final double fontSize;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Align(
        widthFactor: 1,
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppText.sans(
            size: fontSize,
            weight: 600,
            letterSpacing: .01,
            color: foreground,
          ),
        ),
      ),
    );
  }
}

/// The selectable chip used by filters, status pickers and tab rails.
/// 34px tall, radius 9; selected is ink fill with paper text.
class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    required this.selected,
    this.onTap,
    this.height = 34,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      button: onTap != null,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 13),
          decoration: BoxDecoration(
            color: selected ? AppColors.ink : AppColors.paperRaised,
            borderRadius: BorderRadius.circular(AppRadius.chip),
            border: Border.all(
              color: selected ? AppColors.ink : AppColors.ruleStrong,
            ),
          ),
          child: Align(
            widthFactor: 1,
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.chip.copyWith(
                color: selected ? AppColors.paper : AppColors.inkBody,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A removable ink pill on the library header — "Unread ×".
class RemovableFilterPill extends StatelessWidget {
  const RemovableFilterPill({
    super.key,
    required this.label,
    required this.onRemove,
  });

  final String label;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onRemove,
      child: Container(
        height: 28,
        padding: const EdgeInsets.only(left: 11, right: 9),
        decoration: BoxDecoration(
          color: AppColors.ink,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppText.sans(size: 12, weight: 500, color: AppColors.paper),
            ),
            const SizedBox(width: 6),
            Text(
              '×',
              style: AppText.sans(
                size: 14,
                height: 1,
                color: AppColors.paper.withValues(alpha: .55),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A tag pill — "#dystopia".
class TagPill extends StatelessWidget {
  const TagPill({super.key, required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 27,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.paperChip,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Align(
          widthFactor: 1,
          child: Text(
            label.startsWith('#') ? label : '#$label',
            style: AppText.sans(
              size: 12,
              weight: 500,
              color: const Color(0xFF5A5248),
            ),
          ),
        ),
      ),
    );
  }
}
