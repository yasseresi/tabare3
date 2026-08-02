import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/profile_model.dart';
import 'profile_remote_data_source.dart';

const profileSelectColumns =
    'id,email,username,full_name,phone,date_of_birth,gender,national_id,'
    'blood_type,weight,city,chronic_diseases,avatar_url,is_donor,is_recipient,'
    'is_active';

Map<String, dynamic> buildProfileUpdatePayload(ProfileModel profile) => {
  'username': profile.username,
  'phone': profile.phone,
  'weight': profile.weight,
  'city': profile.city,
  'chronic_diseases': profile.chronicDiseases,
  'avatar_url': profile.avatarUrl,
  'is_active': profile.isActive,
};

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final SupabaseClient client;

  ProfileRemoteDataSourceImpl({required this.client});

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
    final path = '$_userId/avatar.$ext';

    await client.storage
        .from('profile_pic')
        .uploadBinary(
          path,
          bytes,
          fileOptions: const FileOptions(upsert: true),
        );

    return client.storage.from('profile_pic').getPublicUrl(path);
  }
}
