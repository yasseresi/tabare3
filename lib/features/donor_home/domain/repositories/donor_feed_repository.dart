import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/donor_feed_entity.dart';

abstract class DonorFeedRepository {
  Future<Either<Failure, DonorFeedEntity>> getFeed();
  Future<Either<Failure, DonorAvailabilityEntity>> getAvailability();
  Future<Either<Failure, DonorAvailabilityEntity>> setAvailability(
    bool isAvailable,
  );
  Future<Either<Failure, List<DonorBloodRequestEntity>>>
  listCompatibleRequests();
  Future<Either<Failure, List<DonorCampaignEntity>>> listAvailableCampaigns();
  Future<Either<Failure, List<DonorAppointmentEntity>>> listAppointments();
  Future<Either<Failure, List<DonationRecordEntity>>> listDonationRecords();
  Future<Either<Failure, DonorAppointmentEntity>> acceptBloodRequest({
    required String requestId,
    required DateTime scheduledAt,
  });
  Future<Either<Failure, DonorAppointmentEntity>> cancelAppointment({
    required String appointmentId,
    required String reason,
  });
  /// Unified redemption: the backend infers request vs campaign from the token.
  Future<Either<Failure, DonationRecordEntity>> redeemQr(String token);
  Future<Either<Failure, DonationRecordEntity>> redeemRequestQr(String token);
  Future<Either<Failure, DonationRecordEntity>> redeemCampaignQr(String token);
}
