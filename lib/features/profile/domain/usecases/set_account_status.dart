import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class SetAccountStatus implements BaseUseCase<ProfileEntity, bool> {
  final ProfileRepository repository;

  SetAccountStatus(this.repository);

  @override
  Future<Either<Failure, ProfileEntity>> call(bool isActive) {
    return repository.setAccountStatus(isActive);
  }
}
