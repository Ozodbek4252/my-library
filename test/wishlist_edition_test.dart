import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_library/data/local/database.dart';
import 'package:my_library/data/metadata/book_metadata.dart';
import 'package:my_library/data/metadata/local_catalog_source.dart';
import 'package:my_library/data/repositories/collection_mutations.dart';
import 'package:my_library/data/repositories/library_repository.dart';
import 'package:my_library/data/repositories/scan_service.dart';
import 'package:my_library/data/repositories/wishlist_repository.dart';
import 'package:my_library/domain/models/book_draft.dart';
import 'package:my_library/domain/models/enums.dart';

/// A scan captures a whole edition — ISBN, cover, page count, year. Wishlisting
/// it used to keep only the title, author and publisher, so the day the book
/// was bought all of that had to be typed in again.
void main() {
  late AppDatabase db;
  late WishlistRepository wishlist;
  late LibraryRepository library;
  late ScanService scanner;

  const scanned = BookMetadata(
    title: 'Essentialism',
    authors: ['Greg McKeown'],
    genres: ['Choice (Psychology)', 'Decision making'],
    firstPublished: 2014,
    isbn13: '9780804137386',
    publisher: 'Crown Business',
    publicationDate: '2014',
    publishedYear: 2014,
    pageCount: 260,
    language: 'English',
    format: 'Hardcover',
    coverUrl: 'https://covers.openlibrary.org/b/id/7890-L.jpg',
  );

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await db.ensureIndexes();
    library = LibraryRepository(db);
    wishlist = WishlistRepository(db);
    scanner = ScanService(
      metadata: const LocalCatalogSource(),
      library: library,
      wishlist: wishlist,
    );
  });

  tearDown(() => db.close());

  test('wishlisting a scanned book remembers its edition', () async {
    final id = await wishlist.add(draft: scanned.toDraft());

    final entry = await wishlist.watchItem(id).first;
    expect(entry, isNotNull);
    expect(entry!.edition, isNotNull, reason: 'the scanned edition is kept');
    expect(entry.edition!.isbn13, '9780804137386');
    expect(entry.edition!.pageCount, 260);
    expect(entry.edition!.publishedYear, 2014);
    expect(entry.coverUrl, scanned.coverUrl);

    // And it is wanted, not owned.
    final copies = await db.select(db.copies).get();
    expect(copies, isEmpty);
  });

  test('buying a wishlisted book keeps the cover, ISBN, pages and year',
      () async {
    final id = await wishlist.add(draft: scanned.toDraft());
    final entry = (await wishlist.watchItem(id).first)!;

    // What the "I bought it" button does.
    await db.addCopyToEdition(
      entry.edition!.id,
      CopyDraft(ownership: Ownership.owned),
    );
    await db.setPrimaryEditionIfUnset(entry.work.id, entry.edition!.id);
    await wishlist.remove(entry.item.id);

    final details = await library.bookDetails(entry.work.id);
    final edition = details!.primaryEdition!.edition;

    expect(edition.coverUrl, scanned.coverUrl, reason: 'the image survives');
    expect(edition.isbn13, '9780804137386');
    expect(edition.pageCount, 260);
    expect(edition.publishedYear, 2014);
    expect(edition.publisher, 'Crown Business');
    expect(edition.language, 'English');
    expect(edition.format, 'Hardcover');
    expect(details.isOwned, isTrue);
    expect(details.wishlistItem, isNull, reason: 'cleared from the wishlist');

    // One work, one edition, one copy — nothing duplicated along the way.
    expect((await db.select(db.works).get()), hasLength(1));
    expect((await db.select(db.editions).get()), hasLength(1));
    expect((await db.select(db.copies).get()), hasLength(1));
  });

  test('scanning a wishlisted book does not claim it is owned', () async {
    await wishlist.add(draft: scanned.toDraft());

    final result = await scanner.resolveIsbn('9780804137386');

    expect(result.verdict, ScanVerdict.notInLibrary);
    expect(result.isOwned, isFalse);
    expect(result.isWishlisted, isTrue);
    // The edition is known, so adding it attaches to what is already there.
    expect(result.matchedEdition, isNotNull);
  });

  test('adding a scanned wishlisted book reuses its edition', () async {
    await wishlist.add(draft: scanned.toDraft());
    final result = await scanner.resolveIsbn('9780804137386');

    final outcome = await db.addBook(result.toDraft()..ownership = Ownership.owned);

    expect(outcome.createdEdition, isFalse, reason: 'the edition already exists');
    expect(outcome.clearedWishlist, isTrue);
    expect((await db.select(db.editions).get()), hasLength(1));

    final details = await library.bookDetails(outcome.workId);
    expect(details!.primaryEdition!.edition.coverUrl, scanned.coverUrl);
    expect(details.isOwned, isTrue);
  });

  test('a previously owned copy is not reported as owned either', () async {
    final added = await db.addBook(
      scanned.toDraft(),
      copyDetails: CopyDraft(ownership: Ownership.previouslyOwned),
    );
    expect(added.editionId, isNotEmpty);

    final result = await scanner.resolveIsbn('9780804137386');
    expect(result.verdict, ScanVerdict.notInLibrary);
    expect(result.isOwned, isFalse);
  });

  test('removing a wanted book takes its edition and work with it', () async {
    final id = await wishlist.add(draft: scanned.toDraft());
    await wishlist.remove(id);

    expect(await db.select(db.wishlistItems).get(), isEmpty);
    expect(await db.select(db.editions).get(), isEmpty);
    expect(await db.select(db.works).get(), isEmpty);
  });

  test('a book wanted only in the abstract still works', () async {
    final id = await wishlist.add(
      draft: BookDraft(title: 'Something I half remember'),
      desiredLanguage: 'English',
      desiredFormat: 'Hardcover',
    );

    final entry = (await wishlist.watchItem(id).first)!;
    expect(entry.edition, isNull);
    expect(entry.wantLine, 'English · Hardcover');
    expect(await db.select(db.editions).get(), isEmpty);
  });

  test('wishlisting a book whose edition is already on file reuses it',
      () async {
    final owned = await db.addBook(scanned.toDraft());
    final work = await library.workById(owned.workId);

    final id = await wishlist.add(
      draft: scanned.toDraft()..workId = work!.id,
    );
    final entry = (await wishlist.watchItem(id).first)!;

    expect(entry.edition!.id, owned.editionId);
    expect((await db.select(db.editions).get()), hasLength(1));
  });
}
