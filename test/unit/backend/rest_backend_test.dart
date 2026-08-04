import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabare3/backend/rest/rest_backend.dart';
import 'package:tabare3/backend/rest/rest_error_mapper.dart';
import 'package:tabare3/core/error/failures.dart';
import 'package:tabare3/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:tabare3/features/donor_home/data/datasources/donor_card_remote_data_source.dart';
import 'package:tabare3/features/donor_home/data/datasources/donor_feed_remote_data_source.dart';
import 'package:tabare3/features/notifications/data/datasources/notification_remote_data_source.dart';
import 'package:tabare3/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:tabare3/features/requester_home/data/datasources/request_remote_data_source.dart';
import 'package:tabare3/injection_container.dart';

DioException _dioError(
  DioExceptionType type, {
  int? statusCode,
}) => DioException(
  requestOptions: RequestOptions(path: '/'),
  type: type,
  response: statusCode == null
      ? null
      : Response<void>(
          requestOptions: RequestOptions(path: '/'),
          statusCode: statusCode,
        ),
);

void main() {
  group('RestErrorMapper', () {
    const mapper = RestErrorMapper();

    test('ignores errors that are not Dio errors', () {
      expect(mapper.map(StateError('not a transport error')), isNull);
    });

    test('maps timeouts and connection loss to NetworkFailure', () {
      expect(
        mapper.map(_dioError(DioExceptionType.receiveTimeout)),
        isA<NetworkFailure>(),
      );
      expect(
        mapper.map(_dioError(DioExceptionType.connectionError)),
        isA<NetworkFailure>(),
      );
    });

    test('maps HTTP status codes to the matching failure type', () {
      expect(
        mapper.map(_dioError(DioExceptionType.badResponse, statusCode: 401)),
        isA<AuthFailure>(),
      );
      expect(
        mapper.map(_dioError(DioExceptionType.badResponse, statusCode: 409)),
        isA<DatabaseFailure>(),
      );
      expect(
        mapper.map(_dioError(DioExceptionType.badResponse, statusCode: 422)),
        isA<ValidationFailure>(),
      );

      final serverFailure = mapper.map(
        _dioError(DioExceptionType.badResponse, statusCode: 503),
      );
      expect(serverFailure, isA<ServerFailure>());
      expect(serverFailure!.code, 503);
    });
  });

  group('RestBackend', () {
    tearDown(() async {
      await sl.reset();
    });

    test('satisfies every data source contract the app depends on', () async {
      final backend = RestBackend();
      await backend.initialize();
      await init(backend);

      expect(sl<AuthRemoteDataSource>(), isNotNull);
      expect(sl<ProfileRemoteDataSource>(), isNotNull);
      expect(sl<RequestRemoteDataSource>(), isNotNull);
      expect(sl<NotificationRemoteDataSource>(), isNotNull);
      expect(sl<DonorCardRemoteDataSource>(), isNotNull);
      expect(sl<DonorFeedRemoteDataSource>(), isNotNull);
    });

    test('unimplemented endpoints fail loudly instead of silently', () async {
      final backend = RestBackend();
      await backend.initialize();
      await init(backend);

      expect(
        () => sl<NotificationRemoteDataSource>().listNotifications(),
        throwsA(isA<UnimplementedError>()),
      );
    });
  });
}
