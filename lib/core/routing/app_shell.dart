import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/tokens.dart';
import '../widgets/app_icons.dart';
import '../widgets/bottom_nav.dart';
import 'routes.dart';

/// Holds the four tabbed sections and the bottom bar. Scan is the fifth item
/// but is pushed over the shell rather than being a tab, because the design
/// hides the nav on the scanner.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _destinations = [
    NavDestination(label: 'Library', icon: AppIcons.navLibrary),
    NavDestination(label: 'Reading', icon: AppIcons.navReading),
    NavDestination(label: 'Scan', icon: AppIcons.barcode, promoted: true),
    NavDestination(label: 'Wishlist', icon: AppIcons.navWishlist),
    NavDestination(label: 'Profile', icon: AppIcons.navProfile),
  ];

  /// Nav index 2 is Scan; branch indexes skip it.
  static int _branchToNav(int branch) => branch >= 2 ? branch + 1 : branch;
  static int? _navToBranch(int nav) => switch (nav) {
        2 => null,
        < 2 => nav,
        _ => nav - 1,
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: AppBottomNav(
        destinations: _destinations,
        currentIndex: _branchToNav(navigationShell.currentIndex),
        onSelected: (index) {
          final branch = _navToBranch(index);
          if (branch == null) {
            context.push(Routes.scanner);
            return;
          }
          navigationShell.goBranch(
            branch,
            // Tapping the active tab returns to the top of that section.
            initialLocation: branch == navigationShell.currentIndex,
          );
        },
      ),
    );
  }
}
