import 'package:dio/dio.dart';

import '../../../features/donor_home/data/datasources/donor_card_remote_data_source.dart';
import '../../../features/donor_home/data/datasources/donor_feed_remote_data_source.dart';
import '../../../features/donor_home/data/models/donor_card_models.dart';
import '../../../features/donor_home/data/models/donor_feed_models.dart';
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

class DonorCardRestDataSource implements DonorCardRemoteDataSource {
  DonorCardRestDataSource(this.dio);

  final Dio dio;

  @override
  Future<DonorCardModel> getDonorCard() async => _todo('GET /donors/me/card');
}

class DonorFeedRestDataSource implements DonorFeedRemoteDataSource {
  DonorFeedRestDataSource(this.dio);

  final Dio dio;

  @override
  Future<DonorAvailabilityModel> getAvailability() async =>
      _todo('GET /donors/me/availability');

  @override
  Future<DonorAvailabilityModel> setAvailability(bool isAvailable) async =>
      _todo('PATCH /donors/me/availability');

  @override
  Future<List<DonorBloodRequestModel>> listCompatibleRequests() async =>
      _todo('GET /donors/me/compatible-requests');

  @override
  Future<List<DonorCampaignModel>> listAvailableCampaigns() async =>
      _todo('GET /donors/me/campaigns');

  @override
  Future<List<DonorAppointmentModel>> listAppointments() async =>
      _todo('GET /donors/me/appointments');

  @override
  Future<List<DonationRecordModel>> listDonationRecords() async =>
      _todo('GET /donors/me/donations');

  @override
  Future<DonorAppointmentModel> acceptBloodRequest({
    required String requestId,
    required DateTime scheduledAt,
  }) async => _todo('POST /requests/{id}/accept');

  @override
  Future<DonorAppointmentModel> cancelAppointment({
    required String appointmentId,
    required String reason,
  }) async => _todo('POST /appointments/{id}/cancel');

  @override
  Future<DonationRecordModel> redeemQr(String token) async =>
      _todo('POST /donations/redeem');

  @override
  Future<DonationRecordModel> redeemRequestQr(String token) async =>
      _todo('POST /donations/redeem/request');

  @override
  Future<DonationRecordModel> redeemCampaignQr(String token) async =>
      _todo('POST /donations/redeem/campaign');
}
