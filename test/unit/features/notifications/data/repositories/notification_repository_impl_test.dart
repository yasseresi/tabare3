import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tabare3/core/error/failures.dart';
import 'package:tabare3/features/notifications/data/datasources/notification_remote_data_source.dart';
import 'package:tabare3/features/notifications/data/models/notification_model.dart';
import 'package:tabare3/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:tabare3/features/notifications/domain/entities/notification_entity.dart';

class MockNotificationRemoteDataSource extends Mock
    implements NotificationRemoteDataSource {}

void main() {
  late MockNotificationRemoteDataSource remoteDataSource;
  late NotificationRepositoryImpl repository;

  final notificationModel = NotificationModel(
    id: 'notification-1',
    userId: 'user-1',
    type: 'new_request',
    title: 'حاجة مستعجلة',
    body: 'هناك طلب جديد يحتاج إلى متبرع',
    refId: 'request-1',
    refType: 'blood_request',
    isRead: false,
    createdAt: DateTime.parse('2026-07-30T10:00:00.000Z'),
    updatedAt: DateTime.parse('2026-07-30T10:00:00.000Z'),
  );

  final notificationEntity = NotificationEntity(
    id: 'notification-1',
    userId: 'user-1',
    type: 'new_request',
    title: 'حاجة مستعجلة',
    body: 'هناك طلب جديد يحتاج إلى متبرع',
    refId: 'request-1',
    refType: 'blood_request',
    isRead: false,
    createdAt: DateTime.parse('2026-07-30T10:00:00.000Z'),
  );

  setUp(() {
    remoteDataSource = MockNotificationRemoteDataSource();
    repository = NotificationRepositoryImpl(remoteDataSource: remoteDataSource);
  });

  group('listNotifications', () {
    test('returns notifications from the remote data source', () async {
      when(
        () => remoteDataSource.listNotifications(),
      ).thenAnswer((_) async => [notificationModel]);

      final result = await repository.listNotifications();

      expect(result.isRight(), true);
      expect(result.getOrElse(() => []), [notificationEntity]);
      verify(() => remoteDataSource.listNotifications()).called(1);
    });

    test('returns a ServerFailure when the remote call throws', () async {
      when(
        () => remoteDataSource.listNotifications(),
      ).thenThrow(Exception('boom'));

      final result = await repository.listNotifications();

      expect(result, isA<Left<Failure, List<NotificationEntity>>>());
      expect((result as Left).value, isA<ServerFailure>());
    });
  });

  group('markAsRead', () {
    test(
      'returns the updated notification from the remote data source',
      () async {
        when(
          () => remoteDataSource.markAsRead('notification-1'),
        ).thenAnswer((_) async => notificationModel.copyWith(isRead: true));

        final result = await repository.markAsRead('notification-1');

        expect(result.isRight(), true);
        expect(
          result.getOrElse(() => notificationEntity),
          notificationEntity.copyWith(isRead: true),
        );
        verify(() => remoteDataSource.markAsRead('notification-1')).called(1);
      },
    );

    test('returns a ServerFailure when markAsRead throws', () async {
      when(
        () => remoteDataSource.markAsRead('notification-1'),
      ).thenThrow(Exception('boom'));

      final result = await repository.markAsRead('notification-1');

      expect(result, isA<Left<Failure, NotificationEntity>>());
      expect((result as Left).value, isA<ServerFailure>());
    });
  });

  group('watchNotifications', () {
    test('maps streamed models to entity lists', () async {
      when(
        () => remoteDataSource.watchNotifications(),
      ).thenAnswer((_) => Stream.value([notificationModel]));

      final result = await repository.watchNotifications().first;

      expect(result.isRight(), true);
      expect(result.getOrElse(() => []), [notificationEntity]);
    });

    test('maps a stream error to a ServerFailure emission', () async {
      when(
        () => remoteDataSource.watchNotifications(),
      ).thenAnswer((_) => Stream.error(Exception('boom')));

      final result = await repository.watchNotifications().first;

      expect(result, isA<Left<Failure, List<NotificationEntity>>>());
      expect((result as Left).value, isA<ServerFailure>());
    });
  });
}
