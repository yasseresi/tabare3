import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/blood_request_entity.dart';

abstract class RequestRepository {
  Future<Either<Failure, List<BloodRequestEntity>>> listOwnRequests();
  Future<Either<Failure, BloodRequestEntity>> getRequest(String requestId);
  Future<Either<Failure, List<HospitalEntity>>> listHospitals();
  Future<Either<Failure, BloodRequestEntity>> createRequest(RequestDraft draft);
  Future<Either<Failure, BloodRequestEntity>> updateRequest({
    required String requestId,
    required RequestDraft draft,
  });
  Future<Either<Failure, BloodRequestEntity>> cancelRequest({
    required String requestId,
    required String reason,
  });
  Future<Either<Failure, List<RequestDonorEntity>>> listRequestDonors(
    String requestId,
  );
  Future<Either<Failure, List<CompatibleDonorEntity>>> listCompatibleDonors(
    String requestId,
  );
  Future<Either<Failure, List<DirectInvitationEntity>>> listInvitations(
    String requestId,
  );
  Future<Either<Failure, void>> inviteDonor({
    required String requestId,
    required String donorId,
  });
  Future<Either<Failure, IssuedRequestQrEntity>> issueRequestQr(
    String requestId,
  );
}
