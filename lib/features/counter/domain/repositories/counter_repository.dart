import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/counter_entity.dart';

abstract class CounterRepository {
  Future<Either<Failure, CounterEntity>> getCounter();
  Future<Either<Failure, CounterEntity>> incrementCounter();
}
