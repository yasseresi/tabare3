import 'package:dio/dio.dart';

import '../../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../../features/auth/data/models/user_model.dart';
import '../../../features/auth/domain/repositories/auth_repository.dart';
import '../constants/rest_paths.dart';
import '../reference/reference_resolver.dart';
import '../token_store.dart';

/// The app authenticates by username; the Django API only knows email. Usernames
/// are mapped onto a fixed fake domain (mirrors the Supabase data source), so the
/// bridge is reversible: `email.split('@').first` recovers the username.
const String fakeEmailDomain = 'tabara3.dz';

String usernameToEmail(String username) => '$username@$fakeEmailDomain';
String emailToUsername(String email) => email.split('@').first;

/// REST implementation of [AuthRemoteDataSource] against the Django backend.
///
/// Login yields a `{access, refresh}` JWT pair persisted in [TokenStore]; the
/// user itself comes from `GET /profile/`. Register needs integer `wilaya` /
/// `blood_type` ids, resolved from the app's Arabic name / "O+" label via
/// [ReferenceResolver].
class AuthRestDataSource implements AuthRemoteDataSource {
  AuthRestDataSource(
    this.dio, {
    required this.tokenStore,
    required this.reference,
  });

  final Dio dio;
  final TokenStore tokenStore;
  final ReferenceResolver reference;

  @override
  Future<UserModel> signIn({
    required String username,
    required String password,
  }) async {
    final response = await dio.post<Map<String, dynamic>>(
      RestPaths.login,
      data: {'email': usernameToEmail(username), 'password': password},
    );
    await _persistTokens(response.data);
    return _fetchProfile();
  }

  @override
  Future<UserModel> signUp({required SignupParams params}) async {
    final response = await dio.post<Map<String, dynamic>>(
      RestPaths.register,
      data: await _registerBody(params),
    );
    final data = response.data ?? const {};
    // Register returns `{user, access, refresh}` — use them directly. Fall back
    // to an explicit sign-in only if a future backend stops returning tokens.
    final user = data['user'];
    if (data['access'] is String && user is Map<String, dynamic>) {
      await _persistTokens(data);
      return _mapProfile(user);
    }
    return signIn(username: params.username, password: params.password);
  }

  @override
  Future<bool> isUsernameAvailable(String username) async {
    final response = await dio.get<Map<String, dynamic>>(
      RestPaths.emailAvailable,
      queryParameters: {'email': usernameToEmail(username)},
    );
    return response.data?['available'] == true;
  }

  @override
  Future<void> signOut() async {
    await tokenStore.clear();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final access = await tokenStore.readAccess();
    if (access == null || access.isEmpty) return null;
    return _fetchProfile();
  }

  @override
  Future<UserModel> updateUserRole({
    required bool isDonor,
    required bool isRecipient,
  }) async {
    await dio.post<Map<String, dynamic>>(
      RestPaths.switchMode,
      data: {'mode': isDonor ? 'donor' : 'recipient'},
    );
    return _fetchProfile();
  }

  Future<Map<String, dynamic>> _registerBody(SignupParams params) async {
    final names = _splitName(params.fullName);
    return {
      'first_name': names.$1,
      'last_name': names.$2,
      'email': usernameToEmail(params.username),
      'phone': params.phone,
      'gender': params.gender,
      'date_of_birth': _isoDate(params.dateOfBirth),
      'wilaya': await reference.wilayaIdForName(params.city),
      'blood_type': await reference.bloodTypeIdForLabel(params.bloodType),
      'weight_kg': params.weight?.toString(),
      'password': params.password,
      'password_confirm': params.password,
    };
  }

  Future<void> _persistTokens(Map<String, dynamic>? data) async {
    final access = data?['access'] as String?;
    final refresh = data?['refresh'] as String?;
    if (access != null && refresh != null) {
      await tokenStore.save(access: access, refresh: refresh);
    }
  }

  Future<UserModel> _fetchProfile() async {
    final response = await dio.get<Map<String, dynamic>>(RestPaths.profile);
    return _mapProfile(response.data ?? const {});
  }

  /// Maps the Django `UserProfile` JSON onto the app's [UserModel].
  UserModel _mapProfile(Map<String, dynamic> json) {
    final email = json['email']?.toString() ?? '';
    final mode = json['mode']?.toString();
    final bloodType = json['blood_type'];
    return UserModel(
      id: json['id']?.toString() ?? '',
      email: email,
      username: email.isEmpty ? '' : emailToUsername(email),
      fullName: json['full_name']?.toString() ?? '',
      isDonor: mode == 'donor',
      isRecipient: mode == 'recipient',
      bloodType: bloodType is Map<String, dynamic>
          ? (bloodType['label']?.toString() ?? '')
          : (bloodType?.toString() ?? ''),
    );
  }

  (String, String) _splitName(String fullName) {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return ('', '');
    if (parts.length == 1) return (parts.first, parts.first);
    return (parts.first, parts.sublist(1).join(' '));
  }

  String _isoDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';
}
