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
import 'package:my_library/domain/models/book_draft.dart';
import 'package:my_library/features/books/presentation/add_book_screen.dart';
import 'package:my_library/l10n/app_localizations.dart';

/// Which saves reach the shared catalogue, and which stay on the device.
void main() {
  late AppDatabase db;
  late List<http.BaseRequest> sent;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await db.ensureIndexes();
    sent = [];
  });

  tearDown(() => db.close());

  BookScraperSource recordingSource() => BookScraperSource(
        baseUrl: 'https://example.test/api/v1',
        client: MockClient((request) async {
          sent.add(request);
          return http.Response(
            '{"message":"Queued"}',
            202,
            headers: {'content-type': 'application/json'},
          );
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
        GoRoute(
          path: '/edit',
          builder: (_, _) => AddBookScreen(draft: args),
        ),
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
    // The top bar's Save is always on screen; the big button at the foot of
    // the form is below the fold.
    await tester.tap(find.text(l10n.actionSave).hitTestable().first);
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 120));
    }
    // Let any toast expire before the tree goes.
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 50));
  }

  testWidgets('editing a book sends the correction to the catalogue',
      (tester) async {
    final added = await db.addBook(
      BookDraft(
        title: 'Lol',
        authors: ['Fotih Duman'],
        isbn13: '9780141036144',
        pageCount: 208,
      ),
    );

    await pumpEditor(tester, AddBookArgs(workId: added.workId));
    await save(tester);

    expect(sent, hasLength(1), reason: 'an edit should reach the catalogue');
    expect(sent.single.url.path, '/api/v1/books/suggestions');
  });

  testWidgets('saving an edit says nothing about the catalogue',
      (tester) async {
    final added = await db.addBook(
      BookDraft(
        title: 'Lol',
        authors: ['Fotih Duman'],
        isbn13: '9780141036144',
      ),
    );

    await pumpEditor(tester, AddBookArgs(workId: added.workId));

    final l10n = await AppL10n.delegate.load(const Locale('en'));
    await tester.tap(find.text(l10n.actionSave).hitTestable().first);
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 120));
    }

    // The user asked to save, not to publish. "Queued for review" after
    // changing a page count would only puzzle.
    expect(find.text(l10n.toastChangesSaved), findsOneWidget);
    expect(find.text('Queued'), findsNothing);

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 50));
  });

  testWidgets('a book with no ISBN stays on the device', (tester) async {
    final added = await db.addBook(
      BookDraft(title: 'No Barcode Anywhere', authors: ['A N Other']),
    );

    await pumpEditor(tester, AddBookArgs(workId: added.workId));
    await save(tester);

    expect(
      sent,
      isEmpty,
      reason: 'the ISBN is the identity the catalogue merges on',
    );
  });
}
