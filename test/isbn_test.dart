import 'package:flutter_test/flutter_test.dart';
import 'package:my_library/core/utils/isbn.dart';

void main() {
  group('Isbn.normalize', () {
    test('strips separators and upper-cases the check character', () {
      expect(Isbn.normalize('978-0-141-03614-4'), '9780141036144');
      expect(Isbn.normalize('0 14 103614 x'), '014103614X');
    });
  });

  group('Isbn.isValid', () {
    test('accepts valid ISBN-13 and ISBN-10', () {
      expect(Isbn.isValid('9780141036144'), isTrue);
      expect(Isbn.isValid('978-0-141-03614-4'), isTrue);
      expect(Isbn.isValid('0141036141'), isTrue);
    });

    test('rejects a wrong check digit and the wrong length', () {
      expect(Isbn.isValid('9780141036145'), isFalse);
      expect(Isbn.isValid('12345'), isFalse);
      expect(Isbn.isValid(''), isFalse);
    });
  });

  group('conversion', () {
    test('ISBN-10 converts to the same edition as ISBN-13', () {
      expect(Isbn.to13('0141036141'), '9780141036144');
      expect(Isbn.to10('9780141036144'), '0141036141');
    });

    test('a 979 prefix has no ISBN-10 form', () {
      expect(Isbn.to10('9791234567896'), isNull);
    });
  });

  group('Isbn.fromBarcode', () {
    test('reads an EAN-13 book barcode', () {
      expect(Isbn.fromBarcode('9780141036144'), '9780141036144');
    });

    test('drops an EAN-5 price add-on', () {
      expect(Isbn.fromBarcode('978014103614450799'), '9780141036144');
    });

    test('returns null for a non-book barcode', () {
      // A grocery EAN-13 that is not in the 978/979 bookland range.
      expect(Isbn.fromBarcode('4006381333931'), isNull);
      expect(Isbn.fromBarcode('not a barcode'), isNull);
    });
  });

  group('Isbn.display', () {
    test('splits at the registration group, whatever its length', () {
      // 0 is the English group — one digit.
      expect(Isbn.display('9780141036144'), '978-0-14103614-4');
      // 9943 is Uzbekistan — four digits. A fixed split would mangle it.
      expect(Isbn.display('9789943231634'), '978-9943-23163-4');
      // 5 is the Russian group.
      expect(Isbn.display('9785961426625'), '978-5-96142662-5');
      // 88 is Italy — two digits.
      expect(Isbn.display('9788806221768'), '978-88-0622176-8');
    });

    test('handles ISBN-10 the same way', () {
      expect(Isbn.display('0141036141'), '0-14103614-1');
    });

    test('leaves anything it cannot place alone', () {
      expect(Isbn.display('12345'), '12345');
    });
  });

  /// The editor's scan button reads a barcode and writes the number into the
  /// ISBN field, so whatever the camera produces has to survive that round
  /// trip: barcode -> stored value -> displayed value -> parsed back.
  group('scan-into-the-field round trip', () {
    for (final barcode in [
      '9789943231634', // Uzbek
      '9780141036144', // English
      '9785961426625', // Russian
      '978014103614450799', // with an EAN-5 price add-on
    ]) {
      test('survives $barcode', () {
        final captured = Isbn.fromBarcode(barcode);
        expect(captured, isNotNull);

        final shown = Isbn.display(captured!);
        // What the user sees must parse back to exactly what was scanned.
        expect(Isbn.normalize(shown), captured);
        expect(Isbn.isValid(shown), isTrue);
      });
    }

    test('a non-book barcode yields nothing to write into the field', () {
      expect(Isbn.fromBarcode('4006381333931'), isNull);
    });
  });
}
