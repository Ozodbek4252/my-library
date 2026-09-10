import 'package:intl/intl.dart';

final _day = DateFormat('d MMM yyyy');
final _shortDay = DateFormat('d MMM');
final _monthYear = DateFormat('MMMM yyyy');
final _monthShort = DateFormat('MMM yyyy');
final _thousands = NumberFormat('#,###');

abstract final class Fmt {
  static String date(DateTime? d) => d == null ? '—' : _day.format(d);
  static String shortDate(DateTime? d) => d == null ? '—' : _shortDay.format(d);
  static String monthYear(DateTime d) => _monthYear.format(d);
  static String monthShort(DateTime d) => _monthShort.format(d);
  static String count(num n) => _thousands.format(n);

  static String money(double? amount, String? currency) {
    if (amount == null) return '—';
    final symbol = switch (currency) {
      'GBP' => '£',
      'USD' => r'$',
      'EUR' => '€',
      'RUB' => '₽',
      _ => '',
    };
    final value = amount == amount.roundToDouble() && amount >= 1000
        ? _thousands.format(amount)
        : amount.toStringAsFixed(2);
    return symbol.isEmpty ? '$value ${currency ?? ''}'.trim() : '$symbol$value';
  }

  static String rating(double? r) =>
      r == null || r == 0 ? 'Unrated' : '★ ${r.toStringAsFixed(1)}';

  static String stars(double? r) =>
      r == null || r == 0 ? '' : '★' * r.round().clamp(0, 5);

  /// "12 days in" / "3 days" — how long a read took or has been going.
  static String durationDays(DateTime from, DateTime to) {
    final days = to.difference(from).inDays;
    if (days <= 0) return 'today';
    return days == 1 ? '1 day' : '$days days';
  }

  /// Joins non-empty parts with the design's middle dot separator.
  static String dotted(Iterable<String?> parts) =>
      parts.where((p) => p != null && p.trim().isNotEmpty).join(' · ');

  /// Author list as shown in the UI. Long lists collapse rather than wrap
  /// endlessly across a card.
  static String authors(List<String> authors) {
    if (authors.isEmpty) return 'Unknown author';
    if (authors.length <= 2) return authors.join(' & ');
    return '${authors.first} & ${authors.length - 1} others';
  }

  /// Surname used for the uppercase line on a cover placeholder.
  static String surname(List<String> authors) {
    if (authors.isEmpty) return '';
    final parts = authors.first.trim().split(RegExp(r'\s+'));
    return parts.isEmpty ? '' : parts.last;
  }

  static String pluralBooks(int n) => n == 1 ? '1 book' : '$n books';
}
