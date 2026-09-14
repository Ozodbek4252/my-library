import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:my_library/l10n/app_localizations.dart';
import 'package:my_library/core/widgets/book_cover.dart';
import 'package:my_library/core/widgets/layout.dart';
import 'package:my_library/core/widgets/pills.dart';
import 'package:my_library/domain/models/enums.dart';

void main() {
  late AppL10n l10n;

  setUpAll(() async {
    l10n = await AppL10n.delegate.load(const Locale('en'));
  });

  Future<void> pumpIn(WidgetTester tester, Widget child) => tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppL10n.localizationsDelegates,
          supportedLocales: AppL10n.supportedLocales,
          home: Scaffold(body: Center(child: child)),
        ),
      );

  group('ProgressTrack', () {
    testWidgets('the fill is actually painted at the track height',
        (tester) async {
      await pumpIn(
        tester,
        const SizedBox(width: 200, child: ProgressTrack(value: .5, height: 6)),
      );

      // The rust fill is the second box in the stack; a zero-height fill means
      // the reader sees an empty track however far through the book they are.
      final fill = tester.widgetList<FractionallySizedBox>(
        find.byType(FractionallySizedBox),
      ).single;
      expect(fill.heightFactor, 1);

      final size = tester.getSize(find.byType(FractionallySizedBox).first);
      expect(size.height, 6, reason: 'a zero-height fill is invisible');
      expect(size.width, 100, reason: 'half of a 200px track');
    });

    testWidgets('a value outside 0..1 is clamped', (tester) async {
      await pumpIn(
        tester,
        const SizedBox(width: 100, child: ProgressTrack(value: 5)),
      );
      expect(tester.takeException(), isNull);
    });
  });

  group('pills and chips size to their label', () {
    testWidgets('a pill in a Wrap does not stretch to full width',
        (tester) async {
      await pumpIn(
        tester,
        SizedBox(
          width: 300,
          child: Wrap(
            children: [
              AppPill.status(ReadingStatus.read, l10n: l10n),
              AppPill.status(ReadingStatus.unread, l10n: l10n),
            ],
          ),
        ),
      );

      final first = tester.getSize(find.byType(AppPill).first);
      expect(first.width, lessThan(150));
      // Both pills fit on one line, which they cannot do if either stretches.
      expect(
        tester.getTopLeft(find.byType(AppPill).at(1)).dy,
        tester.getTopLeft(find.byType(AppPill).first).dy,
      );
    });

    testWidgets('a chip in a Wrap does not stretch to full width',
        (tester) async {
      await pumpIn(
        tester,
        const SizedBox(
          width: 300,
          child: Wrap(
            children: [
              AppChip(label: 'Read', selected: false),
              AppChip(label: 'Unread', selected: true),
            ],
          ),
        ),
      );

      expect(tester.getSize(find.byType(AppChip).first).width, lessThan(150));
      expect(
        tester.getTopLeft(find.byType(AppChip).at(1)).dy,
        tester.getTopLeft(find.byType(AppChip).first).dy,
      );
    });
  });

  group('OutlinedSurface', () {
    testWidgets('paints its outline after the child, so nothing covers it',
        (tester) async {
      await pumpIn(
        tester,
        const SizedBox(
          width: 200,
          child: OutlinedSurface(
            // A header that paints its own background, as both scan-result
            // cards have: this is what used to eat the top two corners.
            child: ColoredBox(
              color: Color(0xFFF1EADC),
              child: SizedBox(height: 40, width: double.infinity),
            ),
          ),
        ),
      );

      final decorated = tester
          .widgetList<DecoratedBox>(find.byType(DecoratedBox))
          .firstWhere((d) => d.decoration is BoxDecoration
              ? (d.decoration as BoxDecoration).border != null
              : false);

      expect(
        decorated.position,
        DecorationPosition.foreground,
        reason: 'a background border would be painted over by the header',
      );

      // The child is clipped to the same radius, so it cannot square off the
      // corners either.
      final clip = tester.widget<ClipRRect>(find.byType(ClipRRect).first);
      final border = (decorated.decoration as BoxDecoration).borderRadius;
      expect(clip.borderRadius, border);
    });

    testWidgets('keeps the size it is given', (tester) async {
      await pumpIn(
        tester,
        const SizedBox(
          width: 200,
          height: 80,
          child: OutlinedSurface(child: SizedBox.expand()),
        ),
      );
      expect(
        tester.getSize(find.byType(OutlinedSurface)),
        const Size(200, 80),
        reason: 'the fix must not change any dimensions',
      );
    });
  });

  group('BookCover', () {
    testWidgets('a fetched cover fills the slot', (tester) async {
      await pumpIn(
        tester,
        const SizedBox(
          width: 100,
          height: 150,
          child: BookCover(
            title: 'A book',
            coverUrl: 'https://example.com/cover.jpg',
            width: 100,
            height: 150,
          ),
        ),
      );

      final image = tester.widget<CachedNetworkImage>(
        find.byType(CachedNetworkImage),
      );
      expect(image.fit, BoxFit.cover);
    });

    testWidgets('a cover the user framed is shown whole, not re-cropped',
        (tester) async {
      await pumpIn(
        tester,
        const SizedBox(
          width: 100,
          height: 150,
          child: BookCover(
            title: 'A book',
            coverImagePath: '/covers/framed.jpg',
            width: 100,
            height: 150,
          ),
        ),
      );

      final image = tester.widget<Image>(find.byType(Image));
      expect(
        image.fit,
        BoxFit.contain,
        reason: 'filling the slot would crop what the user deliberately kept',
      );
    });
  });
}
