import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';

class BookCollectionApp extends ConsumerWidget {
  const BookCollectionApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Book Collection',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.build(),
      routerConfig: ref.watch(routerProvider),
      builder: (context, child) {
        // The design is drawn against a fixed type scale; ignore very large
        // system text scaling so headers and covers keep their proportions,
        // while still honouring moderate accessibility settings.
        final scale = MediaQuery.textScalerOf(context).scale(14) / 14;
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(scale.clamp(1.0, 1.3)),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
