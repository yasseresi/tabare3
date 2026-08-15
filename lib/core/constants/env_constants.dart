class EnvConstants {
  EnvConstants._();

  /// Base URL of the Django REST backend (used by `lib/backend/rest/`).
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );
}
