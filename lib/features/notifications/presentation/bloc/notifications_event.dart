import 'package:equatable/equatable.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object?> get props => [];
}

class NotificationsRequested extends NotificationsEvent {
  const NotificationsRequested();
}

class NotificationsSearchChanged extends NotificationsEvent {
  final String query;

  const NotificationsSearchChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class NotificationReadRequested extends NotificationsEvent {
  final String notificationId;

  const NotificationReadRequested(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}
