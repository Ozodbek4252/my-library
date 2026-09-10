import 'dart:math';

import 'package:drift/drift.dart';

import '../../domain/models/book_draft.dart';
import '../../domain/models/enums.dart';
import '../local/database.dart';

String newId() {
  final rand = Random();
  final now = DateTime.now().microsecondsSinceEpoch.toRadixString(36);
  final salt = rand.nextInt(1 << 32).toRadixString(36).padLeft(7, '0');
  return '$now$salt';
}

/// Writes to the collection. Split from the read side purely for file size —
/// both halves speak to the same database and the same domain rules.
extension CollectionMutations on AppDatabase {
  /// Adds a book, reusing the work and the edition when they already exist.
  ///
  /// This is where duplicate handling lives: an ISBN that is already on the
  /// shelves adds another *copy*; a new ISBN for a known title adds another
  /// *edition*. Nothing is ever rejected as a duplicate.
  Future<AddBookResult> addBook(BookDraft draft, {CopyDraft? copyDetails}) async {
    return transaction(() async {
      final now = DateTime.now();

      // 1. The work.
      var workId = draft.workId;
      var createdWork = false;
      if (workId == null) {
        workId = newId();
        createdWork = true;
        await into(works).insert(
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
            readingStatus: Value(draft.readingStatus.name),
            createdAt: now,
            updatedAt: now,
          ),
        );
      }

      // 2. The edition.
      var editionId = draft.editionId;
      var createdEdition = false;
      if (editionId == null) {
        editionId = newId();
        createdEdition = true;
        await into(editions).insert(
          EditionsCompanion.insert(
            id: editionId,
            workId: workId,
            isbn13: Value(draft.isbn13),
            isbn10: Value(draft.isbn10),
            publisher: Value(draft.publisher),
            publicationDate: Value(draft.publicationDate),
            publishedYear: Value(draft.publishedYear),
            language: Value(draft.language),
            format: Value(draft.format),
            editionName: Value(draft.editionName),
            pageCount: Value(draft.pageCount),
            coverUrl: Value(draft.coverUrl),
            coverColorIndex: Value(draft.coverColorIndex),
            dimensions: Value(draft.dimensions),
            weightGrams: Value(draft.weightGrams),
            translator: Value(draft.translator),
            illustrators: draft.illustrators,
            country: Value(draft.country),
            createdAt: now,
          ),
        );
      }

      // 3. The copy.
      final details = copyDetails ?? CopyDraft(ownership: draft.ownership);
      final copyId = await _insertCopy(editionId, details, now);

      // A work shows the edition of its first owned copy.
      final work = await (select(works)..where((w) => w.id.equals(workId!)))
          .getSingleOrNull();
      if (work?.primaryEditionId == null) {
        await (update(works)..where((w) => w.id.equals(workId!)))
            .write(WorksCompanion(primaryEditionId: Value(editionId), updatedAt: Value(now)));
      }

      // Adding a wishlisted book clears it from the wishlist.
      var clearedWishlist = false;
      if (details.ownership == Ownership.owned) {
        final deleted = await (delete(wishlistItems)
              ..where((w) => w.workId.equals(workId!)))
            .go();
        clearedWishlist = deleted > 0;
      }

      return AddBookResult(
        workId: workId,
        editionId: editionId,
        copyId: copyId,
        createdWork: createdWork,
        createdEdition: createdEdition,
        clearedWishlist: clearedWishlist,
      );
    });
  }

  Future<String> _insertCopy(String editionId, CopyDraft details, DateTime now) async {
    final copyId = details.id ?? newId();
    await into(copies).insert(
      CopiesCompanion.insert(
        id: copyId,
        editionId: editionId,
        ownership: Value(details.ownership.name),
        purchaseDate: Value(details.purchaseDate),
        purchasePrice: Value(details.purchasePrice),
        currency: Value(details.currency),
        store: Value(details.store),
        isGift: Value(details.isGift),
        giftFrom: Value(details.giftFrom),
        condition: Value(details.condition?.name),
        location: Value(details.location),
        notes: Value(details.notes),
        addedDate: now,
      ),
    );
    if (details.tags.isNotEmpty) await setCopyTags(copyId, details.tags);
    return copyId;
  }

  /// Adds another physical copy of an edition already on the shelves.
  Future<String> addCopyToEdition(String editionId, CopyDraft details) =>
      transaction(() => _insertCopy(editionId, details, DateTime.now()));

  /// Saves edits to the work and, when the draft carries one, its edition.
  Future<void> saveDraft(BookDraft draft) async {
    final workId = draft.workId;
    if (workId == null) return;
    await transaction(() async {
      await (update(works)..where((w) => w.id.equals(workId))).write(
        WorksCompanion(
          title: Value(draft.title.trim()),
          authors: Value(draft.authors),
          genres: Value(draft.genres),
          originalTitle: Value(draft.originalTitle),
          originalLanguage: Value(draft.originalLanguage),
          description: Value(draft.description),
          seriesName: Value(draft.seriesName),
          seriesIndex: Value(draft.seriesIndex),
          firstPublished: Value(draft.firstPublished),
          readingStatus: Value(draft.readingStatus.name),
          updatedAt: Value(DateTime.now()),
        ),
      );

      final editionId = draft.editionId;
      if (editionId == null) return;
      await (update(editions)..where((e) => e.id.equals(editionId))).write(
        EditionsCompanion(
          isbn13: Value(draft.isbn13),
          isbn10: Value(draft.isbn10),
          publisher: Value(draft.publisher),
          publicationDate: Value(draft.publicationDate),
          publishedYear: Value(draft.publishedYear),
          language: Value(draft.language),
          format: Value(draft.format),
          editionName: Value(draft.editionName),
          pageCount: Value(draft.pageCount),
          coverUrl: Value(draft.coverUrl),
          dimensions: Value(draft.dimensions),
          weightGrams: Value(draft.weightGrams),
          translator: Value(draft.translator),
          illustrators: Value(draft.illustrators),
          country: Value(draft.country),
        ),
      );
    });
  }

  Future<void> saveCopy(CopyDraft details) async {
    final copyId = details.id;
    if (copyId == null) return;
    await transaction(() async {
      await (update(copies)..where((c) => c.id.equals(copyId))).write(
        CopiesCompanion(
          ownership: Value(details.ownership.name),
          purchaseDate: Value(details.purchaseDate),
          purchasePrice: Value(details.purchasePrice),
          currency: Value(details.currency),
          store: Value(details.store),
          isGift: Value(details.isGift),
          giftFrom: Value(details.giftFrom),
          condition: Value(details.condition?.name),
          location: Value(details.location),
          notes: Value(details.notes),
        ),
      );
      await setCopyTags(copyId, details.tags);
    });
  }

  /// Removes one physical copy. An edition with no copies left goes with it,
  /// and so does a work with no editions and nothing wanting it — but every
  /// other edition of the work survives, as the confirm dialog promises.
  Future<RemoveCopyResult> removeCopy(String copyId) async {
    return transaction(() async {
      final copy = await (select(copies)..where((c) => c.id.equals(copyId)))
          .getSingleOrNull();
      if (copy == null) {
        return const RemoveCopyResult(
          removedEdition: false,
          removedWork: false,
          remainingEditions: 0,
        );
      }

      final edition = await (select(editions)
            ..where((e) => e.id.equals(copy.editionId)))
          .getSingleOrNull();
      final workId = edition?.workId;

      await (delete(copies)..where((c) => c.id.equals(copyId))).go();

      var removedEdition = false;
      final siblings = await (select(copies)
            ..where((c) => c.editionId.equals(copy.editionId)))
          .get();
      if (siblings.isEmpty) {
        await (delete(editions)..where((e) => e.id.equals(copy.editionId))).go();
        removedEdition = true;
      }

      if (workId == null) {
        return RemoveCopyResult(
          removedEdition: removedEdition,
          removedWork: false,
          remainingEditions: 0,
        );
      }

      final remaining = await (select(editions)
            ..where((e) => e.workId.equals(workId)))
          .get();

      final wish = await (select(wishlistItems)
            ..where((w) => w.workId.equals(workId)))
          .getSingleOrNull();

      if (remaining.isEmpty && wish == null) {
        await (delete(works)..where((w) => w.id.equals(workId))).go();
        return RemoveCopyResult(
          removedEdition: removedEdition,
          removedWork: true,
          remainingEditions: 0,
          workId: workId,
        );
      }

      // Keep the display edition pointing at something that still exists.
      final work =
          await (select(works)..where((w) => w.id.equals(workId))).getSingleOrNull();
      if (work != null &&
          (work.primaryEditionId == null ||
              !remaining.any((e) => e.id == work.primaryEditionId))) {
        await (update(works)..where((w) => w.id.equals(workId))).write(
          WorksCompanion(
            primaryEditionId: Value(remaining.isEmpty ? null : remaining.first.id),
            updatedAt: Value(DateTime.now()),
          ),
        );
      }

      return RemoveCopyResult(
        removedEdition: removedEdition,
        removedWork: false,
        remainingEditions: remaining.length,
        workId: workId,
      );
    });
  }

  Future<void> setPrimaryEdition(String workId, String editionId) =>
      (update(works)..where((w) => w.id.equals(workId))).write(
        WorksCompanion(
          primaryEditionId: Value(editionId),
          updatedAt: Value(DateTime.now()),
        ),
      );

  // ------------------------------------------------------------------- tags

  Future<void> setCopyTags(String copyId, List<String> names) async {
    await transaction(() async {
      await (delete(copyTags)..where((t) => t.copyId.equals(copyId))).go();
      for (final raw in names) {
        final name = raw.trim().replaceFirst(RegExp(r'^#'), '');
        if (name.isEmpty) continue;
        final existing =
            await (select(tags)..where((t) => t.name.equals(name))).getSingleOrNull();
        final tagId = existing?.id ?? newId();
        if (existing == null) {
          await into(tags).insert(TagsCompanion.insert(id: tagId, name: name));
        }
        await into(copyTags).insert(
          CopyTagsCompanion.insert(copyId: copyId, tagId: tagId),
          mode: InsertMode.insertOrIgnore,
        );
      }
    });
  }

  // ----------------------------------------------------------------- photos

  Future<void> addCopyPhoto(String copyId, String path, PhotoType type) =>
      into(copyPhotos).insert(
        CopyPhotosCompanion.insert(
          id: newId(),
          copyId: copyId,
          path: path,
          type: Value(type.name),
          addedAt: DateTime.now(),
        ),
      );

  Future<void> removeCopyPhoto(String photoId) =>
      (delete(copyPhotos)..where((p) => p.id.equals(photoId))).go();
}

class AddBookResult {
  const AddBookResult({
    required this.workId,
    required this.editionId,
    required this.copyId,
    required this.createdWork,
    required this.createdEdition,
    required this.clearedWishlist,
  });

  final String workId;
  final String editionId;
  final String copyId;
  final bool createdWork;
  final bool createdEdition;
  final bool clearedWishlist;
}

class RemoveCopyResult {
  const RemoveCopyResult({
    required this.removedEdition,
    required this.removedWork,
    required this.remainingEditions,
    this.workId,
  });

  final bool removedEdition;
  final bool removedWork;
  final int remainingEditions;
  final String? workId;

  /// "Copy removed · 1 edition left"
  String get toastMessage {
    if (removedWork) return 'Removed from your library';
    if (!removedEdition) return 'Copy removed';
    return remainingEditions == 1
        ? 'Copy removed · 1 edition left'
        : 'Copy removed · $remainingEditions editions left';
  }
}
