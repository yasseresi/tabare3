import 'package:dio/dio.dart';

import '../../../features/notifications/data/datasources/notification_remote_data_source.dart';
import '../../../features/notifications/data/models/notification_model.dart';

/// REST implementations of the feature data source contracts.
///
/// Every method is an endpoint still to be built on the custom backend. The
/// Supabase equivalents under `features/*/data/datasources/supabase/` are the
/// specification: each one shows the exact table/RPC and the model it must
/// produce.
///
/// Implement a method by replacing its body with a [Dio] call plus
/// `Model.fromJson(...)` — no other layer changes.

Never _todo(String endpoint) =>
    throw UnimplementedError('REST backend: $endpoint not implemented yet');

class NotificationRestDataSource implements NotificationRemoteDataSource {
  NotificationRestDataSource(this.dio);

  final Dio dio;

  @override
  Future<List<NotificationModel>> listNotifications() async =>
      _todo('GET /notifications');

  @override
  Future<NotificationModel> markAsRead(String notificationId) async =>
      _todo('PATCH /notifications/{id}');

  @override
  Stream<List<NotificationModel>> watchNotifications() =>
      _todo('STREAM /notifications');
}


