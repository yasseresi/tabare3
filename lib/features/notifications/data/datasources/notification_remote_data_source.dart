import '../models/notification_model.dart';

/// Backend-agnostic contract for notifications.
///
/// Implementations live under `datasources/<backend>/`.
abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> listNotifications();
  Future<NotificationModel> markAsRead(String notificationId);

  /// Live stream of the caller's notifications, newest first. Emits the
  /// current list immediately and again on every insert/update.
  Stream<List<NotificationModel>> watchNotifications();
}
