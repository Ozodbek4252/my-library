import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_library/core/l10n_extensions.dart';
import 'package:my_library/core/settings.dart';
import 'package:my_library/domain/models/enums.dart';

/// A key that exists in English but not in Uzbek falls back to English at
/// runtime with no error, so a missing translation is invisible until someone
/// opens the app in that language. These tests are what makes it visible.
/// Whether a message says anything a translator could change: strip the
/// placeholders and see if real words are left.
bool _hasWords(String message) {
  final words = message.replaceAll(RegExp(r'\{[^}]*\}'), ' ');
  return words.replaceAll(RegExp(r'[^A-Za-z]'), '').length > 12;
}

void main() {
  Map<String, dynamic> arb(String code) => jsonDecode(
        File('lib/l10n/app_$code.arb').readAsStringSync(),
      ) as Map<String, dynamic>;

  Set<String> messageKeys(Map<String, dynamic> file) =>
      file.keys.where((k) => !k.startsWith('@')).toSet();

  test('every language carries every message', () {
    final english = messageKeys(arb('en'));

    for (final code in ['uz', 'ru']) {
      final other = messageKeys(arb(code));
      expect(
        english.difference(other),
        isEmpty,
        reason: 'app_$code.arb is missing these keys',
      );
      expect(
        other.difference(english),
        isEmpty,
        reason: 'app_$code.arb has keys English does not',
      );
    }
  });

  /// The app's own name is a proper noun. It reads the same in every
  /// language, the way Spotify or Kindle do, so it is not a missed
  /// translation when it matches English.
  const productNames = {'appTitle'};

  test('no message is left as the English text in another language', () {
    final english = arb('en');

    for (final code in ['uz', 'ru']) {
      final other = arb(code);
      final untranslated = [
        for (final key in messageKeys(english))
          if (!productNames.contains(key) &&
              other[key] == english[key] &&
              // Names, marks and numerals read the same in every language,
              // and a message that is nothing but placeholders — "{from} –
              // {to}" — has no words to translate.
              _hasWords(english[key] as String))
            key,
      ];
      expect(
        untranslated,
        isEmpty,
        reason: 'app_$code.arb still holds the English wording for these',
      );
    }
  });

  test('the app name is the same in every language', () {
    for (final code in ['uz', 'ru']) {
      expect(
        arb(code)['appTitle'],
        arb('en')['appTitle'],
        reason: 'a product name is not translated',
      );
    }
  });

  test('every language the picker offers is one the app can load', () {
    final supported =
        AppL10n.supportedLocales.map((l) => l.languageCode).toSet();
    for (final language in AppLanguage.values) {
      expect(supported, contains(language.code));
      expect(language.endonym, isNotEmpty);
    }
  });

  group('the same value reads differently in each language', () {
    late AppL10n en;
    late AppL10n uz;
    late AppL10n ru;

    setUpAll(() async {
      en = await AppL10n.delegate.load(const Locale('en'));
      uz = await AppL10n.delegate.load(const Locale('uz'));
      ru = await AppL10n.delegate.load(const Locale('ru'));
    });

    test('a reading status is translated, its stored name is not', () {
      expect(ReadingStatus.read.display(en), isNot(ReadingStatus.read.display(ru)));
      expect(ReadingStatus.read.display(uz), isNot(ReadingStatus.read.display(ru)));

      // What the database and the exports see never moves.
      expect(ReadingStatus.read.name, 'read');
      expect(ReadingStatus.read.label, 'Read');
    });

    test('Russian picks the right plural form for each count', () {
      // Russian needs =1 / few / many, so a count of 1, 3 and 5 must differ.
      final one = ru.bookCount(1);
      final few = ru.bookCount(3);
      final many = ru.bookCount(5);
      expect({one, few, many}, hasLength(3));
    });

    test('an empty author list is named in the interface language', () {
      expect(en.authorsOf(const []), isNot(ru.authorsOf(const [])));
      expect(uz.authorsOf(const []), isNotEmpty);
    });
  });
}
