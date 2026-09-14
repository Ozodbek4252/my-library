import 'dart:async';

import '../../core/utils/isbn.dart';
import '../../domain/models/book_draft.dart';
import '../../domain/models/library_models.dart';
import '../local/database.dart';
import '../metadata/book_metadata.dart';
import 'collection_mutations.dart';
import 'library_repository.dart';
import 'wishlist_repository.dart';

/// What a scan turned out to be. The five bookstore questions — do I own it,
/// which edition, have I read it, is it wishlisted, what are the details — are
/// all answered by one of these.
enum ScanVerdict {
  /// This exact ISBN is already on the shelves.
  ownedSameEdition,

  /// The work is owned, but not in this edition. Never a duplicate error.
  ownedOtherEdition,

  /// New to the collection.
  notInLibrary,
}

class ScanResult {
  const ScanResult({
    required this.isbn,
    required this.metadata,
    required this.verdict,
    this.details,
    this.matchedEdition,
    this.wishlistItem,
    this.enrichment = const EnrichmentResult([]),
  });

  final String isbn;

  /// The scanned edition, as described by the metadata provider.
  final BookMetadata metadata;
  final ScanVerdict verdict;

  /// The work in the collection, when there is one.
  final BookDetails? details;

  /// The exact edition row this ISBN matched, for [ScanVerdict.ownedSameEdition].
  final Edition? matchedEdition;

  final WishlistItem? wishlistItem;

  /// What this scan was able to add to a record that was already on file.
  final EnrichmentResult enrichment;

  bool get isOwned => verdict != ScanVerdict.notInLibrary;
  bool get isWishlisted => wishlistItem != null;

  BookDraft toDraft() {
    final draft = metadata.toDraft();
    // Reuse the existing work so a new edition attaches to it rather than
    // creating a second "1984".
    draft.workId = details?.work.id;
    draft.editionId = matchedEdition?.id;
    return draft;
  }
}

enum ScanFailureKind { invalidBarcode, notFound, network, unknown }

class ScanFailure implements Exception {
  const ScanFailure(this.kind, {this.isbn});
  final ScanFailureKind kind;
  final String? isbn;
}

/// Turns a barcode into a verdict: ISBN → edition → work → the user's shelves.
class ScanService {
  /// How long a gap-filling lookup may take before the verdict is shown
  /// without it. Deliberately shorter than a first-time lookup: there is
  /// nothing to wait for, only something to gain.
  static const enrichmentTimeout = Duration(seconds: 2);

  ScanService({
    required BookMetadataRepository metadata,
    required LibraryRepository library,
    required WishlistRepository wishlist,
  })  : _metadata = metadata,
        _library = library,
        _wishlist = wishlist;

  final BookMetadataRepository _metadata;
  final LibraryRepository _library;
  final WishlistRepository _wishlist;

  /// Resolves a raw barcode payload. Throws [ScanFailure] for every path the
  /// scanner UI has a distinct state for.
  Future<ScanResult> resolveBarcode(String rawBarcode) async {
    final isbn = Isbn.fromBarcode(rawBarcode);
    if (isbn == null) {
      throw const ScanFailure(ScanFailureKind.invalidBarcode);
    }
    return resolveIsbn(isbn);
  }

  Future<ScanResult> resolveIsbn(String rawIsbn) async {
    final isbn = Isbn.to13(rawIsbn) ?? Isbn.normalize(rawIsbn);
    if (!Isbn.isValid(isbn)) {
      throw ScanFailure(ScanFailureKind.invalidBarcode, isbn: rawIsbn);
    }

    // The collection is checked first: an ISBN already on the shelves needs no
    // network round trip at all, which is what makes the bookstore flow fast.
    var localEdition = await _library.findEditionByIsbn(isbn);
    if (localEdition != null) {
      var details = await _library.bookDetails(localEdition.workId);
      var enrichment = const EnrichmentResult([]);

      // A thin record is worth a lookup: whatever it is missing — a cover, the
      // page count, the year — can be filled in from what the scan finds.
      // A complete one never touches the network.
      if (details != null && _library.hasGaps(details.work, localEdition)) {
        try {
          // The verdict does not depend on this lookup — the book is already
          // on the shelves. Topping up its record must never be what keeps
          // someone standing in a bookshop waiting, so it gets a short leash.
          final found = await _metadata
              .lookupByIsbn(isbn)
              .timeout(enrichmentTimeout);
          enrichment = await _library.fillGaps(
            workId: details.work.id,
            editionId: localEdition.id,
            found: found,
          );
          if (enrichment.isNotEmpty) {
            localEdition =
                await _library.editionById(localEdition.id) ?? localEdition;
            details = await _library.bookDetails(localEdition.workId);
          }
        } catch (_) {
          // Offline, or the provider has nothing. The book is still on the
          // shelves and the verdict below is unaffected.
        }
      }

      // Settled now, so the closures below see a value that cannot change.
      final matched = localEdition!;
      final metadata =
          await _metadataFor(isbn, fallback: details, edition: matched);

      // Knowing an edition is not the same as owning it: it may be one the
      // user wishlisted, or one they used to own. Only a copy marked owned
      // makes this "you already own this book".
      final ownsThisEdition = details?.editions
              .where((e) => e.edition.id == matched.id)
              .any((e) => e.isOwned) ??
          false;
      final ownsTheWork = details?.isOwned ?? false;

      return ScanResult(
        isbn: isbn,
        metadata: metadata,
        verdict: ownsThisEdition
            ? ScanVerdict.ownedSameEdition
            : ownsTheWork
                ? ScanVerdict.ownedOtherEdition
                : ScanVerdict.notInLibrary,
        details: details,
        matchedEdition: matched,
        wishlistItem: details?.wishlistItem,
        enrichment: enrichment,
      );
    }

    final BookMetadata metadata;
    try {
      metadata = await _metadata.lookupByIsbn(isbn);
    } on MetadataException catch (e) {
      throw ScanFailure(
        switch (e.failure) {
          MetadataFailure.notFound => ScanFailureKind.notFound,
          MetadataFailure.network => ScanFailureKind.network,
          MetadataFailure.invalidIsbn => ScanFailureKind.invalidBarcode,
          MetadataFailure.unknown => ScanFailureKind.unknown,
        },
        isbn: isbn,
      );
    } catch (_) {
      throw ScanFailure(ScanFailureKind.unknown, isbn: isbn);
    }

    // Same work, different edition — matched on title plus author, never on
    // title alone.
    final work =
        await _library.findWorkByTitleAuthor(metadata.title, metadata.authors);
    if (work != null) {
      var details = await _library.bookDetails(work.id);
      var enrichment = const EnrichmentResult([]);
      Edition? matched;

      // The book may already be here, recorded without its ISBN. If exactly
      // one edition fits what was scanned, this scan is what that record was
      // missing — including the ISBN that would have matched it outright.
      final mergeable = await _library.findMergeableEdition(work.id, metadata);
      if (mergeable != null) {
        enrichment = await _library.fillGaps(
          workId: work.id,
          editionId: mergeable.id,
          found: metadata,
        );
        matched = await _library.editionById(mergeable.id) ?? mergeable;
        details = await _library.bookDetails(work.id);
      }

      final ownsTheWork = details?.isOwned ?? false;
      final ownsMatched = matched != null &&
          (details?.editions
                  .where((e) => e.edition.id == matched!.id)
                  .any((e) => e.isOwned) ??
              false);

      return ScanResult(
        isbn: isbn,
        metadata: metadata,
        verdict: ownsMatched
            ? ScanVerdict.ownedSameEdition
            : ownsTheWork
                ? ScanVerdict.ownedOtherEdition
                : ScanVerdict.notInLibrary,
        details: details,
        matchedEdition: matched,
        wishlistItem: details?.wishlistItem ?? await _wishlist.itemForWork(work.id),
        enrichment: enrichment,
      );
    }

    return ScanResult(
      isbn: isbn,
      metadata: metadata,
      verdict: ScanVerdict.notInLibrary,
    );
  }

  /// For a book already on the shelves, the stored row is the better source of
  /// truth than a fresh lookup — and it needs no network.
  Future<BookMetadata> _metadataFor(
    String isbn, {
    BookDetails? fallback,
    Edition? edition,
  }) async {
    if (fallback != null && edition != null) {
      final work = fallback.work;
      return BookMetadata(
        title: work.title,
        authors: work.authors,
        genres: work.genres,
        description: work.description,
        originalTitle: work.originalTitle,
        originalLanguage: work.originalLanguage,
        seriesName: work.seriesName,
        seriesIndex: work.seriesIndex,
        firstPublished: work.firstPublished,
        isbn13: edition.isbn13,
        isbn10: edition.isbn10,
        publisher: edition.publisher,
        publicationDate: edition.publicationDate,
        publishedYear: edition.publishedYear,
        language: edition.language,
        format: edition.format,
        editionName: edition.editionName,
        pageCount: edition.pageCount,
        coverUrl: edition.coverUrl,
        dimensions: edition.dimensions,
        weightGrams: edition.weightGrams,
        translator: edition.translator,
        illustrators: edition.illustrators,
        country: edition.country,
      );
    }
    return _metadata.lookupByIsbn(isbn);
  }
}
