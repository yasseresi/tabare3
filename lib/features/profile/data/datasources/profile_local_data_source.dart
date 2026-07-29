import '../models/profile_model.dart';

abstract class ProfileLocalDataSource {
  Future<ProfileModel?> getLastProfile();
  Future<void> cacheProfile(ProfileModel profile);
  Future<void> clearCache();
}
