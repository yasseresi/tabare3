abstract class Failure {
  final int code;
  final String message;
  const Failure(this.code, this.message);
}

class ServerFailure extends Failure {
  const ServerFailure([super.code = -7, super.message = 'Server error']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.code = -5, super.message = 'Cache error']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([
    super.code = -6,
    super.message = 'No internet connection',
  ]);
}

class DatabaseFailure extends Failure {
  const DatabaseFailure([super.code = -8, super.message = 'Database error']);
}

class AuthFailure extends Failure {
  const AuthFailure([super.code = -9, super.message = 'Authentication error']);
}

class StorageFailure extends Failure {
  const StorageFailure([
    super.code = -10,
    super.message = 'Storage error',
  ]);
}
