import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n_extensions.dart';
import '../../../core/routing/routes.dart';
import '../../../core/settings.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/theme/typography.dart';
import '../../../core/widgets/book_cover.dart';

/// The dark opening screen: three tilted covers, the headline, and the two
/// ways into the app.
class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  static const _covers = [
    (title: 'Pachinko', author: 'Lee', color: 3),
    (title: '1984', author: 'Orwell', color: 0),
    (title: 'Meditations', author: 'Aurelius', color: 6),
  ];

  Future<void> _start(BuildContext context, WidgetRef ref, String route) async {
    await ref.read(settingsProvider.notifier).completeOnboarding();
    if (context.mounted) context.go(route);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.onboardingBg,
      body: Stack(
        children: [
          Positioned(
            top: 96,
            left: 0,
            right: 0,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < _covers.length; i++) ...[
                    if (i > 0) const SizedBox(width: 12),
                    Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 1 / 900)
                        ..rotateY(switch (i) { 0 => .31, 1 => 0.0, _ => -.31 })
                        ..translateByDouble(0, 0, i == 1 ? 26 : 0, 1)
                        ..rotateZ(switch (i) { 0 => -.07, 1 => 0.0, _ => .07 }),
                      child: BookCover(
                        title: _covers[i].title,
                        author: _covers[i].author,
                        colorIndex: _covers[i].color,
                        width: 96,
                        height: 144,
                        titleSize: 14,
                        authorSize: 8,
                        spineWidth: 7,
                        shadows: const [
                          BoxShadow(
                            color: Color(0x80000000),
                            blurRadius: 34,
                            offset: Offset(0, 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 44),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: '${context.l10n.onboardingHeadlineFirst}\n'),
                        TextSpan(
                          text: context.l10n.onboardingHeadlineSecond,
                          style: AppText.onboardingHeadline.copyWith(
                            fontStyle: FontStyle.italic,
                            color: AppColors.highlight,
                          ),
                        ),
                      ],
                    ),
                    style: AppText.onboardingHeadline,
                  ),
                  const SizedBox(height: 14),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 300),
                    child: Text(
                      context.l10n.onboardingSubhead,
                      style: AppText.sans(
                        size: 14.5,
                        height: 1.5,
                        color: AppColors.onboardingSub,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  _OnboardingButton(
                    label: context.l10n.onboardingStart,
                    background: AppColors.onboardingText,
                    foreground: AppColors.ink,
                    onTap: () => _start(context, ref, Routes.library),
                  ),
                  const SizedBox(height: 10),
                  _OnboardingButton(
                    label: context.l10n.onboardingScanFirst,
                    background: Colors.transparent,
                    foreground: const Color(0xFFD6CCBC),
                    border: true,
                    onTap: () async {
                      await ref
                          .read(settingsProvider.notifier)
                          .completeOnboarding();
                      if (!context.mounted) return;
                      context.go(Routes.library);
                      context.push(Routes.scanner);
                    },
                  ),
                  const SizedBox(height: 26),
                  const _Pager(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingButton extends StatelessWidget {
  const _OnboardingButton({
    required this.label,
    required this.background,
    required this.foreground,
    required this.onTap,
    this.border = false,
  });

  final String label;
  final Color background;
  final Color foreground;
  final VoidCallback onTap;
  final bool border;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 54,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: border
                ? Border.all(color: const Color(0x3DF5EEE1))
                : null,
          ),
          child: Text(
            label,
            style: AppText.sans(
              size: border ? 15 : 15.5,
              weight: border ? 500 : 600,
              letterSpacing: .01,
              color: foreground,
            ),
          ),
        ),
      ),
    );
  }
}

class _Pager extends StatelessWidget {
  const _Pager();

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 22,
            height: 3,
            decoration: BoxDecoration(
              color: AppColors.highlight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          for (var i = 0; i < 2; i++) ...[
            const SizedBox(width: 6),
            Container(
              width: 8,
              height: 3,
              decoration: BoxDecoration(
                color: const Color(0x40F5EEE1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ],
      );
}
