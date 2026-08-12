import '../models/donor_feed_models.dart';

/// Backend-agnostic contract for the donor feed (availability, requests,
/// campaigns, appointments, donation records, QR redemption).
///
/// Implementations live under `datasources/<backend>/`.
abstract class DonorFeedRemoteDataSource {
  Future<DonorAvailabilityModel> getAvailability();
  Future<DonorAvailabilityModel> setAvailability(bool isAvailable);
  Future<List<DonorBloodRequestModel>> listCompatibleRequests();
  Future<List<DonorCampaignModel>> listAvailableCampaigns();
  Future<List<DonorAppointmentModel>> listAppointments();
  Future<List<DonationRecordModel>> listDonationRecords();
  Future<DonorAppointmentModel> acceptBloodRequest({
    required String requestId,
    required DateTime scheduledAt,
  });
  Future<DonorAppointmentModel> cancelAppointment({
    required String appointmentId,
    required String reason,
  });
  /// Unified redemption: the backend infers request vs campaign from the token.
  Future<DonationRecordModel> redeemQr(String token);
  Future<DonationRecordModel> redeemRequestQr(String token);
  Future<DonationRecordModel> redeemCampaignQr(String token);
}
