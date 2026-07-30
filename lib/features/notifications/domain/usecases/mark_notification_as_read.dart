import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/notification_entity.dart';
import '../repositories/notification_repository.dart';

class MarkNotificationAsReadParams {
  final String notificationId;

  const MarkNotificationAsReadParams(this.notificationId);
}

class MarkNotificationAsRead
    implements BaseUseCase<NotificationEntity, MarkNotificationAsReadParams> {
  final NotificationRepository repository;

  MarkNotificationAsRead(this.repository);

  @override
  Future<Either<Failure, NotificationEntity>> call(
    MarkNotificationAsReadParams params,
  ) {
    return repository.markAsRead(params.notificationId);
  }
}
