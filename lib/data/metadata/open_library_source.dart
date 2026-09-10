import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/utils/isbn.dart';
import 'book_metadata.dart';

/// Open Library needs no API key, which is why it is the default remote
/// provider. Swapping in Google Books or a paid provider means writing another
/// [BookMetadataRepository] — nothing else in the app changes.
class OpenLibrarySource implements BookMetadataRepository {
  OpenLibrarySource({http.Client? client, this.timeout = const Duration(seconds: 6)})
      : _client = client ?? http.Client();

  final http.Client _client;
  final Duration timeout;

  static final _base = Uri.https('openlibrary.org');

  @override
  Future<BookMetadata> lookupByIsbn(String isbn) async {
    final normalized = Isbn.to13(isbn) ?? Isbn.normalize(isbn);
    if (!Isbn.isValid(normalized)) {
      throw const MetadataException(MetadataFailure.invalidIsbn);
    }

    final uri = _base.replace(
      path: '/api/books',
      queryParameters: {
        'bibkeys': 'ISBN:$normalized',
        'format': 'json',
        'jscmd': 'data',
      },
    );

    final json = await _getJson(uri);
    final entry = json['ISBN:$normalized'];
    if (entry is! Map<String, dynamic>) {
      throw const MetadataException(MetadataFailure.notFound);
    }
    return _parse(entry, normalized);
  }

  @override
  Future<List<BookMetadata>> search(String query, {int limit = 20}) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return const [];

    final digits = Isbn.normalize(trimmed);
    if (digits.length >= 10 && Isbn.isValid(digits)) {
      try {
        return [await lookupByIsbn(digits)];
      } on MetadataException catch (e) {
        if (e.failure == MetadataFailure.notFound) return const [];
        rethrow;
      }
    }

    final uri = _base.replace(
      path: '/search.json',
      queryParameters: {
        'q': trimmed,
        'limit': '$limit',
        'fields': 'title,author_name,first_publish_year,isbn,publisher,'
            'number_of_pages_median,language,subject,cover_i',
      },
    );

    final json = await _getJson(uri);
    final docs = json['docs'];
    if (docs is! List) return const [];

    return docs
        .whereType<Map<String, dynamic>>()
        .map(_parseSearchDoc)
        .whereType<BookMetadata>()
        .toList();
  }

  Future<Map<String, dynamic>> _getJson(Uri uri) async {
    try {
      final response = await _client.get(uri).timeout(timeout);
      if (response.statusCode == 404) {
        throw const MetadataException(MetadataFailure.notFound);
      }
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw MetadataException(
          MetadataFailure.network,
          'HTTP ${response.statusCode}',
        );
      }
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (decoded is! Map<String, dynamic>) {
        throw const MetadataException(MetadataFailure.unknown);
      }
      return decoded;
    } on MetadataException {
      rethrow;
    } on TimeoutException {
      throw const MetadataException(MetadataFailure.network, 'Timed out');
    } on FormatException {
      throw const MetadataException(MetadataFailure.unknown, 'Bad response');
    } catch (e) {
      throw MetadataException(MetadataFailure.network, e.toString());
    }
  }

  BookMetadata _parse(Map<String, dynamic> data, String isbn13) {
    List<String> names(String key) => (data[key] as List?)
            ?.whereType<Map>()
            .map((e) => e['name']?.toString())
            .whereType<String>()
            .toList() ??
        const [];

    final identifiers = data['identifiers'];
    String? firstIdentifier(String key) {
      if (identifiers is! Map) return null;
      final list = identifiers[key];
      return list is List && list.isNotEmpty ? list.first.toString() : null;
    }

    final published = data['publish_date']?.toString();
    return BookMetadata(
      title: data['title']?.toString() ?? 'Untitled',
      authors: names('authors'),
      description: _description(data),
      genres: names('subjects').take(3).toList(),
      firstPublished: _year(published),
      isbn13: firstIdentifier('isbn_13') ?? isbn13,
      isbn10: firstIdentifier('isbn_10') ?? Isbn.to10(isbn13),
      publisher: names('publishers').firstOrNull,
      publicationDate: published,
      publishedYear: _year(published),
      pageCount: (data['number_of_pages'] as num?)?.toInt(),
      coverUrl: _cover(data['cover']),
      country: names('publish_places').firstOrNull,
    );
  }

  BookMetadata? _parseSearchDoc(Map<String, dynamic> doc) {
    final title = doc['title']?.toString();
    if (title == null) return null;

    final isbns = (doc['isbn'] as List?)?.map((e) => e.toString()).toList();
    final isbn13 = isbns?.firstWhere(
      (e) => Isbn.normalize(e).length == 13,
      orElse: () => isbns.isEmpty ? '' : isbns.first,
    );
    final coverId = doc['cover_i'];

    return BookMetadata(
      title: title,
      authors: (doc['author_name'] as List?)?.map((e) => e.toString()).toList() ??
          const [],
      genres:
          (doc['subject'] as List?)?.take(3).map((e) => e.toString()).toList() ??
              const [],
      firstPublished: (doc['first_publish_year'] as num?)?.toInt(),
      isbn13: isbn13 != null && isbn13.isNotEmpty
          ? Isbn.to13(isbn13) ?? isbn13
          : null,
      publisher: (doc['publisher'] as List?)?.firstOrNull?.toString(),
      publishedYear: (doc['first_publish_year'] as num?)?.toInt(),
      language: (doc['language'] as List?)?.firstOrNull?.toString(),
      pageCount: (doc['number_of_pages_median'] as num?)?.toInt(),
      coverUrl: coverId == null
          ? null
          : 'https://covers.openlibrary.org/b/id/$coverId-L.jpg',
    );
  }

  /// `jscmd=data` has no description field; the nearest thing is an excerpt.
  String? _description(Map<String, dynamic> data) {
    final notes = data['notes']?.toString();
    if (notes != null && notes.trim().isNotEmpty) return notes;
    final excerpts = data['excerpts'];
    if (excerpts is List) {
      for (final e in excerpts) {
        if (e is Map && e['text'] != null) return e['text'].toString();
      }
    }
    return null;
  }

  String? _cover(Object? cover) {
    if (cover is! Map) return null;
    return (cover['large'] ?? cover['medium'] ?? cover['small'])?.toString();
  }

  /// Releases the underlying HTTP client.
  void close() => _client.close();

  int? _year(String? value) {
    if (value == null) return null;
    final match = RegExp(r'(1[5-9]\d{2}|20\d{2})').firstMatch(value);
    return match == null ? null : int.tryParse(match.group(1)!);
  }
}

extension<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
