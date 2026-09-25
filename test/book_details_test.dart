import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_library/core/providers.dart';
import 'package:my_library/core/widgets/book_cover.dart';
import 'package:my_library/data/local/database.dart';
import 'package:my_library/data/repositories/collection_mutations.dart';
import 'package:my_library/features/books/presentation/book_details_screen.dart';
import 'package:my_library/domain/models/book_draft.dart';
import 'package:my_library/l10n/app_localizations.dart';

/// A work can have no edition row: older wishlist entries were stored that
/// way, and removing the last edition of a book leaves one behind too. The
/// details screen has to render it rather than throw.
void main() {
  late AppDatabase db;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await db.ensureIndexes();
  });

  tearDown(() => db.close());

  Future<void> pumpDetails(WidgetTester tester, String workId) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: MaterialApp(
          localizationsDelegates: AppL10n.localizationsDelegates,
          supportedLocales: AppL10n.supportedLocales,
          home: BookDetailsScreen(workId: workId),
        ),
      ),
    );
    for (var i = 0; i < 8; i++) {
      await tester.pump(const Duration(milliseconds: 120));
    }
  }

  testWidgets('a work with no edition renders instead of throwing',
      (tester) async {
    // A bare work, the shape a wishlist entry used to be stored in.
    const workId = 'w-no-edition';
    await db.into(db.works).insert(
          WorksCompanion.insert(
            id: workId,
            title: 'Flights',
            authors: const ['Olga Tokarczuk'],
            genres: const ['Fiction'],
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );

    await pumpDetails(tester, workId);

    // Drawing the spine stack used to index an empty list:
    // "RangeError (length): Invalid value: Valid value range is empty: 0".
    expect(tester.takeException(), isNull);
    expect(find.text('No edition recorded yet.'), findsOneWidget);
    expect(find.text('0 editions of this work'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 50));
  });

  testWidgets('the editions row shows the real cover, not a colour block',
      (tester) async {
    final added = await db.addBook(
      BookDraft(
        title: 'Propaganda',
        authors: ['Edward Bernays'],
        coverUrl: 'https://example.test/propaganda.jpg',
      ),
    );

    await pumpDetails(tester, added.workId);

    // Every cover on the screen should be carrying the artwork: the hero and
    // the little spine in the editions row both.
    final covers = tester.widgetList<BookCover>(find.byType(BookCover));
    expect(covers, isNotEmpty);
    expect(
      covers.every((c) => c.coverUrl == 'https://example.test/propaganda.jpg'),
      isTrue,
      reason: 'the spine used to be a flat swatch of the palette colour',
    );

    // And the small one is the editions row's, at spine size.
    expect(
      covers.any((c) => c.width == 20 && c.height == 29),
      isTrue,
    );

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 50));
  });

  testWidgets('a work with one edition still draws its spine', (tester) async {
    final added = await db.addBook(
      BookDraft(title: 'Piranesi', authors: ['Susanna Clarke']),
    );

    await pumpDetails(tester, added.workId);

    expect(tester.takeException(), isNull);
    expect(find.text('1 edition of this work'), findsOneWidget);
    expect(find.text('No edition recorded yet.'), findsNothing);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 50));
  });
}
