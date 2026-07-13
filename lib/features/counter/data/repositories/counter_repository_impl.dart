import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/counter_entity.dart';
import '../../domain/repositories/counter_repository.dart';
import '../datasources/counter_local_data_source.dart';
import '../models/counter_model.dart';

class CounterRepositoryImpl implements CounterRepository {
  final CounterLocalDataSource localDataSource;

  CounterRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, CounterEntity>> getCounter() async {
    try {
      final localCounter = await localDataSource.getLastCounter();
      return Right(localCounter);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, CounterEntity>> incrementCounter() async {
    try {
      final currentCounter = await localDataSource.getLastCounter();
      final newCounter = CounterModel(value: currentCounter.value + 1);
      await localDataSource.cacheCounter(newCounter);
      return Right(newCounter);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}
