import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_library/core/widgets/layout.dart';
import 'package:my_library/core/widgets/pills.dart';
import 'package:my_library/domain/models/enums.dart';

void main() {
  Future<void> pumpIn(WidgetTester tester, Widget child) => tester.pumpWidget(
        MaterialApp(home: Scaffold(body: Center(child: child))),
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
              AppPill.status(ReadingStatus.read),
              AppPill.status(ReadingStatus.unread),
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
}
