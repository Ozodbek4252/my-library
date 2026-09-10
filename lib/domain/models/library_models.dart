import '../../core/utils/formatting.dart';
import '../../data/local/database.dart';
import 'enums.dart';

/// An edition together with the user's copies of it.
class EditionWithCopies {
  const EditionWithCopies({required this.edition, required this.copies});

  final Edition edition;
  final List<Copy> copies;

  bool get isOwned => copies.any((c) => c.ownership == Ownership.owned.name);
  int get ownedCount =>
      copies.where((c) => c.ownership == Ownership.owned.name).length;

  /// "English · Penguin · Paperback"
  String get descriptor => Fmt.dotted([
        edition.language,
        edition.publisher,
        edition.format,
      ]);

  /// "2013 · 336 pp · Study, Shelf 1"
  String detailLine({String? location}) => Fmt.dotted([
        edition.publishedYear?.toString(),
        edition.pageCount == null ? null : '${edition.pageCount} pp',
        location,
      ]);
}

/// One row in the library grid or list: a work plus the edition shown for it.
class LibraryEntry {
  const LibraryEntry({
    required this.work,
    required this.edition,
    required this.editionCount,
    required this.copyCount,
    required this.addedDate,
  });

  final Work work;
  /// The edition whose cover and metadata represent the work in lists.
  /// Null only when a work exists with no edition rows at all.
  final Edition? edition;
  final int editionCount;
  final int copyCount;
  final DateTime addedDate;

  String get title => work.title;
  String get authorLine => Fmt.authors(work.authors);
  ReadingStatus get status => ReadingStatus.fromName(work.readingStatus);

  /// "English · Penguin · Paperback · 2013"
  String get metaLine => Fmt.dotted([
        edition?.language,
        edition?.publisher,
        edition?.format,
        edition?.publishedYear?.toString(),
      ]);

  int? get pageCount => edition?.pageCount;

  double get progress {
    final total = edition?.pageCount ?? 0;
    if (total <= 0) return 0;
    return (work.currentPage / total).clamp(0.0, 1.0);
  }
}

/// Everything the book details screen needs, resolved in one query pass.
class BookDetails {
  const BookDetails({
    required this.work,
    required this.editions,
    required this.primaryEditionId,
    required this.tagsByCopy,
    required this.photosByCopy,
    required this.wishlistItem,
    required this.readingEntries,
  });

  final Work work;
  final List<EditionWithCopies> editions;
  final String? primaryEditionId;
  final Map<String, List<Tag>> tagsByCopy;
  final Map<String, List<CopyPhoto>> photosByCopy;
  final WishlistItem? wishlistItem;
  final List<ReadingEntry> readingEntries;

  ReadingStatus get status => ReadingStatus.fromName(work.readingStatus);

  EditionWithCopies? get primaryEdition {
    if (editions.isEmpty) return null;
    for (final e in editions) {
      if (e.edition.id == primaryEditionId) return e;
    }
    return editions.first;
  }

  Copy? get primaryCopy {
    final copies = primaryEdition?.copies ?? const <Copy>[];
    return copies.isEmpty ? null : copies.first;
  }

  int get totalCopies =>
      editions.fold(0, (sum, e) => sum + e.copies.length);

  bool get isOwned => editions.any((e) => e.isOwned);

  Ownership get ownership {
    if (isOwned) return Ownership.owned;
    if (wishlistItem != null) return Ownership.wishlist;
    final all = editions.expand((e) => e.copies);
    if (all.any((c) => c.ownership == Ownership.previouslyOwned.name)) {
      return Ownership.previouslyOwned;
    }
    return Ownership.wishlist;
  }

  int? get pageCount => primaryEdition?.edition.pageCount;

  double get progress {
    final total = pageCount ?? 0;
    if (total <= 0) return 0;
    return (work.currentPage / total).clamp(0.0, 1.0);
  }

  List<Tag> tagsFor(String copyId) => tagsByCopy[copyId] ?? const [];
  List<CopyPhoto> photosFor(String copyId) => photosByCopy[copyId] ?? const [];
}

/// A wishlist row joined with the work it wants.
class WishlistEntry {
  const WishlistEntry({
    required this.item,
    required this.work,
    required this.desiredEditionColor,
  });

  final WishlistItem item;
  final Work work;
  final int desiredEditionColor;

  Priority get priority => Priority.fromName(item.priority);

  /// "English · Hardcover · Norton"
  String get wantLine => Fmt.dotted([
        item.desiredLanguage,
        item.desiredFormat,
        item.desiredEdition,
      ]);
}

/// A book being read right now, with its progress resolved.
class ReadingEntryView {
  const ReadingEntryView({
    required this.work,
    required this.edition,
    required this.startedAt,
  });

  final Work work;
  final Edition? edition;
  final DateTime? startedAt;

  int get totalPages => edition?.pageCount ?? 0;
  int get currentPage => work.currentPage.clamp(0, totalPages == 0 ? work.currentPage : totalPages);
  double get progress => totalPages <= 0 ? 0 : (currentPage / totalPages).clamp(0.0, 1.0);
  int get percent => (progress * 100).round();
  int get pagesLeft => (totalPages - currentPage).clamp(0, totalPages);

  /// "Started 14 Aug · 12 days in"
  String get sinceLine {
    if (startedAt == null) return 'Not started yet';
    final days = DateTime.now().difference(startedAt!).inDays;
    final started = 'Started ${Fmt.shortDate(startedAt)}';
    if (days <= 0) return '$started · today';
    return '$started · ${days == 1 ? '1 day' : '$days days'} in';
  }
}

/// A finished read, shown in the reading history grouped by month.
class HistoryEntry {
  const HistoryEntry({
    required this.entry,
    required this.work,
    required this.edition,
  });

  final ReadingEntry entry;
  final Work work;
  final Edition? edition;

  /// "Finished 2 Sep · 3 days"
  String get datesLine {
    final finished = 'Finished ${Fmt.shortDate(entry.finishDate)}';
    if (entry.startDate == null) return finished;
    return '$finished · ${Fmt.durationDays(entry.startDate!, entry.finishDate)}';
  }
}
