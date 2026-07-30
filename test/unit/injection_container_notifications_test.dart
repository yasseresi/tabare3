import 'package:flutter_test/flutter_test.dart';
import 'package:tabare3/features/notifications/data/datasources/notification_remote_data_source.dart';
import 'package:tabare3/features/notifications/domain/repositories/notification_repository.dart';
import 'package:tabare3/features/notifications/domain/usecases/get_notifications.dart';
import 'package:tabare3/features/notifications/domain/usecases/mark_notification_as_read.dart';
import 'package:tabare3/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:tabare3/injection_container.dart';

void main() {
  tearDown(() async {
    await sl.reset();
  });

  test('registers the complete notifications dependency graph', () async {
    await initNotifications();

    expect(sl.isRegistered<NotificationRemoteDataSource>(), isTrue);
    expect(sl.isRegistered<NotificationRepository>(), isTrue);
    expect(sl.isRegistered<GetNotifications>(), isTrue);
    expect(sl.isRegistered<MarkNotificationAsRead>(), isTrue);
    expect(sl.isRegistered<NotificationsBloc>(), isTrue);
  });
}
