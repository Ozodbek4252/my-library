import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_library/data/local/database.dart';
import 'package:my_library/data/repositories/collection_mutations.dart';
import 'package:my_library/data/repositories/library_repository.dart';
import 'package:my_library/data/seed/seeder.dart';
import 'package:my_library/data/metadata/book_metadata.dart';
import 'package:my_library/domain/models/book_draft.dart';

void main() {
  test('a user-supplied cover survives a round trip through the database',
      () async {
    final db = AppDatabase(NativeDatabase.memory());
    await db.ensureIndexes();

    final added = await db.addBook(
      BookDraft(
        title: 'A book with no barcode',
        authors: ['Someone'],
        coverImagePath: '/data/user/0/app/covers/123.jpg',
      ),
    );

    final details = await LibraryRepository(db).bookDetails(added.workId);
    final edition = details!.primaryEdition!.edition;
    expect(edition.coverImagePath, '/data/user/0/app/covers/123.jpg');
    expect(edition.coverUrl, isNull);

    // And it can be replaced, and cleared.
    final draft = BookDraft.fromRows(work: details.work, edition: edition)
      ..coverImagePath = '/data/user/0/app/covers/456.jpg';
    await db.saveDraft(draft);

    var reread = await LibraryRepository(db).bookDetails(added.workId);
    expect(
      reread!.primaryEdition!.edition.coverImagePath,
      '/data/user/0/app/covers/456.jpg',
    );

    draft.coverImagePath = null;
    await db.saveDraft(draft);
    reread = await LibraryRepository(db).bookDetails(added.workId);
    expect(reread!.primaryEdition!.edition.coverImagePath, isNull);

    await db.close();
  });

  test('re-scanning a book with missing details fills them back in', () async {
    final db = AppDatabase(NativeDatabase.memory());
    await db.ensureIndexes();

    // A book saved before the wishlist fix: title, author, publisher only.
    final added = await db.addBook(
      BookDraft(
        title: 'Essentialism',
        authors: ['Greg McKeown'],
        publisher: 'Crown Business',
      ),
    );
    var details = await LibraryRepository(db).bookDetails(added.workId);
    expect(details!.primaryEdition!.edition.isbn13, isNull);
    expect(details.primaryEdition!.edition.coverUrl, isNull);

    // Scanning the ISBN in the editor replaces the draft with what the lookup
    // found, keeping the ids, and saving writes it over the thin record.
    final refreshed = const BookMetadata(
      title: 'Essentialism',
      authors: ['Greg McKeown'],
      isbn13: '9780804137386',
      publisher: 'Crown Business',
      publishedYear: 2014,
      pageCount: 260,
      coverUrl: 'https://covers.openlibrary.org/b/id/7890-L.jpg',
    ).toDraft()
      ..workId = added.workId
      ..editionId = added.editionId;

    await db.saveDraft(refreshed);

    details = await LibraryRepository(db).bookDetails(added.workId);
    final edition = details!.primaryEdition!.edition;
    expect(edition.isbn13, '9780804137386');
    expect(edition.pageCount, 260);
    expect(edition.publishedYear, 2014);
    expect(edition.coverUrl, 'https://covers.openlibrary.org/b/id/7890-L.jpg');
    // Repaired in place — no second edition, no second copy.
    expect((await db.select(db.editions).get()), hasLength(1));
    expect((await db.select(db.copies).get()), hasLength(1));

    await db.close();
  });

  test('seeded editions have no user cover, so placeholders still show',
      () async {
    final db = AppDatabase(NativeDatabase.memory());
    await db.ensureIndexes();
    await Seeder(db).seed();

    final editions = await db.select(db.editions).get();
    expect(editions, isNotEmpty);
    expect(editions.every((e) => e.coverImagePath == null), isTrue);

    await db.close();
  });

  test('the schema is at the version the cover column was added in', () {
    final db = AppDatabase(NativeDatabase.memory());
    expect(db.schemaVersion, greaterThanOrEqualTo(2));
    db.close();
  });

  test('an edition row can be written with both cover kinds', () async {
    final db = AppDatabase(NativeDatabase.memory());
    await db.ensureIndexes();

    final added = await db.addBook(
      BookDraft(
        title: 'Both covers',
        coverUrl: 'https://example.com/cover.jpg',
        coverImagePath: '/covers/mine.jpg',
      ),
    );
    await (db.update(db.editions)..where((e) => e.id.equals(added.editionId)))
        .write(const EditionsCompanion(coverUrl: Value('https://x/y.jpg')));

    final edition = await (db.select(db.editions)
          ..where((e) => e.id.equals(added.editionId)))
        .getSingle();
    expect(edition.coverUrl, 'https://x/y.jpg');
    expect(edition.coverImagePath, '/covers/mine.jpg');

    await db.close();
  });
}
