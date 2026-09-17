import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:my_library/core/providers.dart';
import 'package:my_library/data/local/database.dart';
import 'package:my_library/data/metadata/book_scraper_source.dart';
import 'package:my_library/data/repositories/collection_mutations.dart';
import 'package:my_library/data/repositories/reading_repository.dart';
import 'package:my_library/domain/models/book_draft.dart';
import 'package:my_library/features/books/presentation/add_book_screen.dart';
import 'package:my_library/l10n/app_localizations.dart';

/// A book's first appearance goes to the shared catalogue. Nothing after that
/// does: later edits and reading progress are the reader's own records.
void main() {
  late AppDatabase db;
  late List<http.BaseRequest> sent;

  /// What the service answers. Tests that care set this before pumping.
  late http.Response reply;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await db.ensureIndexes();
    sent = [];
    reply = http.Response(
      '{"message":"Queued"}',
      202,
      headers: {'content-type': 'application/json'},
    );
  });

  tearDown(() => db.close());

  BookScraperSource recordingSource() => BookScraperSource(
        baseUrl: 'https://example.test/api/v1',
        client: MockClient((request) async {
          sent.add(request);
          return reply;
        }),
      );

  /// The editor pushed over a route, as the app does it: saving ends in
  /// `context.pop()`, which needs a router and somewhere to go back to.
  Future<void> pumpEditor(WidgetTester tester, AddBookArgs args) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => const Scaffold(body: Text('shelf')),
        ),
        GoRoute(path: '/edit', builder: (_, _) => AddBookScreen(draft: args)),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          bookScraperSourceProvider.overrideWithValue(recordingSource()),
        ],
        child: MaterialApp.router(
          localizationsDelegates: AppL10n.localizationsDelegates,
          supportedLocales: AppL10n.supportedLocales,
          routerConfig: router,
        ),
      ),
    );

    router.push('/edit');
    for (var i = 0; i < 8; i++) {
      await tester.pump(const Duration(milliseconds: 120));
    }
  }

  Future<void> save(WidgetTester tester) async {
    final l10n = await AppL10n.delegate.load(const Locale('en'));
    // The top bar's Save is always on screen; the button at the foot of the
    // form is below the fold.
    await tester.tap(find.text(l10n.actionSave).hitTestable().first);
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 120));
    }
  }

  Future<void> teardown(WidgetTester tester) async {
    // A toast lives for 2.4s; let any showing one expire before the tree goes.
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 50));
  }

  Map<String, dynamic> bodyOf(http.BaseRequest request) =>
      jsonDecode((request as http.Request).body) as Map<String, dynamic>;

  group('creating a book', () {
    testWidgets('sends it to the catalogue', (tester) async {
      await pumpEditor(
        tester,
        AddBookArgs(
          prefill: BookDraft(
            title: 'Lol',
            authors: ['Fotih Duman'],
            isbn13: '9780141036144',
            pageCount: 208,
          ),
        ),
      );
      await save(tester);

      expect(sent, hasLength(1));
      expect(sent.single.url.path, '/api/v1/books/suggestions');
      final body = bodyOf(sent.single);
      expect(body['title'], 'Lol');
      expect(body['isbn'], '9780141036144');
      expect(body['authors'], ['Fotih Duman']);

      await teardown(tester);
    });

    testWidgets('one typed in by hand goes too', (tester) async {
      await pumpEditor(tester, const AddBookArgs());

      await tester.enterText(find.byType(TextField).first, 'Typed By Hand');
      await tester.pump();
      await save(tester);

      expect(sent, hasLength(1));
      expect(bodyOf(sent.single)['title'], 'Typed By Hand');

      await teardown(tester);
    });

    testWidgets('one with no ISBN is sent anyway, for a human to sort out',
        (tester) async {
      await pumpEditor(
        tester,
        AddBookArgs(
          prefill: BookDraft(title: 'No Barcode Anywhere', authors: ['A N O']),
        ),
      );
      await save(tester);

      expect(sent, hasLength(1));
      expect(
        bodyOf(sent.single).containsKey('isbn'),
        isFalse,
        reason: 'there is none to send; the catalogue merges on a fingerprint',
      );

      await teardown(tester);
    });

    testWidgets('an ISBN that fails its check digit is dropped, not sent',
        (tester) async {
      await pumpEditor(
        tester,
        AddBookArgs(
          prefill: BookDraft(
            title: 'Mis-typed',
            authors: ['A N O'],
            isbn13: '9789943012345',
          ),
        ),
      );
      await save(tester);

      expect(sent, hasLength(1), reason: 'the book itself still goes');
      expect(
        bodyOf(sent.single).containsKey('isbn'),
        isFalse,
        reason: 'sending it would have the service refuse the whole book',
      );

      await teardown(tester);
    });

    testWidgets('the reader is told nothing about it', (tester) async {
      await pumpEditor(
        tester,
        AddBookArgs(
          prefill: BookDraft(title: 'Lol', isbn13: '9780141036144'),
        ),
      );
      await save(tester);

      final l10n = await AppL10n.delegate.load(const Locale('en'));
      expect(sent, hasLength(1));
      expect(find.text(l10n.toastAddedToLibrary), findsOneWidget);
      expect(find.text('Queued'), findsNothing);

      await teardown(tester);
    });

    testWidgets('a service that refuses the book says nothing either',
        (tester) async {
      reply = http.Response(
        '{"message":"The given data was invalid.","errors":{"title":["bad"]}}',
        422,
        headers: {'content-type': 'application/json'},
      );

      await pumpEditor(
        tester,
        AddBookArgs(
          prefill: BookDraft(title: 'Lol', isbn13: '9780141036144'),
        ),
      );
      await save(tester);

      // The book is saved on the device; a service the reader never chose to
      // talk to must not interrupt them about it.
      expect(sent, hasLength(1));
      expect(find.textContaining('invalid'), findsNothing);
      expect(tester.takeException(), isNull);

      await teardown(tester);
    });
  });

  group('everything after that stays on the device', () {
    testWidgets('editing a book is not sent', (tester) async {
      final added = await db.addBook(
        BookDraft(
          title: 'Lol',
          authors: ['Fotih Duman'],
          isbn13: '9780141036144',
        ),
      );

      await pumpEditor(tester, AddBookArgs(workId: added.workId));
      await save(tester);

      expect(
        sent,
        isEmpty,
        reason: 'a book makes one trip out, when it is first created',
      );

      await teardown(tester);
    });

    testWidgets('adding a cover by editing is not sent either', (tester) async {
      final added = await db.addBook(
        BookDraft(title: 'Lol', isbn13: '9780141036144'),
      );

      await pumpEditor(tester, AddBookArgs(workId: added.workId));
      await save(tester);

      expect(sent, isEmpty);

      await teardown(tester);
    });

    testWidgets('reading progress is never sent', (tester) async {
      final added = await db.addBook(
        BookDraft(
          title: 'Being Read',
          isbn13: '9780141036144',
          pageCount: 300,
        ),
      );

      // How far someone has got is their own business, not the catalogue's.
      final reading = ReadingRepository(db);
      await reading.updateProgress(added.workId, 95);
      await reading.setRating(added.workId, 4);
      await reading.finishReading(added.workId);

      expect(sent, isEmpty);
    });
  });
}
