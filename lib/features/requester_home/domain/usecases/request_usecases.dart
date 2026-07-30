import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/blood_request_entity.dart';
import '../repositories/request_repository.dart';

class GetRecipientRequests
    implements BaseUseCase<List<BloodRequestEntity>, NoParams> {
  final RequestRepository repository;

  GetRecipientRequests(this.repository);

  @override
  Future<Either<Failure, List<BloodRequestEntity>>> call(NoParams params) {
    return repository.listOwnRequests();
  }
}

class GetRecipientRequest implements BaseUseCase<BloodRequestEntity, String> {
  final RequestRepository repository;

  GetRecipientRequest(this.repository);

  @override
  Future<Either<Failure, BloodRequestEntity>> call(String requestId) {
    return repository.getRequest(requestId);
  }
}

class GetHospitals implements BaseUseCase<List<HospitalEntity>, NoParams> {
  final RequestRepository repository;

  GetHospitals(this.repository);

  @override
  Future<Either<Failure, List<HospitalEntity>>> call(NoParams params) {
    return repository.listHospitals();
  }
}

class CreateRecipientRequest
    implements BaseUseCase<BloodRequestEntity, RequestDraft> {
  final RequestRepository repository;
  final DateTime Function() now;

  CreateRecipientRequest(this.repository, {DateTime Function()? now})
    : now = now ?? DateTime.now;

  @override
  Future<Either<Failure, BloodRequestEntity>> call(RequestDraft draft) {
    final failure = validateRequestDraft(draft, now());
    if (failure != null) {
      return Future.value(Left(failure));
    }
    return repository.createRequest(draft);
  }
}

class UpdateRequestParams {
  final String requestId;
  final RequestDraft draft;

  const UpdateRequestParams({required this.requestId, required this.draft});
}

class UpdateRecipientRequest
    implements BaseUseCase<BloodRequestEntity, UpdateRequestParams> {
  final RequestRepository repository;
  final DateTime Function() now;

  UpdateRecipientRequest(this.repository, {DateTime Function()? now})
    : now = now ?? DateTime.now;

  @override
  Future<Either<Failure, BloodRequestEntity>> call(UpdateRequestParams params) {
    final failure = validateRequestDraft(params.draft, now());
    if (failure != null) {
      return Future.value(Left(failure));
    }
    return repository.updateRequest(
      requestId: params.requestId,
      draft: params.draft,
    );
  }
}

class CancelRequestParams {
  final String requestId;
  final String reason;

  const CancelRequestParams({required this.requestId, required this.reason});
}

class CancelRecipientRequest
    implements BaseUseCase<BloodRequestEntity, CancelRequestParams> {
  final RequestRepository repository;

  CancelRecipientRequest(this.repository);

  @override
  Future<Either<Failure, BloodRequestEntity>> call(CancelRequestParams params) {
    if (params.reason.trim().isEmpty) {
      return Future.value(
        const Left(ValidationFailure(-11, 'سبب الإلغاء مطلوب')),
      );
    }
    return repository.cancelRequest(
      requestId: params.requestId,
      reason: params.reason.trim(),
    );
  }
}

class GetRequestDonors
    implements BaseUseCase<List<RequestDonorEntity>, String> {
  final RequestRepository repository;

  GetRequestDonors(this.repository);

  @override
  Future<Either<Failure, List<RequestDonorEntity>>> call(String requestId) {
    return repository.listRequestDonors(requestId);
  }
}

class GetCompatibleDonors
    implements BaseUseCase<List<CompatibleDonorEntity>, String> {
  final RequestRepository repository;

  GetCompatibleDonors(this.repository);

  @override
  Future<Either<Failure, List<CompatibleDonorEntity>>> call(String requestId) {
    return repository.listCompatibleDonors(requestId);
  }
}

class GetRequestInvitations
    implements BaseUseCase<List<DirectInvitationEntity>, String> {
  final RequestRepository repository;

  GetRequestInvitations(this.repository);

  @override
  Future<Either<Failure, List<DirectInvitationEntity>>> call(String requestId) {
    return repository.listInvitations(requestId);
  }
}

class InviteDonorParams {
  final String requestId;
  final String donorId;

  const InviteDonorParams({required this.requestId, required this.donorId});
}

class InviteCompatibleDonor implements BaseUseCase<void, InviteDonorParams> {
  final RequestRepository repository;

  InviteCompatibleDonor(this.repository);

  @override
  Future<Either<Failure, void>> call(InviteDonorParams params) {
    return repository.inviteDonor(
      requestId: params.requestId,
      donorId: params.donorId,
    );
  }
}

class IssueRequestQr implements BaseUseCase<IssuedRequestQrEntity, String> {
  final RequestRepository repository;

  IssueRequestQr(this.repository);

  @override
  Future<Either<Failure, IssuedRequestQrEntity>> call(String requestId) {
    return repository.issueRequestQr(requestId);
  }
}

ValidationFailure? validateRequestDraft(RequestDraft draft, DateTime now) {
  if (draft.hospitalId.trim().isEmpty ||
      draft.bloodType.trim().isEmpty ||
      draft.unitsNeeded <= 0) {
    return const ValidationFailure();
  }

  if (draft.neededBy != null && !draft.neededBy!.isAfter(now)) {
    return const ValidationFailure(-11, 'تاريخ الحاجة يجب أن يكون في المستقبل');
  }

  return null;
}
