import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/notification_entity.dart';

abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object?> get props => [];
}

class NotificationsInitial extends NotificationsState {
  const NotificationsInitial();
}

class NotificationsLoading extends NotificationsState {
  const NotificationsLoading();
}

class NotificationsLoaded extends NotificationsState {
  final List<NotificationEntity> notifications;
  final List<NotificationEntity> visibleNotifications;
  final String query;

  const NotificationsLoaded({
    required this.notifications,
    required this.visibleNotifications,
    this.query = '',
  });

  @override
  List<Object?> get props => [notifications, visibleNotifications, query];
}

class NotificationsError extends NotificationsState {
  final Failure failure;

  const NotificationsError(this.failure);

  @override
  List<Object?> get props => [failure];
}
