import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/counter_entity.dart';
import '../repositories/counter_repository.dart';

class GetCounter implements UseCase<CounterEntity, NoParams> {
  final CounterRepository repository;

  GetCounter(this.repository);

  @override
  Future<Either<Failure, CounterEntity>> call(NoParams params) async {
    return await repository.getCounter();
  }
}
