import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import '../theme/typography.dart';

/// A book cover.
///
/// Real artwork is used when the edition has a cover URL; otherwise the
/// typographic placeholder from the design stands in — same aspect ratio,
/// radius and shadow, so a shelf of mixed books still lines up.
class BookCover extends StatelessWidget {
  const BookCover({
    super.key,
    required this.title,
    this.author,
    this.colorIndex = 0,
    this.coverUrl,
    this.width,
    this.height,
    this.aspectRatio = 2 / 3,
    this.radius = AppRadius.cover,
    this.shadows = AppShadows.coverGrid,
    this.titleSize,
    this.authorSize,
    this.spineWidth,
    this.showText = true,
    this.border,
    this.overlay,
    this.titleRightPadding,
  });

  final String title;
  final String? author;
  final int colorIndex;
  final String? coverUrl;

  final double? width;
  final double? height;
  final double aspectRatio;
  final double radius;
  final List<BoxShadow> shadows;

  final double? titleSize;
  final double? authorSize;
  final double? spineWidth;
  final bool showText;
  final BoxBorder? border;

  /// Reserves room for a status badge in the top-right corner so a long title
  /// never runs underneath it.
  final double? titleRightPadding;

  /// Drawn on top of the cover — the status badge in the library grid.
  final Widget? overlay;

  (Color, Color) get _palette =>
      AppColors.coverPalette[colorIndex.abs() % AppColors.coverPalette.length];

  @override
  Widget build(BuildContext context) {
    Widget cover = LayoutBuilder(
      builder: (context, constraints) {
        final w = width ??
            (constraints.hasBoundedWidth ? constraints.maxWidth : 100.0);
        return _CoverSurface(
          width: w,
          title: title,
          author: author,
          palette: _palette,
          coverUrl: coverUrl,
          radius: radius,
          titleSize: titleSize ?? (w * .145).clamp(7.0, 20.0),
          authorSize: authorSize ?? (w * .065).clamp(5.5, 8.0),
          spineWidth: spineWidth ?? (w * .052).clamp(2.0, 7.0),
          showText: showText,
          overlay: overlay,
          titleRightPadding: titleRightPadding,
        );
      },
    );

    if (width != null && height != null) {
      cover = SizedBox(width: width, height: height, child: cover);
    } else {
      cover = AspectRatio(aspectRatio: aspectRatio, child: cover);
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: shadows,
        border: border,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: cover,
      ),
    );
  }
}

class _CoverSurface extends StatelessWidget {
  const _CoverSurface({
    required this.width,
    required this.title,
    required this.author,
    required this.palette,
    required this.coverUrl,
    required this.radius,
    required this.titleSize,
    required this.authorSize,
    required this.spineWidth,
    required this.showText,
    required this.overlay,
    required this.titleRightPadding,
  });

  final double width;
  final String title;
  final String? author;
  final (Color, Color) palette;
  final String? coverUrl;
  final double radius;
  final double titleSize;
  final double authorSize;
  final double spineWidth;
  final bool showText;
  final Widget? overlay;
  final double? titleRightPadding;

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = palette;
    final url = coverUrl;

    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(color: background),
        if (url != null && url.isNotEmpty)
          CachedNetworkImage(
            imageUrl: url,
            fit: BoxFit.cover,
            fadeInDuration: const Duration(milliseconds: 180),
            // A missing or unreachable cover falls back to the placeholder
            // rather than to a broken-image icon.
            placeholder: (context, _) => _placeholder(foreground),
            errorWidget: (context, _, _) => _placeholder(foreground),
          )
        else
          _placeholder(foreground),
        ?overlay,
      ],
    );
  }

  /// The status badge leaves a narrow column for the title, and a single long
  /// word in that column would otherwise be broken mid-word ("Atomi / c").
  /// Shrinking the type just enough for the longest word to fit keeps titles
  /// readable at every cover size without changing the layout.
  double _fittedTitleSize(double available) {
    if (!available.isFinite || available <= 0) return titleSize;

    final longest = title
        .split(RegExp(r'\s+'))
        .fold<String>('', (a, b) => b.length > a.length ? b : a);
    if (longest.isEmpty) return titleSize;

    final painter = TextPainter(
      text: TextSpan(
        text: longest,
        style: AppText.coverTitle(titleSize, const Color(0xFF000000)),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout();

    if (painter.width <= available) return titleSize;
    // Never shrink below the point where the text stops being legible; a word
    // longer than that still ellipsises rather than breaking.
    return (titleSize * available / painter.width).clamp(titleSize * .62, titleSize);
  }

  Widget _placeholder(Color foreground) {
    final leftPad = spineWidth + width * .075;
    return Stack(
      fit: StackFit.expand,
      children: [
        // Sheen, so a flat colour still reads as a physical object.
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-.9, -1),
              end: Alignment(.9, 1),
              colors: [Color(0x21FFFFFF), Color(0x24000000), Color(0x3D000000)],
              stops: [0, .62, 1],
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: spineWidth,
            child: const ColoredBox(color: Color(0x47000000)),
          ),
        ),
        if (showText)
          Padding(
            padding: EdgeInsets.fromLTRB(
              leftPad,
              width * .105,
              titleRightPadding ?? width * .085,
              width * .075,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: LayoutBuilder(
                    builder: (context, constraints) => Text(
                      title,
                      maxLines: titleSize < 9 ? 2 : 4,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.coverTitle(
                        _fittedTitleSize(constraints.maxWidth),
                        foreground,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                if (author != null && author!.isNotEmpty && authorSize >= 6)
                  Text(
                    author!.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.coverAuthor(
                      authorSize,
                      foreground.withValues(alpha: .82),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
