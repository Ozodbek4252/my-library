import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import '../theme/typography.dart';
import 'app_icons.dart';

class NavDestination {
  const NavDestination({
    required this.label,
    required this.icon,
    this.promoted = false,
  });

  final String label;
  final AppIconData icon;

  /// The Scan item sits in an ink rounded rectangle rather than plain.
  final bool promoted;
}

/// The 88px translucent bottom bar. Scan is visually promoted, matching the
/// design; tapping it opens the scanner rather than switching tabs.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onSelected,
    required this.destinations,
  });

  final int currentIndex;
  final ValueChanged<int> onSelected;
  final List<NavDestination> destinations;

  static const height = AppSpacing.navHeight;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          height: height + bottomInset,
          padding: EdgeInsets.only(top: 9, left: 8, right: 8, bottom: bottomInset),
          decoration: const BoxDecoration(
            color: Color(0xEDF7F3EB),
            border: Border(top: BorderSide(color: Color(0xFFE4DCCC))),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < destinations.length; i++)
                Expanded(
                  child: _NavItem(
                    destination: destinations[i],
                    active: i == currentIndex,
                    onTap: () => onSelected(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.destination,
    required this.active,
    required this.onTap,
  });

  final NavDestination destination;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.ink : AppColors.faint;

    return Semantics(
      button: true,
      selected: active,
      label: destination.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 34,
                child: Center(
                  child: destination.promoted
                      ? Container(
                          width: 46,
                          height: 34,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.ink,
                            borderRadius: BorderRadius.circular(11),
                            boxShadow: AppShadows.scanFab,
                          ),
                          child: AppIcon(
                            destination.icon,
                            size: 23,
                            color: AppColors.paper,
                          ),
                        )
                      : AppIcon(destination.icon, size: 21, color: color),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                destination.label,
                style: AppText.navLabel.copyWith(
                  color: color,
                  fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                  fontVariations: [
                    FontVariation('wght', active ? 600 : 500),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
