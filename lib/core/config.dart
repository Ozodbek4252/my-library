/// Build-time configuration.
///
/// The lookup service is the project's own book database — the one that holds
/// Uzbek ISBNs the global providers do not have. Point the app at a different
/// deployment, or at a machine on your network, without touching the code:
///
/// ```sh
/// flutter run --dart-define=BOOK_API_BASE_URL=http://192.168.1.20:8000
/// ```
///
/// Either form of URL works, with or without the `/api/v1` suffix. Set it to an
/// empty string to switch the service off entirely; the app still works, with
/// the bundled catalogue answering offline and Open Library covering the rest.
abstract final class AppConfig {
  static const bookApiBaseUrl = String.fromEnvironment(
    'BOOK_API_BASE_URL',
    defaultValue: 'https://189.74.98.147.sslip.io/api/v1',
  );

  /// Sanctum token, for when the service turns its auth middleware back on.
  static const bookApiToken =
      String.fromEnvironment('BOOK_API_TOKEN', defaultValue: '');

  static bool get hasBookApi => bookApiBaseUrl.trim().isNotEmpty;
}
