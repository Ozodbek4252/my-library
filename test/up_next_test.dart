import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_library/data/local/database.dart';
import 'package:my_library/data/repositories/collection_mutations.dart';
import 'package:my_library/data/repositories/reading_repository.dart';
import 'package:my_library/data/repositories/wishlist_repository.dart';
import 'package:my_library/data/seed/seeder.dart';
import 'package:my_library/domain/models/book_draft.dart';
import 'package:my_library/domain/models/enums.dart';

/// "Up next · from your shelves" says what it shows. A book you merely want,
/// or used to own, is not on your shelves.
void main() {
  late AppDatabase db;
  late ReadingRepository reading;
  late WishlistRepository wishlist;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await db.ensureIndexes();
    reading = ReadingRepository(db);
    wishlist = WishlistRepository(db);
  });

  tearDown(() => db.close());

  Future<List<String>> upNextTitles() async {
    final entries = await reading.watchUpNext().first;
    return [for (final e in entries) e.work.title];
  }

  test('an owned unread book is up next', () async {
    await db.addBook(
      BookDraft(title: 'Piranesi', authors: ['Susanna Clarke']),
    );

    expect(await upNextTitles(), contains('Piranesi'));
  });

  test('a wishlisted book is not up next', () async {
    await wishlist.add(
      draft: BookDraft(
        title: 'Flights',
        authors: ['Olga Tokarczuk'],
        isbn13: '9781910695210',
        pageCount: 426,
      ),
    );

    expect(
      await upNextTitles(),
      isNot(contains('Flights')),
      reason: 'wanting a book does not put it on your shelves',
    );
  });

  test('a book you used to own is not up next', () async {
    await db.addBook(
      BookDraft(
        title: 'Lent Out And Lost',
        authors: ['A N Other'],
        ownership: Ownership.previouslyOwned,
      ),
    );

    expect(await upNextTitles(), isNot(contains('Lent Out And Lost')));
  });

  test('the seeded sample wishlist never reaches the shelves', () async {
    await Seeder(db).seed();

    final titles = await upNextTitles();
    final wishlisted = await wishlist.watchWishlist().first;
    expect(wishlisted, isNotEmpty, reason: 'the sample seeds a wishlist');

    for (final item in wishlisted) {
      expect(
        titles,
        isNot(contains(item.work.title)),
        reason: '${item.work.title} is wished for, not owned',
      );
    }
  });

  test('a seeded wishlist entry carries the edition it wants', () async {
    await Seeder(db).seed();

    // Every wishlist entry the app creates records the edition, so nothing has
    // to be retyped the day it is bought. The sample must match.
    for (final item in await wishlist.watchWishlist().first) {
      final editions = await (db.select(db.editions)
            ..where((e) => e.workId.equals(item.work.id)))
          .get();
      expect(
        editions,
        isNotEmpty,
        reason: '${item.work.title} was seeded with no edition at all',
      );
    }
  });
}
