import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/profile_entity.dart';

abstract class ProfileRepository {
  /// Locally cached profile from the last successful fetch, if any.
  /// Lets the UI render instantly while the remote refresh runs.
  Future<ProfileEntity?> getCachedProfile();

  Future<Either<Failure, ProfileEntity>> getProfile();
  Future<Either<Failure, ProfileEntity>> updateProfile(ProfileEntity profile);
  Future<Either<Failure, ProfileEntity>> setAccountStatus(bool isActive);
  Future<Either<Failure, ProfileEntity>> changeRole({
    required bool isDonor,
    required bool isRecipient,
  });
  Future<Either<Failure, String>> uploadAvatar(String filePath);
}
