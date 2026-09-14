import 'package:flutter/material.dart';

import '../l10n_extensions.dart';
import '../theme/tokens.dart';
import '../theme/typography.dart';
import 'app_buttons.dart';
import 'app_icons.dart';

/// A shimmering block, shaped like the content it stands in for. The design
/// asks for cover-shaped skeletons, never a spinner on a blank page.
class Skeleton extends StatefulWidget {
  const Skeleton({
    super.key,
    this.width,
    this.height,
    this.radius = 3,
    this.aspectRatio,
  });

  final double? width;
  final double? height;
  final double radius;
  final double? aspectRatio;

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: AppMotion.shimmer,
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget block = AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius),
            gradient: LinearGradient(
              begin: Alignment(-1 + t * 2 - .6, 0),
              end: Alignment(-1 + t * 2 + .6, 0),
              colors: const [
                Color(0xFFEAE3D6),
                Color(0xFFF3EDE2),
                Color(0xFFEAE3D6),
              ],
              stops: const [.08, .5, .92],
            ),
          ),
        );
      },
    );

    if (widget.aspectRatio != null) {
      block = AspectRatio(aspectRatio: widget.aspectRatio!, child: block);
    }
    return SizedBox(width: widget.width, height: widget.height, child: block);
  }
}

/// The library loading state: a skeleton of the real grid.
class LibrarySkeleton extends StatelessWidget {
  const LibrarySkeleton({super.key, this.columns = 3, this.message});

  final int columns;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Skeleton(height: 34, width: 150, radius: 6),
          const SizedBox(height: 18),
          const Skeleton(height: 44, radius: 12),
          const SizedBox(height: 26),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: columns * 3,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              mainAxisSpacing: 14,
              crossAxisSpacing: 12,
              childAspectRatio: 2 / 3.42,
            ),
            itemBuilder: (context, index) => const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Skeleton(aspectRatio: 2 / 3)),
                SizedBox(height: 8),
                Skeleton(height: 9, width: 70, radius: 3),
                SizedBox(height: 5),
                Skeleton(height: 8, width: 46, radius: 3),
              ],
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 34),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const _SpinnerArc(size: 15),
                  const SizedBox(width: 9),
                  // Flexible, not fixed: the same sentence is longer in some
                  // languages than in others, and it must wrap rather than
                  // run off the edge.
                  Flexible(
                    child: Text(
                      message!,
                      style: AppText.sans(size: 12.5, color: AppColors.muted),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SpinnerArc extends StatefulWidget {
  const _SpinnerArc({this.size = 15});
  final double size;

  @override
  State<_SpinnerArc> createState() => _SpinnerArcState();
}

class _SpinnerArcState extends State<_SpinnerArc>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => RotationTransition(
        turns: _controller,
        child: AppIcon(
          AppIcons.spinnerArc,
          size: widget.size,
          color: AppColors.accent,
        ),
      );
}

/// A centred empty or error state: optional icon, serif headline, supporting
/// line and up to two actions.
class MessageState extends StatelessWidget {
  const MessageState({
    super.key,
    required this.title,
    required this.message,
    this.icon,
    this.leading,
    this.primaryLabel,
    this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
    this.topPadding = 0,
    this.maxMessageWidth = 250,
    this.titleSize = 23,
  });

  final String title;
  final String message;
  final AppIconData? icon;

  /// Drawn above the title — the dashed cover outlines on the empty library.
  final Widget? leading;

  final String? primaryLabel;
  final VoidCallback? onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  final double topPadding;
  final double maxMessageWidth;
  final double titleSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding, left: 24, right: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (leading != null) ...[leading!, const SizedBox(height: 24)],
          if (icon != null) ...[
            AppIcon(icon!, size: 40, color: AppColors.dashed, strokeWidth: 1.4),
            const SizedBox(height: 8),
          ],
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppText.serif(size: titleSize),
          ),
          const SizedBox(height: 7),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxMessageWidth),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: AppText.sans(
                size: 13.5,
                height: 1.5,
                color: AppColors.muted,
              ),
            ),
          ),
          if (primaryLabel != null) ...[
            const SizedBox(height: 18),
            PrimaryButton(
              label: primaryLabel!,
              onPressed: onPrimary,
              height: 46,
              expand: false,
              fontSize: 14.5,
            ),
          ],
          if (secondaryLabel != null) ...[
            const SizedBox(height: 6),
            TextActionButton(
              label: secondaryLabel!,
              onPressed: onSecondary,
              fontSize: 14,
            ),
          ],
        ],
      ),
    );
  }
}

/// Shown when a query or lookup fails outright.
class ErrorStateView extends StatelessWidget {
  const ErrorStateView({
    super.key,
    required this.message,
    this.onRetry,
    this.title,
  });

  /// Defaults to the generic apology when the call site has nothing better
  /// to say.
  final String? title;
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => MessageState(
        title: title ?? context.l10n.scanFailUnknownTitle,
        message: message,
        icon: AppIcons.alert,
        titleSize: 22,
        maxMessageWidth: 260,
        primaryLabel: onRetry == null ? null : context.l10n.actionTryAgain,
        onPrimary: onRetry,
      );
}
