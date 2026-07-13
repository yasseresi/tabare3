import 'package:dartz/dartz.dart';
import '../error/failures.dart';

abstract class UseCase<TypeResult, Params> {
  Future<Either<Failure, TypeResult>> call(Params params);
}

class NoParams {}
