import 'package:flutter/material.dart';

/// Design tokens from the Book Collection handoff.
/// All values are taken from the design spec — do not invent new ones.
abstract final class AppColors {
  // Surfaces
  static const paper = Color(0xFFF7F3EB);
  static const paperRaised = Color(0xFFFCFAF5);
  static const paperSunken = Color(0xFFF1EADC);
  static const paperChip = Color(0xFFEFE9DB);
  static const desk = Color(0xFFE4DED2);

  // Text
  static const ink = Color(0xFF1A1714);
  static const ink2 = Color(0xFF2A251F);
  static const inkBody = Color(0xFF4A443C);
  static const muted = Color(0xFF7A7167);
  static const muted2 = Color(0xFF8A8177);
  static const faint = Color(0xFFA0968A);
  static const faintest = Color(0xFFB4AA9C);
  static const chevron = Color(0xFFC0B6A6);

  // Lines
  static const rule = Color(0xFFE7E0D2);
  static const ruleStrong = Color(0xFFE0D8C9);
  static const ruleInner = Color(0xFFEFE8DA);
  static const dashed = Color(0xFFCFC5B4);

  // Accent (rust)
  static const accent = Color(0xFF8A3B2C);
  static const accentDark = Color(0xFF6E2C20);
  static const accentWash = Color(0xFFFBF1EE);
  static const accentWashStrong = Color(0xFFF3E2DC);
  static const accentBorder = Color(0xFFE3CBC4);

  // Status
  static const successBg = Color(0xFFE7EDE4);
  static const successFg = Color(0xFF3B5C3F);
  static const successBorder = Color(0xFFCDDAC6);
  static const successInk = Color(0xFF294229);
  static const progressBg = Color(0xFFF5E7D3);
  static const progressFg = Color(0xFF7A5B33);

  // Highlight (scanned / attention)
  static const highlight = Color(0xFFD9A87C);
  static const highlightBright = Color(0xFFE9C79A);
  static const highlightWash = Color(0xFFFBF4E9);
  static const highlightBorder = Color(0xFFEBDCC5);

  // Stars
  static const star = Color(0xFFB9873F);
  static const starEmpty = Color(0xFFDCD3C2);

  // Dark scenes
  static const darkScene = Color(0xFF100E0C);
  static const onboardingBg = Color(0xFF1E1B17);
  static const onboardingText = Color(0xFFF5EEE1);
  static const onboardingSub = Color(0xFFA79C8D);

  // Chart palette
  static const chart = [
    Color(0xFF2A2521),
    Color(0xFF8A3B2C),
    Color(0xFF8A6B3A),
    Color(0xFFB9AE9C),
  ];
  static const barDefault = Color(0xFFC4BAA6);
  static const barBest = ink;
  static const barEmpty = Color(0xFFEAE3D6);

  /// Cover placeholder palette: (background, foreground).
  static const coverPalette = <(Color, Color)>[
    (Color(0xFF1F1D1A), Color(0xFFE8DCC8)),
    (Color(0xFFE4DCC6), Color(0xFF241F19)),
    (Color(0xFF2F4A3C), Color(0xFFE5DDCB)),
    (Color(0xFF7A2E2E), Color(0xFFF0E4D2)),
    (Color(0xFF4B2E5A), Color(0xFFEADFEA)),
    (Color(0xFF4A5D3A), Color(0xFFEDE6D2)),
    (Color(0xFF6B5B3E), Color(0xFFF2E9D6)),
    (Color(0xFFD9C48A), Color(0xFF2A2418)),
    (Color(0xFF8A3B2C), Color(0xFFF4E6D6)),
    (Color(0xFFC9532F), Color(0xFFFBEEDD)),
    (Color(0xFF26364F), Color(0xFFDFE4EA)),
    (Color(0xFFB08A4E), Color(0xFF2A2114)),
  ];
}

abstract final class AppRadius {
  static const cover = 3.0;
  static const thumb = 2.0;
  static const pill = 7.0;
  static const chip = 9.0;
  static const input = 11.0;
  static const button = 13.0;
  static const card = 14.0;
  static const dialog = 20.0;
  static const sheet = 26.0;
  static const sheetSmall = 24.0;
}

abstract final class AppSpacing {
  /// Horizontal padding used on every screen.
  static const screenH = 22.0;
  static const screenTop = 60.0;
  /// Bottom padding on screens that sit behind the bottom nav.
  static const navClearance = 112.0;
  /// Bottom padding on modal-style screens (no nav).
  static const modalBottom = 40.0;
  static const navHeight = 88.0;
}

abstract final class AppShadows {
  static const coverGrid = [
    BoxShadow(color: Color(0x331A1714), blurRadius: 2, offset: Offset(0, 1)),
    BoxShadow(color: Color(0x211A1714), blurRadius: 16, offset: Offset(0, 6)),
  ];
  static const coverLarge = [
    BoxShadow(color: Color(0x73000000), blurRadius: 22, offset: Offset(0, 6)),
  ];
  static const thumb = [
    BoxShadow(color: Color(0x2E1A1714), blurRadius: 3, offset: Offset(0, 1)),
  ];
  static const scanFab = [
    BoxShadow(color: Color(0x471A1714), blurRadius: 10, offset: Offset(0, 3)),
  ];
  static const dialog = [
    BoxShadow(color: Color(0x660C0A08), blurRadius: 50, offset: Offset(0, 20)),
  ];
  static const toast = [
    BoxShadow(color: Color(0x520C0A08), blurRadius: 30, offset: Offset(0, 10)),
  ];
  static const segmentedThumb = [
    BoxShadow(color: Color(0x1F1A1714), blurRadius: 2, offset: Offset(0, 1)),
  ];
}

abstract final class AppMotion {
  static const sheetCurve = Cubic(.2, .8, .3, 1);
  static const sheet = Duration(milliseconds: 300);
  static const rise = Duration(milliseconds: 230);
  static const scanline = Duration(milliseconds: 1600);
  static const pulse = Duration(milliseconds: 1100);
  static const shimmer = Duration(milliseconds: 1300);
  static const toastLife = Duration(milliseconds: 2400);
}
