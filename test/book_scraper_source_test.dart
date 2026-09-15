import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:my_library/data/metadata/book_metadata.dart';
import 'package:my_library/data/metadata/book_scraper_source.dart';

/// A real response from GET /api/v1/books/{isbn}, trimmed to one book.
const _bookJson = {
  'id': 2213,
  'isbn13': '9785961426625',
  'isbn10': null,
  'title': 'Марк Мэнсон: Всё хреново. Книга о надежде (Мягкая)',
  'title_latin': 'Mark Menson: Vsyo xrenovo. Kniga o nadejde (Myagkaya)',
  'title_cyrillic': 'Марк Мэнсон: Всё хреново. Книга о надежде (Мягкая)',
  'subtitle': null,
  'authors': [
    {
      'id': 21,
      'full_name': 'Mark Menson',
      'full_name_latin': 'Mark Menson',
      'full_name_cyrillic': 'Марк Менсон',
    },
  ],
  'publisher': {
    'id': 117,
    'name': 'Alpina Publisher',
    'name_latin': 'Alpina Publisher',
    'name_cyrillic': 'Алпина Публишер',
  },
  'published_year': 2019,
  'pages': 374,
  'language': 'Ruscha',
  'description': 'Книга о надежде.',
  'cover_url':
      'https://assets.asaxiy.uz/product/main_image/desktop/5e15bd80e11bd.jpg.webp',
  'verified': false,
};

void main() {
  /// Laravel answers as UTF-8 JSON; `http.Response` encodes its body as
  /// latin-1 unless the charset says otherwise, and these bodies are Cyrillic.
  const jsonHeaders = {'content-type': 'application/json; charset=utf-8'};

  http.Response json(Object body, int status) =>
      http.Response(jsonEncode(body), status, headers: jsonHeaders);

  BookScraperSource sourceThat(
    Future<http.Response> Function(http.Request) handler, {
    String baseUrl = 'http://localhost:8000',
  }) =>
      BookScraperSource(
        baseUrl: baseUrl,
        client: MockClient(handler),
      );

  group('lookupByIsbn', () {
    test('maps a book to the app-neutral shape', () async {
      late Uri called;
      final source = sourceThat((request) async {
        called = request.url;
        return json({'data': _bookJson}, 200);
      });

      final book = await source.lookupByIsbn('978-5-9614-2662-5');

      expect(called.path, '/api/v1/books/9785961426625');
      expect(book.title, 'Марк Мэнсон: Всё хреново. Книга о надежде (Мягкая)');
      expect(book.authors, ['Mark Menson']);
      expect(book.publisher, 'Alpina Publisher');
      expect(book.publishedYear, 2019);
      expect(book.pageCount, 374);
      expect(book.coverUrl, startsWith('https://assets.asaxiy.uz/'));
      // "Ruscha" is how the Uzbek sources write it; filters need one name.
      expect(book.language, 'Russian');
      // ISBN-10 is absent upstream but derivable, so the editor can show it.
      expect(book.isbn13, '9785961426625');
    });

    test('the retail blurb is never taken as a description', () async {
      // What the service actually returns: a shop listing, not a book.
      const blurb = 'Henri Ford: Mening hayotimni ASAXIYda arzon narxda xarid '
          'qiling⭐Aksiyalar⚡Kafolat✅Tavsif⏰Muddatli to\'lov⌛Toshkent va '
          "O'zbekiston bo'ylab tezkor yetkazib berish 👉 asaxiy.uz";

      final source = sourceThat(
        (_) async => json({
          'data': {..._bookJson, 'description': blurb, 'subtitle': blurb},
        }, 200),
      );

      final book = await source.lookupByIsbn('9785961426625');

      expect(book.description, isNull);
      // Everything else still comes through.
      expect(book.title, isNotEmpty);
      expect(book.pageCount, 374);
      expect(book.coverUrl, isNotNull);
    });

    test('404 is "not found", not a network failure', () async {
      final source = sourceThat(
        (_) async => json({
          'message': 'No book is known with that ISBN.',
          'isbn13': '9780141036144',
        }, 404),
      );

      expect(
        () => source.lookupByIsbn('9780141036144'),
        throwsA(
          isA<MetadataException>()
              .having((e) => e.failure, 'failure', MetadataFailure.notFound),
        ),
      );
    });

    test('422 is reported as an invalid ISBN', () async {
      final source = sourceThat(
        (_) async => json(
          {'message': 'That is not a valid ISBN-10 or ISBN-13.'},
          422,
        ),
      );

      expect(
        () => source.lookupByIsbn('9781526624369'),
        throwsA(
          isA<MetadataException>()
              .having((e) => e.failure, 'failure', MetadataFailure.invalidIsbn),
        ),
      );
    });

    test('a server error is a network failure so the next source is tried',
        () async {
      final source = sourceThat((_) async => http.Response('nginx', 502));

      expect(
        () => source.lookupByIsbn('9785961426625'),
        throwsA(
          isA<MetadataException>()
              .having((e) => e.failure, 'failure', MetadataFailure.network),
        ),
      );
    });

    test('a check digit that fails never reaches the network', () async {
      var called = false;
      final source = sourceThat((_) async {
        called = true;
        return json(const <String, Object>{}, 200);
      });

      await expectLater(
        () => source.lookupByIsbn('9785961426620'),
        throwsA(isA<MetadataException>()),
      );
      expect(called, isFalse);
    });
  });

  group('search', () {
    test('sends the query and reads the paginated collection', () async {
      late Uri called;
      final source = sourceThat((request) async {
        called = request.url;
        return json({
          'data': [_bookJson, _bookJson],
          'meta': {'total': 2},
        }, 200);
      });

      final results = await source.search('menson', limit: 5);

      expect(called.path, '/api/v1/books');
      expect(called.queryParameters['q'], 'menson');
      expect(called.queryParameters['per_page'], '5');
      expect(results, hasLength(2));
      expect(results.first.authors, ['Mark Menson']);
    });

    test('an ISBN typed into search resolves to the one book', () async {
      final paths = <String>[];
      final source = sourceThat((request) async {
        paths.add(request.url.path);
        return json({'data': _bookJson}, 200);
      });

      final results = await source.search('9785961426625');

      expect(paths, ['/api/v1/books/9785961426625']);
      expect(results, hasLength(1));
    });

    test('an unconfigured base URL returns nothing rather than throwing',
        () async {
      final source =
          sourceThat((_) async => json(const <String, Object>{}, 200), baseUrl: '');
      expect(await source.search('anything'), isEmpty);
    });
  });

  group('suggest', () {
    test('posts the book and returns the acknowledgement', () async {
      late Map<String, dynamic> body;
      late Uri called;
      final source = sourceThat((request) async {
        called = request.url;
        body = jsonDecode(request.body) as Map<String, dynamic>;
        return json(
          {'message': 'Thank you. The book has been queued for review.'},
          202,
        );
      });

      final message = await source.suggest(
        title: 'Oʻtkan kunlar',
        isbn: '978-9943-01-234-5',
        authors: ['Abdulla Qodiriy'],
        publisher: 'Sharq',
        publishedYear: 2019,
        pages: 384,
        language: 'Uzbek',
      );

      expect(called.path, '/api/v1/books/suggestions');
      expect(body['title'], 'Oʻtkan kunlar');
      // The service wants a bare ISBN, not the hyphenated display form.
      expect(body['isbn'], '9789943012345');
      expect(body['authors'], ['Abdulla Qodiriy']);
      expect(body['pages'], 384);
      expect(message, contains('queued for review'));
    });

    test('a validation error carries the service message back', () async {
      final source = sourceThat(
        (_) async => json({
          'message': 'The given data was invalid.',
          'errors': {
            'isbn': ['The isbn field must be a valid ISBN-10 or ISBN-13.'],
          },
        }, 422),
      );

      expect(
        () => source.suggest(title: 'A book', isbn: '9785961426625'),
        throwsA(
          isA<MetadataException>().having(
            (e) => e.message,
            'message',
            contains('valid ISBN'),
          ),
        ),
      );
    });

    test('omits every field the user left blank', () async {
      late Map<String, dynamic> body;
      final source = sourceThat((request) async {
        body = jsonDecode(request.body) as Map<String, dynamic>;
        return json({'message': 'ok'}, 202);
      });

      await source.suggest(title: 'Bare minimum');

      expect(body.keys, ['title']);
    });
  });

  group('suggest with a cover', () {
    late Directory temp;

    setUp(() => temp = Directory.systemTemp.createTempSync('covers'));
    tearDown(() => temp.deleteSync(recursive: true));

    /// A real file on disk, because that is what the app has: the cropper
    /// writes one and the draft holds its path.
    File coverFile(String name, {List<int>? bytes}) {
      final file = File('${temp.path}/$name')
        ..writeAsBytesSync(bytes ?? List<int>.filled(64, 7));
      return file;
    }

    test('the photographed cover is sent as a file, with the fields',
        () async {
      late http.BaseRequest sent;
      late List<int> bodyBytes;
      final source = sourceThat((request) async {
        sent = request;
        bodyBytes = request.bodyBytes;
        return json({'message': 'Queued'}, 202);
      });

      await source.suggest(
        title: 'Lol',
        isbn: '978-9943-01-234-5',
        authors: ['Fotih Duman'],
        pages: 208,
        coverImagePath: coverFile('lol.jpg').path,
      );

      expect(
        sent.headers['content-type'],
        startsWith('multipart/form-data'),
        reason: 'a file cannot travel inside a JSON body',
      );

      final body = utf8.decode(bodyBytes, allowMalformed: true);
      expect(body, contains('name="cover"'));
      expect(body, contains('filename="lol.jpg"'));
      expect(body, contains('image/jpeg'));

      // The text fields still have to arrive, spelled the way the service's
      // validator reads them.
      expect(body, contains('name="title"'));
      expect(body, contains('Lol'));
      expect(body, contains('name="isbn"'));
      expect(body, contains('9789943012345'));
      expect(body, contains('name="authors[0]"'));
      expect(body, contains('Fotih Duman'));
      expect(body, contains('name="pages"'));
      expect(body, contains('208'));
    });

    test('the media type follows the file, so png is not sent as jpeg',
        () async {
      late List<int> bodyBytes;
      final source = sourceThat((request) async {
        bodyBytes = request.bodyBytes;
        return json({'message': 'Queued'}, 202);
      });

      await source.suggest(
        title: 'Lol',
        coverImagePath: coverFile('lol.png').path,
      );

      final body = utf8.decode(bodyBytes, allowMalformed: true);
      expect(body, contains('image/png'));
      expect(body, isNot(contains('image/jpeg')));
    });

    test('a book with no cover is still sent as plain JSON', () async {
      late http.BaseRequest sent;
      late String body;
      final source = sourceThat((request) async {
        sent = request;
        body = request.body;
        return json({'message': 'Queued'}, 202);
      });

      await source.suggest(title: 'Lol', pages: 208);

      expect(sent.headers['content-type'], contains('application/json'));
      expect(jsonDecode(body), containsPair('title', 'Lol'));
    });

    test('a cover whose file has gone falls back to JSON rather than failing',
        () async {
      late http.BaseRequest sent;
      final source = sourceThat((request) async {
        sent = request;
        return json({'message': 'Queued'}, 202);
      });

      // The record can outlive the file — storage cleared, or the user
      // removed it. The book itself is still worth sending.
      final message = await source.suggest(
        title: 'Lol',
        coverImagePath: '${temp.path}/never-written.jpg',
      );

      expect(sent.headers['content-type'], contains('application/json'));
      expect(message, 'Queued');
    });

    test('a rejected cover carries the service message back', () async {
      final source = sourceThat(
        (_) async => json({
          'message': 'The given data was invalid.',
          'errors': {
            'cover': ['The cover field must not be greater than 5120 kilobytes.'],
          },
        }, 422),
      );

      expect(
        () => source.suggest(
          title: 'Lol',
          coverImagePath: coverFile('huge.jpg').path,
        ),
        throwsA(
          isA<MetadataException>().having(
            (e) => e.message,
            'message',
            contains('5120 kilobytes'),
          ),
        ),
      );
    });
  });

  group('language names', () {
    Future<String?> languageFor(String value) async {
      final source = sourceThat(
        (_) async => json({
          'data': {..._bookJson, 'language': value},
        }, 200),
      );
      return (await source.lookupByIsbn('9785961426625')).language;
    }

    test('folds the Uzbek names, and the apostrophes in them', () async {
      expect(await languageFor("O'zbekcha"), 'Uzbek');
      expect(await languageFor('Oʻzbekcha'), 'Uzbek');
      expect(await languageFor('Inglizcha'), 'English');
      expect(await languageFor('Turkcha'), 'Turkish');
      expect(await languageFor('Qoraqalpoqcha'), 'Karakalpak');
    });

    test('passes an unrecognised value through untouched', () async {
      expect(await languageFor("O'zb/Rus"), "O'zb/Rus");
    });
  });
}
