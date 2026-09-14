import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_library/core/l10n_extensions.dart';
import 'package:my_library/data/local/database.dart';
import 'package:my_library/data/metadata/book_metadata.dart';
import 'package:my_library/data/metadata/local_catalog.dart';
import 'package:my_library/data/metadata/local_catalog_source.dart';
import 'package:my_library/data/repositories/collection_mutations.dart';
import 'package:my_library/data/repositories/library_repository.dart';
import 'package:my_library/data/repositories/scan_service.dart';
import 'package:my_library/data/repositories/wishlist_repository.dart';
import 'package:my_library/domain/models/book_draft.dart';
import 'package:my_library/domain/models/enums.dart';

/// Scanning a book that is already on the shelves should top up whatever its
/// record is missing — and touch nothing else.
void main() {
  late AppDatabase db;
  late LibraryRepository library;
  late ScanService scanner;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await db.ensureIndexes();
    library = LibraryRepository(db);
    scanner = ScanService(
      metadata: const LocalCatalogSource(),
      library: library,
      wishlist: WishlistRepository(db),
    );
  });

  tearDown(() => db.close());

  /// 1984, Penguin — recorded with almost nothing, as a hand-typed book is.
  Future<AddBookResult> addThinBook() => db.addBook(
        BookDraft(
          title: '1984',
          authors: ['George Orwell'],
          isbn13: '9780141036144',
        ),
      );

  test('a scan fills in what the record was missing', () async {
    final added = await addThinBook();

    final result = await scanner.resolveIsbn('9780141036144');

    expect(result.enrichment.isNotEmpty, isTrue);
    expect(result.enrichment.filled, contains(EnrichedField.pageCount));
    expect(result.enrichment.filled, contains(EnrichedField.publisher));

    final details = await library.bookDetails(added.workId);
    final edition = details!.primaryEdition!.edition;
    expect(edition.publisher, 'Penguin');
    expect(edition.pageCount, 336);
    expect(edition.publishedYear, 2013);
    expect(edition.language, 'English');
    expect(edition.format, 'Paperback');
    expect(details.work.genres, contains('Fiction'));
    expect(details.work.description, isNotNull);
  });

  test('it never overwrites something already recorded', () async {
    // The user corrected the publisher and page count themselves.
    final added = await db.addBook(
      BookDraft(
        title: '1984',
        authors: ['George Orwell'],
        isbn13: '9780141036144',
        publisher: 'My own note about the publisher',
        pageCount: 999,
        language: 'English',
      ),
    );

    await scanner.resolveIsbn('9780141036144');

    final details = await library.bookDetails(added.workId);
    final edition = details!.primaryEdition!.edition;
    expect(edition.publisher, 'My own note about the publisher');
    expect(edition.pageCount, 999);
    // The gaps around them were still filled.
    expect(edition.publishedYear, 2013);
    expect(edition.format, 'Paperback');
  });

  test('a photographed cover is never replaced by a fetched one', () async {
    final added = await db.addBook(
      BookDraft(
        title: '1984',
        authors: ['George Orwell'],
        isbn13: '9780141036144',
        coverImagePath: '/covers/my-own-photo.jpg',
      ),
    );

    final result = await scanner.resolveIsbn('9780141036144');

    final details = await library.bookDetails(added.workId);
    final edition = details!.primaryEdition!.edition;
    expect(edition.coverImagePath, '/covers/my-own-photo.jpg');
    expect(edition.coverUrl, isNull, reason: 'no URL written over a real photo');
    expect(result.enrichment.filled, isNot(contains(EnrichedField.cover)));
  });

  test('a complete record is left alone and needs no lookup', () async {
    final added = await db.addBook(localCatalog['1984_penguin']!.toDraft());
    final before = await library.bookDetails(added.workId);

    final result = await scanner.resolveIsbn('9780141036144');

    expect(result.enrichment.isEmpty, isTrue);
    final after = await library.bookDetails(added.workId);
    expect(
      after!.work.updatedAt,
      before!.work.updatedAt,
      reason: 'nothing was written, so nothing was touched',
    );
  });

  test('the scan still succeeds when the lookup is unreachable', () async {
    final added = await addThinBook();
    final offline = ScanService(
      metadata: _FailingSource(),
      library: library,
      wishlist: WishlistRepository(db),
    );

    final result = await offline.resolveIsbn('9780141036144');

    // The verdict is unaffected; there was simply nothing to add.
    expect(result.details?.work.id, added.workId);
    expect(result.enrichment.isEmpty, isTrue);
    expect(result.metadata.title, '1984');
  });

  group('a book recorded without its ISBN', () {
    /// Exactly the shape a book moved over from the wishlist used to have:
    /// title, author and publisher, and nothing else.
    Future<AddBookResult> addIsbnless() => db.addBook(
          BookDraft(
            title: '1984',
            authors: ['George Orwell'],
            publisher: 'Penguin',
          ),
        );

    test('is recognised and filled in, not duplicated', () async {
      final added = await addIsbnless();

      final result = await scanner.resolveIsbn('9780141036144');

      expect(
        result.verdict,
        ScanVerdict.ownedSameEdition,
        reason: 'it is the same edition, just recorded thinly',
      );
      expect(result.enrichment.filled, contains(EnrichedField.isbn));
      expect(result.enrichment.filled, contains(EnrichedField.pageCount));

      final details = await library.bookDetails(added.workId);
      final edition = details!.primaryEdition!.edition;
      expect(edition.isbn13, '9780141036144');
      expect(edition.pageCount, 336);
      expect(edition.publishedYear, 2013);
      expect(edition.publisher, 'Penguin');
      // Filled in place: still one edition, still one copy.
      expect((await db.select(db.editions).get()), hasLength(1));
      expect((await db.select(db.copies).get()), hasLength(1));
    });

    test('a genuinely different edition is left alone', () async {
      // The Russian АСТ hardcover, recorded without an ISBN.
      final added = await db.addBook(
        BookDraft(
          title: '1984',
          authors: ['George Orwell'],
          publisher: 'АСТ',
          language: 'Russian',
          format: 'Hardcover',
        ),
      );

      // Scanning the English Penguin paperback must not merge into it.
      final result = await scanner.resolveIsbn('9780141036144');

      expect(result.verdict, ScanVerdict.ownedOtherEdition);
      expect(result.enrichment.isEmpty, isTrue);

      final details = await library.bookDetails(added.workId);
      final edition = details!.primaryEdition!.edition;
      expect(edition.publisher, 'АСТ');
      expect(edition.isbn13, isNull, reason: 'no ISBN written onto it');
    });

    test('two ISBN-less editions are too ambiguous to merge', () async {
      final added = await addIsbnless();
      await db.addBook(
        BookDraft(title: '1984', authors: ['George Orwell'], workId: added.workId),
      );

      final result = await scanner.resolveIsbn('9780141036144');

      expect(result.enrichment.isEmpty, isTrue);
      expect(result.verdict, ScanVerdict.ownedOtherEdition);
    });
  });

  test('the message names what changed', () async {
    final l10n = await AppL10n.delegate.load(const Locale('en'));

    expect(
      [EnrichedField.cover].summary(l10n),
      'Filled in the cover',
    );
    expect(
      [EnrichedField.cover, EnrichedField.pageCount].summary(l10n),
      'Filled in the cover and page count',
    );
    expect(
      [EnrichedField.cover, EnrichedField.pageCount, EnrichedField.year]
          .summary(l10n),
      'Filled in the cover, page count and year',
    );
  });

  test('scanning the same book again adds nothing a second time', () async {
    await addThinBook();

    final first = await scanner.resolveIsbn('9780141036144');
    expect(first.enrichment.isNotEmpty, isTrue);

    final second = await scanner.resolveIsbn('9780141036144');
    expect(
      second.enrichment.isEmpty,
      isTrue,
      reason: 'everything the provider had was taken the first time',
    );
  });

  test('a lookup that hangs cannot hold up the verdict', () async {
    final added = await addThinBook();
    final slow = ScanService(
      metadata: _HangingSource(),
      library: library,
      wishlist: WishlistRepository(db),
    );

    final started = DateTime.now();
    final result = await slow.resolveIsbn('9780141036144');
    final elapsed = DateTime.now().difference(started);

    expect(result.details?.work.id, added.workId);
    expect(
      elapsed,
      lessThan(ScanService.enrichmentTimeout + const Duration(seconds: 1)),
      reason: 'the shelf answer does not wait on the network',
    );
  });
}

/// Never answers, standing in for a bookshop with no signal.
class _HangingSource implements BookMetadataRepository {
  @override
  Future<BookMetadata> lookupByIsbn(String isbn) => Completer<BookMetadata>().future;

  @override
  Future<List<BookMetadata>> search(String query, {int limit = 20}) =>
      Completer<List<BookMetadata>>().future;
}

class _FailingSource implements BookMetadataRepository {
  @override
  Future<BookMetadata> lookupByIsbn(String isbn) async =>
      throw const MetadataException(MetadataFailure.network);

  @override
  Future<List<BookMetadata>> search(String query, {int limit = 20}) async =>
      throw const MetadataException(MetadataFailure.network);
}
