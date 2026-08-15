import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tabare3/core/error/failures.dart';
import 'package:tabare3/core/usecases/usecase.dart';
import 'package:tabare3/features/notifications/domain/entities/notification_entity.dart';
import 'package:tabare3/features/notifications/domain/repositories/notification_repository.dart';
import 'package:tabare3/features/notifications/domain/usecases/get_notifications.dart';
import 'package:tabare3/features/notifications/domain/usecases/mark_notification_as_read.dart';
import 'package:tabare3/features/notifications/domain/usecases/watch_notifications.dart';

class MockNotificationRepository extends Mock
    implements NotificationRepository {}

void main() {
  late MockNotificationRepository repository;
  late GetNotifications getNotifications;
  late MarkNotificationAsRead markNotificationAsRead;

  final notification = NotificationEntity(
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

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(const MarkNotificationAsReadParams('notification-1'));
  });

  setUp(() {
    repository = MockNotificationRepository();
    getNotifications = GetNotifications(repository);
    markNotificationAsRead = MarkNotificationAsRead(repository);
  });

  test('GetNotifications returns the repository result', () async {
    when(() => repository.listNotifications()).thenAnswer(
      (_) async => Right<Failure, List<NotificationEntity>>([notification]),
    );

    final result = await getNotifications(NoParams());

    expect(result.isRight(), true);
    expect(result.getOrElse(() => []), [notification]);
    verify(() => repository.listNotifications()).called(1);
  });

  test('MarkNotificationAsRead returns the updated notification', () async {
    when(() => repository.markAsRead('notification-1')).thenAnswer(
      (_) async => Right<Failure, NotificationEntity>(
        notification.copyWith(isRead: true),
      ),
    );

    final result = await markNotificationAsRead(
      const MarkNotificationAsReadParams('notification-1'),
    );

    expect(result.isRight(), true);
    expect(
      result.getOrElse(() => notification),
      notification.copyWith(isRead: true),
    );
    verify(() => repository.markAsRead('notification-1')).called(1);
  });

  test('WatchNotifications streams the repository live results', () async {
    when(() => repository.watchNotifications()).thenAnswer(
      (_) => Stream.value(
        Right<Failure, List<NotificationEntity>>([notification]),
      ),
    );

    final event = await WatchNotifications(repository)().first;

    expect(event.isRight(), true);
    expect(event.getOrElse(() => const []), [notification]);
    verify(() => repository.watchNotifications()).called(1);
  });
}
