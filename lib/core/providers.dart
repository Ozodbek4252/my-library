import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/local/database.dart';
import '../data/metadata/book_metadata.dart';
import '../data/metadata/book_scraper_source.dart';
import '../data/metadata/composite_metadata_repository.dart';
import '../data/metadata/local_catalog_source.dart';
import '../data/metadata/open_library_source.dart';
import '../data/repositories/library_repository.dart';
import '../data/repositories/reading_repository.dart';
import '../data/repositories/scan_service.dart';
import '../data/repositories/statistics_repository.dart';
import '../data/repositories/wishlist_repository.dart';
import '../data/seed/seeder.dart';
import 'config.dart';

/// Both of these are created before `runApp` and injected as overrides, so
/// nothing in the tree has to deal with an uninitialised database.
final databaseProvider = Provider<AppDatabase>(
  (ref) => throw UnimplementedError('databaseProvider must be overridden'),
);

final preferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('preferencesProvider must be overridden'),
);

final libraryRepositoryProvider = Provider(
  (ref) => LibraryRepository(ref.watch(databaseProvider)),
);

final readingRepositoryProvider = Provider(
  (ref) => ReadingRepository(ref.watch(databaseProvider)),
);

final wishlistRepositoryProvider = Provider(
  (ref) => WishlistRepository(ref.watch(databaseProvider)),
);

final statisticsRepositoryProvider = Provider(
  (ref) => StatisticsRepository(ref.watch(databaseProvider)),
);

final seederProvider = Provider(
  (ref) => Seeder(ref.watch(databaseProvider)),
);

/// The project's own lookup service, when one is configured — it holds the
/// Uzbek ISBNs the global providers do not. The bundled catalogue answers next
/// (instantly, and with no network at all), then Open Library fills the gaps.
/// Swapping providers happens only here.
final bookScraperSourceProvider = Provider<BookScraperSource?>((ref) {
  if (!AppConfig.hasBookApi) return null;
  final source = BookScraperSource(
    baseUrl: AppConfig.bookApiBaseUrl,
    token: AppConfig.bookApiToken.isEmpty ? null : AppConfig.bookApiToken,
  );
  ref.onDispose(source.close);
  return source;
});

final bookMetadataRepositoryProvider = Provider<BookMetadataRepository>((ref) {
  final remote = OpenLibrarySource();
  ref.onDispose(remote.close);

  final scraper = ref.watch(bookScraperSourceProvider);

  return CompositeBookMetadataRepository([
    ?scraper,
    const LocalCatalogSource(),
    remote,
  ]);
});

final scanServiceProvider = Provider(
  (ref) => ScanService(
    metadata: ref.watch(bookMetadataRepositoryProvider),
    library: ref.watch(libraryRepositoryProvider),
    wishlist: ref.watch(wishlistRepositoryProvider),
  ),
);
