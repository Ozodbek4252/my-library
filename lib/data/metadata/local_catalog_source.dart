import '../../core/utils/isbn.dart';
import 'book_metadata.dart';
import 'local_catalog.dart';

/// Serves book metadata from the bundled catalogue. Always available, always
/// instant — which is what the bookstore flow needs when signal is poor.
class LocalCatalogSource implements BookMetadataRepository {
  const LocalCatalogSource();

  @override
  Future<BookMetadata> lookupByIsbn(String isbn) async {
    final normalized = Isbn.to13(isbn) ?? Isbn.normalize(isbn);
    final key = catalogByIsbn[normalized];
    if (key == null) {
      throw const MetadataException(MetadataFailure.notFound);
    }
    return localCatalog[key]!;
  }

  @override
  Future<List<BookMetadata>> search(String query, {int limit = 20}) async {
    final needle = query.trim().toLowerCase();
    if (needle.isEmpty) return const [];

    // An ISBN typed into the search field should resolve directly.
    final digits = Isbn.normalize(needle);
    if (digits.length >= 10 && Isbn.isValid(digits)) {
      try {
        return [await lookupByIsbn(digits)];
      } on MetadataException {
        return const [];
      }
    }

    final matches = localCatalog.values.where((b) {
      final haystack = [
        b.title,
        b.originalTitle ?? '',
        b.authors.join(' '),
        b.publisher ?? '',
        b.genres.join(' '),
        b.seriesName ?? '',
        b.isbn13 ?? '',
        b.isbn10 ?? '',
      ].join(' ').toLowerCase();
      return haystack.contains(needle);
    }).toList();

    // Title matches rank above author or publisher matches.
    matches.sort((a, b) {
      final aTitle = a.title.toLowerCase().contains(needle) ? 0 : 1;
      final bTitle = b.title.toLowerCase().contains(needle) ? 0 : 1;
      if (aTitle != bTitle) return aTitle - bTitle;
      return a.title.compareTo(b.title);
    });

    return matches.take(limit).toList();
  }
}
