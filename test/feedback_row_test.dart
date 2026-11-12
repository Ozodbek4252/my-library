import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_library/core/providers.dart';
import 'package:my_library/data/local/database.dart';
import 'package:my_library/features/profile/presentation/profile_screen.dart';
import 'package:my_library/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The Feedback row is only worth showing when it has somewhere to go. A
/// button that opens nothing is exactly what the brief ruled out.
void main() {
  late AppDatabase db;
  late SharedPreferences prefs;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await db.ensureIndexes();
    SharedPreferences.setMockInitialValues({'onboarding_complete': true});
    prefs = await SharedPreferences.getInstance();
  });

  tearDown(() => db.close());

  Future<void> pumpProfile(WidgetTester tester, String? feedbackUrl) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          preferencesProvider.overrideWithValue(prefs),
          feedbackUrlProvider.overrideWithValue(feedbackUrl),
        ],
        child: MaterialApp(
          localizationsDelegates: AppL10n.localizationsDelegates,
          supportedLocales: AppL10n.supportedLocales,
          home: const Scaffold(body: ProfileScreen()),
        ),
      ),
    );
    for (var i = 0; i < 8; i++) {
      await tester.pump(const Duration(milliseconds: 120));
    }
  }

  Future<void> teardown(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 50));
  }

  testWidgets('a configured link puts Feedback in the App section',
      (tester) async {
    await pumpProfile(tester, 'https://t.me/example_bot');

    final l10n = await AppL10n.delegate.load(const Locale('en'));
    await tester.scrollUntilVisible(find.text(l10n.profileFeedback), 300);

    expect(find.text(l10n.profileFeedback), findsOneWidget);
    expect(find.text('Telegram'), findsOneWidget);

    await teardown(tester);
  });

  testWidgets('with no link the row is hidden, not dead', (tester) async {
    await pumpProfile(tester, null);

    final l10n = await AppL10n.delegate.load(const Locale('en'));
    // Scroll to the foot of the list so the whole App section has been built.
    await tester.scrollUntilVisible(find.text(l10n.profileVersion), 300);

    expect(find.text(l10n.profileFeedback), findsNothing);
    expect(find.text('Telegram'), findsNothing);

    await teardown(tester);
  });

  testWidgets('the row is translated with the rest of the interface',
      (tester) async {
    final ru = await AppL10n.delegate.load(const Locale('ru'));
    expect(ru.profileFeedback, isNot('Feedback'));
    expect(ru.toastCouldNotOpenFeedback, isNot(isEmpty));
  });
}
