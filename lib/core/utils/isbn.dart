/// ISBN normalisation, validation and conversion.
///
/// ISBN identifies an *edition*, so every lookup and duplicate check runs
/// through here to make sure "978-0-241-63938-4" and "9780241639384" are
/// treated as the same book.
abstract final class Isbn {
  /// Strips hyphens, spaces and other separators; upper-cases a trailing "x".
  static String normalize(String raw) {
    final cleaned = raw.replaceAll(RegExp(r'[^0-9Xx]'), '').toUpperCase();
    return cleaned;
  }

  static bool isValid(String raw) {
    final v = normalize(raw);
    return v.length == 10 ? _isValid10(v) : (v.length == 13 && _isValid13(v));
  }

  static bool _isValid10(String v) {
    if (!RegExp(r'^\d{9}[\dX]$').hasMatch(v)) return false;
    var sum = 0;
    for (var i = 0; i < 10; i++) {
      final c = v[i];
      final digit = c == 'X' ? 10 : int.parse(c);
      sum += digit * (10 - i);
    }
    return sum % 11 == 0;
  }

  static bool _isValid13(String v) {
    // Every ISBN-13 lives in the bookland range. Requiring it stops a grocery
    // EAN-13 with a valid checksum being mistaken for a book.
    if (!RegExp(r'^97[89]\d{10}$').hasMatch(v)) return false;
    var sum = 0;
    for (var i = 0; i < 13; i++) {
      sum += int.parse(v[i]) * (i.isEven ? 1 : 3);
    }
    return sum % 10 == 0;
  }

  /// Converts a valid ISBN-10 to its ISBN-13 form. Returns null otherwise.
  static String? to13(String raw) {
    final v = normalize(raw);
    if (v.length == 13) return _isValid13(v) ? v : null;
    if (!_isValid10(v)) return null;
    final core = '978${v.substring(0, 9)}';
    var sum = 0;
    for (var i = 0; i < 12; i++) {
      sum += int.parse(core[i]) * (i.isEven ? 1 : 3);
    }
    final check = (10 - (sum % 10)) % 10;
    return '$core$check';
  }

  /// Converts a 978-prefixed ISBN-13 back to ISBN-10. Returns null otherwise.
  static String? to10(String raw) {
    final v = normalize(raw);
    if (v.length == 10) return _isValid10(v) ? v : null;
    if (!_isValid13(v) || !v.startsWith('978')) return null;
    final core = v.substring(3, 12);
    var sum = 0;
    for (var i = 0; i < 9; i++) {
      sum += int.parse(core[i]) * (10 - i);
    }
    final remainder = (11 - (sum % 11)) % 11;
    return '$core${remainder == 10 ? 'X' : remainder}';
  }

  /// Formats an ISBN-13 for display as the design shows it.
  static String display(String raw) {
    final v = normalize(raw);
    if (v.length == 13) {
      return '${v.substring(0, 3)}-${v.substring(3, 4)}-${v.substring(4, 7)}'
          '-${v.substring(7, 12)}-${v.substring(12)}';
    }
    if (v.length == 10) {
      return '${v.substring(0, 1)}-${v.substring(1, 4)}'
          '-${v.substring(4, 9)}-${v.substring(9)}';
    }
    return raw;
  }

  /// Barcode payloads on books are EAN-13 in the 978/979 bookland range. A
  /// 5-digit EAN-5 price add-on is sometimes appended by the scanner — drop it.
  static String? fromBarcode(String raw) {
    final v = normalize(raw);
    if (v.length == 18) {
      final candidate = v.substring(0, 13);
      return _isValid13(candidate) ? candidate : null;
    }
    if (v.length == 13) return _isValid13(v) ? v : null;
    if (v.length == 10 && _isValid10(v)) return to13(v);
    return null;
  }
}
