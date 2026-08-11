import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/notification_entity.dart';
import '../repositories/notification_repository.dart';

/// Streams the caller's notifications live. Unlike [BaseUseCase] this returns a
/// [Stream] rather than a one-shot [Future], so it stands on its own.
class WatchNotifications {
  final NotificationRepository repository;

  WatchNotifications(this.repository);

  Stream<Either<Failure, List<NotificationEntity>>> call() {
    return repository.watchNotifications();
  }
}
