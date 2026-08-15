import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile();
  Future<ProfileModel> updateProfile(ProfileModel profile);
  Future<ProfileModel> setAccountStatus(bool isActive);
  Future<ProfileModel> changeRole({
    required bool isDonor,
    required bool isRecipient,
  });
  Future<String> uploadAvatar(String filePath);
}
