import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import '../theme/typography.dart';
import 'app_icons.dart';

/// The 10px uppercase label that opens every section in the design.
class SectionLabel extends StatelessWidget {
  const SectionLabel(
    this.label, {
    super.key,
    this.top = 26,
    this.bottom = 10,
  });

  final String label;
  final double top;
  final double bottom;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: top, bottom: bottom),
      child: Text(label.toUpperCase(), style: AppText.sectionLabel),
    );
  }
}

/// The bordered paper card that holds rows of fields and settings.
class PaperCard extends StatelessWidget {
  const PaperCard({
    super.key,
    required this.children,
    this.padding = EdgeInsets.zero,
    this.radius = AppRadius.card,
    this.background = AppColors.paperRaised,
    this.border,
  });

  final List<Widget> children;
  final EdgeInsets padding;
  final double radius;
  final Color background;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(radius),
        border: border ?? Border.all(color: AppColors.ruleStrong),
      ),
      padding: padding,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }
}

/// A label/value row inside a [PaperCard]. Values are right-aligned on the
/// detail screens and left-aligned in the editors, as the design shows.
class FieldRow extends StatelessWidget {
  const FieldRow({
    super.key,
    required this.label,
    required this.value,
    this.labelWidth = 104,
    this.alignEnd = true,
    this.onTap,
    this.last = false,
    this.placeholder = false,
    this.trailing,
    this.verticalPadding = 11,
  });

  final String label;
  final String value;
  final double labelWidth;
  final bool alignEnd;
  final VoidCallback? onTap;
  final bool last;

  /// Renders the value in the muted tone used for unfilled fields.
  final bool placeholder;
  final Widget? trailing;
  final double verticalPadding;

  @override
  Widget build(BuildContext context) {
    final row = Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: verticalPadding),
      decoration: BoxDecoration(
        border: last
            ? null
            : const Border(bottom: BorderSide(color: AppColors.ruleInner)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: labelWidth,
            child: Text(
              label,
              style: AppText.sans(size: 12.5, color: AppColors.muted2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value.isEmpty ? '—' : value,
              textAlign: alignEnd ? TextAlign.end : TextAlign.start,
              style: AppText.sans(
                size: alignEnd ? 13 : 13.5,
                weight: 500,
                color: placeholder || value.isEmpty
                    ? AppColors.faint
                    : AppColors.ink,
              ),
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: 8), trailing!],
          if (onTap != null && trailing == null) ...[
            const SizedBox(width: 8),
            const AppIcon(
              AppIcons.chevronRight,
              size: 15,
              color: AppColors.chevron,
            ),
          ],
        ],
      ),
    );

    if (onTap == null) return row;
    return Material(
      color: Colors.transparent,
      child: InkWell(onTap: onTap, child: row),
    );
  }
}

/// The note block: sunken paper, uppercase label, serif italic body.
class NoteBlock extends StatelessWidget {
  const NoteBlock({super.key, required this.label, required this.text});

  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.paperSunken,
        borderRadius: BorderRadius.circular(AppRadius.button),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: AppText.sans(
              size: 10,
              letterSpacing: .14,
              color: AppColors.muted2,
            ),
          ),
          const SizedBox(height: 7),
          Text(text, style: AppText.note),
        ],
      ),
    );
  }
}

/// A row of chips that wraps, used by every status and filter picker.
class ChipWrap extends StatelessWidget {
  const ChipWrap({super.key, required this.children, this.spacing = 7});

  final List<Widget> children;
  final double spacing;

  @override
  Widget build(BuildContext context) =>
      Wrap(spacing: spacing, runSpacing: spacing, children: children);
}

/// A five-star display or picker. 
class StarRating extends StatelessWidget {
  const StarRating({
    super.key,
    required this.rating,
    this.size = 29,
    this.onChanged,
    this.spacing = 9,
  });

  final double rating;
  final double size;
  final ValueChanged<double>? onChanged;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 1; i <= 5; i++) ...[
          if (i > 1) SizedBox(width: spacing),
          GestureDetector(
            // Tapping the current rating again clears it.
            onTap: onChanged == null
                ? null
                : () => onChanged!(rating == i ? 0 : i.toDouble()),
            child: Text(
              '★',
              style: TextStyle(
                fontSize: size,
                height: 1,
                color: i <= rating.round()
                    ? AppColors.star
                    : AppColors.starEmpty,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// The rust-filled progress track used for reading progress.
class ProgressTrack extends StatelessWidget {
  const ProgressTrack({
    super.key,
    required this.value,
    this.height = 5,
    this.background = AppColors.rule,
    this.fill = AppColors.accent,
  });

  final double value;
  final double height;
  final Color background;
  final Color fill;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: SizedBox(
        height: height,
        child: Stack(
          children: [
            Positioned.fill(child: ColoredBox(color: background)),
            FractionallySizedBox(
              widthFactor: value.clamp(0.0, 1.0),
              heightFactor: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: fill,
                  borderRadius: BorderRadius.circular(height / 2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
