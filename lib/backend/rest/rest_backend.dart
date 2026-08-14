import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../core/backend/backend.dart';
import '../../core/backend/backend_error_mapper.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/donor_home/data/datasources/donor_card_remote_data_source.dart';
import '../../features/donor_home/data/datasources/donor_feed_remote_data_source.dart';
import '../../features/notifications/data/datasources/notification_remote_data_source.dart';
import '../../features/profile/data/datasources/profile_remote_data_source.dart';
import '../../features/requester_home/data/datasources/request_remote_data_source.dart';
import 'datasources/auth_rest_data_source.dart';
import 'datasources/donor_feed_rest_data_source.dart';
import 'datasources/profile_rest_data_source.dart';
import 'datasources/request_rest_data_source.dart';
import 'datasources/rest_data_sources.dart';
import 'reference/reference_remote_data_source.dart';
import 'reference/reference_resolver.dart';
import 'rest_client.dart';
import 'rest_error_mapper.dart';
import 'token_store.dart';

/// Custom REST backend — scaffold for the migration off Supabase.
///
/// Endpoints are not implemented yet (see `datasources/rest_data_sources.dart`),
/// but the wiring is complete: switching `lib/backend/active_backend.dart` to
/// `RestBackend()` compiles and boots without touching any feature code.
class RestBackend implements Backend {
  RestBackend({RestClientFactory? clientFactory})
    : _clientFactory = clientFactory ?? RestClientFactory();

  final RestClientFactory _clientFactory;
  Dio? _dio;

  @override
  String get name => 'rest';

  @override
  BackendErrorMapper get errorMapper => const RestErrorMapper();

  @override
  Future<void> initialize() async {
    _dio = _clientFactory.build();
  }

  @override
  Future<void> registerDataSources(GetIt sl) async {
    final dio = _dio ??= _clientFactory.build();

    sl.registerLazySingleton<Dio>(() => dio);
    sl.registerLazySingleton<RestClientFactory>(() => _clientFactory);
    sl.registerLazySingleton<TokenStore>(() => _clientFactory.tokenStore);

    // Reference resolvers (REST-only: id lookups for register / request create).
    sl.registerLazySingleton<ReferenceRemoteDataSource>(
      () => ReferenceRestDataSource(sl()),
    );
    sl.registerLazySingleton<ReferenceResolver>(() => ReferenceResolver(sl()));

    sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRestDataSource(sl(), tokenStore: sl(), reference: sl()),
    );
    sl.registerLazySingleton<ProfileRemoteDataSource>(
      () => ProfileRestDataSource(sl(), reference: sl()),
    );
    sl.registerLazySingleton<RequestRemoteDataSource>(
      () => RequestRestDataSource(sl(), reference: sl()),
    );
    sl.registerLazySingleton<NotificationRemoteDataSource>(
      () => NotificationRestDataSource(sl()),
    );
    sl.registerLazySingleton<DonorCardRemoteDataSource>(
      () => DonorCardRestDataSource(sl()),
    );
    sl.registerLazySingleton<DonorFeedRemoteDataSource>(
      () => DonorFeedRestDataSource(sl()),
    );
  }
}
