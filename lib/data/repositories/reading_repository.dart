import 'package:drift/drift.dart';

import '../../domain/models/enums.dart';
import '../../domain/models/library_models.dart';
import '../local/database.dart';
import 'collection_mutations.dart';

/// Reading progress and history. Reading state belongs to the work, so
/// everything here keys off a work id, never a copy.
class ReadingRepository {
  ReadingRepository(this._db);

  final AppDatabase _db;

  Stream<List<ReadingEntryView>> watchCurrentlyReading() {
    final query = _db.select(_db.works).join([
      leftOuterJoin(
        _db.editions,
        _db.editions.id.equalsExp(_db.works.primaryEditionId),
      ),
    ])
      ..where(
        _db.works.readingStatus.isIn([
          ReadingStatus.reading.name,
          ReadingStatus.rereading.name,
        ]),
      )
      ..orderBy([OrderingTerm.desc(_db.works.updatedAt)]);

    return query.watch().map(
          (rows) => [
            for (final row in rows)
              ReadingEntryView(
                work: row.readTable(_db.works),
                edition: row.readTableOrNull(_db.editions),
                startedAt: row.readTable(_db.works).startDate,
              ),
          ],
        );
  }

  /// Unread books already on the shelves — the "Up next" strip.
  Stream<List<LibraryEntry>> watchUpNext({int limit = 8}) {
    final query = _db.select(_db.works).join([
      leftOuterJoin(
        _db.editions,
        _db.editions.id.equalsExp(_db.works.primaryEditionId),
      ),
    ])
      ..where(_db.works.readingStatus.equals(ReadingStatus.unread.name))
      ..orderBy([OrderingTerm.desc(_db.works.createdAt)])
      ..limit(limit);

    return query.watch().map(
          (rows) => [
            for (final row in rows)
              LibraryEntry(
                work: row.readTable(_db.works),
                edition: row.readTableOrNull(_db.editions),
                editionCount: 1,
                copyCount: 1,
                addedDate: row.readTable(_db.works).createdAt,
              ),
          ],
        );
  }

  Stream<List<HistoryEntry>> watchHistory({int limit = 200}) {
    final query = _db.select(_db.readingEntries).join([
      innerJoin(_db.works, _db.works.id.equalsExp(_db.readingEntries.workId)),
      leftOuterJoin(
        _db.editions,
        _db.editions.id.equalsExp(_db.works.primaryEditionId),
      ),
    ])
      ..orderBy([OrderingTerm.desc(_db.readingEntries.finishDate)])
      ..limit(limit);

    return query.watch().map(
          (rows) => [
            for (final row in rows)
              HistoryEntry(
                entry: row.readTable(_db.readingEntries),
                work: row.readTable(_db.works),
                edition: row.readTableOrNull(_db.editions),
              ),
          ],
        );
  }

  /// Page count is clamped to the edition, so a stepper can never push a book
  /// past its own last page.
  Future<void> updateProgress(String workId, int page) async {
    final work = await (_db.select(_db.works)..where((w) => w.id.equals(workId)))
        .getSingleOrNull();
    if (work == null) return;

    final total = await _pageCount(work);
    final clamped = total > 0 ? page.clamp(0, total) : (page < 0 ? 0 : page);

    await (_db.update(_db.works)..where((w) => w.id.equals(workId))).write(
      WorksCompanion(
        currentPage: Value(clamped),
        // Opening a book for the first time starts the clock.
        startDate: Value(work.startDate ?? DateTime.now()),
        readingStatus: Value(
          work.readingStatus == ReadingStatus.unread.name
              ? ReadingStatus.reading.name
              : work.readingStatus,
        ),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Jumps to the last page, moves the work to Read and files a history entry.
  Future<void> finishReading(String workId, {double? rating}) async {
    await _db.transaction(() async {
      final work = await (_db.select(_db.works)..where((w) => w.id.equals(workId)))
          .getSingleOrNull();
      if (work == null) return;

      final total = await _pageCount(work);
      final now = DateTime.now();

      await (_db.update(_db.works)..where((w) => w.id.equals(workId))).write(
        WorksCompanion(
          readingStatus: const Value('read'),
          currentPage: Value(total > 0 ? total : work.currentPage),
          finishDate: Value(now),
          rating: rating == null ? const Value.absent() : Value(rating),
          updatedAt: Value(now),
        ),
      );

      await _db.into(_db.readingEntries).insert(
            ReadingEntriesCompanion.insert(
              id: newId(),
              workId: workId,
              editionId: Value(work.primaryEditionId),
              startDate: Value(work.startDate),
              finishDate: now,
              pagesRead: Value(total > 0 ? total : work.currentPage),
              rating: Value(rating ?? work.rating),
              finished: const Value(true),
            ),
          );
    });
  }

  Future<void> setStatus(String workId, ReadingStatus status) async {
    await _db.transaction(() async {
      final work = await (_db.select(_db.works)..where((w) => w.id.equals(workId)))
          .getSingleOrNull();
      if (work == null) return;
      final now = DateTime.now();

      // Moving straight to Read from the status chips should still record the
      // read, so statistics and history stay truthful.
      if (status == ReadingStatus.read &&
          work.readingStatus != ReadingStatus.read.name) {
        final total = await _pageCount(work);
        await _db.into(_db.readingEntries).insert(
              ReadingEntriesCompanion.insert(
                id: newId(),
                workId: workId,
                editionId: Value(work.primaryEditionId),
                startDate: Value(work.startDate),
                finishDate: now,
                pagesRead: Value(total > 0 ? total : work.currentPage),
                rating: Value(work.rating),
                finished: const Value(true),
              ),
            );
      }

      await (_db.update(_db.works)..where((w) => w.id.equals(workId))).write(
        WorksCompanion(
          readingStatus: Value(status.name),
          startDate: Value(
            switch (status) {
              ReadingStatus.reading ||
              ReadingStatus.rereading =>
                work.startDate ?? now,
              ReadingStatus.unread => null,
              _ => work.startDate,
            },
          ),
          finishDate: Value(status == ReadingStatus.read ? now : work.finishDate),
          currentPage: Value(
            status == ReadingStatus.unread ? 0 : work.currentPage,
          ),
          updatedAt: Value(now),
        ),
      );
    });
  }

  Future<void> setRating(String workId, double? rating) =>
      (_db.update(_db.works)..where((w) => w.id.equals(workId))).write(
        WorksCompanion(
          rating: Value(rating),
          updatedAt: Value(DateTime.now()),
        ),
      );

  Future<int> _pageCount(Work work) async {
    final id = work.primaryEditionId;
    if (id == null) return 0;
    final edition =
        await (_db.select(_db.editions)..where((e) => e.id.equals(id)))
            .getSingleOrNull();
    return edition?.pageCount ?? 0;
  }
}
