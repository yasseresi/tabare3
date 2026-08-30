class EnvConstants {
  EnvConstants._();

  /// Default base URL of the Django REST backend (used by `lib/backend/rest/`).
  ///
  /// Baked in so `flutter run` / `flutter build` work without any
  /// `--dart-define`. Override per-build with
  /// `--dart-define=API_BASE_URL=...` (or `--dart-define-from-file=.env`)
  /// when pointing at a different backend.
  static const String _defaultApiBaseUrl =
      'https://blood-backend-dz.onrender.com/api/v1';

  /// Base URL of the Django REST backend (used by `lib/backend/rest/`).
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: _defaultApiBaseUrl,
  );
}
