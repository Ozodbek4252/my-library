import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_library/data/local/database.dart';
import 'package:my_library/data/repositories/collection_mutations.dart';
import 'package:my_library/data/repositories/library_repository.dart';
import 'package:my_library/data/seed/seeder.dart';
import 'package:my_library/domain/models/book_draft.dart';
import 'package:sqlite3/sqlite3.dart';

/// The cover column arrived in schema v2 and the wishlist's edition link in
/// v3, while real devices already hold older libraries. An upgrade that dropped
/// a book would be unforgivable, so each one is exercised here against a
/// database that genuinely lacks the columns.
void main() {
  late Directory temp;
  late File file;

  setUp(() {
    temp = Directory.systemTemp.createTempSync('book_collection_upgrade');
    file = File('${temp.path}/library.sqlite');
  });

  tearDown(() => temp.deleteSync(recursive: true));

  test('upgrading from v1 keeps every book and adds the cover column',
      () async {
    // 1. Build a full library, then take the database back to v1 by removing
    //    the column v2 introduced.
    var db = AppDatabase(NativeDatabase(file));
    await db.ensureIndexes();
    await Seeder(db).seed();

    final before = (await db.select(db.works).get()).length;
    final editionsBefore = (await db.select(db.editions).get()).length;
    final copiesBefore = (await db.select(db.copies).get()).length;
    expect(before, greaterThan(20));
    await db.close();

    final raw = sqlite3.open(file.path);
    raw.execute('ALTER TABLE editions DROP COLUMN cover_image_path');
    raw.execute('ALTER TABLE wishlist_items DROP COLUMN edition_id');
    raw.execute('PRAGMA user_version = 1');
    final v1Columns = raw
        .select('PRAGMA table_info(editions)')
        .map((row) => row['name'] as String)
        .toList();
    expect(v1Columns, isNot(contains('cover_image_path')));
    expect(
      raw
          .select('PRAGMA table_info(wishlist_items)')
          .map((row) => row['name'] as String),
      isNot(contains('edition_id')),
    );
    raw.close();

    // 2. Open it with the current app. The migration should run.
    db = AppDatabase(NativeDatabase(file));
    final works = await db.select(db.works).get();
    final editions = await db.select(db.editions).get();
    final copies = await db.select(db.copies).get();

    expect(works, hasLength(before), reason: 'no book may be lost');
    expect(editions, hasLength(editionsBefore));
    expect(copies, hasLength(copiesBefore));
    expect(editions.every((e) => e.coverImagePath == null), isTrue);
    final wishes = await db.select(db.wishlistItems).get();
    expect(wishes, isNotEmpty, reason: 'wanted books survive too');
    expect(wishes.every((w) => w.editionId == null), isTrue);

    // 3. And the new column is usable straight away.
    final added = await db.addBook(
      BookDraft(title: 'After the upgrade', coverImagePath: '/covers/new.jpg'),
    );
    final details = await LibraryRepository(db).bookDetails(added.workId);
    expect(details!.primaryEdition!.edition.coverImagePath, '/covers/new.jpg');

    await db.close();
  });

  test('opening an existing v2 database does not run the migration again',
      () async {
    var db = AppDatabase(NativeDatabase(file));
    await db.ensureIndexes();
    final added = await db.addBook(
      BookDraft(title: 'Kept', coverImagePath: '/covers/kept.jpg'),
    );
    await db.close();

    db = AppDatabase(NativeDatabase(file));
    final details = await LibraryRepository(db).bookDetails(added.workId);
    expect(details!.primaryEdition!.edition.coverImagePath, '/covers/kept.jpg');
    await db.close();
  });
}
