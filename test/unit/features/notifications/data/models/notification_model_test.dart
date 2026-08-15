import 'package:flutter_test/flutter_test.dart';
import 'package:tabare3/features/notifications/data/models/notification_model.dart';

void main() {
  const json = {
    'id': 'notification-1',
    'user_id': 'user-1',
    'type': 'new_request',
    'title': 'حاجة مستعجلة',
    'body': 'هناك طلب جديد يحتاج إلى متبرع',
    'ref_id': 'request-1',
    'ref_type': 'blood_request',
    'is_read': false,
    'created_at': '2026-07-30T10:00:00.000Z',
    'updated_at': '2026-07-30T10:00:00.000Z',
  };

  test('fromJson parses the notification payload', () {
    final model = NotificationModel.fromJson(json);

    expect(model.id, 'notification-1');
    expect(model.userId, 'user-1');
    expect(model.type, 'new_request');
    expect(model.title, 'حاجة مستعجلة');
    expect(model.body, 'هناك طلب جديد يحتاج إلى متبرع');
    expect(model.refId, 'request-1');
    expect(model.refType, 'blood_request');
    expect(model.isRead, false);
    expect(model.createdAt, DateTime.parse('2026-07-30T10:00:00.000Z'));
  });

  test('toEntity preserves the notification fields', () {
    final model = NotificationModel.fromJson(json);
    final entity = model.toEntity();

    expect(entity.id, model.id);
    expect(entity.userId, model.userId);
    expect(entity.type, model.type);
    expect(entity.title, model.title);
    expect(entity.body, model.body);
    expect(entity.refId, model.refId);
    expect(entity.refType, model.refType);
    expect(entity.isRead, model.isRead);
    expect(entity.createdAt, model.createdAt);
  });
}
