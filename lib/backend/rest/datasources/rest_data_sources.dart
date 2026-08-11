import 'package:dio/dio.dart';

import '../../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../../features/auth/data/models/user_model.dart';
import '../../../features/auth/domain/repositories/auth_repository.dart';
import '../../../features/donor_home/data/datasources/donor_card_remote_data_source.dart';
import '../../../features/donor_home/data/datasources/donor_feed_remote_data_source.dart';
import '../../../features/donor_home/data/models/donor_card_models.dart';
import '../../../features/donor_home/data/models/donor_feed_models.dart';
import '../../../features/notifications/data/datasources/notification_remote_data_source.dart';
import '../../../features/notifications/data/models/notification_model.dart';
import '../../../features/profile/data/datasources/profile_remote_data_source.dart';
import '../../../features/profile/data/models/profile_model.dart';
import '../../../features/requester_home/data/datasources/request_remote_data_source.dart';
import '../../../features/requester_home/domain/entities/blood_request_entity.dart';
import '../../../features/requester_home/data/models/request_models.dart';

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

class AuthRestDataSource implements AuthRemoteDataSource {
  AuthRestDataSource(this.dio);

  final Dio dio;

  @override
  Future<UserModel> signIn({
    required String username,
    required String password,
  }) async => _todo('POST /auth/login');

  @override
  Future<UserModel> signUp({required SignupParams params}) async =>
      _todo('POST /auth/register');

  @override
  Future<void> signOut() async => _todo('POST /auth/logout');

  @override
  Future<UserModel?> getCurrentUser() async => _todo('GET /auth/me');

  @override
  Future<UserModel> updateUserRole({
    required bool isDonor,
    required bool isRecipient,
  }) async => _todo('PATCH /users/me/roles');
}

class ProfileRestDataSource implements ProfileRemoteDataSource {
  ProfileRestDataSource(this.dio);

  final Dio dio;

  @override
  Future<ProfileModel> getProfile() async => _todo('GET /users/me');

  @override
  Future<ProfileModel> updateProfile(ProfileModel profile) async =>
      _todo('PATCH /users/me');

  @override
  Future<ProfileModel> changeRole({
    required bool isDonor,
    required bool isRecipient,
  }) async => _todo('PATCH /users/me/roles');

  @override
  Future<String> uploadAvatar(String filePath) async =>
      _todo('POST /users/me/avatar');
}

class RequestRestDataSource implements RequestRemoteDataSource {
  RequestRestDataSource(this.dio);

  final Dio dio;

  @override
  Future<List<BloodRequestModel>> listOwnRequests() async =>
      _todo('GET /requests?mine=true');

  @override
  Future<BloodRequestModel> getRequest(String requestId) async =>
      _todo('GET /requests/{id}');

  @override
  Future<List<HospitalModel>> listHospitals() async => _todo('GET /hospitals');

  @override
  Future<BloodRequestModel> createRequest(RequestDraft draft) async =>
      _todo('POST /requests');

  @override
  Future<BloodRequestModel> updateRequest({
    required String requestId,
    required RequestDraft draft,
  }) async => _todo('PATCH /requests/{id}');

  @override
  Future<BloodRequestModel> cancelRequest({
    required String requestId,
    required String reason,
  }) async => _todo('POST /requests/{id}/cancel');

  @override
  Future<List<RequestDonorModel>> listRequestDonors(String requestId) async =>
      _todo('GET /requests/{id}/donors');

  @override
  Future<List<CompatibleDonorModel>> listCompatibleDonors(
    String requestId,
  ) async => _todo('GET /requests/{id}/compatible-donors');

  @override
  Future<List<DirectInvitationModel>> listInvitations(String requestId) async =>
      _todo('GET /requests/{id}/invitations');

  @override
  Future<void> inviteDonor({
    required String requestId,
    required String donorId,
  }) async => _todo('POST /requests/{id}/invitations');

  @override
  Future<IssuedRequestQrModel> issueRequestQr(String requestId) async =>
      _todo('POST /requests/{id}/qr');
}

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
  Future<DonationRecordModel> redeemRequestQr(String token) async =>
      _todo('POST /donations/redeem/request');

  @override
  Future<DonationRecordModel> redeemCampaignQr(String token) async =>
      _todo('POST /donations/redeem/campaign');
}
