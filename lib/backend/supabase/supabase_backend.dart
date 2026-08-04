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
import 'supabase_error_mapper.dart';

/// Supabase implementation of [Backend].
///
/// This is the only place that knows the app talks to Supabase: it boots the
/// SDK, exposes the Supabase error mapper, and binds every feature's
/// `*RemoteDataSource` contract to its Supabase implementation.
class SupabaseBackend implements Backend {
  const SupabaseBackend();

  @override
  String get name => 'supabase';

  @override
  BackendErrorMapper get errorMapper => const SupabaseErrorMapper();

  @override
  Future<void> initialize() async {
    await Supabase.initialize(
      url: EnvConstants.supabaseUrl,
      publishableKey: EnvConstants.supabasePublishableKey,
    );
  }

  @override
  Future<void> registerDataSources(GetIt sl) async {
    sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

    sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthSupabaseDataSource(client: sl()),
    );
    sl.registerLazySingleton<ProfileRemoteDataSource>(
      () => ProfileSupabaseDataSource(client: sl()),
    );
    sl.registerLazySingleton<RequestRemoteDataSource>(
      () => RequestSupabaseDataSource(client: sl()),
    );
    sl.registerLazySingleton<NotificationRemoteDataSource>(
      () => NotificationSupabaseDataSource(client: sl()),
    );
    sl.registerLazySingleton<DonorCardRemoteDataSource>(
      () => DonorCardSupabaseDataSource(client: sl()),
    );
    sl.registerLazySingleton<DonorFeedRemoteDataSource>(
      () => DonorFeedSupabaseDataSource(client: sl()),
    );
  }
}
