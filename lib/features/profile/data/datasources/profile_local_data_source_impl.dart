import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/profile_model.dart';
import 'profile_local_data_source.dart';

const _cachedProfileKey = 'CACHED_PROFILE';

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  @override
  Future<ProfileModel?> getLastProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_cachedProfileKey);
    if (jsonString == null) return null;

    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return ProfileModel.fromJson(json);
  }

  @override
  Future<void> cacheProfile(ProfileModel profile) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(profile.toJson());
    await prefs.setString(_cachedProfileKey, jsonString);
  }

  @override
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cachedProfileKey);
  }
}
