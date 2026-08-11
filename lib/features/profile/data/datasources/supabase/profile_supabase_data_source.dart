import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/profile_model.dart';
import '../profile_remote_data_source.dart';

const profileSelectColumns =
    'id,email,username,full_name,phone,date_of_birth,gender,national_id,'
    'blood_type,weight,city,chronic_diseases,avatar_url,is_donor,is_recipient,'
    'is_active';

const _avatarBucket = 'profile_pic';

/// Object name for a newly uploaded avatar.
///
/// The name carries [at] so each upload lands on a fresh public URL. A fixed
/// name (`avatar.jpg`) reused the same URL on every change, and both the image
/// cache and the storage CDN kept serving the previous photo.
String buildAvatarObjectName({required String extension, required DateTime at}) =>
    'avatar_${at.millisecondsSinceEpoch}.$extension';

Map<String, dynamic> buildProfileUpdatePayload(ProfileModel profile) => {
  'username': profile.username,
  'phone': profile.phone,
  'weight': profile.weight,
  'city': profile.city,
  'chronic_diseases': profile.chronicDiseases,
  'avatar_url': profile.avatarUrl,
  'is_active': profile.isActive,
};

class ProfileSupabaseDataSource implements ProfileRemoteDataSource {
  final SupabaseClient client;

  ProfileSupabaseDataSource({required this.client});

  String get _userId => client.auth.currentUser!.id;

  @override
  Future<ProfileModel> getProfile() async {
    final response = await client
        .from('users')
        .select(profileSelectColumns)
        .eq('id', _userId)
        .single();

    return ProfileModel.fromJson(response);
  }

  @override
  Future<ProfileModel> updateProfile(ProfileModel profile) async {
    final response = await client
        .from('users')
        .update(buildProfileUpdatePayload(profile))
        .eq('id', _userId)
        .select(profileSelectColumns)
        .single();

    return ProfileModel.fromJson(response);
  }

  @override
  Future<ProfileModel> changeRole({
    required bool isDonor,
    required bool isRecipient,
  }) async {
    final response = await client
        .from('users')
        .update({
          'is_donor': isDonor,
          'is_recipient': isRecipient,
          'active_mode': isDonor ? 'donor' : 'recipient',
        })
        .eq('id', _userId)
        .select(profileSelectColumns)
        .single();

    return ProfileModel.fromJson(response);
  }

  @override
  Future<String> uploadAvatar(String filePath) async {
    final file = File(filePath);
    final bytes = await file.readAsBytes();
    final ext = filePath.split('.').last.toLowerCase();
    final name = buildAvatarObjectName(extension: ext, at: DateTime.now());
    final path = '$_userId/$name';

    await client.storage
        .from(_avatarBucket)
        .uploadBinary(
          path,
          bytes,
          fileOptions: const FileOptions(upsert: true),
        );

    await _removeSupersededAvatars(keep: name);

    return client.storage.from(_avatarBucket).getPublicUrl(path);
  }

  /// Deletes the user's previous avatar objects so versioned names don't
  /// accumulate. Best-effort: the upload already succeeded by this point, so a
  /// failed cleanup must not surface as a failed avatar change. Any leftover
  /// object is unreferenced and safe to collect later.
  Future<void> _removeSupersededAvatars({required String keep}) async {
    try {
      final existing = await client.storage
          .from(_avatarBucket)
          .list(path: _userId);
      final superseded = existing
          .where((object) => object.name != keep)
          .map((object) => '$_userId/${object.name}')
          .toList();
      if (superseded.isNotEmpty) {
        await client.storage.from(_avatarBucket).remove(superseded);
      }
    } catch (_) {
      // Intentionally ignored — see doc comment.
    }
  }
}
