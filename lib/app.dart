import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/routing/app_router.dart';
import 'core/settings.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/formatting.dart';
import 'l10n/app_localizations.dart';

class BookCollectionApp extends ConsumerWidget {
  const BookCollectionApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(settingsProvider.select((s) => s.language));

    // Dates and numbers follow the interface language. Set here rather than
    // inside [Fmt] so there is one place where the language is decided.
    Fmt.locale = language.code;

    return MaterialApp.router(
      onGenerateTitle: (context) => AppL10n.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.build(),
      locale: language.locale,
      localizationsDelegates: AppL10n.localizationsDelegates,
      supportedLocales: AppL10n.supportedLocales,
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
