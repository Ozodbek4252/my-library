import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_library/app.dart';
import 'package:my_library/core/providers.dart';
import 'package:my_library/core/widgets/bottom_nav.dart';
import 'package:my_library/data/local/database.dart';
import 'package:my_library/core/utils/formatting.dart';
import 'package:my_library/data/repositories/statistics_repository.dart';
import 'package:my_library/data/seed/seeder.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late SharedPreferences prefs;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await db.ensureIndexes();
    await Seeder(db).seed();

    SharedPreferences.setMockInitialValues({'onboarding_complete': true});
    prefs = await SharedPreferences.getInstance();
  });

  tearDown(() => db.close());

  /// The design is drawn against a 390×844 phone. The default 800×600 test
  /// surface is a different shape entirely.
  void usePhoneSurface(WidgetTester tester) {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  /// The library shows a shimmering skeleton while it loads, and shimmer never
  /// stops — so `pumpAndSettle` would wait forever. Pumping fixed frames lets
  /// the database streams deliver without waiting on animations.
  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 12; i++) {
      await tester.pump(const Duration(milliseconds: 120));
    }
  }

  /// Tearing down a Riverpod scope cancels the drift stream queries, and drift
  /// closes them on a zero-duration timer. Pumping the tree away inside the
  /// test lets those timers run before the binding checks for stragglers.
  Future<void> teardownApp(WidgetTester tester) async {
    // A toast lives for 2.4s; let any showing one expire first.
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpWidget(const SizedBox.shrink());
    for (var i = 0; i < 4; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  Widget app() => ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          preferencesProvider.overrideWithValue(prefs),
        ],
        child: const BookCollectionApp(),
      );

  /// "Reading" also appears as a tab chip and a status pill, so nav taps are
  /// scoped to the bottom bar.
  Finder navItem(String label) => find.descendant(
        of: find.byType(AppBottomNav),
        matching: find.text(label),
      );

  Future<void> start(WidgetTester tester) async {
    usePhoneSurface(tester);
    await tester.pumpWidget(app());
    await settle(tester);
  }

  testWidgets('the library opens on the seeded collection', (tester) async {
    await start(tester);

    expect(find.text('Library'), findsWidgets);
    // Counts come from the database, not from the design's placeholders.
    expect(
      find.textContaining('of 22 shown · sorted by recently added'),
      findsOneWidget,
    );
    expect(find.textContaining('22 books'), findsWidgets);
    // The most recently added seeded book leads the grid.
    expect(find.text('Atomic Habits'), findsWidgets);
    expect(find.text('214'), findsNothing);

    await teardownApp(tester);
  });

  testWidgets('the bottom nav reaches reading, wishlist and profile',
      (tester) async {
    await start(tester);

    await tester.tap(navItem('Reading'));
    await settle(tester);
    expect(find.text('Currently reading'), findsOneWidget);
    expect(find.text('Up next · from your shelves'.toUpperCase()), findsOneWidget);

    await tester.tap(navItem('Wishlist'));
    await settle(tester);
    expect(find.text('The Overstory'), findsWidgets);
    expect(find.text('High'), findsWidgets);

    await tester.tap(navItem('Profile'));
    await settle(tester);
    expect(find.text('Reading statistics'), findsOneWidget);

    await teardownApp(tester);
  });

  testWidgets('opening a book shows its edition and copy details',
      (tester) async {
    await start(tester);

    await tester.tap(find.text('Atomic Habits').first);
    await settle(tester);

    expect(find.text('THE EDITION YOU OWN'), findsOneWidget);
    expect(find.text('MY COPY'), findsOneWidget);
    // Real stored values, not design placeholders.
    expect(find.text('Random House Business'), findsOneWidget);
    expect(find.text('Waterstones, Piccadilly'), findsOneWidget);
    // Atomic Habits is seeded as in progress, so the progress card is shown.
    expect(find.text('Update progress'), findsOneWidget);
    expect(find.text('237 of 320 pages'), findsOneWidget);

    await teardownApp(tester);
  });

  testWidgets('reading progress can be updated from the sheet', (tester) async {
    await start(tester);

    await tester.tap(navItem('Reading'));
    await settle(tester);
    await tester.tap(find.text('Update page').first);
    await settle(tester);

    expect(find.text('+10 pages'), findsOneWidget);
    await tester.tap(find.text('+10 pages'));
    await tester.pump();

    await tester.tap(find.text('Save progress'));
    await settle(tester);

    // The change is persisted, not just held in the sheet.
    final work = await (db.select(db.works)
          ..where((w) => w.title.equals('Atomic Habits')))
        .getSingle();
    expect(work.currentPage, 247);

    await teardownApp(tester);
  });

  testWidgets('statistics are calculated, not hardcoded', (tester) async {
    await start(tester);

    await tester.tap(navItem('Profile'));
    await settle(tester);
    await tester.tap(find.text('Reading statistics'));
    await settle(tester);

    expect(find.text('This year'), findsOneWidget);
    expect(find.text('Books read this year'), findsOneWidget);

    // The figures on screen must equal what the repository computes from the
    // stored reading log — not the design's placeholders.
    final stats = await StatisticsRepository(db).statistics();
    expect(find.text('${stats.booksReadThisYear}'), findsWidgets);
    expect(find.text(Fmt.count(stats.pagesReadThisYear)), findsOneWidget);
    expect(find.text('9,842'), findsNothing);

    await teardownApp(tester);
  });

  testWidgets('an empty library shows the empty state, not an empty grid',
      (tester) async {
    await Seeder(db).reset();
    await start(tester);

    expect(find.text('Your shelves are empty'), findsOneWidget);
    expect(find.text('Scan a book'), findsOneWidget);

    await teardownApp(tester);
  });
}
