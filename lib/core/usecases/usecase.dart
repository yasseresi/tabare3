import 'package:dartz/dartz.dart';

import '../error/failures.dart';

abstract class BaseUseCase<TypeResult, Params> {
  Future<Either<Failure, TypeResult>> call(Params params);
}

class NoParams {}
