import '../models/notification_model.dart';

/// Backend-agnostic contract for notifications.
///
/// Implementations live under `datasources/<backend>/`.
abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> listNotifications();
  Future<NotificationModel> markAsRead(String notificationId);
}
