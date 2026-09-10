import 'package:drift/drift.dart';

import '../../domain/models/book_draft.dart';
import '../../domain/models/enums.dart';
import '../local/database.dart';
import '../metadata/local_catalog.dart';
import '../repositories/collection_mutations.dart';
import 'seed_data.dart';

/// Fills an empty database with a realistic sample library so the app can be
/// used and tested straight away. Runs once — a database with any work in it is
/// left alone.
class Seeder {
  Seeder(this._db);

  final AppDatabase _db;

  Future<bool> seedIfEmpty() async {
    final existing = await _db.select(_db.works).get();
    if (existing.isNotEmpty) return false;
    await seed();
    return true;
  }

  Future<void> seed() async {
    final now = DateTime.now();
    final yearStart = DateTime(now.year);
    final elapsed = now.difference(yearStart);

    /// Places a finished read inside the current year, whatever today's date
    /// is, so the sample statistics are never empty or in the future.
    DateTime finishDate(double fraction) =>
        yearStart.add(elapsed * fraction.clamp(0.0, 1.0));

    await _db.transaction(() async {
      // catalogue key -> work id, so a second edition attaches to the work the
      // first one created.
      final workIds = <String, String>{};

      for (final seed in seedBooks) {
        final metadata = localCatalog[seed.catalogKey];
        if (metadata == null) continue;

        final draft = metadata.toDraft()
          ..readingStatus = seed.status
          ..ownership = seed.ownership;

        final sharedWorkKey = seed.sameWorkAs;
        if (sharedWorkKey != null) draft.workId = workIds[sharedWorkKey];

        final firstCopy = seed.copies.first;
        final result = await _db.addBook(
          draft,
          copyDetails: _copyDraft(firstCopy, seed.ownership, now),
        );
        workIds[seed.catalogKey] = result.workId;

        for (final extra in seed.copies.skip(1)) {
          await _db.addCopyToEdition(
            result.editionId,
            _copyDraft(extra, seed.ownership, now),
          );
        }

        // Reading state belongs to the work, so only write it for the edition
        // that introduced it.
        if (sharedWorkKey != null) continue;

        final started = seed.startedDaysAgo == null
            ? null
            : now.subtract(Duration(days: seed.startedDaysAgo!));
        final finished = seed.finishedAtFraction == null
            ? null
            : finishDate(seed.finishedAtFraction!);

        await (_db.update(_db.works)..where((w) => w.id.equals(result.workId)))
            .write(
          WorksCompanion(
            readingStatus: Value(seed.status.name),
            rating: Value(seed.rating),
            currentPage: Value(seed.currentPage),
            startDate: Value(started ?? finished?.subtract(
                  Duration(days: seed.readingDays ?? 7),
                )),
            finishDate: Value(finished),
            // Spread creation dates so "Recently added" has a real order.
            createdAt: Value(
              now.subtract(
                Duration(days: firstCopy.purchasedDaysAgo ?? 30),
              ),
            ),
            updatedAt: Value(now),
          ),
        );

        if (finished != null) {
          await _db.into(_db.readingEntries).insert(
                ReadingEntriesCompanion.insert(
                  id: newId(),
                  workId: result.workId,
                  editionId: Value(result.editionId),
                  startDate: Value(
                    finished.subtract(Duration(days: seed.readingDays ?? 7)),
                  ),
                  finishDate: finished,
                  pagesRead: Value(metadata.pageCount ?? 0),
                  rating: Value(seed.rating),
                  finished: const Value(true),
                ),
              );
        }
      }

      for (final wish in seedWishes) {
        final metadata = localCatalog[wish.catalogKey];
        if (metadata == null) continue;

        final draft = metadata.toDraft();
        final workId = newId();
        final added = now.subtract(Duration(days: wish.addedDaysAgo));

        await _db.into(_db.works).insert(
              WorksCompanion.insert(
                id: workId,
                title: draft.title,
                authors: draft.authors,
                genres: draft.genres,
                originalTitle: Value(draft.originalTitle),
                originalLanguage: Value(draft.originalLanguage),
                description: Value(draft.description),
                seriesName: Value(draft.seriesName),
                seriesIndex: Value(draft.seriesIndex),
                firstPublished: Value(draft.firstPublished),
                createdAt: added,
                updatedAt: added,
              ),
            );

        await _db.into(_db.wishlistItems).insert(
              WishlistItemsCompanion.insert(
                id: newId(),
                workId: workId,
                desiredLanguage: Value(wish.desiredLanguage),
                desiredFormat: Value(wish.desiredFormat),
                desiredEdition: Value(wish.desiredEdition),
                priority: Value(wish.priority.name),
                notes: Value(wish.notes),
                dateAdded: added,
              ),
            );
      }
    });

    await _db.ensureIndexes();
  }

  CopyDraft _copyDraft(SeedCopy copy, Ownership ownership, DateTime now) =>
      CopyDraft(
        ownership: ownership,
        purchaseDate: copy.purchasedDaysAgo == null
            ? null
            : now.subtract(Duration(days: copy.purchasedDaysAgo!)),
        purchasePrice: copy.price,
        currency: copy.currency,
        store: copy.store,
        isGift: copy.isGift,
        giftFrom: copy.giftFrom,
        condition: copy.condition,
        location: copy.location,
        notes: copy.notes,
        tags: copy.tags,
      );

  /// Wipes every table. Used by "Reset sample library" in settings.
  Future<void> reset() async {
    await _db.transaction(() async {
      await _db.delete(_db.copyTags).go();
      await _db.delete(_db.copyPhotos).go();
      await _db.delete(_db.copies).go();
      await _db.delete(_db.readingEntries).go();
      await _db.delete(_db.wishlistItems).go();
      await _db.delete(_db.editions).go();
      await _db.delete(_db.works).go();
      await _db.delete(_db.tags).go();
      await _db.delete(_db.recentSearches).go();
    });
  }
}
