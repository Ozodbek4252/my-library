import '../../domain/models/book_draft.dart';

/// A book description returned by an external provider. Deliberately plain:
/// nothing here is tied to a particular API's response shape.
class BookMetadata {
  const BookMetadata({
    required this.title,
    required this.authors,
    this.originalTitle,
    this.originalLanguage,
    this.description,
    this.genres = const [],
    this.seriesName,
    this.seriesIndex,
    this.firstPublished,
    this.isbn13,
    this.isbn10,
    this.publisher,
    this.publicationDate,
    this.publishedYear,
    this.language,
    this.format,
    this.editionName,
    this.pageCount,
    this.coverUrl,
    this.dimensions,
    this.weightGrams,
    this.translator,
    this.illustrators = const [],
    this.country,
  });

  final String title;
  final List<String> authors;
  final String? originalTitle;
  final String? originalLanguage;
  final String? description;
  final List<String> genres;
  final String? seriesName;
  final int? seriesIndex;
  final int? firstPublished;

  final String? isbn13;
  final String? isbn10;
  final String? publisher;
  final String? publicationDate;
  final int? publishedYear;
  final String? language;
  final String? format;
  final String? editionName;
  final int? pageCount;
  final String? coverUrl;
  final String? dimensions;
  final double? weightGrams;
  final String? translator;
  final List<String> illustrators;
  final String? country;

  BookDraft toDraft() => BookDraft(
        title: title,
        authors: [...authors],
        originalTitle: originalTitle,
        originalLanguage: originalLanguage,
        description: description,
        genres: [...genres],
        seriesName: seriesName,
        seriesIndex: seriesIndex,
        firstPublished: firstPublished,
        isbn13: isbn13,
        isbn10: isbn10,
        publisher: publisher,
        publicationDate: publicationDate,
        publishedYear: publishedYear,
        language: language,
        format: format,
        editionName: editionName,
        pageCount: pageCount,
        coverUrl: coverUrl,
        coverColorIndex: _colorFor(isbn13 ?? isbn10 ?? title),
        dimensions: dimensions,
        weightGrams: weightGrams,
        translator: translator,
        illustrators: [...illustrators],
        country: country,
      );

  /// Stable placeholder colour so a book without artwork looks the same on
  /// every launch and on every device.
  static int _colorFor(String key) {
    var hash = 0;
    for (final unit in key.codeUnits) {
      hash = (hash * 31 + unit) & 0x7FFFFFFF;
    }
    return hash % 12;
  }
}

/// Why a lookup could not produce a book. The scanner shows a different sheet
/// for each of these, so they must stay distinguishable.
enum MetadataFailure { notFound, network, invalidIsbn, unknown }

class MetadataException implements Exception {
  const MetadataException(this.failure, [this.message]);
  final MetadataFailure failure;
  final String? message;

  @override
  String toString() => 'MetadataException($failure, $message)';
}

/// Where book metadata comes from. The app depends on this interface only, so
/// swapping Open Library for another provider — or for a bundled catalogue —
/// changes nothing above this line.
abstract interface class BookMetadataRepository {
  /// Resolves an ISBN to a single edition. Throws [MetadataException] with
  /// [MetadataFailure.notFound] when the provider has no record of it.
  Future<BookMetadata> lookupByIsbn(String isbn);

  /// Free-text search used by "Search all editions".
  Future<List<BookMetadata>> search(String query, {int limit = 20});
}
