import 'package:intl/intl.dart';

/// Dates and numbers, formatted for whichever language the app is in.
///
/// The locale is set once when the interface language changes rather than
/// threaded through every call site, because every one of these is a leaf of
/// the widget tree and a parameter on all of them would drown the screens.
abstract final class Fmt {
  static String _locale = 'en';

  /// Called when the interface language changes.
  ///
  /// Date symbols are loaded once at startup. If they are not there — an
  /// entry point that skipped `initializeDateFormatting`, or a language intl
  /// has no data for — dates keep the formats they had. Wrong month names are
  /// a blemish; a blank app is not.
  static set locale(String value) {
    if (_locale == value) return;
    try {
      _day = DateFormat.yMMMd(value);
      _shortDay = DateFormat.MMMd(value);
      _monthYear = DateFormat.yMMMM(value);
      _monthShort = DateFormat.yMMM(value);
      _monthName = DateFormat.MMMM(value);
      _thousands = NumberFormat('#,###', value);
      _locale = value;
    } catch (_) {
      // Keep the formats already in place.
    }
  }

  static String get locale => _locale;

  static DateFormat _day = DateFormat.yMMMd('en');
  static DateFormat _shortDay = DateFormat.MMMd('en');
  static DateFormat _monthYear = DateFormat.yMMMM('en');
  static DateFormat _monthShort = DateFormat.yMMM('en');
  static DateFormat _monthName = DateFormat.MMMM('en');
  static NumberFormat _thousands = NumberFormat('#,###', 'en');

  static String date(DateTime? d) => d == null ? '—' : _day.format(d);
  static String shortDate(DateTime? d) => d == null ? '—' : _shortDay.format(d);
  static String monthYear(DateTime d) => _monthYear.format(d);
  static String monthShort(DateTime d) => _monthShort.format(d);
  static String monthName(DateTime d) => _monthName.format(d);
  static String count(num n) => _thousands.format(n);

  static String money(double? amount, String? currency) {
    if (amount == null) return '—';
    final symbol = switch (currency) {
      'GBP' => '£',
      'USD' => r'$',
      'EUR' => '€',
      'RUB' => '₽',
      'UZS' => "so'm",
      _ => '',
    };
    final value = amount == amount.roundToDouble() && amount >= 1000
        ? _thousands.format(amount)
        : amount.toStringAsFixed(2);
    return symbol.isEmpty ? '$value ${currency ?? ''}'.trim() : '$symbol$value';
  }

  static String stars(double? r) =>
      r == null || r == 0 ? '' : '★' * r.round().clamp(0, 5);

  /// How many whole days lie between two moments.
  static int daysBetween(DateTime from, DateTime to) => to.difference(from).inDays;

  /// Joins non-empty parts with the design's middle dot separator.
  static String dotted(Iterable<String?> parts) =>
      parts.where((p) => p != null && p.trim().isNotEmpty).join(' · ');

  /// Surname used for the uppercase line on a cover placeholder.
  static String surname(List<String> authors) {
    if (authors.isEmpty) return '';
    final parts = authors.first.trim().split(RegExp(r'\s+'));
    return parts.isEmpty ? '' : parts.last;
  }
}
