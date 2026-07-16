import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginWithEmailPassword implements BaseUseCase<UserEntity, LoginParams> {
  final AuthRepository repository;

  LoginWithEmailPassword(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(LoginParams params) {
    return repository.loginWithEmailPassword(
      email: params.email,
      password: params.password,
    );
  }
}
