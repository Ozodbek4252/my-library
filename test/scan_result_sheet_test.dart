import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_library/core/providers.dart';
import 'package:my_library/core/widgets/app_sheet.dart';
import 'package:my_library/data/local/database.dart';
import 'package:my_library/data/metadata/book_metadata.dart';
import 'package:my_library/data/repositories/collection_mutations.dart';
import 'package:my_library/data/repositories/library_repository.dart';
import 'package:my_library/data/repositories/scan_service.dart';
import 'package:my_library/domain/models/book_draft.dart';
import 'package:my_library/features/scanner/presentation/widgets/scan_result_sheet.dart';
import 'package:my_library/l10n/app_localizations.dart';

/// The sheet reports what the user chose and navigates nowhere itself. It is
/// popped the instant a button is tapped, and a route pushed from a context
/// that has just been deactivated goes nowhere — which is how "Open book"
/// came to do nothing at all.
void main() {
  late AppDatabase db;
  late ScanResult owned;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await db.ensureIndexes();

    final added = await db.addBook(
      BookDraft(
        title: "O'zim Bilan Yolg'iz",
        authors: ['Mark Avreliy'],
        isbn13: '9789943012345',
        pageCount: 185,
      ),
    );
    final details = await LibraryRepository(db).bookDetails(added.workId);

    owned = ScanResult(
      isbn: '9789943012345',
      metadata: const BookMetadata(
        title: "O'zim Bilan Yolg'iz",
        authors: ['Mark Avreliy'],
      ),
      verdict: ScanVerdict.ownedSameEdition,
      details: details,
      matchedEdition: details!.primaryEdition!.edition,
    );
  });

  tearDown(() => db.close());

  /// Opens the sheet the way the scanner does and hands back what it returned.
  Future<ScanNextAction?> tapAndCollect(
    WidgetTester tester,
    String Function(AppL10n) label, {
    ScanResult? result,
  }) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    ScanNextAction? action;
    var returned = false;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: MaterialApp(
          localizationsDelegates: AppL10n.localizationsDelegates,
          supportedLocales: AppL10n.supportedLocales,
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    action = await showAppSheet<ScanNextAction>(
                      context,
                      builder: (_) =>
                          ScanResultSheet(result: result ?? owned),
                    );
                    returned = true;
                  },
                  child: const Text('open sheet'),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open sheet'));
    await tester.pumpAndSettle();

    final l10n = await AppL10n.delegate.load(const Locale('en'));
    await tester.tap(find.text(label(l10n)));
    await tester.pumpAndSettle();

    expect(returned, isTrue, reason: 'the sheet should have closed');
    expect(tester.takeException(), isNull);

    // A toast lives for 2.4s; let any showing one expire before the tree goes,
    // or its timer outlives the test.
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 50));

    return action;
  }

  testWidgets('"Open book" asks the scanner to open it, and does not navigate',
      (tester) async {
    // There is no GoRouter above this sheet on purpose: if the sheet tried to
    // route anywhere itself, this would throw rather than quietly do nothing.
    final action = await tapAndCollect(tester, (l10n) => l10n.actionOpenBook);

    expect(action, ScanNextAction.openBook);
  });

  testWidgets('"Scan next" sends the scanner back to the camera',
      (tester) async {
    final action = await tapAndCollect(tester, (l10n) => l10n.actionScanNext);

    expect(action, ScanNextAction.scanNext);
  });

  testWidgets('"Add with details" asks the scanner to open the editor',
      (tester) async {
    final notOwned = ScanResult(
      isbn: '9789943012345',
      metadata: const BookMetadata(
        title: 'Something New',
        authors: ['A N Other'],
      ),
      verdict: ScanVerdict.notInLibrary,
    );

    final action = await tapAndCollect(
      tester,
      (l10n) => l10n.scanAddWithDetails,
      result: notOwned,
    );

    expect(action, ScanNextAction.addWithDetails);
  });

  testWidgets('adding a copy outright still just closes the sheet',
      (tester) async {
    final action =
        await tapAndCollect(tester, (l10n) => l10n.scanAddAnotherCopy);

    expect(action, ScanNextAction.close);
    // That one does its work before closing, rather than delegating.
    expect(await db.select(db.copies).get(), hasLength(2));
  });
}
