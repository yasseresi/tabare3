import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class UpdateUserRole implements BaseUseCase<UserEntity, UpdateRoleParams> {
  final AuthRepository repository;

  UpdateUserRole(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(UpdateRoleParams params) {
    return repository.updateUserRole(
      isDonor: params.isDonor,
      isRecipient: params.isRecipient,
    );
  }
}

class UpdateRoleParams {
  final bool isDonor;
  final bool isRecipient;

  const UpdateRoleParams({
    required this.isDonor,
    required this.isRecipient,
  });
}
