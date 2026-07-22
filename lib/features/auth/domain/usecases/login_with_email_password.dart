import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginWithUsernamePassword
    implements BaseUseCase<UserEntity, LoginParams> {
  final AuthRepository repository;

  LoginWithUsernamePassword(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(LoginParams params) {
    return repository.loginWithUsernamePassword(
      username: params.username,
      password: params.password,
    );
  }
}
