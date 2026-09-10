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

  test('display formats an ISBN the way the design shows it', () {
    expect(Isbn.display('9780141036144'), '978-0-141-03614-4');
  });
}
