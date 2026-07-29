import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/profile_model.dart';
import 'profile_remote_data_source.dart';

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final SupabaseClient client;

  ProfileRemoteDataSourceImpl({required this.client});

  String get _userId => client.auth.currentUser!.id;

  @override
  Future<ProfileModel> getProfile() async {
    final response = await client
        .from('users')
        .select()
        .eq('id', _userId)
        .single();

    return ProfileModel.fromJson(response);
  }

  @override
  Future<ProfileModel> updateProfile(ProfileModel profile) async {
    final response = await client
        .from('users')
        .update(_toUpdateMap(profile))
        .eq('id', _userId)
        .select()
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
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('id', _userId)
        .select()
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

  Map<String, dynamic> _toUpdateMap(ProfileModel profile) => {
    'full_name': profile.fullName,
    'phone': profile.phone,
    'date_of_birth': profile.dateOfBirth,
    'gender': profile.gender,
    'national_id': profile.nationalId,
    'blood_type': profile.bloodType,
    'weight': profile.weight,
    'city': profile.city,
    'chronic_diseases': profile.chronicDiseases,
    'avatar_url': profile.avatarUrl,
    'is_active': profile.isActive,
    'updated_at': DateTime.now().toUtc().toIso8601String(),
  };
}
