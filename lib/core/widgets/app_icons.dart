import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/tokens.dart';

/// The icon set from the design: a 24-box stroke family, 1.8–2.2 weight, round
/// caps. Drawn from the original paths so the shapes match exactly rather than
/// being approximated with a stock glyph set.
class AppIcon extends StatelessWidget {
  const AppIcon(
    this.icon, {
    super.key,
    this.size = 21,
    this.color = AppColors.ink,
    this.strokeWidth,
  });

  final AppIconData icon;
  final double size;
  final Color color;
  final double? strokeWidth;

  @override
  Widget build(BuildContext context) {
    final width = strokeWidth ?? icon.strokeWidth;
    final svg = '<svg xmlns="http://www.w3.org/2000/svg" width="$size" '
        'height="$size" viewBox="0 0 24 24" fill="${icon.fill ? 'currentColor' : 'none'}" '
        'stroke="currentColor" stroke-width="$width" stroke-linecap="round" '
        'stroke-linejoin="round">${icon.paths}</svg>';

    return SvgPicture.string(
      svg,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}

class AppIconData {
  const AppIconData(this.paths, {this.strokeWidth = 1.9, this.fill = false});

  final String paths;
  final double strokeWidth;
  final bool fill;
}

abstract final class AppIcons {
  static const search = AppIconData(
    '<circle cx="11" cy="11" r="7"/><path d="m20 20-3.5-3.5"/>',
    strokeWidth: 2,
  );
  static const filter = AppIconData(
    '<path d="M4 6h16M7 12h10M10 18h4"/>',
    strokeWidth: 2,
  );
  static const sort = AppIconData(
    '<path d="M7 4v16m0 0-3-3.5M7 20l3-3.5M17 20V4m0 0-3 3.5M17 4l3 3.5"/>',
    strokeWidth: 2,
  );
  static const barcode = AppIconData(
    '<path d="M3 7V5a2 2 0 0 1 2-2h2M17 3h2a2 2 0 0 1 2 2v2M21 17v2a2 2 0 0 1-2 2'
    'h-2M7 21H5a2 2 0 0 1-2-2v-2M7 8v8M11 8v8M15 8v8"/>',
  );
  static const chevronRight = AppIconData(
    '<path d="m10 6 6 6-6 6"/>',
    strokeWidth: 2,
  );
  static const chevronLeft = AppIconData(
    '<path d="m14 6-6 6 6 6"/>',
    strokeWidth: 2.2,
  );
  static const check = AppIconData(
    '<path d="M20 6 9 17l-5-5"/>',
    strokeWidth: 2.3,
  );
  static const plus = AppIconData(
    '<path d="M12 5v14M5 12h14"/>',
    strokeWidth: 2,
  );
  static const alert = AppIconData(
    '<path d="M12 8v5M12 16.5v.5"/><circle cx="12" cy="12" r="9"/>',
    strokeWidth: 2,
  );
  static const info = AppIconData(
    '<path d="M12 17v-6M12 8v.5"/><circle cx="12" cy="12" r="9"/>',
    strokeWidth: 2,
  );
  static const clock = AppIconData(
    '<circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 2"/>',
  );
  static const image = AppIconData(
    '<rect x="3" y="4" width="18" height="16" rx="2"/>'
    '<circle cx="9" cy="10" r="2"/><path d="m4 18 5-4 4 3 3-2 4 3"/>',
    strokeWidth: 1.7,
  );
  static const grid = AppIconData(
    '<rect x="3" y="3" width="7" height="7" rx="1"/>'
    '<rect x="14" y="3" width="7" height="7" rx="1"/>'
    '<rect x="3" y="14" width="7" height="7" rx="1"/>'
    '<rect x="14" y="14" width="7" height="7" rx="1"/>',
  );
  static const list = AppIconData(
    '<path d="M4 6h16M4 12h16M4 18h16"/>',
  );
  static const close = AppIconData(
    '<path d="M18 6 6 18M6 6l12 12"/>',
    strokeWidth: 2,
  );
  static const trash = AppIconData(
    '<path d="M4 7h16M10 11v6M14 11v6M6 7l1 13h10l1-13M9 7V4h6v3"/>',
    strokeWidth: 1.8,
  );
  static const star = AppIconData(
    '<path d="m12 3.5 2.6 5.6 6 .8-4.4 4.2 1.1 6-5.3-2.9-5.3 2.9 1.1-6L3.4 9.9l6-.8Z"/>',
    strokeWidth: 1.6,
  );
  static const flash = AppIconData(
    '<path d="M13 2 4 14h7l-1 8 9-12h-7l1-8Z"/>',
    strokeWidth: 1.8,
  );
  static const camera = AppIconData(
    '<path d="M4 7h3l2-3h6l2 3h3v13H4z"/><circle cx="12" cy="13" r="4"/>',
    strokeWidth: 1.8,
  );
  static const keyboard = AppIconData(
    '<rect x="2.5" y="6" width="19" height="12" rx="2"/>'
    '<path d="M6.5 10h.01M10 10h.01M13.5 10h.01M17 10h.01M8 14h8"/>',
    strokeWidth: 1.8,
  );
  static const refresh = AppIconData(
    '<path d="M21 12a9 9 0 1 1-6.2-8.6"/><path d="M21 3v5h-5"/>',
    strokeWidth: 2,
  );
  static const spinnerArc = AppIconData(
    '<path d="M21 12a9 9 0 1 1-6.2-8.6"/>',
    strokeWidth: 2.4,
  );

  // Bottom navigation
  static const navLibrary = AppIconData(
    '<rect x="3" y="4" width="5" height="16" rx="1"/>'
    '<rect x="10" y="4" width="5" height="16" rx="1"/>'
    '<path d="m17.4 5.6 3.3 14.1"/>',
    strokeWidth: 1.8,
  );
  static const navReading = AppIconData(
    '<path d="M12 7c-2-1.6-4.4-2.2-8-2v13c3.6-.2 6 .4 8 2 2-1.6 4.4-2.2 8-2V5'
    'c-3.6-.2-6 .4-8 2Z"/><path d="M12 7v13"/>',
    strokeWidth: 1.8,
  );
  static const navWishlist = AppIconData(
    '<path d="M6 4h12v17l-6-4.2L6 21Z"/>',
    strokeWidth: 1.8,
  );
  static const navProfile = AppIconData(
    '<circle cx="12" cy="8.5" r="3.6"/>'
    '<path d="M5 20c1.2-3.6 3.8-5.4 7-5.4s5.8 1.8 7 5.4"/>',
    strokeWidth: 1.8,
  );
}
