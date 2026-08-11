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

/// A backend payload did not match the shape the models expect — typically a
/// column or embed that is nullable in the database but `required` in the
/// model. Distinct from [ServerFailure] so parse bugs are greppable in logs
/// instead of hiding behind the generic "unexpected error".
class ParseFailure extends Failure {
  const ParseFailure([
    super.code = -12,
    super.message = 'خطأ في الخادم، يرجى المحاولة لاحقاً',
  ]);
}

class ValidationFailure extends Failure {
  const ValidationFailure([
    super.code = -11,
    super.message = 'البيانات المدخلة غير صالحة',
  ]);
}
