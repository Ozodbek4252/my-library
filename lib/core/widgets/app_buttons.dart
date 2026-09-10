import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import '../theme/typography.dart';

/// The filled ink button — the primary action on every screen and sheet.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.height = 52,
    this.icon,
    this.expand = true,
    this.background = AppColors.ink,
    this.foreground = AppColors.paper,
    this.fontSize = 15,
    this.busy = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final double height;
  final Widget? icon;
  final bool expand;
  final Color background;
  final Color foreground;
  final double fontSize;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !busy;
    final button = Opacity(
      opacity: enabled ? 1 : .5,
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.button),
        child: InkWell(
          onTap: enabled ? onPressed : null,
          borderRadius: BorderRadius.circular(AppRadius.button),
          child: SizedBox(
            height: height,
            child: Center(
              child: busy
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(foreground),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (icon != null) ...[icon!, const SizedBox(width: 10)],
                        Flexible(
                          child: Text(
                            label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.sans(
                              size: fontSize,
                              weight: 600,
                              color: foreground,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );

    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}

/// The paper button with a hairline border — secondary actions beside a
/// primary one.
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.height = 48,
    this.expand = true,
    this.foreground = AppColors.ink,
    this.fontSize = 14,
    this.fontWeight = 500,
  });

  final String label;
  final VoidCallback? onPressed;
  final double height;
  final bool expand;
  final Color foreground;
  final double fontSize;
  final double fontWeight;

  @override
  Widget build(BuildContext context) {
    final button = Material(
      color: AppColors.paperRaised,
      borderRadius: BorderRadius.circular(AppRadius.button),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadius.button),
        child: Container(
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.button),
            border: Border.all(color: AppColors.starEmpty),
          ),
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.sans(
                size: fontSize,
                weight: fontWeight,
                color: foreground,
              ),
            ),
          ),
        ),
      ),
    );

    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}

/// A bare rust-coloured text button — "Cancel", "Save", "Clear".
class TextActionButton extends StatelessWidget {
  const TextActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color = AppColors.accent,
    this.fontSize = 14.5,
    this.fontWeight = 600,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color color;
  final double fontSize;
  final double fontWeight;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text(
          label,
          style: AppText.sans(
            size: fontSize,
            weight: fontWeight,
            color: onPressed == null ? AppColors.faintest : color,
          ),
        ),
      ),
    );
  }
}

/// The destructive button on the edit screen: rust label on a pale wash.
class DestructiveButton extends StatelessWidget {
  const DestructiveButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.height = 50,
    this.filled = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final double height;

  /// True for the solid rust button inside a confirmation dialog.
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: filled ? AppColors.accent : AppColors.accentWash,
        borderRadius: BorderRadius.circular(AppRadius.button),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppRadius.button),
          child: Container(
            height: height,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.button),
              border: filled
                  ? null
                  : Border.all(color: AppColors.accentBorder),
            ),
            child: Text(
              label,
              style: AppText.sans(
                size: filled ? 15 : 14.5,
                weight: 600,
                color: filled ? const Color(0xFFFBF6EE) : AppColors.accent,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The dashed "+ Add another edition" button.
class DashedButton extends StatelessWidget {
  const DashedButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.height = 50,
  });

  final String label;
  final VoidCallback? onPressed;
  final double height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: CustomPaint(
        painter: const DashedBorderPainter(
          color: AppColors.dashed,
          radius: AppRadius.button,
        ),
        child: SizedBox(
          height: height,
          width: double.infinity,
          child: Center(
            child: Text(
              label,
              style: AppText.sans(
                size: 14.5,
                weight: 600,
                color: const Color(0xFF5A5248),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Draws a dashed rounded rectangle — used for empty cover slots, the cover
/// dropzone and the "add another edition" button.
class DashedBorderPainter extends CustomPainter {
  const DashedBorderPainter({
    this.color = AppColors.dashed,
    this.radius = 3,
    this.strokeWidth = 1.5,
    this.dash = 5,
    this.gap = 4,
  });

  final Color color;
  final double radius;
  final double strokeWidth;
  final double dash;
  final double gap;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          Radius.circular(radius),
        ),
      );

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = (distance + dash).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance = next + gap;
      }
    }
  }

  @override
  bool shouldRepaint(DashedBorderPainter old) =>
      old.color != color ||
      old.radius != radius ||
      old.strokeWidth != strokeWidth;
}

/// A circular icon button — the back affordance and the scanner's close button.
class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.size = 34,
    this.background = AppColors.paperRaised,
    this.border,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final double size;
  final Color background;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      shape: CircleBorder(
        side: border is Border
            ? (border as Border).top
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: size,
          height: size,
          child: Center(child: child),
        ),
      ),
    );
  }
}
