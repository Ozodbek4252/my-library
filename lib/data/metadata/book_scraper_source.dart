import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../../core/utils/isbn.dart';
import 'book_metadata.dart';

/// The project's own lookup service — a database of Uzbek books that carries
/// ISBNs the big providers do not have.
///
/// Three endpoints:
///   GET  /api/v1/books?q=…      typo-tolerant search across both alphabets
///   GET  /api/v1/books/{isbn}   barcode lookup
///   POST /api/v1/books/suggestions   a book a user could not find
class BookScraperSource implements BookMetadataRepository {
  BookScraperSource({
    required this.baseUrl,
    http.Client? client,
    this.token,
    this.timeout = const Duration(seconds: 5),
  }) : _client = client ?? http.Client();

  /// Root of the service. Either form works — `https://example.com` or
  /// `https://example.com/api/v1` — because both are natural things to be
  /// handed, and appending the prefix twice is a silent 404.
  final String baseUrl;

  /// Sanctum token, when the service has auth switched on.
  final String? token;

  final Duration timeout;
  final http.Client _client;

  bool get isConfigured => baseUrl.trim().isNotEmpty;

  Uri _uri(String path, [Map<String, String>? query]) {
    var root = baseUrl.trim().replaceAll(RegExp(r'/+$'), '');
    if (!root.endsWith('/api/v1')) root = '$root/api/v1';
    return Uri.parse('$root$path').replace(queryParameters: query);
  }

  Map<String, String> get _headers => {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        if (token != null && token!.isNotEmpty) 'Authorization': 'Bearer $token',
      };

  @override
  Future<BookMetadata> lookupByIsbn(String isbn) async {
    if (!isConfigured) {
      throw const MetadataException(MetadataFailure.notFound, 'No base URL');
    }

    final normalized = Isbn.to13(isbn) ?? Isbn.normalize(isbn);
    if (!Isbn.isValid(normalized)) {
      throw const MetadataException(MetadataFailure.invalidIsbn);
    }

    final response = await _get(_uri('/books/$normalized'));

    // The service answers 404 with the ISBN it normalised to, and 422 when the
    // check digit fails — both are answers, not transport failures.
    if (response.statusCode == 404) {
      throw const MetadataException(MetadataFailure.notFound);
    }
    if (response.statusCode == 422) {
      throw const MetadataException(MetadataFailure.invalidIsbn);
    }
    if (response.statusCode != 200) {
      throw MetadataException(
        MetadataFailure.network,
        'HTTP ${response.statusCode}',
      );
    }

    final body = _decode(response);
    final data = body['data'] ?? body;
    if (data is! Map<String, dynamic>) {
      throw const MetadataException(MetadataFailure.unknown, 'Bad response');
    }
    return _parse(data);
  }

  @override
  Future<List<BookMetadata>> search(String query, {int limit = 20}) async {
    if (!isConfigured) return const [];

    final trimmed = query.trim();
    if (trimmed.isEmpty) return const [];

    // A scanned or typed ISBN should resolve to the one book, not to a search.
    final digits = Isbn.normalize(trimmed);
    if (digits.length >= 10 && Isbn.isValid(digits)) {
      try {
        return [await lookupByIsbn(digits)];
      } on MetadataException catch (e) {
        if (e.failure == MetadataFailure.notFound) return const [];
        rethrow;
      }
    }

    final response = await _get(
      _uri('/books', {'q': trimmed, 'per_page': '${limit.clamp(1, 100)}'}),
    );
    if (response.statusCode != 200) {
      throw MetadataException(
        MetadataFailure.network,
        'HTTP ${response.statusCode}',
      );
    }

    final body = _decode(response);
    final data = body['data'];
    if (data is! List) return const [];

    return data
        .whereType<Map<String, dynamic>>()
        .map(_parse)
        .toList();
  }

  /// Sends a book the user could not find anywhere. It arrives unverified and
  /// waits for a human, so nothing here overwrites trusted data.
  ///
  /// Returns the service's acknowledgement message.
  Future<String> suggest({
    required String title,
    String? isbn,
    List<String> authors = const [],
    String? subtitle,
    String? publisher,
    int? publishedYear,
    int? pages,
    String? language,
    String? description,
    String? coverImagePath,
  }) async {
    if (!isConfigured) {
      throw const MetadataException(MetadataFailure.network, 'No base URL');
    }

    final payload = <String, dynamic>{
      'title': title.trim(),
      if (isbn != null && isbn.trim().isNotEmpty) 'isbn': Isbn.normalize(isbn),
      if (authors.isNotEmpty) 'authors': authors.take(10).toList(),
      if (subtitle != null && subtitle.isNotEmpty) 'subtitle': subtitle,
      if (publisher != null && publisher.isNotEmpty) 'publisher': publisher,
      'published_year': ?publishedYear,
      'pages': ?pages,
      if (language != null && language.isNotEmpty) 'language': language,
      if (description != null && description.isNotEmpty)
        'description': description.length > 5000
            ? description.substring(0, 5000)
            : description,

    };

    // A cover the reader photographed is a file, not a URL, so a book that
    // has one is sent as multipart. Without one the request stays JSON.
    final cover = coverImagePath == null || coverImagePath.isEmpty
        ? null
        : File(coverImagePath);

    final http.Response response;
    try {
      response = await (cover != null && cover.existsSync()
              ? _postMultipart(payload, cover)
              : _postJson(payload))
          .timeout(timeout);
    } on TimeoutException {
      throw const MetadataException(MetadataFailure.network, 'Timed out');
    } catch (e) {
      throw MetadataException(MetadataFailure.network, e.toString());
    }

    if (response.statusCode == 202 || response.statusCode == 200) {
      final body = _decode(response);
      return body['message']?.toString() ??
          'Thank you. The book has been queued for review.';
    }

    if (response.statusCode == 422) {
      final body = _decode(response);
      final errors = body['errors'];
      final first = errors is Map && errors.isNotEmpty
          ? (errors.values.first is List
              ? (errors.values.first as List).first.toString()
              : errors.values.first.toString())
          : body['message']?.toString();
      throw MetadataException(
        MetadataFailure.invalidIsbn,
        first ?? 'The book could not be accepted.',
      );
    }

    throw MetadataException(
      MetadataFailure.network,
      'HTTP ${response.statusCode}',
    );
  }

  Future<http.Response> _postJson(Map<String, dynamic> payload) => _client.post(
        _uri('/books/suggestions'),
        headers: _headers,
        body: jsonEncode(payload),
      );

  /// The same fields, plus the photograph. Multipart carries no types, so
  /// numbers and lists are spelled the way the service's validator reads
  /// them: `pages=336`, `authors[0]=…`.
  Future<http.Response> _postMultipart(
    Map<String, dynamic> payload,
    File cover,
  ) async {
    final request = http.MultipartRequest('POST', _uri('/books/suggestions'))
      ..headers.addAll({
        'Accept': 'application/json',
        if (token != null && token!.isNotEmpty)
          'Authorization': 'Bearer $token',
      });

    payload.forEach((key, value) {
      if (value is List) {
        for (var i = 0; i < value.length; i++) {
          request.fields['$key[$i]'] = '${value[i]}';
        }
      } else {
        request.fields[key] = '$value';
      }
    });

    request.files.add(
      await http.MultipartFile.fromPath(
        'cover',
        cover.path,
        contentType: _mediaTypeOf(cover.path),
      ),
    );

    // Through the configured client, never request.send(): that would spin up
    // a fresh one and lose everything this source was built with.
    return http.Response.fromStream(await _client.send(request));
  }

  /// The service accepts jpeg, png and webp. A cover with no recognisable
  /// extension is sent as jpeg, which is what the camera and the cropper
  /// produce.
  static MediaType _mediaTypeOf(String path) {
    final extension = path.toLowerCase().split('.').last;
    return switch (extension) {
      'png' => MediaType('image', 'png'),
      'webp' => MediaType('image', 'webp'),
      _ => MediaType('image', 'jpeg'),
    };
  }

  Future<http.Response> _get(Uri uri) async {
    try {
      return await _client.get(uri, headers: _headers).timeout(timeout);
    } on TimeoutException {
      throw const MetadataException(MetadataFailure.network, 'Timed out');
    } on MetadataException {
      rethrow;
    } catch (e) {
      throw MetadataException(MetadataFailure.network, e.toString());
    }
  }

  Map<String, dynamic> _decode(http.Response response) {
    try {
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      return decoded is Map<String, dynamic> ? decoded : <String, dynamic>{};
    } on FormatException {
      throw const MetadataException(MetadataFailure.unknown, 'Bad response');
    }
  }

  /// Maps one `BookResource` to the app's provider-neutral shape.
  BookMetadata _parse(Map<String, dynamic> data) {
    final authors = (data['authors'] as List?)
            ?.whereType<Map>()
            .map((a) => _name(a))
            .whereType<String>()
            .toList() ??
        const <String>[];

    final publisher = data['publisher'];
    final isbn13 = data['isbn13']?.toString();

    return BookMetadata(
      title: data['title']?.toString() ??
          data['title_latin']?.toString() ??
          'Untitled',
      authors: authors,
      // Deliberately not mapped. The service scrapes retail listings, so its
      // description and subtitle are shop copy — delivery terms, discounts and
      // a link back to the store — not anything about the book. An empty
      // description reads better than that, and stays editable.
      isbn13: isbn13,
      isbn10: data['isbn10']?.toString() ??
          (isbn13 == null ? null : Isbn.to10(isbn13)),
      publisher: publisher is Map ? _name(publisher) : null,
      publishedYear: _int(data['published_year']),
      publicationDate: data['published_year']?.toString(),
      pageCount: _int(data['pages']),
      language: _language(data['language']?.toString()),
      coverUrl: data['cover_url']?.toString(),
    );
  }

  /// The service returns every name in both alphabets. The plain field is the
  /// one it considers canonical; the Latin form is the readable fallback.
  String? _name(Map<dynamic, dynamic> node) {
    for (final key in ['full_name', 'name', 'full_name_latin', 'name_latin']) {
      final value = node[key]?.toString().trim();
      if (value != null && value.isNotEmpty) return value;
    }
    return null;
  }

  /// The service stores languages the way its Uzbek sources write them —
  /// "O'zbekcha", "Ruscha", "Inglizcha". The app's filters and statistics group
  /// by this value, so it is mapped to one English name per language. Anything
  /// unrecognised (including the bilingual "O'zb/Rus" rows) is passed through.
  String? _language(String? value) {
    final raw = value?.trim();
    if (raw == null || raw.isEmpty) return null;

    // Uzbek is written with several different apostrophes; fold them all.
    final key = raw
        .toLowerCase()
        .replaceAll(RegExp("[\u2018\u2019\u02bb\u02bc`']"), '')
        .trim();

    return const {
          'ozbekcha': 'Uzbek',
          'ozbek': 'Uzbek',
          'uzbekcha': 'Uzbek',
          'uz': 'Uzbek',
          'uzb': 'Uzbek',
          'ruscha': 'Russian',
          'rus': 'Russian',
          'ru': 'Russian',
          'inglizcha': 'English',
          'ingliz': 'English',
          'en': 'English',
          'eng': 'English',
          'turkcha': 'Turkish',
          'tr': 'Turkish',
          'arabcha': 'Arabic',
          'ar': 'Arabic',
          'turkmancha': 'Turkmen',
          'qoraqalpoqcha': 'Karakalpak',
          'kaa': 'Karakalpak',
        }[key] ??
        raw;
  }

  static int? _int(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '');
  }

  void close() => _client.close();
}
