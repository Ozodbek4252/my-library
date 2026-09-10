import 'package:drift/drift.dart';

import '../../domain/models/book_draft.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/library_models.dart';
import '../local/database.dart';
import 'collection_mutations.dart';

/// Books the user wants. Deliberately carries no price fields — this app does
/// not track prices or watch for deals.
class WishlistRepository {
  WishlistRepository(this._db);

  final AppDatabase _db;

  Stream<List<WishlistEntry>> watchWishlist({WishlistFilter? filter}) {
    final query = _db.select(_db.wishlistItems).join([
      innerJoin(_db.works, _db.works.id.equalsExp(_db.wishlistItems.workId)),
    ])
      ..orderBy([OrderingTerm.desc(_db.wishlistItems.dateAdded)]);

    if (filter != null) {
      switch (filter.kind) {
        case WishlistFilterKind.all:
          break;
        case WishlistFilterKind.priority:
          query.where(_db.wishlistItems.priority.equals(filter.value!));
        case WishlistFilterKind.language:
          query.where(_db.wishlistItems.desiredLanguage.equals(filter.value!));
        case WishlistFilterKind.format:
          query.where(_db.wishlistItems.desiredFormat.equals(filter.value!));
      }
    }

    return query.watch().map(
          (rows) => [
            for (final row in rows)
              WishlistEntry(
                item: row.readTable(_db.wishlistItems),
                work: row.readTable(_db.works),
                desiredEditionColor:
                    _colorFor(row.readTable(_db.works).id),
              ),
          ],
        );
  }

  Stream<WishlistEntry?> watchItem(String itemId) {
    final query = _db.select(_db.wishlistItems).join([
      innerJoin(_db.works, _db.works.id.equalsExp(_db.wishlistItems.workId)),
    ])
      ..where(_db.wishlistItems.id.equals(itemId));

    return query.watchSingleOrNull().map(
          (row) => row == null
              ? null
              : WishlistEntry(
                  item: row.readTable(_db.wishlistItems),
                  work: row.readTable(_db.works),
                  desiredEditionColor: _colorFor(row.readTable(_db.works).id),
                ),
        );
  }

  Future<WishlistItem?> itemForWork(String workId) =>
      (_db.select(_db.wishlistItems)..where((w) => w.workId.equals(workId)))
          .getSingleOrNull();

  /// The chip rail above the list: "All 7 · High 2 · English · Hardcover",
  /// derived from what is actually on the wishlist.
  Future<List<WishlistFilter>> availableFilters() async {
    final items = await _db.select(_db.wishlistItems).get();
    final filters = <WishlistFilter>[
      WishlistFilter.all(items.length),
    ];

    for (final priority in Priority.values) {
      final count = items.where((i) => i.priority == priority.name).length;
      if (count > 0) {
        filters.add(
          WishlistFilter(
            kind: WishlistFilterKind.priority,
            value: priority.name,
            label: '${priority.label} $count',
          ),
        );
      }
    }

    final languages = items
        .map((i) => i.desiredLanguage)
        .whereType<String>()
        .toSet()
        .toList()
      ..sort();
    for (final language in languages) {
      filters.add(
        WishlistFilter(
          kind: WishlistFilterKind.language,
          value: language,
          label: language,
        ),
      );
    }

    final formats = items
        .map((i) => i.desiredFormat)
        .whereType<String>()
        .toSet()
        .toList()
      ..sort();
    for (final format in formats) {
      filters.add(
        WishlistFilter(
          kind: WishlistFilterKind.format,
          value: format,
          label: format,
        ),
      );
    }

    return filters;
  }

  Stream<int> watchCount() {
    final count = _db.wishlistItems.id.count();
    final query = _db.selectOnly(_db.wishlistItems)..addColumns([count]);
    return query.map((row) => row.read(count) ?? 0).watchSingle();
  }

  /// Adds a book to the wishlist, creating the work first when it is not
  /// already known to the collection.
  Future<String> add({
    required BookDraft draft,
    String? desiredLanguage,
    String? desiredFormat,
    String? desiredEdition,
    Priority priority = Priority.medium,
    String? notes,
  }) async {
    return _db.transaction(() async {
      final now = DateTime.now();
      var workId = draft.workId;

      if (workId == null) {
        workId = newId();
        await _db.into(_db.works).insert(
              WorksCompanion.insert(
                id: workId,
                title: draft.title.trim(),
                authors: draft.authors,
                genres: draft.genres,
                originalTitle: Value(draft.originalTitle),
                originalLanguage: Value(draft.originalLanguage),
                description: Value(draft.description),
                seriesName: Value(draft.seriesName),
                seriesIndex: Value(draft.seriesIndex),
                firstPublished: Value(draft.firstPublished),
                createdAt: now,
                updatedAt: now,
              ),
            );
      }

      final existing = await (_db.select(_db.wishlistItems)
            ..where((w) => w.workId.equals(workId!)))
          .getSingleOrNull();
      if (existing != null) return existing.id;

      final id = newId();
      await _db.into(_db.wishlistItems).insert(
            WishlistItemsCompanion.insert(
              id: id,
              workId: workId,
              desiredLanguage: Value(desiredLanguage ?? draft.language),
              desiredFormat: Value(desiredFormat ?? draft.format),
              desiredEdition: Value(desiredEdition ?? draft.publisher),
              priority: Value(priority.name),
              notes: Value(notes),
              dateAdded: now,
            ),
          );
      return id;
    });
  }

  Future<void> update(
    String itemId, {
    String? desiredLanguage,
    String? desiredFormat,
    String? desiredEdition,
    Priority? priority,
    String? notes,
  }) =>
      (_db.update(_db.wishlistItems)..where((w) => w.id.equals(itemId))).write(
        WishlistItemsCompanion(
          desiredLanguage: Value(desiredLanguage),
          desiredFormat: Value(desiredFormat),
          desiredEdition: Value(desiredEdition),
          priority: priority == null ? const Value.absent() : Value(priority.name),
          notes: Value(notes),
        ),
      );

  /// Removing a wanted book also removes the placeholder work created for it,
  /// unless the user actually owns a copy.
  Future<void> remove(String itemId) async {
    await _db.transaction(() async {
      final item = await (_db.select(_db.wishlistItems)
            ..where((w) => w.id.equals(itemId)))
          .getSingleOrNull();
      if (item == null) return;

      await (_db.delete(_db.wishlistItems)..where((w) => w.id.equals(itemId))).go();

      final editionRows = await (_db.select(_db.editions)
            ..where((e) => e.workId.equals(item.workId)))
          .get();
      if (editionRows.isEmpty) {
        await (_db.delete(_db.works)..where((w) => w.id.equals(item.workId))).go();
      }
    });
  }

  /// Matches the placeholder colour a book would get once it is owned.
  static int _colorFor(String key) {
    var hash = 0x811C9DC5;
    for (final unit in key.codeUnits) {
      hash = (hash ^ unit) & 0xFFFFFFFF;
      hash = (hash * 0x01000193) & 0xFFFFFFFF;
    }
    return hash % 12;
  }
}

enum WishlistFilterKind { all, priority, language, format }

class WishlistFilter {
  const WishlistFilter({
    required this.kind,
    required this.label,
    this.value,
  });

  factory WishlistFilter.all(int count) =>
      WishlistFilter(kind: WishlistFilterKind.all, label: 'All $count');

  final WishlistFilterKind kind;
  final String label;
  final String? value;

  @override
  bool operator ==(Object other) =>
      other is WishlistFilter && other.kind == kind && other.value == value;

  @override
  int get hashCode => Object.hash(kind, value);
}
