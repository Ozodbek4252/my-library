import 'package:drift/drift.dart';

import '../../core/utils/isbn.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/library_models.dart';
import '../local/database.dart';
import '../metadata/book_metadata.dart';
import 'collection_mutations.dart';
import 'library_query.dart';

/// Reads and writes the user's collection. Every UI screen goes through this
/// class; no widget touches the database directly.
class LibraryRepository {
  LibraryRepository(this._db);

  final AppDatabase _db;

  static const pageSize = 60;

  // ---------------------------------------------------------------- reading

  /// The library grid/list. Filtering, sorting and paging all happen in SQL so
  /// a large collection never loads into memory at once.
  Stream<List<LibraryEntry>> watchLibrary(
    LibraryQuery query, {
    int limit = pageSize,
    int offset = 0,
  }) {
    final select = _libraryStatement(query)
      ..limit(limit, offset: offset);
    return select.watch().asyncMap(_attachCounts);
  }

  Stream<int> watchLibraryCount(LibraryQuery query) {
    final countExp = _db.works.id.count();
    final statement = _db.selectOnly(_db.works)..addColumns([countExp]);
    final predicate = _predicate(query);
    if (predicate != null) statement.where(predicate);
    return statement.map((row) => row.read(countExp) ?? 0).watchSingle();
  }

  /// Total works on the owned shelf, ignoring search and filters — the "of 214"
  /// in the count line and the header subtitle.
  Stream<int> watchTotalOwned() =>
      watchLibraryCount(const LibraryQuery());

  Stream<LibraryStats> watchLibraryStats() {
    final query = _db.select(_db.works).join([
      innerJoin(_db.editions, _db.editions.workId.equalsExp(_db.works.id)),
      innerJoin(_db.copies, _db.copies.editionId.equalsExp(_db.editions.id)),
    ])
      ..where(_db.copies.ownership.equals(Ownership.owned.name))
      ..groupBy([_db.works.id]);

    return query.watch().map((rows) {
      final works = rows.map((r) => r.readTable(_db.works)).toList();
      var unread = 0, reading = 0, read = 0;
      for (final w in works) {
        switch (ReadingStatus.fromName(w.readingStatus)) {
          case ReadingStatus.unread:
            unread++;
          case ReadingStatus.reading:
          case ReadingStatus.rereading:
            reading++;
          case ReadingStatus.read:
            read++;
          case ReadingStatus.dnf:
            break;
        }
      }
      return LibraryStats(
        total: works.length,
        unread: unread,
        reading: reading,
        read: read,
      );
    });
  }

  /// Every distinct value present in the collection for a filter group, so the
  /// filter sheet only ever offers options that would return something.
  Future<Map<FilterGroup, List<String>>> filterOptions() async {
    Future<List<String>> distinctEdition(GeneratedColumn<String> column) async {
      final rows = await _db
          .customSelect(
            'SELECT DISTINCT ${column.name} AS v FROM editions '
            "WHERE ${column.name} IS NOT NULL AND ${column.name} != '' "
            'ORDER BY v COLLATE NOCASE',
            readsFrom: {_db.editions},
          )
          .get();
      return rows.map((r) => r.read<String>('v')).toList();
    }

    Future<List<String>> distinctList(String column) async {
      final rows = await _db
          .customSelect(
            "SELECT DISTINCT $column AS v FROM works WHERE $column != ''",
            readsFrom: {_db.works},
          )
          .get();
      final values = <String>{};
      for (final r in rows) {
        values.addAll(r.read<String>('v').split('|').where((e) => e.isNotEmpty));
      }
      final sorted = values.toList()..sort();
      return sorted;
    }

    final results = await Future.wait([
      distinctList('genres'),
      distinctList('authors'),
      distinctEdition(_db.editions.language),
      distinctEdition(_db.editions.format),
      distinctEdition(_db.editions.publisher),
    ]);

    final series = await _db
        .customSelect(
          'SELECT DISTINCT series_name AS v FROM works '
          "WHERE series_name IS NOT NULL AND series_name != '' ORDER BY v",
          readsFrom: {_db.works},
        )
        .get();

    return {
      FilterGroup.status: ReadingStatus.values.map((e) => e.label).toList(),
      FilterGroup.language: results[2],
      FilterGroup.genre: results[0],
      FilterGroup.format: results[3],
      FilterGroup.publisher: results[4],
      FilterGroup.author: results[1],
      FilterGroup.series: series.map((r) => r.read<String>('v')).toList(),
    };
  }

  Stream<BookDetails?> watchBookDetails(String workId) {
    // Re-resolve whenever anything the screen shows changes.
    return _db
        .customSelect(
          'SELECT 1',
          readsFrom: {
            _db.works,
            _db.editions,
            _db.copies,
            _db.copyTags,
            _db.tags,
            _db.copyPhotos,
            _db.wishlistItems,
            _db.readingEntries,
          },
        )
        .watch()
        .asyncMap((_) => bookDetails(workId));
  }

  Future<BookDetails?> bookDetails(String workId) async {
    final work = await (_db.select(_db.works)..where((w) => w.id.equals(workId)))
        .getSingleOrNull();
    if (work == null) return null;

    final editions = await (_db.select(_db.editions)
          ..where((e) => e.workId.equals(workId))
          ..orderBy([(e) => OrderingTerm.asc(e.createdAt)]))
        .get();
    final editionIds = editions.map((e) => e.id).toList();

    final copies = editionIds.isEmpty
        ? <Copy>[]
        : await (_db.select(_db.copies)
              ..where((c) => c.editionId.isIn(editionIds))
              ..orderBy([(c) => OrderingTerm.asc(c.addedDate)]))
            .get();
    final copyIds = copies.map((c) => c.id).toList();

    final tagRows = copyIds.isEmpty
        ? <TypedResult>[]
        : await (_db.select(_db.copyTags).join([
            innerJoin(_db.tags, _db.tags.id.equalsExp(_db.copyTags.tagId)),
          ])..where(_db.copyTags.copyId.isIn(copyIds)))
            .get();
    final tagsByCopy = <String, List<Tag>>{};
    for (final row in tagRows) {
      final link = row.readTable(_db.copyTags);
      tagsByCopy.putIfAbsent(link.copyId, () => []).add(row.readTable(_db.tags));
    }

    final photos = copyIds.isEmpty
        ? <CopyPhoto>[]
        : await (_db.select(_db.copyPhotos)
              ..where((p) => p.copyId.isIn(copyIds))
              ..orderBy([(p) => OrderingTerm.asc(p.addedAt)]))
            .get();
    final photosByCopy = <String, List<CopyPhoto>>{};
    for (final p in photos) {
      photosByCopy.putIfAbsent(p.copyId, () => []).add(p);
    }

    final wish = await (_db.select(_db.wishlistItems)
          ..where((w) => w.workId.equals(workId)))
        .getSingleOrNull();

    final entries = await (_db.select(_db.readingEntries)
          ..where((e) => e.workId.equals(workId))
          ..orderBy([(e) => OrderingTerm.desc(e.finishDate)]))
        .get();

    return BookDetails(
      work: work,
      editions: [
        for (final e in editions)
          EditionWithCopies(
            edition: e,
            copies: copies.where((c) => c.editionId == e.id).toList(),
          ),
      ],
      primaryEditionId: work.primaryEditionId,
      tagsByCopy: tagsByCopy,
      photosByCopy: photosByCopy,
      wishlistItem: wish,
      readingEntries: entries,
    );
  }

  /// True when a record on the shelves is missing something a lookup could
  /// supply. Checked before reaching for the network so a complete book still
  /// resolves from the database alone, which is what keeps a scan fast.
  bool hasGaps(Work work, Edition edition) {
    bool blank(String? value) => value == null || value.isEmpty;

    final hasArtwork =
        !blank(edition.coverUrl) || !blank(edition.coverImagePath);

    return !hasArtwork ||
        blank(edition.isbn13) ||
        blank(edition.publisher) ||
        blank(edition.language) ||
        blank(edition.format) ||
        edition.pageCount == null ||
        edition.publishedYear == null ||
        blank(work.description) ||
        work.genres.isEmpty;
  }

  /// Fills only the blanks on a book already in the library.
  Future<EnrichmentResult> fillGaps({
    required String workId,
    required String editionId,
    required BookMetadata found,
  }) =>
      _db.fillGaps(workId: workId, editionId: editionId, found: found);

  /// Finds an edition of [workId] that is plainly the one just scanned, only
  /// recorded without its ISBN — a book typed in by hand, or moved over from
  /// the wishlist before it had one.
  ///
  /// Deliberately cautious. A candidate must carry no ISBN of its own, and
  /// nothing it does record may disagree with what was scanned: a Russian
  /// hardcover is not the English paperback in your hand, and merging them
  /// would be worse than leaving both alone. An ambiguous choice is no choice,
  /// so several candidates mean none.
  Future<Edition?> findMergeableEdition(
    String workId,
    BookMetadata found,
  ) async {
    final candidates = await (_db.select(_db.editions)
          ..where((e) =>
              e.workId.equals(workId) & e.isbn13.isNull() & e.isbn10.isNull()))
        .get();
    if (candidates.length != 1) return null;

    final edition = candidates.single;

    bool conflicts<T>(T? stored, T? scanned) {
      if (stored == null || scanned == null) return false;
      if (stored is String && scanned is String) {
        return stored.trim().toLowerCase() != scanned.trim().toLowerCase();
      }
      return stored != scanned;
    }

    final disagrees = conflicts(edition.publisher, found.publisher) ||
        conflicts(edition.language, found.language) ||
        conflicts(edition.format, found.format) ||
        conflicts(edition.publishedYear, found.publishedYear) ||
        conflicts(edition.pageCount, found.pageCount);

    return disagrees ? null : edition;
  }

  Future<Edition?> editionById(String id) =>
      (_db.select(_db.editions)..where((e) => e.id.equals(id)))
          .getSingleOrNull();

  Future<Work?> workById(String id) =>
      (_db.select(_db.works)..where((w) => w.id.equals(id))).getSingleOrNull();

  // -------------------------------------------------------------- searching

  /// An edition is identified by its ISBN. Both the 10- and 13-digit forms are
  /// checked so a scan matches however the row was originally saved.
  Future<Edition?> findEditionByIsbn(String rawIsbn) async {
    final isbn13 = Isbn.to13(rawIsbn) ?? Isbn.normalize(rawIsbn);
    final isbn10 = Isbn.to10(rawIsbn);
    return (_db.select(_db.editions)
          ..where((e) {
            var predicate = e.isbn13.equals(isbn13);
            if (isbn10 != null) predicate = predicate | e.isbn10.equals(isbn10);
            return predicate;
          })
          ..limit(1))
        .getSingleOrNull();
  }

  /// Same work, different edition: matched on normalised title + first author.
  /// Title alone is never enough — different books share titles.
  Future<Work?> findWorkByTitleAuthor(String title, List<String> authors) async {
    final normTitle = _normalizeText(title);
    if (normTitle.isEmpty) return null;
    final normAuthor = authors.isEmpty ? '' : _normalizeText(authors.first);

    final candidates = await (_db.select(_db.works)
          ..where((w) => w.title.lower().like('%${normTitle.split(' ').first}%')))
        .get();

    for (final w in candidates) {
      if (_normalizeText(w.title) != normTitle) continue;
      if (normAuthor.isEmpty) return w;
      final match = w.authors.any((a) => _normalizeText(a) == normAuthor);
      if (match) return w;
    }
    return null;
  }

  static String _normalizeText(String value) => value
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9Ѐ-ӿ ]'), '')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();

  Future<List<RecentSearch>> recentSearches({int limit = 3}) =>
      (_db.select(_db.recentSearches)
            ..orderBy([(r) => OrderingTerm.desc(r.searchedAt)])
            ..limit(limit))
          .get();

  Future<void> recordSearch(String query, int resultCount) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;
    await _db.into(_db.recentSearches).insertOnConflictUpdate(
          RecentSearchesCompanion.insert(
            query: trimmed,
            searchedAt: DateTime.now(),
            resultCount: Value(resultCount),
          ),
        );
  }

  Future<void> clearRecentSearches() => _db.delete(_db.recentSearches).go();

  // ---------------------------------------------------------- query building

  JoinedSelectStatement<HasResultSet, dynamic> _libraryStatement(
    LibraryQuery query,
  ) {
    final statement = _db.select(_db.works).join([
      leftOuterJoin(
        _db.editions,
        _db.editions.id.equalsExp(_db.works.primaryEditionId),
      ),
    ]);

    final predicate = _predicate(query);
    if (predicate != null) statement.where(predicate);
    statement.orderBy(_ordering(query.sort));
    return statement;
  }

  Expression<bool>? _predicate(LibraryQuery query) {
    final parts = <Expression<bool>>[];

    if (query.ownership != null) {
      parts.add(_ownsCopyWith(query.ownership!));
    }

    final search = query.search.trim();
    if (search.isNotEmpty) parts.add(_searchPredicate(search));

    for (final entry in query.filters.entries) {
      if (entry.value.isEmpty) continue;
      final group = entry.key;
      final options = entry.value
          .map((value) => _filterPredicate(group, value))
          .toList();
      parts.add(options.reduce((a, b) => a | b));
    }

    if (parts.isEmpty) return null;
    return parts.reduce((a, b) => a & b);
  }

  /// EXISTS a copy of this work with the given ownership.
  Expression<bool> _ownsCopyWith(Ownership ownership) => existsQuery(
        _db.selectOnly(_db.copies)
          ..addColumns([_db.copies.id])
          ..join([
            innerJoin(
              _db.editions,
              _db.editions.id.equalsExp(_db.copies.editionId),
              useColumns: false,
            ),
          ])
          ..where(
            _db.editions.workId.equalsExp(_db.works.id) &
                _db.copies.ownership.equals(ownership.name),
          ),
      );

  Expression<bool> _searchPredicate(String search) {
    final like = '%${search.toLowerCase()}%';
    final isbnDigits = Isbn.normalize(search);

    var predicate = _db.works.title.lower().like(like) |
        _db.works.authors.lower().like(like) |
        _db.works.genres.lower().like(like) |
        _db.works.seriesName.lower().like(like);

    // Publisher and ISBN can match on any edition of the work, not just the
    // one displayed.
    var editionMatch = _db.editions.publisher.lower().like(like);
    if (isbnDigits.length >= 4) {
      final isbnLike = '%$isbnDigits%';
      editionMatch = editionMatch |
          _db.editions.isbn13.like(isbnLike) |
          _db.editions.isbn10.like(isbnLike);
    }
    predicate = predicate |
        existsQuery(
          _db.selectOnly(_db.editions)
            ..addColumns([_db.editions.id])
            ..where(_db.editions.workId.equalsExp(_db.works.id) & editionMatch),
        );

    // Tags live on copies.
    predicate = predicate |
        existsQuery(
          _db.selectOnly(_db.copyTags)
            ..addColumns([_db.copyTags.tagId])
            ..join([
              innerJoin(_db.tags, _db.tags.id.equalsExp(_db.copyTags.tagId),
                  useColumns: false),
              innerJoin(_db.copies, _db.copies.id.equalsExp(_db.copyTags.copyId),
                  useColumns: false),
              innerJoin(
                  _db.editions, _db.editions.id.equalsExp(_db.copies.editionId),
                  useColumns: false),
            ])
            ..where(
              _db.editions.workId.equalsExp(_db.works.id) &
                  _db.tags.name.lower().like(like),
            ),
        );

    return predicate;
  }

  Expression<bool> _filterPredicate(FilterGroup group, String value) {
    switch (group) {
      case FilterGroup.status:
        return _db.works.readingStatus
            .equals(ReadingStatus.fromLabel(value).name);
      case FilterGroup.series:
        return _db.works.seriesName.equals(value);
      case FilterGroup.genre:
        return _listContains(_db.works.genres, value);
      case FilterGroup.author:
        return _listContains(_db.works.authors, value);
      case FilterGroup.language:
        return _anyEdition(_db.editions.language.equals(value));
      case FilterGroup.format:
        return _anyEdition(_db.editions.format.equals(value));
      case FilterGroup.publisher:
        return _anyEdition(_db.editions.publisher.equals(value));
    }
  }

  /// Matches one entry of a `|`-separated list column without matching a
  /// value that merely contains it ("Fiction" must not match "Nonfiction").
  /// The stored value carries leading and trailing separators, so wrapping the
  /// needle the same way is enough.
  Expression<bool> _listContains(GeneratedColumn<String> column, String value) =>
      column.like('%|$value|%');

  Expression<bool> _anyEdition(Expression<bool> condition) => existsQuery(
        _db.selectOnly(_db.editions)
          ..addColumns([_db.editions.id])
          ..where(_db.editions.workId.equalsExp(_db.works.id) & condition),
      );

  List<OrderingTerm> _ordering(SortOption sort) => switch (sort) {
        SortOption.recentlyAdded => [
            OrderingTerm.desc(_db.works.createdAt),
            OrderingTerm.asc(_db.works.title),
          ],
        SortOption.title => [
            OrderingTerm(expression: _db.works.title, mode: OrderingMode.asc),
          ],
        SortOption.author => [
            OrderingTerm.asc(_db.works.authors),
            OrderingTerm.asc(_db.works.title),
          ],
        SortOption.pages => [
            OrderingTerm.desc(_db.editions.pageCount),
            OrderingTerm.asc(_db.works.title),
          ],
        SortOption.publicationDate => [
            OrderingTerm.desc(_db.editions.publishedYear),
            OrderingTerm.asc(_db.works.title),
          ],
        SortOption.rating => [
            OrderingTerm.desc(_db.works.rating),
            OrderingTerm.asc(_db.works.title),
          ],
      };

  /// Fills in edition and copy counts for the page of works just loaded.
  /// Restricted to the visible rows so this stays cheap on a large library.
  Future<List<LibraryEntry>> _attachCounts(List<TypedResult> rows) async {
    if (rows.isEmpty) return const [];
    final works = rows.map((r) => r.readTable(_db.works)).toList();
    final workIds = works.map((w) => w.id).toList();

    final editionCount = _db.editions.id.count();
    final copyCount = _db.copies.id.count();
    final addedAt = _db.copies.addedDate.min();

    final aggregate = await (_db.selectOnly(_db.editions)
          ..addColumns([_db.editions.workId, editionCount])
          ..where(_db.editions.workId.isIn(workIds))
          ..groupBy([_db.editions.workId]))
        .get();
    final editionsPerWork = {
      for (final row in aggregate)
        row.read(_db.editions.workId)!: row.read(editionCount) ?? 0,
    };

    final copyRows = await (_db.selectOnly(_db.copies)
          ..addColumns([_db.editions.workId, copyCount, addedAt])
          ..join([
            innerJoin(
              _db.editions,
              _db.editions.id.equalsExp(_db.copies.editionId),
              useColumns: false,
            ),
          ])
          ..where(_db.editions.workId.isIn(workIds))
          ..groupBy([_db.editions.workId]))
        .get();
    final copiesPerWork = {
      for (final row in copyRows)
        row.read(_db.editions.workId)!: (
          row.read(copyCount) ?? 0,
          row.read(addedAt),
        ),
    };

    return [
      for (final row in rows)
        () {
          final work = row.readTable(_db.works);
          final counts = copiesPerWork[work.id];
          return LibraryEntry(
            work: work,
            edition: row.readTableOrNull(_db.editions),
            editionCount: editionsPerWork[work.id] ?? 0,
            copyCount: counts?.$1 ?? 0,
            addedDate: counts?.$2 ?? work.createdAt,
          );
        }(),
    ];
  }
}

class LibraryStats {
  const LibraryStats({
    required this.total,
    required this.unread,
    required this.reading,
    required this.read,
  });

  static const empty = LibraryStats(total: 0, unread: 0, reading: 0, read: 0);

  final int total;
  final int unread;
  final int reading;
  final int read;
}
