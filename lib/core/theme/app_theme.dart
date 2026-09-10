import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';

import 'tokens.dart';
import 'typography.dart';

abstract final class AppTheme {
  static ThemeData build() {
    const scheme = ColorScheme.light(
      primary: AppColors.ink,
      onPrimary: AppColors.paper,
      secondary: AppColors.accent,
      onSecondary: AppColors.paper,
      surface: AppColors.paper,
      onSurface: AppColors.ink,
      error: AppColors.accent,
      onError: AppColors.paper,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.paper,
      fontFamily: 'InstrumentSans',
      splashFactory: InkRipple.splashFactory,
      highlightColor: const Color(0x0F1A1714),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.accent,
        selectionColor: Color(0x338A3B2C),
        selectionHandleColor: AppColors.accent,
      ),
      textTheme: TextTheme(
        bodyMedium: AppText.body,
        bodySmall: AppText.listSecondary,
        titleMedium: AppText.listPrimary,
        headlineSmall: AppText.sheetTitle,
        headlineMedium: AppText.screenTitle,
      ),
      // The design has no Material app bars, dividers or cards of its own —
      // every surface is drawn explicitly by the feature widgets.
      dividerTheme: const DividerThemeData(
        color: AppColors.rule,
        thickness: 1,
        space: 1,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
