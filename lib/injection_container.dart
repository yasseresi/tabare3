import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/network/network_info.dart';
import 'core/network/supabase_service.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/get_current_session.dart';
import 'features/auth/domain/usecases/login_with_email_password.dart';
import 'features/auth/domain/usecases/sign_out.dart';
import 'features/auth/domain/usecases/signup_with_email_password.dart';
import 'features/auth/domain/usecases/update_user_role.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/counter/data/datasources/counter_local_data_source.dart';
import 'features/counter/data/repositories/counter_repository_impl.dart';
import 'features/counter/domain/repositories/counter_repository.dart';
import 'features/counter/domain/usecases/get_counter.dart';
import 'features/counter/domain/usecases/increment_counter.dart';
import 'features/counter/presentation/bloc/counter_bloc.dart';
import 'features/profile/data/datasources/profile_local_data_source.dart';
import 'features/profile/data/datasources/profile_local_data_source_impl.dart';
import 'features/profile/data/datasources/profile_remote_data_source.dart';
import 'features/profile/data/datasources/profile_remote_data_source_impl.dart';
import 'features/profile/data/repositories/profile_repository_impl.dart';
import 'features/profile/domain/repositories/profile_repository.dart';
import 'features/profile/domain/usecases/change_role.dart';
import 'features/profile/domain/usecases/get_profile.dart';
import 'features/profile/domain/usecases/update_profile.dart';
import 'features/profile/domain/usecases/upload_avatar.dart';
import 'features/profile/presentation/bloc/profile_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await initCore();
  await initCounter();
  await initAuth();
  await initProfile();
}

Future<void> initProfile() async {
  sl.registerFactory(
    () => ProfileBloc(
      getProfile: sl(),
      updateProfile: sl(),
      changeRole: sl(),
      uploadAvatar: sl(),
    ),
  );

  sl.registerLazySingleton(() => GetProfile(sl()));
  sl.registerLazySingleton(() => UpdateProfile(sl()));
  sl.registerLazySingleton(() => ChangeRole(sl()));
  sl.registerLazySingleton(() => UploadAvatar(sl()));

  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<ProfileLocalDataSource>(
    () => ProfileLocalDataSourceImpl(),
  );
}

Future<void> initCore() async {
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton<SupabaseClient>(() => SupabaseService.client);
}

Future<void> initAuth() async {
  sl.registerFactory(
    () => AuthBloc(
      loginWithUsernamePassword: sl(),
      signupWithUsernamePassword: sl(),
      signOutUseCase: sl(),
      getCurrentSession: sl(),
      updateUserRole: sl(),
    ),
  );

  sl.registerLazySingleton(() => LoginWithUsernamePassword(sl()));
  sl.registerLazySingleton(() => SignupWithUsernamePassword(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));
  sl.registerLazySingleton(() => GetCurrentSession(sl()));
  sl.registerLazySingleton(() => UpdateUserRole(sl()));

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: sl()),
  );
}

Future<void> initCounter() async {
  sl.registerFactory(
    () => CounterBloc(getCounter: sl(), incrementCounter: sl()),
  );
  sl.registerLazySingleton(() => GetCounter(sl()));
  sl.registerLazySingleton(() => IncrementCounter(sl()));
  sl.registerLazySingleton<CounterRepository>(
    () => CounterRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<CounterLocalDataSource>(
    () => CounterLocalDataSourceImpl(),
  );
}
