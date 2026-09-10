import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_library/data/local/database.dart';
import 'package:my_library/data/metadata/local_catalog.dart';
import 'package:my_library/data/metadata/local_catalog_source.dart';
import 'package:my_library/data/repositories/collection_mutations.dart';
import 'package:my_library/data/repositories/library_query.dart';
import 'package:my_library/data/repositories/library_repository.dart';
import 'package:my_library/data/repositories/reading_repository.dart';
import 'package:my_library/data/repositories/scan_service.dart';
import 'package:my_library/data/repositories/statistics_repository.dart';
import 'package:my_library/data/repositories/wishlist_repository.dart';
import 'package:my_library/data/seed/seeder.dart';
import 'package:my_library/domain/models/book_draft.dart';
import 'package:my_library/domain/models/enums.dart';

void main() {
  late AppDatabase db;
  late LibraryRepository library;
  late WishlistRepository wishlist;
  late ReadingRepository reading;
  late ScanService scanner;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await db.ensureIndexes();
    library = LibraryRepository(db);
    wishlist = WishlistRepository(db);
    reading = ReadingRepository(db);
    scanner = ScanService(
      metadata: const LocalCatalogSource(),
      library: library,
      wishlist: wishlist,
    );
  });

  tearDown(() => db.close());

  Future<AddBookResult> addFromCatalog(
    String key, {
    ReadingStatus status = ReadingStatus.unread,
    String? workId,
  }) {
    final draft = localCatalog[key]!.toDraft()
      ..readingStatus = status
      ..workId = workId;
    return db.addBook(draft);
  }

  group('duplicate detection', () {
    test('the same ISBN twice is the same edition, not a new one', () async {
      final first = await addFromCatalog('1984_penguin');
      final result = await scanner.resolveIsbn('9780141036144');

      expect(result.verdict, ScanVerdict.ownedSameEdition);
      expect(result.matchedEdition?.id, first.editionId);
      expect(result.details?.work.id, first.workId);
    });

    test('a different edition of an owned book is offered, never rejected',
        () async {
      await addFromCatalog('1984_penguin');

      // The Penguin Clothbound printing: same work, different ISBN.
      final result = await scanner.resolveIsbn('9780241639382');

      expect(result.verdict, ScanVerdict.ownedOtherEdition);
      expect(result.details, isNotNull);
      expect(result.metadata.publisher, 'Penguin Clothbound Classics');
    });

    test('a Russian translation is the same work, not a duplicate', () async {
      final first = await addFromCatalog('1984_penguin');
      final result = await scanner.resolveIsbn('9785171472856');

      expect(result.verdict, ScanVerdict.ownedOtherEdition);
      expect(result.details?.work.id, first.workId);

      // Adding it attaches to the existing work rather than creating a second.
      final added = await db.addBook(result.toDraft());
      expect(added.workId, first.workId);
      expect(added.createdWork, isFalse);
      expect(added.createdEdition, isTrue);

      final details = await library.bookDetails(first.workId);
      expect(details!.editions, hasLength(2));
    });

    test('a book with an unrelated title is not in the library', () async {
      await addFromCatalog('1984_penguin');
      final result = await scanner.resolveIsbn('9781526624369');
      expect(result.verdict, ScanVerdict.notInLibrary);
      expect(result.details, isNull);
    });

    test('two different books sharing a title stay separate', () async {
      await db.addBook(
        BookDraft(
          title: 'Home',
          authors: ['Marilynne Robinson'],
          isbn13: '9781844083688',
        ),
      );

      final other = await library.findWorkByTitleAuthor('Home', ['Toni Morrison']);
      expect(other, isNull, reason: 'same title, different author');

      final same =
          await library.findWorkByTitleAuthor('home', ['marilynne robinson']);
      expect(same, isNotNull, reason: 'matching is case and spacing tolerant');
    });

    test('an invalid barcode is reported as unreadable', () async {
      expect(
        () => scanner.resolveBarcode('4006381333931'),
        throwsA(
          isA<ScanFailure>().having(
            (e) => e.kind,
            'kind',
            ScanFailureKind.invalidBarcode,
          ),
        ),
      );
    });

    test('an unknown ISBN is reported as not found', () async {
      expect(
        () => scanner.resolveIsbn('9780306406157'),
        throwsA(
          isA<ScanFailure>()
              .having((e) => e.kind, 'kind', ScanFailureKind.notFound),
        ),
      );
    });
  });

  group('copies', () {
    test('a second copy of one edition does not create a second edition',
        () async {
      final first = await addFromCatalog('meditations');
      await db.addCopyToEdition(
        first.editionId,
        CopyDraft(ownership: Ownership.owned, location: 'Office'),
      );

      final details = await library.bookDetails(first.workId);
      expect(details!.editions, hasLength(1));
      expect(details.editions.single.copies, hasLength(2));
      expect(details.totalCopies, 2);
    });

    test('removing one copy keeps the other editions of the work', () async {
      final penguin = await addFromCatalog('1984_penguin');
      final ast = await db.addBook(
        localCatalog['1984_ast']!.toDraft()..workId = penguin.workId,
      );

      final result = await db.removeCopy(penguin.copyId);

      expect(result.removedEdition, isTrue);
      expect(result.removedWork, isFalse);
      expect(result.remainingEditions, 1);
      expect(result.toastMessage, 'Copy removed · 1 edition left');

      final details = await library.bookDetails(penguin.workId);
      expect(details!.editions.single.edition.id, ast.editionId);
      // The display edition follows, so the library never points at a gap.
      expect(details.work.primaryEditionId, ast.editionId);
    });

    test('removing the last copy removes the book entirely', () async {
      final added = await addFromCatalog('circe');
      final result = await db.removeCopy(added.copyId);

      expect(result.removedWork, isTrue);
      expect(await library.bookDetails(added.workId), isNull);
    });
  });

  group('wishlist', () {
    test('adding a wishlisted book clears it from the wishlist', () async {
      final draft = localCatalog['piranesi']!.toDraft();
      await wishlist.add(draft: draft, priority: Priority.high);

      final work = await library.findWorkByTitleAuthor(
        draft.title,
        draft.authors,
      );
      expect(work, isNotNull);

      final result = await db.addBook(draft..workId = work!.id);
      expect(result.clearedWishlist, isTrue);
      expect(await wishlist.itemForWork(work.id), isNull);
    });

    test('a scan reports that the book is already wishlisted', () async {
      await wishlist.add(draft: localCatalog['piranesi']!.toDraft());
      final result = await scanner.resolveIsbn('9781526624369');

      expect(result.verdict, ScanVerdict.notInLibrary);
      expect(result.isWishlisted, isTrue);
    });

    test('removing a wanted book removes the placeholder work with it',
        () async {
      final id = await wishlist.add(draft: localCatalog['solaris']!.toDraft());
      await wishlist.remove(id);

      expect(await db.select(db.wishlistItems).get(), isEmpty);
      expect(await db.select(db.works).get(), isEmpty);
    });
  });

  group('search, filters and sorting', () {
    setUp(() async {
      await addFromCatalog('1984_penguin', status: ReadingStatus.read);
      await addFromCatalog('master', status: ReadingStatus.reading);
      await addFromCatalog('circe');
    });

    Future<List<String>> titles(LibraryQuery query) async {
      final entries = await library.watchLibrary(query).first;
      return entries.map((e) => e.title).toList();
    }

    test('search matches title, author, publisher and ISBN', () async {
      expect(await titles(const LibraryQuery(search: 'orwell')), ['1984']);
      expect(await titles(const LibraryQuery(search: 'Bloomsbury')), ['Circe']);
      expect(await titles(const LibraryQuery(search: '9780141036144')), ['1984']);
      expect(await titles(const LibraryQuery(search: 'Bulgakov')),
          ['The Master and Margarita']);
    });

    test('a search with no matches returns nothing rather than everything',
        () async {
      expect(await titles(const LibraryQuery(search: 'Bolaño')), isEmpty);
    });

    test('filters are AND-ed across groups', () async {
      final byLanguage = await titles(
        const LibraryQuery(filters: {
          FilterGroup.language: {'Russian'},
        }),
      );
      expect(byLanguage, ['The Master and Margarita']);

      final impossible = await titles(
        const LibraryQuery(filters: {
          FilterGroup.language: {'Russian'},
          FilterGroup.status: {'Read'},
        }),
      );
      expect(impossible, isEmpty);
    });

    test('a genre filter matches a whole entry, not a substring', () async {
      // "Fiction" must not match a book whose only genre is "Nonfiction".
      await addFromCatalog('thinking');
      final fiction = await titles(
        const LibraryQuery(filters: {
          FilterGroup.genre: {'Fiction'},
        }),
      );
      expect(fiction, isNot(contains('Thinking, Fast and Slow')));
      expect(fiction, contains('1984'));
    });

    test('sorting by title and by pages', () async {
      expect(
        await titles(const LibraryQuery(sort: SortOption.title)),
        ['1984', 'Circe', 'The Master and Margarita'],
      );
      expect(
        (await titles(const LibraryQuery(sort: SortOption.pages))).first,
        'The Master and Margarita',
      );
    });
  });

  group('reading and statistics', () {
    test('progress is clamped to the edition page count', () async {
      final added = await addFromCatalog('circe'); // 352 pages
      await reading.updateProgress(added.workId, 9999);

      final work = await library.workById(added.workId);
      expect(work!.currentPage, 352);
      expect(work.readingStatus, ReadingStatus.reading.name);
      expect(work.startDate, isNotNull);
    });

    test('finishing a book files a history entry and fills the statistics',
        () async {
      final added = await addFromCatalog('circe');
      await reading.updateProgress(added.workId, 100);
      await reading.setRating(added.workId, 5);
      await reading.finishReading(added.workId, rating: 5);

      final work = await library.workById(added.workId);
      expect(work!.readingStatus, ReadingStatus.read.name);
      expect(work.currentPage, 352);

      final stats = await StatisticsRepository(db).statistics();
      expect(stats.booksReadThisYear, 1);
      expect(stats.pagesReadThisYear, 352);
      expect(stats.averageRating, 5);
      expect(stats.byAuthor.single.label, 'Madeline Miller');
      expect(stats.byLanguage.single.label, 'English');
    });

    test('statistics are empty, not wrong, for an empty library', () async {
      final stats = await StatisticsRepository(db).statistics();
      expect(stats.booksReadThisYear, 0);
      expect(stats.averageRating, isNull);
      expect(stats.bestMonthIndex, -1);
      expect(stats.booksPerMonth, hasLength(12));
    });
  });

  group('seed data', () {
    test('produces a library that exercises every state', () async {
      await Seeder(db).seed();

      final works = await db.select(db.works).get();
      final editions = await db.select(db.editions).get();
      final copies = await db.select(db.copies).get();
      final wishes = await db.select(db.wishlistItems).get();
      final entries = await db.select(db.readingEntries).get();

      expect(works.length, greaterThan(20));
      expect(wishes.length, 5);
      expect(entries, isNotEmpty);

      // Multiple editions of one work, and multiple copies of one edition.
      final editionsPerWork = <String, int>{};
      for (final e in editions) {
        editionsPerWork[e.workId] = (editionsPerWork[e.workId] ?? 0) + 1;
      }
      expect(editionsPerWork.values.any((c) => c > 1), isTrue);

      final copiesPerEdition = <String, int>{};
      for (final c in copies) {
        copiesPerEdition[c.editionId] =
            (copiesPerEdition[c.editionId] ?? 0) + 1;
      }
      expect(copiesPerEdition.values.any((c) => c > 1), isTrue);

      // Every reading status is represented.
      final statuses = works.map((w) => w.readingStatus).toSet();
      for (final status in ReadingStatus.values) {
        expect(statuses, contains(status.name), reason: status.name);
      }

      // Several languages and publishers.
      expect(editions.map((e) => e.language).toSet().length, greaterThan(2));
      expect(editions.map((e) => e.publisher).toSet().length, greaterThan(5));

      final stats = await StatisticsRepository(db).statistics();
      expect(stats.booksReadThisYear, greaterThan(5));
      expect(stats.pagesReadThisYear, greaterThan(1000));
    });

    test('seeding twice does not duplicate the library', () async {
      final seeder = Seeder(db);
      expect(await seeder.seedIfEmpty(), isTrue);
      final count = (await db.select(db.works).get()).length;
      expect(await seeder.seedIfEmpty(), isFalse);
      expect((await db.select(db.works).get()).length, count);
    });
  });

  group('incomplete data', () {
    test('a book with no edition, pages or author still loads', () async {
      final added = await db.addBook(BookDraft(title: 'A pamphlet'));

      final details = await library.bookDetails(added.workId);
      expect(details, isNotNull);
      expect(details!.pageCount, isNull);
      expect(details.progress, 0);

      final entries = await library.watchLibrary(const LibraryQuery()).first;
      expect(entries.single.metaLine, isEmpty);
      expect(entries.single.authorLine, 'Unknown author');
    });

    test('progress on a book with no page count does not divide by zero',
        () async {
      final added = await db.addBook(BookDraft(title: 'A pamphlet'));
      await reading.updateProgress(added.workId, 12);
      final work = await library.workById(added.workId);
      expect(work!.currentPage, 12);
    });
  });
}
