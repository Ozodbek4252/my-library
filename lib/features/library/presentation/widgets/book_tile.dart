import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/utils/formatting.dart';
import '../../../../core/widgets/app_icons.dart';
import '../../../../core/widgets/book_cover.dart';
import '../../../../core/widgets/pills.dart';
import '../../../../domain/models/enums.dart';
import '../../../../domain/models/library_models.dart';

/// The status marker in the top-right of a grid cover: a "Reading" pill, a
/// check for a finished book, nothing otherwise.
class CoverStatusBadge extends StatelessWidget {
  const CoverStatusBadge({super.key, required this.status});

  final ReadingStatus status;

  /// Room the cover title must leave for the badge in the top-right corner.
  static double titleRightPaddingFor(ReadingStatus status) => switch (status) {
        ReadingStatus.reading || ReadingStatus.rereading => 54,
        ReadingStatus.read => 30,
        _ => 9,
      };

  @override
  Widget build(BuildContext context) {
    if (status == ReadingStatus.read) {
      return Positioned(
        top: 6,
        right: 6,
        child: Container(
          width: 17,
          height: 17,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Color(0xEBF7F3EB),
            shape: BoxShape.circle,
          ),
          child: const AppIcon(
            AppIcons.check,
            size: 10,
            color: AppColors.successFg,
            strokeWidth: 3,
          ),
        ),
      );
    }

    if (status == ReadingStatus.reading || status == ReadingStatus.rereading) {
      return Positioned(
        top: 6,
        right: 6,
        child: Container(
          height: 17,
          padding: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: AppColors.progressBg,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            widthFactor: 1,
            child: Text(
              status == ReadingStatus.reading ? 'Reading' : 'Re-read',
              style: AppText.sans(
                size: 8.5,
                weight: 700,
                letterSpacing: .04,
                color: AppColors.progressFg,
              ),
            ),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

/// One cell of the library grid: cover, badge, and an optional caption.
class BookGridCell extends StatelessWidget {
  const BookGridCell({
    super.key,
    required this.entry,
    required this.onTap,
    this.onLongPress,
    this.showCaption = true,
  });

  final LibraryEntry entry;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final bool showCaption;

  @override
  Widget build(BuildContext context) {
    final status = entry.status;
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      behavior: HitTestBehavior.opaque,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: BookCover(
              title: entry.title,
              author: Fmt.surname(entry.work.authors),
              colorIndex: entry.edition?.coverColorIndex ?? 0,
              coverUrl: entry.edition?.coverUrl,
              titleSize: 12,
              authorSize: 6.5,
              spineWidth: 5,
              titleRightPadding: CoverStatusBadge.titleRightPaddingFor(status),
              overlay: CoverStatusBadge(status: status),
            ),
          ),
          if (showCaption) ...[
            const SizedBox(height: 7),
            Text(
              entry.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.sans(
                size: 11.5,
                weight: 500,
                height: 1.25,
                color: AppColors.ink2,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              entry.authorLine,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.sans(size: 10.5, color: AppColors.muted2),
            ),
          ],
        ],
      ),
    );
  }
}

/// A library list row — also used for search results.
class BookListRow extends StatelessWidget {
  const BookListRow({
    super.key,
    required this.entry,
    required this.onTap,
    this.onLongPress,
    this.showDivider = true,
  });

  final LibraryEntry entry;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          border: showDivider
              ? const Border(bottom: BorderSide(color: AppColors.rule))
              : null,
        ),
        child: Row(
          children: [
            BookCover(
              title: entry.title,
              colorIndex: entry.edition?.coverColorIndex ?? 0,
              coverUrl: entry.edition?.coverUrl,
              width: 38,
              height: 57,
              radius: AppRadius.thumb,
              shadows: AppShadows.thumb,
              titleSize: 7.5,
              authorSize: 0,
              spineWidth: 3,
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.listPrimary,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    entry.authorLine,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.listSecondary,
                  ),
                  if (entry.metaLine.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      entry.metaLine,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.metadata,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 10),
            AppPill.status(entry.status),
          ],
        ),
      ),
    );
  }
}
