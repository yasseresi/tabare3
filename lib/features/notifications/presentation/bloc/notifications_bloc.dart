import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/usecases/mark_notification_as_read.dart';
import '../../domain/usecases/watch_notifications.dart';
import 'notifications_event.dart';
import 'notifications_state.dart';

export 'notifications_event.dart';
export 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final WatchNotifications watchNotifications;
  final MarkNotificationAsRead markNotificationAsRead;

  StreamSubscription<Either<Failure, List<NotificationEntity>>>? _subscription;

  NotificationsBloc({
    required this.watchNotifications,
    required this.markNotificationAsRead,
  }) : super(const NotificationsInitial()) {
    on<NotificationsRequested>(_onRequested);
    on<NotificationsStreamUpdated>(_onStreamUpdated);
    on<NotificationsSearchChanged>(_onSearchChanged);
    on<NotificationReadRequested>(_onReadRequested);
  }

  void _onRequested(
    NotificationsRequested event,
    Emitter<NotificationsState> emit,
  ) {
    if (state is NotificationsInitial) emit(const NotificationsLoading());
    // Managed subscription (not emit.forEach) so the search/read handlers stay
    // responsive while the realtime stream runs for the bloc's whole lifetime.
    _subscription?.cancel();
    _subscription = watchNotifications().listen(
      (result) => add(NotificationsStreamUpdated(result)),
    );
  }

  void _onStreamUpdated(
    NotificationsStreamUpdated event,
    Emitter<NotificationsState> emit,
  ) {
    event.result.fold((failure) => emit(NotificationsError(failure)), (
      notifications,
    ) {
      final current = state;
      final query = current is NotificationsLoaded ? current.query : '';
      emit(
        NotificationsLoaded(
          notifications: notifications,
          visibleNotifications: _filterNotifications(notifications, query),
          query: query,
        ),
      );
    });
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

    // The realtime stream re-emits the updated row, so the read state and
    // unread badge refresh on their own; only surface a failure here.
    final result = await markNotificationAsRead(
      MarkNotificationAsReadParams(event.notificationId),
    );
    result.fold((failure) => emit(NotificationsError(failure)), (_) {});
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
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
