import 'package:dio/dio.dart';

import '../../../features/profile/data/datasources/profile_remote_data_source.dart';
import '../../../features/profile/data/models/profile_model.dart';
import '../constants/rest_paths.dart';
import '../reference/reference_resolver.dart';
import 'auth_rest_data_source.dart' show emailToUsername;

/// Thrown when the app asks for a capability the REST backend does not expose.
///
/// Avatar upload is the current case: the Django backend has no avatar field or
/// upload endpoint, so there is nowhere to store an image. The UI falls back to
/// the first-letter avatar until the backend gains support.
class UnsupportedRestOperation implements Exception {
  const UnsupportedRestOperation(this.message);
  final String message;
  @override
  String toString() => 'UnsupportedRestOperation: $message';
}

/// REST implementation of [ProfileRemoteDataSource] against the Django backend.
///
/// Reads/writes the same `UserProfile` resource as auth. Update needs integer
/// `wilaya` / `blood_type` ids, resolved from the app's Arabic name / "O+"
/// label via [ReferenceResolver].
class ProfileRestDataSource implements ProfileRemoteDataSource {
  ProfileRestDataSource(this.dio, {required this.reference});

  final Dio dio;
  final ReferenceResolver reference;

  @override
  Future<ProfileModel> getProfile() async {
    final response = await dio.get<Map<String, dynamic>>(RestPaths.profile);
    return _mapProfile(response.data ?? const {});
  }

  @override
  Future<ProfileModel> updateProfile(ProfileModel profile) async {
    final response = await dio.patch<Map<String, dynamic>>(
      RestPaths.profile,
      data: {
        'email': profile.email,
        'phone': profile.phone,
        'gender': profile.gender,
        'date_of_birth': profile.dateOfBirth,
        'wilaya': await reference.wilayaIdForName(profile.city),
        'blood_type': await reference.bloodTypeIdForLabel(profile.bloodType),
        'weight_kg': profile.weight?.toString(),
      },
    );
    return _mapProfile(response.data ?? const {});
  }

  @override
  Future<ProfileModel> changeRole({
    required bool isDonor,
    required bool isRecipient,
  }) async {
    final response = await dio.post<Map<String, dynamic>>(
      RestPaths.switchMode,
      data: {'mode': isDonor ? 'donor' : 'recipient'},
    );
    // switch-mode may echo the profile; re-fetch if it does not.
    final data = response.data;
    if (data != null && data.containsKey('id')) return _mapProfile(data);
    return getProfile();
  }

  @override
  Future<String> uploadAvatar(String filePath) async {
    throw const UnsupportedRestOperation(
      'Avatar upload is not available on the REST backend yet.',
    );
  }

  ProfileModel _mapProfile(Map<String, dynamic> json) {
    final email = json['email']?.toString() ?? '';
    final mode = json['mode']?.toString();
    final wilaya = json['wilaya'];
    final bloodType = json['blood_type'];
    return ProfileModel(
      id: json['id']?.toString() ?? '',
      email: email,
      username: email.isEmpty ? '' : emailToUsername(email),
      fullName: json['full_name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      dateOfBirth: json['date_of_birth']?.toString() ?? '',
      gender: json['gender']?.toString() ?? '',
      bloodType: bloodType is Map<String, dynamic>
          ? (bloodType['label']?.toString() ?? '')
          : (bloodType?.toString() ?? ''),
      weight: _asDouble(json['weight_kg']),
      city: wilaya is Map<String, dynamic>
          ? (wilaya['name_ar']?.toString() ?? '')
          : (wilaya?.toString() ?? ''),
      avatarUrl: null, // deferred: no backend avatar field
      isDonor: mode == 'donor',
      isRecipient: mode == 'recipient',
      isActive: (json['status']?.toString() ?? 'active') == 'active',
    );
  }

  double? _asDouble(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString());
  }
}
