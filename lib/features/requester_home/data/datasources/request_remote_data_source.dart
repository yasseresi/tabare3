import '../../domain/entities/blood_request_entity.dart';
import '../models/request_models.dart';

/// Backend-agnostic contract for recipient blood requests.
///
/// Implementations live under `datasources/<backend>/`.
abstract class RequestRemoteDataSource {
  Future<List<BloodRequestModel>> listOwnRequests();
  Future<BloodRequestModel> getRequest(String requestId);
  Future<List<HospitalModel>> listHospitals();
  Future<BloodRequestModel> createRequest(RequestDraft draft);
  Future<BloodRequestModel> updateRequest({
    required String requestId,
    required RequestDraft draft,
  });
  Future<BloodRequestModel> cancelRequest({
    required String requestId,
    required String reason,
  });
  Future<List<RequestDonorModel>> listRequestDonors(String requestId);
  Future<List<CompatibleDonorModel>> listCompatibleDonors(String requestId);
  Future<List<DirectInvitationModel>> listInvitations(String requestId);
  Future<void> inviteDonor({
    required String requestId,
    required String donorId,
  });
  Future<IssuedRequestQrModel> issueRequestQr(String requestId);
  Future<BloodRequestModel> reactivateRequest(String requestId);
}
