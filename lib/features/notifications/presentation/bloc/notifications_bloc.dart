import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/usecases/get_notifications.dart';
import '../../domain/usecases/mark_notification_as_read.dart';
import 'notifications_event.dart';
import 'notifications_state.dart';

export 'notifications_event.dart';
export 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final GetNotifications getNotifications;
  final MarkNotificationAsRead markNotificationAsRead;

  NotificationsBloc({
    required this.getNotifications,
    required this.markNotificationAsRead,
  }) : super(const NotificationsInitial()) {
    on<NotificationsRequested>(_onRequested);
    on<NotificationsSearchChanged>(_onSearchChanged);
    on<NotificationReadRequested>(_onReadRequested);
  }

  Future<void> _onRequested(
    NotificationsRequested event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(const NotificationsLoading());
    final result = await getNotifications(NoParams());
    result.fold(
      (failure) => emit(NotificationsError(failure)),
      (notifications) => emit(
        NotificationsLoaded(
          notifications: notifications,
          visibleNotifications: notifications,
        ),
      ),
    );
  }

  void _onSearchChanged(
    NotificationsSearchChanged event,
    Emitter<NotificationsState> emit,
  ) {
    final current = state;
    if (current is! NotificationsLoaded) return;

    final filtered = _filterNotifications(current.notifications, event.query);
    emit(
      NotificationsLoaded(
        notifications: current.notifications,
        visibleNotifications: filtered,
        query: event.query,
      ),
    );
  }

  Future<void> _onReadRequested(
    NotificationReadRequested event,
    Emitter<NotificationsState> emit,
  ) async {
    final current = state;
    if (current is! NotificationsLoaded) return;

    final target = current.notifications.where(
      (notification) => notification.id == event.notificationId,
    );
    if (target.isEmpty || target.first.isRead) return;

    final result = await markNotificationAsRead(
      MarkNotificationAsReadParams(event.notificationId),
    );

    result.fold((failure) => emit(NotificationsError(failure)), (updated) {
      final notifications = current.notifications.map((notification) {
        return notification.id == updated.id ? updated : notification;
      }).toList();
      emit(
        NotificationsLoaded(
          notifications: notifications,
          visibleNotifications: _filterNotifications(
            notifications,
            current.query,
          ),
          query: current.query,
        ),
      );
    });
  }
}

List<NotificationEntity> _filterNotifications(
  List<NotificationEntity> notifications,
  String query,
) {
  final normalized = query.trim().toLowerCase();
  if (normalized.isEmpty) return notifications;

  return notifications.where((notification) {
    final haystack = '${notification.title} ${notification.body}'.toLowerCase();
    return haystack.contains(normalized);
  }).toList();
}
