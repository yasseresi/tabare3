import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabare3/backend/hybrid/backend_feature.dart';
import 'package:tabare3/backend/hybrid/hybrid_backend.dart';
import 'package:tabare3/backend/hybrid/hybrid_error_mapper.dart';
import 'package:tabare3/backend/rest/datasources/auth_rest_data_source.dart';
import 'package:tabare3/backend/rest/datasources/profile_rest_data_source.dart';
import 'package:tabare3/backend/rest/datasources/rest_data_sources.dart';
import 'package:tabare3/backend/rest/rest_client.dart';
import 'package:tabare3/backend/rest/token_store.dart';
import 'package:tabare3/core/error/failures.dart';
import 'package:tabare3/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:tabare3/features/auth/data/datasources/supabase/auth_supabase_data_source.dart';
import 'package:tabare3/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:tabare3/features/profile/data/datasources/supabase/profile_supabase_data_source.dart';
import 'package:tabare3/features/requester_home/data/datasources/request_remote_data_source.dart';
import 'package:tabare3/features/requester_home/data/datasources/supabase/request_supabase_data_source.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class FakeTokenStore implements TokenStore {
  @override
  Future<void> clear() async {}
  @override
  Future<String?> readAccess() async => null;
  @override
  Future<String?> readRefresh() async => null;
  @override
  Future<void> save({required String access, required String refresh}) async {}
}

HybridBackend _backend(Set<BackendFeature> restFeatures) => HybridBackend(
  restFeatures: restFeatures,
  restClientFactory: RestClientFactory(
    baseUrl: 'https://x/api/v1',
    dio: Dio(),
    tokenStore: FakeTokenStore(),
  ),
);

void main() {
  late GetIt sl;

  setUp(() {
    sl = GetIt.asNewInstance();
    // Pre-register a mock so the Supabase-backed sources resolve without booting
    // the real SDK.
    sl.registerSingleton<SupabaseClient>(MockSupabaseClient());
  });

  test('enabled features resolve to REST, the rest stay on Supabase', () async {
    await _backend({
      BackendFeature.auth,
      BackendFeature.profile,
    }).registerDataSources(sl);

    expect(sl<AuthRemoteDataSource>(), isA<AuthRestDataSource>());
    expect(sl<ProfileRemoteDataSource>(), isA<ProfileRestDataSource>());
    expect(sl<RequestRemoteDataSource>(), isA<RequestSupabaseDataSource>());
  });

  test('empty feature set keeps every source on Supabase', () async {
    await _backend(const {}).registerDataSources(sl);

    expect(sl<AuthRemoteDataSource>(), isA<AuthSupabaseDataSource>());
    expect(sl<ProfileRemoteDataSource>(), isA<ProfileSupabaseDataSource>());
    expect(sl<RequestRemoteDataSource>(), isA<RequestSupabaseDataSource>());
  });

  group('HybridErrorMapper', () {
    const mapper = HybridErrorMapper();

    test('maps Dio (REST) errors', () {
      final err = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.connectionError,
      );
      expect(mapper.map(err), isA<NetworkFailure>());
    });

    test('ignores errors neither backend recognises', () {
      expect(mapper.map(StateError('nope')), isNull);
    });
  });
}
