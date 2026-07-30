import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tabare3/core/error/failures.dart';
import 'package:tabare3/core/usecases/usecase.dart';
import 'package:tabare3/features/notifications/domain/entities/notification_entity.dart';
import 'package:tabare3/features/notifications/domain/usecases/get_notifications.dart';
import 'package:tabare3/features/notifications/domain/usecases/mark_notification_as_read.dart';
import 'package:tabare3/features/notifications/presentation/bloc/notifications_bloc.dart';

class MockGetNotifications extends Mock implements GetNotifications {}

class MockMarkNotificationAsRead extends Mock
    implements MarkNotificationAsRead {}

void main() {
  late MockGetNotifications getNotifications;
  late MockMarkNotificationAsRead markNotificationAsRead;

  final unreadNotification = NotificationEntity(
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

  final readNotification = NotificationEntity(
    id: 'notification-2',
    userId: 'user-1',
    type: 'thank_you',
    title: 'شكراً لك',
    body: 'تم اكتمال الطلب بنجاح',
    refId: null,
    refType: null,
    isRead: true,
    createdAt: DateTime.parse('2026-07-29T10:00:00.000Z'),
  );

  NotificationsBloc buildBloc() => NotificationsBloc(
    getNotifications: getNotifications,
    markNotificationAsRead: markNotificationAsRead,
  );

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(const MarkNotificationAsReadParams('notification-1'));
  });

  setUp(() {
    getNotifications = MockGetNotifications();
    markNotificationAsRead = MockMarkNotificationAsRead();
  });

  test('initial state is NotificationsInitial', () {
    expect(buildBloc().state, const NotificationsInitial());
  });

  blocTest<NotificationsBloc, NotificationsState>(
    'loads notifications successfully',
    build: () {
      when(
        () => getNotifications(any()),
      ).thenAnswer((_) async => Right([unreadNotification, readNotification]));
      return buildBloc();
    },
    act: (bloc) => bloc.add(const NotificationsRequested()),
    expect: () => [
      const NotificationsLoading(),
      NotificationsLoaded(
        notifications: [unreadNotification, readNotification],
        visibleNotifications: [unreadNotification, readNotification],
      ),
    ],
  );

  blocTest<NotificationsBloc, NotificationsState>(
    'emits an error when loading notifications fails',
    build: () {
      when(
        () => getNotifications(any()),
      ).thenAnswer((_) async => const Left(ServerFailure()));
      return buildBloc();
    },
    act: (bloc) => bloc.add(const NotificationsRequested()),
    expect: () => [const NotificationsLoading(), isA<NotificationsError>()],
  );

  blocTest<NotificationsBloc, NotificationsState>(
    'filters notifications by search query',
    build: buildBloc,
    seed: () => NotificationsLoaded(
      notifications: [unreadNotification, readNotification],
      visibleNotifications: [unreadNotification, readNotification],
    ),
    act: (bloc) => bloc.add(const NotificationsSearchChanged('مستعجلة')),
    expect: () => [
      NotificationsLoaded(
        notifications: [unreadNotification, readNotification],
        visibleNotifications: [unreadNotification],
        query: 'مستعجلة',
      ),
    ],
  );

  blocTest<NotificationsBloc, NotificationsState>(
    'marks a notification as read and updates the loaded list',
    build: () {
      when(() => markNotificationAsRead(any())).thenAnswer(
        (_) async => Right(unreadNotification.copyWith(isRead: true)),
      );
      return buildBloc();
    },
    seed: () => NotificationsLoaded(
      notifications: [unreadNotification, readNotification],
      visibleNotifications: [unreadNotification, readNotification],
    ),
    act: (bloc) => bloc.add(const NotificationReadRequested('notification-1')),
    expect: () => [
      NotificationsLoaded(
        notifications: [
          unreadNotification.copyWith(isRead: true),
          readNotification,
        ],
        visibleNotifications: [
          unreadNotification.copyWith(isRead: true),
          readNotification,
        ],
      ),
    ],
    verify: (_) {
      final params =
          verify(() => markNotificationAsRead(captureAny())).captured.single
              as MarkNotificationAsReadParams;
      expect(params.notificationId, 'notification-1');
    },
  );

  blocTest<NotificationsBloc, NotificationsState>(
    'does not re-mark an already read notification',
    build: buildBloc,
    seed: () => NotificationsLoaded(
      notifications: [readNotification],
      visibleNotifications: [readNotification],
    ),
    act: (bloc) => bloc.add(const NotificationReadRequested('notification-2')),
    expect: () => <NotificationsState>[],
    verify: (_) => verifyNever(() => markNotificationAsRead(any())),
  );
}
