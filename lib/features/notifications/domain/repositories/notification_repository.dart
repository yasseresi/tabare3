import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<Either<Failure, List<NotificationEntity>>> listNotifications();
  Future<Either<Failure, NotificationEntity>> markAsRead(String notificationId);

  /// Live stream of the caller's notifications. Each emission is either the
  /// latest list or a [Failure] if the realtime channel errors.
  Stream<Either<Failure, List<NotificationEntity>>> watchNotifications();
}
