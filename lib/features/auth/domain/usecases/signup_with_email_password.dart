import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignupWithUsernamePassword implements BaseUseCase<UserEntity, SignupParams> {
  final AuthRepository repository;

  SignupWithUsernamePassword(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(SignupParams params) {
    return repository.signupWithUsernamePassword(params: params);
  }
}
