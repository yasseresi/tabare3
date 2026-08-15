import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persists the JWT pair the REST backend issues.
///
/// The rest of the app never touches tokens directly — the REST client reads
/// them to sign requests and refreshes them on `401`.
abstract class TokenStore {
  Future<void> save({required String access, required String refresh});
  Future<String?> readAccess();
  Future<String?> readRefresh();
  Future<void> clear();
}

/// [TokenStore] backed by the platform secure enclave / keystore.
///
/// Tokens are secrets: a prior audit flagged SharedPreferences token storage,
/// so they live in `flutter_secure_storage`, never in plain prefs.
class SecureTokenStore implements TokenStore {
  SecureTokenStore({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const String accessKey = 'rest_access_token';
  static const String refreshKey = 'rest_refresh_token';

  @override
  Future<void> save({required String access, required String refresh}) async {
    await _storage.write(key: accessKey, value: access);
    await _storage.write(key: refreshKey, value: refresh);
  }

  @override
  Future<String?> readAccess() => _storage.read(key: accessKey);

  @override
  Future<String?> readRefresh() => _storage.read(key: refreshKey);

  @override
  Future<void> clear() async {
    await _storage.delete(key: accessKey);
    await _storage.delete(key: refreshKey);
  }
}
