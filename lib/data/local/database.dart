import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    Works,
    Editions,
    Copies,
    CopyPhotos,
    Tags,
    CopyTags,
    WishlistItems,
    ReadingEntries,
    RecentSearches,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'book_collection'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) async {
          // Required for the ON DELETE CASCADE rules above to actually fire.
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  /// Indexes that keep search and the library query fast on large libraries.
  Future<void> ensureIndexes() async {
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_editions_work ON editions (work_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_editions_isbn13 ON editions (isbn13)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_editions_isbn10 ON editions (isbn10)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_copies_edition ON copies (edition_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_reading_entries_work ON reading_entries (work_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_reading_entries_finish ON reading_entries (finish_date)',
    );
  }
}
