/// Everything the statistics screen shows. Every field is computed from stored
/// reading entries and the collection — nothing here is a constant.
class ReadingStatistics {
  const ReadingStatistics({
    required this.year,
    required this.rangeStart,
    required this.rangeEnd,
    required this.booksReadThisYear,
    required this.pagesReadThisYear,
    required this.currentlyReading,
    required this.unreadCount,
    required this.averageRating,
    required this.booksPerMonth,
    required this.pagesPerMonth,
    required this.byLanguage,
    required this.byGenre,
    required this.byAuthor,
  });

  static final empty = ReadingStatistics(
    year: DateTime.now().year,
    rangeStart: DateTime(DateTime.now().year),
    rangeEnd: DateTime.now(),
    booksReadThisYear: 0,
    pagesReadThisYear: 0,
    currentlyReading: 0,
    unreadCount: 0,
    averageRating: null,
    booksPerMonth: List.filled(12, 0),
    pagesPerMonth: List.filled(12, 0),
    byLanguage: const [],
    byGenre: const [],
    byAuthor: const [],
  );

  final int year;
  final DateTime rangeStart;
  final DateTime rangeEnd;

  final int booksReadThisYear;
  final int pagesReadThisYear;
  final int currentlyReading;
  final int unreadCount;
  final double? averageRating;

  /// Twelve entries, January first.
  final List<int> booksPerMonth;
  final List<int> pagesPerMonth;

  final List<CountSlice> byLanguage;
  final List<CountSlice> byGenre;
  final List<CountSlice> byAuthor;

  bool get hasReadAnything => booksReadThisYear > 0;

  int get bestMonthIndex {
    if (booksPerMonth.every((v) => v == 0)) return -1;
    var best = 0;
    for (var i = 1; i < booksPerMonth.length; i++) {
      if (booksPerMonth[i] > booksPerMonth[best]) best = i;
    }
    return best;
  }

  int get maxBooksInMonth =>
      booksPerMonth.fold(0, (a, b) => b > a ? b : a);
}

/// One labelled count in a breakdown, with its share of the total.
class CountSlice {
  const CountSlice({
    required this.label,
    required this.count,
    required this.percent,
  });

  final String label;
  final int count;
  final double percent;
}
