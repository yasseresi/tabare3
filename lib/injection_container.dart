import 'package:get_it/get_it.dart';
import 'features/counter/data/datasources/counter_local_data_source.dart';
import 'features/counter/data/repositories/counter_repository_impl.dart';
import 'features/counter/domain/repositories/counter_repository.dart';
import 'features/counter/domain/usecases/get_counter.dart';
import 'features/counter/domain/usecases/increment_counter.dart';
import 'features/counter/presentation/bloc/counter_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Counter
  // Bloc
  sl.registerFactory(
    () => CounterBloc(
      getCounter: sl(),
      incrementCounter: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetCounter(sl()));
  sl.registerLazySingleton(() => IncrementCounter(sl()));

  // Repository
  sl.registerLazySingleton<CounterRepository>(
    () => CounterRepositoryImpl(
      localDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<CounterLocalDataSource>(
    () => CounterLocalDataSourceImpl(),
  );
}
