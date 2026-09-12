import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/books/presentation/add_book_screen.dart';
import '../../features/books/presentation/book_details_screen.dart';
import '../../features/books/presentation/edit_copy_screen.dart';
import '../../features/books/presentation/editions_screen.dart';
import '../../features/library/presentation/library_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/profile/presentation/import_export_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/reading/presentation/reading_screen.dart';
import '../../features/scanner/presentation/scanner_screen.dart';
import '../../features/search/presentation/search_screen.dart';
import '../../features/statistics/presentation/statistics_screen.dart';
import '../../features/wishlist/presentation/wishlist_detail_screen.dart';
import '../../features/wishlist/presentation/wishlist_screen.dart';
import '../settings.dart';
import 'app_shell.dart';
import 'routes.dart';

final _rootKey = GlobalKey<NavigatorState>();

/// A page with no transition — used for the tab branches, which swap in place.
CustomTransitionPage<T> _noTransition<T>(Widget child, GoRouterState state) =>
    CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
      transitionsBuilder: (_, _, _, child) => child,
    );

/// Full-screen routes that rise from the bottom: sheets-as-screens such as
/// Add book and the scanner.
CustomTransitionPage<T> _modalPage<T>(Widget child, GoRouterState state) =>
    CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 280),
      reverseTransitionDuration: const Duration(milliseconds: 220),
      transitionsBuilder: (context, animation, _, child) => SlideTransition(
        position: Tween(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: animation, curve: const Cubic(.2, .8, .3, 1)),
        ),
        child: child,
      ),
    );

final routerProvider = Provider<GoRouter>((ref) {
  final onboardingComplete =
      ref.watch(settingsProvider.select((s) => s.onboardingComplete));

  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: onboardingComplete ? Routes.library : Routes.onboarding,
    routes: [
      GoRoute(
        path: Routes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: Routes.search,
        pageBuilder: (context, state) =>
            _modalPage(const SearchScreen(), state),
      ),
      GoRoute(
        path: Routes.scanner,
        pageBuilder: (context, state) =>
            _modalPage(const ScannerScreen(), state),
      ),
      GoRoute(
        path: Routes.scanIsbn,
        pageBuilder: (context, state) => _modalPage<String>(
          const ScannerScreen(captureOnly: true),
          state,
        ),
      ),
      GoRoute(
        path: Routes.addBook,
        pageBuilder: (context, state) => _modalPage(
          AddBookScreen(draft: state.extra as AddBookArgs?),
          state,
        ),
      ),
      GoRoute(
        path: Routes.importExport,
        builder: (context, state) => const ImportExportScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.library,
                pageBuilder: (context, state) =>
                    _noTransition(const LibraryScreen(), state),
                routes: [
                  GoRoute(
                    path: 'book/:workId',
                    builder: (context, state) => BookDetailsScreen(
                      workId: state.pathParameters['workId']!,
                    ),
                    routes: [
                      GoRoute(
                        path: 'editions',
                        builder: (context, state) => EditionsScreen(
                          workId: state.pathParameters['workId']!,
                        ),
                      ),
                      GoRoute(
                        path: 'edit',
                        parentNavigatorKey: _rootKey,
                        pageBuilder: (context, state) => _modalPage(
                          AddBookScreen(
                            draft: AddBookArgs(
                              workId: state.pathParameters['workId'],
                            ),
                          ),
                          state,
                        ),
                      ),
                      GoRoute(
                        path: 'copy/:copyId/edit',
                        parentNavigatorKey: _rootKey,
                        pageBuilder: (context, state) => _modalPage(
                          EditCopyScreen(
                            workId: state.pathParameters['workId']!,
                            copyId: state.pathParameters['copyId']!,
                          ),
                          state,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.reading,
                pageBuilder: (context, state) =>
                    _noTransition(const ReadingScreen(), state),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.wishlist,
                pageBuilder: (context, state) =>
                    _noTransition(const WishlistScreen(), state),
                routes: [
                  GoRoute(
                    path: ':itemId',
                    builder: (context, state) => WishlistDetailScreen(
                      itemId: state.pathParameters['itemId']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.profile,
                pageBuilder: (context, state) =>
                    _noTransition(const ProfileScreen(), state),
                routes: [
                  GoRoute(
                    path: 'statistics',
                    builder: (context, state) => const StatisticsScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
