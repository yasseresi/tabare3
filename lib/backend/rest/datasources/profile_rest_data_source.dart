import 'package:dio/dio.dart';

import '../../../features/profile/data/datasources/profile_remote_data_source.dart';
import '../../../features/profile/data/models/profile_model.dart';
import '../constants/rest_paths.dart';
import '../reference/reference_resolver.dart';
import '../rest_error_mapper.dart' show RestValidationException;
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
    // Resolve + guard before PATCHing: sending a null FK would 400 or, worse,
    // null out the user's stored wilaya/blood type. Mirrors createRequest/signUp.
    final wilayaId = await reference.wilayaIdForName(profile.city);
    final bloodTypeId = await reference.bloodTypeIdForLabel(profile.bloodType);
    if (wilayaId == null) {
      throw RestValidationException('Unknown wilaya: ${profile.city}');
    }
    if (bloodTypeId == null) {
      throw RestValidationException('Unknown blood type: ${profile.bloodType}');
    }
    final response = await dio.patch<Map<String, dynamic>>(
      RestPaths.profile,
      data: {
        'email': profile.email,
        'phone': profile.phone,
        'gender': profile.gender,
        'date_of_birth': profile.dateOfBirth,
        'wilaya': wilayaId,
        'blood_type': bloodTypeId,
        'weight_kg': profile.weight?.toString(),
        // The app edits chronic diseases as free text; Django keeps free-text
        // entries as `custom_conditions` (per-account, not added to the shared
        // list). No id matching, so `condition_ids` stays empty.
        'condition_ids': const <int>[],
        'custom_conditions': _splitConditions(profile.chronicDiseases),
      },
    );
    return _mapProfile(response.data ?? const {});
  }

  @override
  Future<ProfileModel> setAccountStatus(bool isActive) async {
    final response = await dio.post<Map<String, dynamic>>(
      RestPaths.toggleStatus,
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
      chronicDiseases: _joinConditions(json),
    );
  }

  /// Django exposes known conditions as `conditions` (objects with `name_ar`)
  /// and free-text ones as `chronic_conditions` (strings). The app shows both
  /// as one free-text field, so they are joined.
  String? _joinConditions(Map<String, dynamic> json) {
    final names = <String>[
      ...?(json['conditions'] as List<dynamic>?)
          ?.whereType<Map<String, dynamic>>()
          .map((c) => c['name_ar']?.toString() ?? '')
          .where((s) => s.isNotEmpty),
      ...?(json['chronic_conditions'] as List<dynamic>?)
          ?.map((c) => c.toString())
          .where((s) => s.isNotEmpty),
    ];
    return names.isEmpty ? null : names.join('، ');
  }

  List<String> _splitConditions(String? text) {
    if (text == null || text.trim().isEmpty) return const [];
    return text
        .split(RegExp('[،,]'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList(growable: false);
  }

  double? _asDouble(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString());
  }
}
