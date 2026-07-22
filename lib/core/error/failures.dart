abstract class Failure {
  final int code;
  final String message;
  const Failure(this.code, this.message);
}

class ServerFailure extends Failure {
  const ServerFailure([
    super.code = -7,
    super.message = 'خطأ في الخادم، يرجى المحاولة لاحقاً',
  ]);
}

class CacheFailure extends Failure {
  const CacheFailure([
    super.code = -5,
    super.message = 'خطأ في التخزين المؤقت',
  ]);
}

class NetworkFailure extends Failure {
  const NetworkFailure([
    super.code = -6,
    super.message = 'لا يوجد اتصال بالإنترنت',
  ]);
}

class DatabaseFailure extends Failure {
  const DatabaseFailure([
    super.code = -8,
    super.message = 'خطأ في قاعدة البيانات',
  ]);
}

class AuthFailure extends Failure {
  const AuthFailure([super.code = -9, super.message = 'خطأ في المصادقة']);
}

class StorageFailure extends Failure {
  const StorageFailure([
    super.code = -10,
    super.message = 'خطأ في تخزين الملفات',
  ]);
}
