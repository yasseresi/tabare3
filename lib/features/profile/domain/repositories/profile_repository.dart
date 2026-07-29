import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileEntity>> getProfile();
  Future<Either<Failure, ProfileEntity>> updateProfile(ProfileEntity profile);
  Future<Either<Failure, ProfileEntity>> changeRole({
    required bool isDonor,
    required bool isRecipient,
  });
  Future<Either<Failure, String>> uploadAvatar(String filePath);
}
