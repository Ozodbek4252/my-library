import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../data/repositories/wishlist_repository.dart';
import '../../../domain/models/library_models.dart';

/// The chip selected above the wishlist. Null means "All".
class WishlistFilterNotifier extends Notifier<WishlistFilter?> {
  @override
  WishlistFilter? build() => null;

  void select(WishlistFilter? filter) => state = filter;
}

final wishlistFilterProvider =
    NotifierProvider<WishlistFilterNotifier, WishlistFilter?>(
  WishlistFilterNotifier.new,
);

final wishlistProvider = StreamProvider<List<WishlistEntry>>((ref) {
  final filter = ref.watch(wishlistFilterProvider);
  return ref.watch(wishlistRepositoryProvider).watchWishlist(filter: filter);
});

final wishlistFiltersProvider = FutureProvider<List<WishlistFilter>>((ref) {
  ref.watch(wishlistCountProvider);
  return ref.watch(wishlistRepositoryProvider).availableFilters();
});

final wishlistCountProvider = StreamProvider<int>(
  (ref) => ref.watch(wishlistRepositoryProvider).watchCount(),
);

final wishlistItemProvider =
    StreamProvider.family<WishlistEntry?, String>((ref, itemId) {
  return ref.watch(wishlistRepositoryProvider).watchItem(itemId);
});
