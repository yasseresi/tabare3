import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/backend/backend.dart';
import '../../core/backend/backend_error_mapper.dart';
import '../../core/constants/env_constants.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/datasources/supabase/auth_supabase_data_source.dart';
import '../../features/donor_home/data/datasources/donor_card_remote_data_source.dart';
import '../../features/donor_home/data/datasources/donor_feed_remote_data_source.dart';
import '../../features/donor_home/data/datasources/supabase/donor_card_supabase_data_source.dart';
import '../../features/donor_home/data/datasources/supabase/donor_feed_supabase_data_source.dart';
import '../../features/notifications/data/datasources/notification_remote_data_source.dart';
import '../../features/notifications/data/datasources/supabase/notification_supabase_data_source.dart';
import '../../features/profile/data/datasources/profile_remote_data_source.dart';
import '../../features/profile/data/datasources/supabase/profile_supabase_data_source.dart';
import '../../features/requester_home/data/datasources/request_remote_data_source.dart';
import '../../features/requester_home/data/datasources/supabase/request_supabase_data_source.dart';
import '../rest/datasources/auth_rest_data_source.dart';
import '../rest/datasources/profile_rest_data_source.dart';
import '../rest/datasources/rest_data_sources.dart';
import '../rest/reference/reference_remote_data_source.dart';
import '../rest/reference/reference_resolver.dart';
import '../rest/rest_client.dart';
import '../rest/token_store.dart';
import 'backend_feature.dart';
import 'hybrid_error_mapper.dart';

/// A [Backend] that serves a chosen set of features from the REST API and the
/// rest from Supabase, so both backends run in one build during the migration.
///
/// Boots both SDKs and registers both clients, then binds each feature's
/// `*RemoteDataSource` to REST when its [BackendFeature] is enabled, else to
/// Supabase. With an empty [restFeatures] set the app is fully on Supabase —
/// identical behaviour to [SupabaseBackend].
class HybridBackend implements Backend {
  HybridBackend({
    this.restFeatures = const {},
    RestClientFactory? restClientFactory,
  }) : _clientFactory = restClientFactory ?? RestClientFactory();

  final Set<BackendFeature> restFeatures;
  final RestClientFactory _clientFactory;
  Dio? _dio;

  bool _rest(BackendFeature f) => restFeatures.contains(f);

  @override
  String get name =>
      restFeatures.isEmpty ? 'hybrid(supabase)' : 'hybrid($restFeatures)';

  @override
  BackendErrorMapper get errorMapper => const HybridErrorMapper();

  @override
  Future<void> initialize() async {
    await Supabase.initialize(
      url: EnvConstants.supabaseUrl,
      publishableKey: EnvConstants.supabasePublishableKey,
    );
    _dio = _clientFactory.build();
  }

  @override
  Future<void> registerDataSources(GetIt sl) async {
    // Both clients are always available; each data source picks the one it
    // needs. Guarded so a test (or a re-registration) can inject its own client.
    if (!sl.isRegistered<SupabaseClient>()) {
      sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);
    }
    final dio = _dio ??= _clientFactory.build();
    if (!sl.isRegistered<Dio>()) {
      sl.registerLazySingleton<Dio>(() => dio);
    }
    if (!sl.isRegistered<RestClientFactory>()) {
      sl.registerLazySingleton<RestClientFactory>(() => _clientFactory);
    }
    if (!sl.isRegistered<TokenStore>()) {
      sl.registerLazySingleton<TokenStore>(() => _clientFactory.tokenStore);
    }
    // Reference resolvers (REST-only: id lookups for register / request create).
    if (!sl.isRegistered<ReferenceRemoteDataSource>()) {
      sl.registerLazySingleton<ReferenceRemoteDataSource>(
        () => ReferenceRestDataSource(sl()),
      );
    }
    if (!sl.isRegistered<ReferenceResolver>()) {
      sl.registerLazySingleton<ReferenceResolver>(() => ReferenceResolver(sl()));
    }

    sl.registerLazySingleton<AuthRemoteDataSource>(
      () => _rest(BackendFeature.auth)
          ? AuthRestDataSource(sl(), tokenStore: sl(), reference: sl())
          : AuthSupabaseDataSource(client: sl()),
    );
    sl.registerLazySingleton<ProfileRemoteDataSource>(
      () => _rest(BackendFeature.profile)
          ? ProfileRestDataSource(sl(), reference: sl())
          : ProfileSupabaseDataSource(client: sl()),
    );
    sl.registerLazySingleton<RequestRemoteDataSource>(
      () => _rest(BackendFeature.requests)
          ? RequestRestDataSource(sl())
          : RequestSupabaseDataSource(client: sl()),
    );
    sl.registerLazySingleton<NotificationRemoteDataSource>(
      () => _rest(BackendFeature.notifications)
          ? NotificationRestDataSource(sl())
          : NotificationSupabaseDataSource(client: sl()),
    );
    sl.registerLazySingleton<DonorCardRemoteDataSource>(
      () => _rest(BackendFeature.donorCard)
          ? DonorCardRestDataSource(sl())
          : DonorCardSupabaseDataSource(client: sl()),
    );
    sl.registerLazySingleton<DonorFeedRemoteDataSource>(
      () => _rest(BackendFeature.donorFeed)
          ? DonorFeedRestDataSource(sl())
          : DonorFeedSupabaseDataSource(client: sl()),
    );
  }
}
