import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/local/database.dart';
import '../data/metadata/book_metadata.dart';
import '../data/metadata/composite_metadata_repository.dart';
import '../data/metadata/local_catalog_source.dart';
import '../data/metadata/open_library_source.dart';
import '../data/repositories/library_repository.dart';
import '../data/repositories/reading_repository.dart';
import '../data/repositories/scan_service.dart';
import '../data/repositories/statistics_repository.dart';
import '../data/repositories/wishlist_repository.dart';
import '../data/seed/seeder.dart';

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

/// The bundled catalogue answers first — instantly and offline — and Open
/// Library fills the gaps. Swapping providers happens only here.
final bookMetadataRepositoryProvider = Provider<BookMetadataRepository>((ref) {
  final remote = OpenLibrarySource();
  ref.onDispose(remote.close);
  return CompositeBookMetadataRepository([
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
