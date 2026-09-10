import 'package:flutter/material.dart';

import 'tokens.dart';

const _serif = 'Newsreader';
const _sans = 'InstrumentSans';

/// Both bundled families are variable fonts. Flutter only reliably applies a
/// weight to a variable font when the `wght` axis is set explicitly, so every
/// style here carries a matching [FontVariation].
TextStyle _serifStyle({
  required double size,
  double weight = 400,
  double? height,
  double? letterSpacing,
  Color color = AppColors.ink,
  FontStyle? fontStyle,
}) {
  return TextStyle(
    fontFamily: _serif,
    fontSize: size,
    height: height,
    letterSpacing: letterSpacing == null ? null : letterSpacing * size,
    color: color,
    fontStyle: fontStyle,
    fontWeight: _weightOf(weight),
    fontVariations: [FontVariation('wght', weight)],
  );
}

TextStyle _sansStyle({
  required double size,
  double weight = 400,
  double? height,
  double? letterSpacing,
  Color color = AppColors.ink,
}) {
  return TextStyle(
    fontFamily: _sans,
    fontSize: size,
    height: height,
    letterSpacing: letterSpacing == null ? null : letterSpacing * size,
    color: color,
    fontWeight: _weightOf(weight),
    fontVariations: [FontVariation('wght', weight)],
  );
}

FontWeight _weightOf(double w) =>
    FontWeight.values[((w / 100).round() - 1).clamp(0, 8)];

/// The type scale from the handoff. Sizes are in logical pixels against a
/// 390pt-wide viewport, matching the design 1:1.
abstract final class AppText {
  // Display / serif
  static TextStyle get onboardingHeadline =>
      _serifStyle(size: 42, height: 1.06, letterSpacing: -.02, color: AppColors.onboardingText);
  static TextStyle get screenTitle =>
      _serifStyle(size: 31, height: 1.1, letterSpacing: -.015);
  static TextStyle get screenTitleSmall =>
      _serifStyle(size: 29, height: 1.1, letterSpacing: -.01);
  static TextStyle get heroTitle =>
      _serifStyle(size: 27, height: 1.1, letterSpacing: -.01);
  static TextStyle get sheetTitle => _serifStyle(size: 22, height: 1.2);
  static TextStyle get statFigure => _serifStyle(size: 30, height: 1);
  static TextStyle get statFigureSmall => _serifStyle(size: 21, height: 1);
  static TextStyle get progressFigure => _serifStyle(size: 58, height: 1);
  static TextStyle get note => _serifStyle(
        size: 15.5,
        height: 1.55,
        color: Color(0xFF332E28),
        fontStyle: FontStyle.italic,
      );

  // UI / sans
  static TextStyle get body =>
      _sansStyle(size: 14, height: 1.62, color: AppColors.inkBody);
  static TextStyle get bodySmall =>
      _sansStyle(size: 13.5, height: 1.5, color: AppColors.muted);
  static TextStyle get listPrimary =>
      _sansStyle(size: 14.5, weight: 500, height: 1.25);
  static TextStyle get listSecondary =>
      _sansStyle(size: 12.5, color: AppColors.muted2);
  static TextStyle get metadata => _sansStyle(size: 11, color: AppColors.faint);
  static TextStyle get sectionLabel => _sansStyle(
        size: 10,
        letterSpacing: .14,
        color: AppColors.faint,
      );
  static TextStyle get microLabel => _sansStyle(
        size: 9.5,
        letterSpacing: .1,
        color: AppColors.muted2,
      );
  static TextStyle get button => _sansStyle(size: 15, weight: 600);
  static TextStyle get chip => _sansStyle(size: 13, weight: 500);
  static TextStyle get pill => _sansStyle(size: 11.5, weight: 600);
  static TextStyle get navLabel => _sansStyle(size: 10, weight: 500, letterSpacing: .02);

  /// Serif style used inside cover placeholders.
  static TextStyle coverTitle(double size, Color color) =>
      _serifStyle(size: size, height: 1.16, letterSpacing: .005, color: color);

  /// Uppercase author line at the foot of a cover placeholder.
  static TextStyle coverAuthor(double size, Color color) =>
      _sansStyle(size: size, letterSpacing: .13, height: 1.3, color: color);

  static TextStyle serif({
    required double size,
    double weight = 400,
    double? height,
    double? letterSpacing,
    Color color = AppColors.ink,
    FontStyle? fontStyle,
  }) =>
      _serifStyle(
        size: size,
        weight: weight,
        height: height,
        letterSpacing: letterSpacing,
        color: color,
        fontStyle: fontStyle,
      );

  static TextStyle sans({
    required double size,
    double weight = 400,
    double? height,
    double? letterSpacing,
    Color color = AppColors.ink,
  }) =>
      _sansStyle(
        size: size,
        weight: weight,
        height: height,
        letterSpacing: letterSpacing,
        color: color,
      );
}
