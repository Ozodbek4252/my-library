import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_library/data/local/database.dart';
import 'package:my_library/data/repositories/collection_mutations.dart';
import 'package:my_library/data/repositories/reading_repository.dart';
import 'package:my_library/data/repositories/statistics_repository.dart';
import 'package:my_library/domain/models/book_draft.dart';
import 'package:my_library/domain/models/enums.dart';

/// "Pages read" counts pages the reader actually read — including the ones in
/// a book they are still in the middle of.
void main() {
  late AppDatabase db;
  late ReadingRepository reading;
  late StatisticsRepository stats;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await db.ensureIndexes();
    reading = ReadingRepository(db);
    stats = StatisticsRepository(db);
  });

  tearDown(() => db.close());

  Future<String> addBook(String title, int pages) async {
    final added = await db.addBook(
      BookDraft(title: title, authors: ['A N Other'], pageCount: pages),
    );
    return added.workId;
  }

  test('pages in a book still being read are counted', () async {
    final workId = await addBook('Meditations', 185);
    await reading.updateProgress(workId, 95);

    final result = await stats.statistics();

    expect(result.pagesReadThisYear, 95);
    expect(result.currentlyReading, 1);
    // Nothing has been finished, so that figure stays honest.
    expect(result.booksReadThisYear, 0);
    expect(result.hasReadAnything, isFalse);
  });

  test('finishing a book does not count its pages twice', () async {
    final workId = await addBook('Meditations', 185);
    await reading.updateProgress(workId, 95);
    await reading.finishReading(workId);

    final result = await stats.statistics();

    expect(
      result.pagesReadThisYear,
      185,
      reason: 'the finished entry is the count; current page must not be added',
    );
    expect(result.booksReadThisYear, 1);
    expect(result.currentlyReading, 0);
  });

  test('a finished book and an open one add up', () async {
    final finished = await addBook('Finished', 200);
    await reading.finishReading(finished);

    final open = await addBook('Open', 185);
    await reading.updateProgress(open, 95);

    expect((await stats.statistics()).pagesReadThisYear, 295);
  });

  test('marking read straight from the status chips counts once', () async {
    final workId = await addBook('Straight To Read', 300);
    await reading.setStatus(workId, ReadingStatus.read);

    final result = await stats.statistics();

    expect(result.pagesReadThisYear, 300);
    expect(result.booksReadThisYear, 1);
  });

  test('an unread book contributes nothing', () async {
    await addBook('Untouched', 400);

    expect((await stats.statistics()).pagesReadThisYear, 0);
  });

  test('a book carried over from last year is not counted in this one',
      () async {
    final workId = await addBook('Started Last Year', 500);
    await reading.updateProgress(workId, 120);

    // Backdate the start: the reading happened in the previous year.
    await (db.update(db.works)..where((w) => w.id.equals(workId))).write(
      WorksCompanion(
        startDate: Value(DateTime(DateTime.now().year - 1, 11, 2)),
      ),
    );

    final result = await stats.statistics();

    expect(
      result.pagesReadThisYear,
      0,
      reason: 'those pages belong to the year the reading started',
    );
    expect(result.currentlyReading, 1, reason: 'it is still open right now');
  });

  test('a re-read counts the earlier finish and the pages read again',
      () async {
    final workId = await addBook('Worth Rereading', 200);
    await reading.finishReading(workId);

    // Opening it again and getting 40 pages in.
    await reading.setStatus(workId, ReadingStatus.rereading);
    await reading.updateProgress(workId, 40);

    final result = await stats.statistics();

    expect(result.pagesReadThisYear, 240);
    expect(result.booksReadThisYear, 1);
    expect(result.currentlyReading, 1);
  });
}
