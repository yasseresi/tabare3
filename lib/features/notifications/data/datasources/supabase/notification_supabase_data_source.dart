import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/notification_model.dart';
import '../notification_remote_data_source.dart';

const notificationSelectColumns =
    'id,user_id,type,title,body,ref_id,ref_type,is_read,created_at,updated_at';

class NotificationSupabaseDataSource implements NotificationRemoteDataSource {
  final SupabaseClient client;

  NotificationSupabaseDataSource({required this.client});

  String get _userId => client.auth.currentUser!.id;

  @override
  Future<List<NotificationModel>> listNotifications() async {
    final rows = await client
        .from('notifications')
        .select(notificationSelectColumns)
        .eq('user_id', _userId)
        .order('created_at', ascending: false);

    return rows.map(NotificationModel.fromJson).toList();
  }

  @override
  Future<NotificationModel> markAsRead(String notificationId) async {
    final row = await client
        .from('notifications')
        .update({'is_read': true})
        .eq('id', notificationId)
        .eq('user_id', _userId)
        .select(notificationSelectColumns)
        .single();

    return NotificationModel.fromJson(row);
  }
}
