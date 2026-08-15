import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/notification_entity.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
abstract class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String type,
    required String title,
    required String body,
    @JsonKey(name: 'ref_id') String? refId,
    @JsonKey(name: 'ref_type') String? refType,
    @JsonKey(name: 'is_read') @Default(false) bool isRead,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}

extension NotificationModelX on NotificationModel {
  NotificationEntity toEntity() => NotificationEntity(
    id: id,
    userId: userId,
    type: type,
    title: title,
    body: body,
    refId: refId,
    refType: refType,
    isRead: isRead,
    createdAt: createdAt,
  );
}
