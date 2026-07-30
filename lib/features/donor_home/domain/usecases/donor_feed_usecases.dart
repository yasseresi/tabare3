import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/donor_feed_entity.dart';
import '../repositories/donor_feed_repository.dart';

class GetDonorFeed implements BaseUseCase<DonorFeedEntity, NoParams> {
  final DonorFeedRepository repository;

  GetDonorFeed(this.repository);

  @override
  Future<Either<Failure, DonorFeedEntity>> call(NoParams params) {
    return repository.getFeed();
  }
}

class GetDonorAvailability
    implements BaseUseCase<DonorAvailabilityEntity, NoParams> {
  final DonorFeedRepository repository;

  GetDonorAvailability(this.repository);

  @override
  Future<Either<Failure, DonorAvailabilityEntity>> call(NoParams params) {
    return repository.getAvailability();
  }
}

class SetDonorAvailability
    implements BaseUseCase<DonorAvailabilityEntity, bool> {
  final DonorFeedRepository repository;

  SetDonorAvailability(this.repository);

  @override
  Future<Either<Failure, DonorAvailabilityEntity>> call(bool isAvailable) {
    return repository.setAvailability(isAvailable);
  }
}

class GetCompatibleDonationRequests
    implements BaseUseCase<List<DonorBloodRequestEntity>, NoParams> {
  final DonorFeedRepository repository;

  GetCompatibleDonationRequests(this.repository);

  @override
  Future<Either<Failure, List<DonorBloodRequestEntity>>> call(NoParams params) {
    return repository.listCompatibleRequests();
  }
}

class GetAvailableCampaigns
    implements BaseUseCase<List<DonorCampaignEntity>, NoParams> {
  final DonorFeedRepository repository;

  GetAvailableCampaigns(this.repository);

  @override
  Future<Either<Failure, List<DonorCampaignEntity>>> call(NoParams params) {
    return repository.listAvailableCampaigns();
  }
}

class GetDonationAppointments
    implements BaseUseCase<List<DonorAppointmentEntity>, NoParams> {
  final DonorFeedRepository repository;

  GetDonationAppointments(this.repository);

  @override
  Future<Either<Failure, List<DonorAppointmentEntity>>> call(NoParams params) {
    return repository.listAppointments();
  }
}

class GetDonationRecords
    implements BaseUseCase<List<DonationRecordEntity>, NoParams> {
  final DonorFeedRepository repository;

  GetDonationRecords(this.repository);

  @override
  Future<Either<Failure, List<DonationRecordEntity>>> call(NoParams params) {
    return repository.listDonationRecords();
  }
}

class AcceptBloodRequestParams {
  final String requestId;
  final DateTime scheduledAt;

  const AcceptBloodRequestParams({
    required this.requestId,
    required this.scheduledAt,
  });
}

class AcceptBloodRequest
    implements BaseUseCase<DonorAppointmentEntity, AcceptBloodRequestParams> {
  final DonorFeedRepository repository;
  final DateTime Function() now;

  AcceptBloodRequest(this.repository, {DateTime Function()? now})
    : now = now ?? DateTime.now;

  @override
  Future<Either<Failure, DonorAppointmentEntity>> call(
    AcceptBloodRequestParams params,
  ) {
    final requestId = params.requestId.trim();
    if (requestId.isEmpty || !params.scheduledAt.isAfter(now())) {
      return Future.value(
        const Left(
          ValidationFailure(-11, 'موعد التبرع يجب أن يكون في المستقبل'),
        ),
      );
    }

    return repository.acceptBloodRequest(
      requestId: requestId,
      scheduledAt: params.scheduledAt,
    );
  }
}

class CancelDonationAppointmentParams {
  final String appointmentId;
  final String reason;

  const CancelDonationAppointmentParams({
    required this.appointmentId,
    required this.reason,
  });
}

class CancelDonationAppointment
    implements
        BaseUseCase<DonorAppointmentEntity, CancelDonationAppointmentParams> {
  final DonorFeedRepository repository;

  CancelDonationAppointment(this.repository);

  @override
  Future<Either<Failure, DonorAppointmentEntity>> call(
    CancelDonationAppointmentParams params,
  ) {
    final appointmentId = params.appointmentId.trim();
    final reason = params.reason.trim();
    if (appointmentId.isEmpty || reason.isEmpty) {
      return Future.value(
        const Left(ValidationFailure(-11, 'سبب الإلغاء مطلوب')),
      );
    }

    return repository.cancelAppointment(
      appointmentId: appointmentId,
      reason: reason,
    );
  }
}

class RedeemRequestDonation
    implements BaseUseCase<DonationRecordEntity, String> {
  final DonorFeedRepository repository;

  RedeemRequestDonation(this.repository);

  @override
  Future<Either<Failure, DonationRecordEntity>> call(String token) {
    final trimmed = token.trim();
    if (trimmed.isEmpty) {
      return Future.value(
        const Left(ValidationFailure(-11, 'رمز التحقق مطلوب')),
      );
    }
    return repository.redeemRequestQr(trimmed);
  }
}

class RedeemCampaignDonation
    implements BaseUseCase<DonationRecordEntity, String> {
  final DonorFeedRepository repository;

  RedeemCampaignDonation(this.repository);

  @override
  Future<Either<Failure, DonationRecordEntity>> call(String token) {
    final trimmed = token.trim();
    if (trimmed.isEmpty) {
      return Future.value(
        const Left(ValidationFailure(-11, 'رمز التحقق مطلوب')),
      );
    }
    return repository.redeemCampaignQr(trimmed);
  }
}
