import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tabare3/core/backend/backend.dart';
import 'package:tabare3/core/backend/backend_error_mapper.dart';
import 'package:tabare3/core/error/failures.dart';
import 'package:tabare3/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:tabare3/features/donor_home/data/datasources/donor_card_remote_data_source.dart';
import 'package:tabare3/features/donor_home/data/datasources/donor_feed_remote_data_source.dart';
import 'package:tabare3/features/notifications/data/datasources/notification_remote_data_source.dart';
import 'package:tabare3/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:tabare3/features/requester_home/data/datasources/request_remote_data_source.dart';

class FakeAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class FakeProfileRemoteDataSource extends Mock
    implements ProfileRemoteDataSource {}

class FakeRequestRemoteDataSource extends Mock
    implements RequestRemoteDataSource {}

class FakeNotificationRemoteDataSource extends Mock
    implements NotificationRemoteDataSource {}

class FakeDonorCardRemoteDataSource extends Mock
    implements DonorCardRemoteDataSource {}

class FakeDonorFeedRemoteDataSource extends Mock
    implements DonorFeedRemoteDataSource {}

class FakeBackendErrorMapper implements BackendErrorMapper {
  const FakeBackendErrorMapper();

  @override
  Failure? map(Object error) => null;
}

/// In-memory [Backend] for tests: no SDK, no network, only fake data sources.
///
/// Its existence is the proof that the app is backend-agnostic — swapping the
/// backend never touches a feature, repository, or bloc.
class FakeBackend implements Backend {
  const FakeBackend();

  @override
  String get name => 'fake';

  @override
  BackendErrorMapper get errorMapper => const FakeBackendErrorMapper();

  @override
  Future<void> initialize() async {}

  @override
  Future<void> registerDataSources(GetIt sl) async {
    sl.registerLazySingleton<AuthRemoteDataSource>(
      FakeAuthRemoteDataSource.new,
    );
    sl.registerLazySingleton<ProfileRemoteDataSource>(
      FakeProfileRemoteDataSource.new,
    );
    sl.registerLazySingleton<RequestRemoteDataSource>(
      FakeRequestRemoteDataSource.new,
    );
    sl.registerLazySingleton<NotificationRemoteDataSource>(
      FakeNotificationRemoteDataSource.new,
    );
    sl.registerLazySingleton<DonorCardRemoteDataSource>(
      FakeDonorCardRemoteDataSource.new,
    );
    sl.registerLazySingleton<DonorFeedRemoteDataSource>(
      FakeDonorFeedRemoteDataSource.new,
    );
  }
}
