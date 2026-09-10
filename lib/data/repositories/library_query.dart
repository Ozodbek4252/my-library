import '../../domain/models/enums.dart';

/// The set of selections that turn the full library into what is on screen.
/// Options inside a group are OR-ed, groups are AND-ed together, exactly as
/// the filter sheet describes.
class LibraryQuery {
  const LibraryQuery({
    this.search = '',
    this.filters = const {},
    this.sort = SortOption.recentlyAdded,
    this.ownership = Ownership.owned,
  });

  final String search;
  final Map<FilterGroup, Set<String>> filters;
  final SortOption sort;

  /// Which shelf this query reads. The library screen shows owned books;
  /// previously-owned books are reachable through filters later.
  final Ownership? ownership;

  bool get hasFilters => filters.values.any((v) => v.isNotEmpty);

  int get activeFilterCount =>
      filters.values.fold(0, (sum, v) => sum + v.length);

  /// Flat list of active filters, used to render the removable ink pills.
  List<(FilterGroup, String)> get activeFilters => [
        for (final entry in filters.entries)
          for (final value in entry.value) (entry.key, value),
      ];

  LibraryQuery copyWith({
    String? search,
    Map<FilterGroup, Set<String>>? filters,
    SortOption? sort,
  }) =>
      LibraryQuery(
        search: search ?? this.search,
        filters: filters ?? this.filters,
        sort: sort ?? this.sort,
        ownership: ownership,
      );

  LibraryQuery toggleFilter(FilterGroup group, String value) {
    final next = {
      for (final e in filters.entries) e.key: {...e.value},
    };
    final set = next.putIfAbsent(group, () => <String>{});
    if (!set.remove(value)) set.add(value);
    if (set.isEmpty) next.remove(group);
    return copyWith(filters: next);
  }

  LibraryQuery clearFilters() => copyWith(filters: const {});

  @override
  bool operator ==(Object other) =>
      other is LibraryQuery &&
      other.search == search &&
      other.sort == sort &&
      other.ownership == ownership &&
      _sameFilters(other.filters, filters);

  @override
  int get hashCode => Object.hash(
        search,
        sort,
        ownership,
        Object.hashAllUnordered([
          for (final e in filters.entries)
            Object.hash(e.key, Object.hashAllUnordered(e.value)),
        ]),
      );

  static bool _sameFilters(
    Map<FilterGroup, Set<String>> a,
    Map<FilterGroup, Set<String>> b,
  ) {
    if (a.length != b.length) return false;
    for (final entry in a.entries) {
      final other = b[entry.key];
      if (other == null || other.length != entry.value.length) return false;
      if (!other.containsAll(entry.value)) return false;
    }
    return true;
  }
}
