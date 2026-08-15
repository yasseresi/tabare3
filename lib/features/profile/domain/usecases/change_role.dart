import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class ChangeRoleParams {
  final bool isDonor;
  final bool isRecipient;

  const ChangeRoleParams({required this.isDonor, required this.isRecipient});
}

class ChangeRole implements BaseUseCase<ProfileEntity, ChangeRoleParams> {
  final ProfileRepository repository;

  ChangeRole(this.repository);

  @override
  Future<Either<Failure, ProfileEntity>> call(ChangeRoleParams params) {
    return repository.changeRole(
      isDonor: params.isDonor,
      isRecipient: params.isRecipient,
    );
  }
}
