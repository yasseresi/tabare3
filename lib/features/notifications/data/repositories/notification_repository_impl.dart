import 'package:dartz/dartz.dart';

import '../../../../core/error/error_handler.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_data_source.dart';
import '../models/notification_model.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<NotificationEntity>>> listNotifications() async {
    try {
      final models = await remoteDataSource.listNotifications();
      return Right(models.map((model) => model.toEntity()).toList());
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<Failure, NotificationEntity>> markAsRead(
    String notificationId,
  ) async {
    try {
      final model = await remoteDataSource.markAsRead(notificationId);
      return Right(model.toEntity());
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }
}
