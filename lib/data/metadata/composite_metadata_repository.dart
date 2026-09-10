import 'book_metadata.dart';

/// Tries each source in order and returns the first usable answer.
///
/// The bundled catalogue goes first: it answers instantly and works with no
/// signal, which is exactly the situation the bookstore flow is designed for.
/// A remote provider fills the gaps. Results are memoised for the session so
/// re-scanning the same shelf costs nothing.
class CompositeBookMetadataRepository implements BookMetadataRepository {
  CompositeBookMetadataRepository(this._sources);

  final List<BookMetadataRepository> _sources;
  final Map<String, BookMetadata> _isbnCache = {};

  @override
  Future<BookMetadata> lookupByIsbn(String isbn) async {
    final cached = _isbnCache[isbn];
    if (cached != null) return cached;

    MetadataException? lastFailure;
    for (final source in _sources) {
      try {
        final result = await source.lookupByIsbn(isbn);
        _isbnCache[isbn] = result;
        return result;
      } on MetadataException catch (e) {
        // An invalid ISBN is the caller's problem, not the provider's — no
        // other source will do better.
        if (e.failure == MetadataFailure.invalidIsbn) rethrow;
        lastFailure = e;
      } catch (e) {
        lastFailure = MetadataException(MetadataFailure.unknown, e.toString());
      }
    }
    throw lastFailure ?? const MetadataException(MetadataFailure.notFound);
  }

  @override
  Future<List<BookMetadata>> search(String query, {int limit = 20}) async {
    final results = <BookMetadata>[];
    final seen = <String>{};
    MetadataException? lastFailure;

    for (final source in _sources) {
      try {
        for (final item in await source.search(query, limit: limit)) {
          final key = item.isbn13 ?? '${item.title}|${item.authors.join(',')}';
          if (seen.add(key)) results.add(item);
        }
      } on MetadataException catch (e) {
        lastFailure = e;
      } catch (e) {
        lastFailure = MetadataException(MetadataFailure.unknown, e.toString());
      }
      if (results.length >= limit) break;
    }

    // Only surface a failure when nothing at all came back.
    if (results.isEmpty && lastFailure != null) throw lastFailure;
    return results.take(limit).toList();
  }
}
