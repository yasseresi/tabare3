import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class UpdateProfile implements BaseUseCase<ProfileEntity, ProfileEntity> {
  final ProfileRepository repository;

  UpdateProfile(this.repository);

  @override
  Future<Either<Failure, ProfileEntity>> call(ProfileEntity params) {
    return repository.updateProfile(params);
  }
}
