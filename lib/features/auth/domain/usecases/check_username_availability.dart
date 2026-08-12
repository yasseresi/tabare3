import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

/// Asks the backend whether a username can still be claimed.
///
/// Advisory: the answer is racy, so a `true` here is never a promise that the
/// sign-up will succeed — the backend's uniqueness error stays the backstop.
class CheckUsernameAvailability implements BaseUseCase<bool, String> {
  final AuthRepository repository;

  CheckUsernameAvailability(this.repository);

  @override
  Future<Either<Failure, bool>> call(String username) {
    return repository.isUsernameAvailable(username);
  }
}
