import 'dart:async';

import 'package:dio/dio.dart';

import '../../../features/notifications/data/datasources/notification_remote_data_source.dart';
import '../../../features/notifications/data/models/notification_model.dart';
import '../constants/rest_paths.dart';
import '../rest_paginator.dart';

/// How often [NotificationRestDataSource.watchNotifications] re-fetches. The
/// Django backend has no realtime channel, so the live Supabase stream becomes
/// a poll.
const Duration notificationPollInterval = Duration(seconds: 30);

/// REST implementation of [NotificationRemoteDataSource] against the Django
/// backend.
class NotificationRestDataSource implements NotificationRemoteDataSource {
  NotificationRestDataSource(this.dio, {Duration? pollInterval})
    : pollInterval = pollInterval ?? notificationPollInterval;

  final Dio dio;
  final Duration pollInterval;

  @override
  Future<List<NotificationModel>> listNotifications() async {
    final rows = await fetchAllPages(dio, RestPaths.notifications);
    return rows.map(_map).toList(growable: false);
  }

  /// First page only — used by the 30s poll so a user with many notifications
  /// doesn't walk every page each tick just to refresh the list + badge.
  Future<List<NotificationModel>> _listFirstPage() async {
    final response = await dio.get<Map<String, dynamic>>(
      RestPaths.notifications,
    );
    final results = response.data?['results'];
    if (results is! List) return const [];
    return results
        .whereType<Map<String, dynamic>>()
        .map(_map)
        .toList(growable: false);
  }

  @override
  Future<NotificationModel> markAsRead(String notificationId) async {
    final response = await dio.post<Map<String, dynamic>>(
      RestPaths.notificationMarkRead(notificationId),
    );
    return _map(response.data ?? const {});
  }

  /// Polling replacement for the Supabase realtime stream: emits the current
  /// list immediately, then re-fetches every [pollInterval]. The timer is tied
  /// to the subscription — it starts on listen and stops on cancel, so signing
  /// out (which cancels the subscription) ends the polling.
  @override
  Stream<List<NotificationModel>> watchNotifications() {
    late final StreamController<List<NotificationModel>> controller;
    Timer? timer;
    var closed = false;

    Future<void> tick() async {
      try {
        final list = await _listFirstPage();
        if (!closed) controller.add(list);
      } catch (error, stack) {
        if (!closed) controller.addError(error, stack);
      }
    }

    controller = StreamController<List<NotificationModel>>(
      onListen: () {
        tick();
        timer = Timer.periodic(pollInterval, (_) => tick());
      },
      onCancel: () {
        closed = true;
        timer?.cancel();
      },
    );

    return controller.stream;
  }

  NotificationModel _map(Map<String, dynamic> json) {
    final createdAt =
        DateTime.tryParse(json['created_at']?.toString() ?? '') ??
        DateTime.now();
    return NotificationModel(
      id: json['id']?.toString() ?? '',
      // The recipient is the caller; Django does not echo a user id.
      userId: '',
      type: json['notification_type']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      refId: json['entity_id']?.toString(),
      refType: json['entity_type']?.toString(),
      isRead: json['is_read'] == true,
      createdAt: createdAt,
      updatedAt:
          DateTime.tryParse(json['read_at']?.toString() ?? '') ?? createdAt,
    );
  }
}
