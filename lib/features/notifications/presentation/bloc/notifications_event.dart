import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/notification_entity.dart';

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

/// Internal: a new snapshot arrived on the realtime stream (or it errored).
class NotificationsStreamUpdated extends NotificationsEvent {
  final Either<Failure, List<NotificationEntity>> result;

  const NotificationsStreamUpdated(this.result);

  @override
  List<Object?> get props => [result];
}
