import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/providers.dart';
import 'data/local/database.dart';
import 'data/seed/seeder.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  // Month and day names for every language the app offers. Without this the
  // first date formatted in Uzbek or Russian throws before anything is drawn.
  await initializeDateFormatting();

  final database = AppDatabase();
  await database.ensureIndexes();

  // A first run gets a realistic sample library so every screen has something
  // to show. An existing database is never touched.
  await Seeder(database).seedIfEmpty();

  final preferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(database),
        preferencesProvider.overrideWithValue(preferences),
      ],
      child: const BookCollectionApp(),
    ),
  );
}
