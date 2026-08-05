import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_entity.freezed.dart';

@freezed
abstract class NotificationEntity with _$NotificationEntity {
  const factory NotificationEntity({
    required String id,
    required String userId,
    required String type,
    required String title,
    required String body,
    String? refId,
    String? refType,
    required bool isRead,
    required DateTime createdAt,
  }) = _NotificationEntity;
}

extension NotificationEntityX on NotificationEntity {
  bool get hasSuccessStatus =>
      type == NotificationTypes.thankYou ||
      type == NotificationTypes.participationAccepted;
}

class NotificationTypes {
  static const String thankYou = 'thank_you';
  static const String participationAccepted = 'participation_accepted';
  static const String appointmentReminder = 'appointment_reminder';
}
