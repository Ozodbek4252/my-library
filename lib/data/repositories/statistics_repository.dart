import 'package:drift/drift.dart';

import '../../domain/models/enums.dart';
import '../../domain/models/statistics.dart';
import '../local/database.dart';

/// Derives the statistics screen from what is actually stored. Reads come from
/// the reading-entry log, so re-reads count and a book finished twice in a year
/// counts twice.
class StatisticsRepository {
  StatisticsRepository(this._db);

  final AppDatabase _db;

  Stream<ReadingStatistics> watchStatistics({int? year}) {
    return _db
        .customSelect(
          'SELECT 1',
          readsFrom: {_db.readingEntries, _db.works, _db.editions, _db.copies},
        )
        .watch()
        .asyncMap((_) => statistics(year: year));
  }

  Future<ReadingStatistics> statistics({int? year}) async {
    final now = DateTime.now();
    final targetYear = year ?? now.year;
    final start = DateTime(targetYear);
    final end = DateTime(targetYear + 1);

    final entryRows = await (_db.select(_db.readingEntries).join([
      innerJoin(_db.works, _db.works.id.equalsExp(_db.readingEntries.workId)),
      leftOuterJoin(
        _db.editions,
        _db.editions.id.equalsExp(_db.works.primaryEditionId),
      ),
    ])
          ..where(
            _db.readingEntries.finishDate.isBiggerOrEqualValue(start) &
                _db.readingEntries.finishDate.isSmallerThanValue(end) &
                _db.readingEntries.finished.equals(true),
          ))
        .get();

    final booksPerMonth = List.filled(12, 0);
    final pagesPerMonth = List.filled(12, 0);
    var pagesTotal = 0;
    var ratingSum = 0.0;
    var ratingCount = 0;

    final languageCounts = <String, int>{};
    final genreCounts = <String, int>{};
    final authorCounts = <String, int>{};

    for (final row in entryRows) {
      final entry = row.readTable(_db.readingEntries);
      final work = row.readTable(_db.works);
      final edition = row.readTableOrNull(_db.editions);

      final month = entry.finishDate.month - 1;
      booksPerMonth[month]++;

      final pages = entry.pagesRead > 0
          ? entry.pagesRead
          : (edition?.pageCount ?? 0);
      pagesPerMonth[month] += pages;
      pagesTotal += pages;

      final rating = entry.rating ?? work.rating;
      if (rating != null && rating > 0) {
        ratingSum += rating;
        ratingCount++;
      }

      final language = edition?.language;
      if (language != null && language.isNotEmpty) {
        languageCounts[language] = (languageCounts[language] ?? 0) + 1;
      }
      for (final genre in work.genres) {
        genreCounts[genre] = (genreCounts[genre] ?? 0) + 1;
      }
      for (final author in work.authors) {
        authorCounts[author] = (authorCounts[author] ?? 0) + 1;
      }
    }

    // "Currently reading" and "Unread" describe the shelves right now, not the
    // selected year.
    final statusRows = await _db.select(_db.works).get();
    var reading = 0;
    var unread = 0;

    // Pages read in books that are still open. Someone 95 pages into a book
    // has read 95 pages, whether or not they ever finish it — and the screen
    // says "pages read", not "pages in finished books".
    //
    // Only books still in progress are added: a finished one is already
    // counted through its entry above, so counting its current page again
    // would double it.
    var pagesInProgress = 0;

    for (final work in statusRows) {
      switch (ReadingStatus.fromName(work.readingStatus)) {
        case ReadingStatus.reading:
        case ReadingStatus.rereading:
          reading++;
          // Attributed to the year the reading started, so a book carried over
          // from last year does not land all its pages in this one.
          final started = work.startDate;
          if (started != null &&
              !started.isBefore(start) &&
              started.isBefore(end)) {
            pagesInProgress += work.currentPage;
          }
        case ReadingStatus.unread:
          unread++;
        default:
          break;
      }
    }

    return ReadingStatistics(
      year: targetYear,
      rangeStart: start,
      rangeEnd: targetYear == now.year ? now : DateTime(targetYear, 12, 31),
      booksReadThisYear: entryRows.length,
      pagesReadThisYear: pagesTotal + pagesInProgress,
      currentlyReading: reading,
      unreadCount: unread,
      averageRating: ratingCount == 0 ? null : ratingSum / ratingCount,
      booksPerMonth: booksPerMonth,
      pagesPerMonth: pagesPerMonth,
      byLanguage: _slices(languageCounts, limit: 4, groupRest: true),
      byGenre: _slices(genreCounts, limit: 6),
      byAuthor: _slices(authorCounts, limit: 5),
    );
  }

  /// Sorts a tally into display order, optionally folding the tail into
  /// "Other" so a stacked bar never turns into confetti.
  static List<CountSlice> _slices(
    Map<String, int> counts, {
    required int limit,
    bool groupRest = false,
  }) {
    if (counts.isEmpty) return const [];
    final total = counts.values.fold(0, (a, b) => a + b);
    final sorted = counts.entries.toList()
      ..sort((a, b) {
        final byCount = b.value.compareTo(a.value);
        return byCount != 0 ? byCount : a.key.compareTo(b.key);
      });

    final head = sorted.take(groupRest ? limit - 1 : limit).toList();
    final slices = [
      for (final e in head)
        CountSlice(
          label: e.key,
          count: e.value,
          percent: total == 0 ? 0 : e.value / total * 100,
        ),
    ];

    if (groupRest && sorted.length > head.length) {
      final rest = sorted.skip(head.length).fold(0, (sum, e) => sum + e.value);
      if (rest > 0) {
        slices.add(
          CountSlice(
            // Named in the UI, where the interface language is known.
            label: 'Other',
            isOther: true,
            count: rest,
            percent: total == 0 ? 0 : rest / total * 100,
          ),
        );
      }
    }
    return slices;
  }
}
