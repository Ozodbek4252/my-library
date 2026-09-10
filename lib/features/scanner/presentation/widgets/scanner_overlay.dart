import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';

/// Dims everything outside the reticle. The design does this with a 2000px
/// box-shadow; here it is one even-odd filled path.
class ReticleDimPainter extends CustomPainter {
  const ReticleDimPainter({required this.reticle, required this.radius});

  final Rect reticle;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(Offset.zero & size)
      ..addRRect(
        RRect.fromRectAndRadius(reticle, Radius.circular(radius)),
      );
    canvas.drawPath(path, Paint()..color = const Color(0x8C0A0907));
  }

  @override
  bool shouldRepaint(ReticleDimPainter old) => old.reticle != reticle;
}

/// The four 34px corner brackets of the reticle.
class CornerBrackets extends StatelessWidget {
  const CornerBrackets({super.key, this.size = 34, this.thickness = 2.5});

  final double size;
  final double thickness;

  @override
  Widget build(BuildContext context) {
    Widget corner({
      required bool top,
      required bool left,
    }) {
      final side = BorderSide(
        color: AppColors.highlightBright,
        width: thickness,
      );
      return Positioned(
        top: top ? 0 : null,
        bottom: top ? null : 0,
        left: left ? 0 : null,
        right: left ? null : 0,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            border: Border(
              top: top ? side : BorderSide.none,
              bottom: top ? BorderSide.none : side,
              left: left ? side : BorderSide.none,
              right: left ? BorderSide.none : side,
            ),
            borderRadius: BorderRadius.only(
              topLeft: top && left ? const Radius.circular(14) : Radius.zero,
              topRight: top && !left ? const Radius.circular(14) : Radius.zero,
              bottomLeft:
                  !top && left ? const Radius.circular(14) : Radius.zero,
              bottomRight:
                  !top && !left ? const Radius.circular(14) : Radius.zero,
            ),
          ),
        ),
      );
    }

    return Stack(
      children: [
        corner(top: true, left: true),
        corner(top: true, left: false),
        corner(top: false, left: true),
        corner(top: false, left: false),
      ],
    );
  }
}

/// The sweeping scan line, 1.6s ease-in-out, alternating.
class ScanLine extends StatefulWidget {
  const ScanLine({super.key, required this.travel});

  final double travel;

  @override
  State<ScanLine> createState() => _ScanLineState();
}

class _ScanLineState extends State<ScanLine>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: AppMotion.scanline,
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = Curves.easeInOut.transform(_controller.value);
        return Transform.translate(
          offset: Offset(0, (t * 2 - 1) * widget.travel),
          child: child,
        );
      },
      child: Container(
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0x00E9C79A),
              AppColors.highlightBright,
              Color(0x00E9C79A),
            ],
          ),
          boxShadow: [
            BoxShadow(color: AppColors.highlightBright, blurRadius: 14),
          ],
        ),
      ),
    );
  }
}

/// The translucent buttons along the bottom of the scanner.
class ScannerButton extends StatelessWidget {
  const ScannerButton({
    super.key,
    required this.label,
    required this.onTap,
    this.height = 48,
  });

  final String label;
  final VoidCallback onTap;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0x1FF5EEE1),
      borderRadius: BorderRadius.circular(AppRadius.button),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.button),
        child: SizedBox(
          height: height,
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'InstrumentSans',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.onboardingText,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
