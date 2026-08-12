import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tabare3/core/error/failures.dart';
import 'package:tabare3/features/notifications/domain/entities/notification_entity.dart';
import 'package:tabare3/features/notifications/domain/usecases/mark_notification_as_read.dart';
import 'package:tabare3/features/notifications/domain/usecases/watch_notifications.dart';
import 'package:tabare3/features/notifications/presentation/bloc/notifications_bloc.dart';

class MockWatchNotifications extends Mock implements WatchNotifications {}

class MockMarkNotificationAsRead extends Mock
    implements MarkNotificationAsRead {}

void main() {
  late MockWatchNotifications watchNotifications;
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
    watchNotifications: watchNotifications,
    markNotificationAsRead: markNotificationAsRead,
  );

  void stubStream(
    Stream<Either<Failure, List<NotificationEntity>>> stream,
  ) {
    when(() => watchNotifications()).thenAnswer((_) => stream);
  }

  setUpAll(() {
    registerFallbackValue(const MarkNotificationAsReadParams('notification-1'));
  });

  setUp(() {
    watchNotifications = MockWatchNotifications();
    markNotificationAsRead = MockMarkNotificationAsRead();
    // Default: an inert stream so blocs that never subscribe stay clean.
    stubStream(const Stream.empty());
  });

  test('initial state is NotificationsInitial', () {
    expect(buildBloc().state, const NotificationsInitial());
  });

  blocTest<NotificationsBloc, NotificationsState>(
    'streams notifications from the realtime source',
    build: () {
      stubStream(
        Stream.value(Right([unreadNotification, readNotification])),
      );
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
    'exposes the unread count on the loaded state',
    build: () {
      stubStream(
        Stream.value(Right([unreadNotification, readNotification])),
      );
      return buildBloc();
    },
    act: (bloc) => bloc.add(const NotificationsRequested()),
    verify: (bloc) {
      final state = bloc.state as NotificationsLoaded;
      expect(state.unreadCount, 1);
    },
  );

  blocTest<NotificationsBloc, NotificationsState>(
    'emits an error when the realtime stream errors',
    build: () {
      stubStream(Stream.value(const Left(ServerFailure())));
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
    'optimistically marks a notification as read before the write returns',
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
    'reverts the optimistic read when the write fails',
    build: () {
      when(
        () => markNotificationAsRead(any()),
      ).thenAnswer((_) async => const Left(ServerFailure()));
      return buildBloc();
    },
    seed: () => NotificationsLoaded(
      notifications: [unreadNotification, readNotification],
      visibleNotifications: [unreadNotification, readNotification],
    ),
    act: (bloc) => bloc.add(const NotificationReadRequested('notification-1')),
    expect: () => [
      // Optimistic read...
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
      // ...rolled back after the write fails.
      NotificationsLoaded(
        notifications: [unreadNotification, readNotification],
        visibleNotifications: [unreadNotification, readNotification],
      ),
    ],
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
