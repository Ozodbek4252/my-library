/// Every route path in one place, so screens navigate by name rather than by
/// hand-built strings.
abstract final class Routes {
  static const onboarding = '/onboarding';

  static const library = '/library';
  static const reading = '/reading';
  static const wishlist = '/wishlist';
  static const profile = '/profile';

  static const statistics = '/profile/statistics';

  // Presented over the shell, with the bottom nav hidden.
  static const search = '/search';
  static const scanner = '/scan';

  /// Reads a barcode and returns the ISBN to the caller, without looking it up.
  static const scanIsbn = '/scan/isbn';
  static const addBook = '/add';
  static const importExport = '/import';

  static String bookDetails(String workId) => '/library/book/$workId';
  static String bookEditions(String workId) => '/library/book/$workId/editions';
  static String editCopy(String workId, String copyId) =>
      '/library/book/$workId/copy/$copyId/edit';
  static String editBook(String workId) => '/library/book/$workId/edit';
  static String wishlistDetail(String itemId) => '/wishlist/$itemId';
}
