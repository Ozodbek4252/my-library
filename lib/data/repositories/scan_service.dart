import '../../core/utils/isbn.dart';
import '../../domain/models/book_draft.dart';
import '../../domain/models/library_models.dart';
import '../local/database.dart';
import '../metadata/book_metadata.dart';
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

  String get title => switch (kind) {
        ScanFailureKind.invalidBarcode => "Couldn't read that barcode",
        ScanFailureKind.notFound => "We don't know that ISBN",
        ScanFailureKind.network => 'No connection',
        ScanFailureKind.unknown => 'Something went wrong',
      };

  String get message => switch (kind) {
        ScanFailureKind.invalidBarcode =>
          'Low light, or the code may be creased. Try again, or type the 13 '
              'digits printed under it.',
        ScanFailureKind.notFound =>
          'No book matches ${isbn ?? 'that code'}. It may be a local printing. '
              'You can still add it by hand.',
        ScanFailureKind.network =>
          "We couldn't reach the book lookup. Your library still works "
              'offline — try again, or enter the details yourself.',
        ScanFailureKind.unknown =>
          'The lookup failed unexpectedly. Try again, or enter the details '
              'yourself.',
      };
}

/// Turns a barcode into a verdict: ISBN → edition → work → the user's shelves.
class ScanService {
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
    final localEdition = await _library.findEditionByIsbn(isbn);
    if (localEdition != null) {
      final details = await _library.bookDetails(localEdition.workId);
      final metadata = await _metadataFor(isbn, fallback: details, edition: localEdition);
      return ScanResult(
        isbn: isbn,
        metadata: metadata,
        verdict: ScanVerdict.ownedSameEdition,
        details: details,
        matchedEdition: localEdition,
        wishlistItem: details?.wishlistItem,
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
      final details = await _library.bookDetails(work.id);
      final owned = details?.isOwned ?? false;
      return ScanResult(
        isbn: isbn,
        metadata: metadata,
        verdict:
            owned ? ScanVerdict.ownedOtherEdition : ScanVerdict.notInLibrary,
        details: details,
        wishlistItem: details?.wishlistItem ?? await _wishlist.itemForWork(work.id),
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
