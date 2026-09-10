import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../core/settings.dart';
import '../../../data/repositories/library_query.dart';
import '../../../data/repositories/library_repository.dart';
import '../../../domain/models/enums.dart';
import '../../../domain/models/library_models.dart';

/// Search text, filters and sort for the library screen. Sort is mirrored into
/// preferences so it survives a restart, as the design specifies.
class LibraryQueryNotifier extends Notifier<LibraryQuery> {
  @override
  LibraryQuery build() =>
      LibraryQuery(sort: ref.watch(settingsProvider.select((s) => s.sort)));

  void setSearch(String value) {
    if (state.search == value) return;
    state = state.copyWith(search: value);
    ref.read(libraryPageProvider.notifier).reset();
  }

  void toggleFilter(FilterGroup group, String value) {
    state = state.toggleFilter(group, value);
    ref.read(libraryPageProvider.notifier).reset();
  }

  void clearFilters() {
    state = state.clearFilters();
    ref.read(libraryPageProvider.notifier).reset();
  }

  void setSort(SortOption sort) {
    state = state.copyWith(sort: sort);
    ref.read(settingsProvider.notifier).setSort(sort);
    ref.read(libraryPageProvider.notifier).reset();
  }
}

final libraryQueryProvider =
    NotifierProvider<LibraryQueryNotifier, LibraryQuery>(
  LibraryQueryNotifier.new,
);

/// How many pages of the library have been requested. The grid grows as the
/// user scrolls rather than loading a whole large collection at once.
class LibraryPageNotifier extends Notifier<int> {
  @override
  int build() => 1;

  void reset() => state = 1;
  void loadMore() => state = state + 1;
}

final libraryPageProvider =
    NotifierProvider<LibraryPageNotifier, int>(LibraryPageNotifier.new);

final libraryEntriesProvider = StreamProvider<List<LibraryEntry>>((ref) {
  final repository = ref.watch(libraryRepositoryProvider);
  final query = ref.watch(libraryQueryProvider);
  final pages = ref.watch(libraryPageProvider);
  return repository.watchLibrary(
    query,
    limit: LibraryRepository.pageSize * pages,
  );
});

/// How many books the current query matches, for "${N} of 214 shown".
final libraryMatchCountProvider = StreamProvider<int>((ref) {
  final repository = ref.watch(libraryRepositoryProvider);
  return repository.watchLibraryCount(ref.watch(libraryQueryProvider));
});

final libraryTotalProvider = StreamProvider<int>(
  (ref) => ref.watch(libraryRepositoryProvider).watchTotalOwned(),
);

final libraryStatsProvider = StreamProvider<LibraryStats>(
  (ref) => ref.watch(libraryRepositoryProvider).watchLibraryStats(),
);

/// Filter options come from the collection itself, so the sheet never offers a
/// value that would return nothing.
final filterOptionsProvider =
    FutureProvider<Map<FilterGroup, List<String>>>((ref) {
  // Re-read whenever the library changes.
  ref.watch(libraryTotalProvider);
  return ref.watch(libraryRepositoryProvider).filterOptions();
});

/// How many distinct shelf locations the collection uses — the "12 shelves"
/// in the library subtitle.
final shelfCountProvider = FutureProvider<int>((ref) async {
  ref.watch(libraryTotalProvider);
  final db = ref.watch(databaseProvider);
  final rows = await db.select(db.copies).get();
  return rows
      .map((c) => c.location)
      .whereType<String>()
      .where((l) => l.trim().isNotEmpty)
      .toSet()
      .length;
});
