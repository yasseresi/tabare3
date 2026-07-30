import 'package:dartz/dartz.dart';

import '../../../../core/error/error_handler.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/donor_feed_entity.dart';
import '../../domain/repositories/donor_feed_repository.dart';
import '../datasources/donor_feed_remote_data_source.dart';

class DonorFeedRepositoryImpl implements DonorFeedRepository {
  final DonorFeedRemoteDataSource remoteDataSource;

  DonorFeedRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, DonorFeedEntity>> getFeed() async {
    try {
      final availability = await remoteDataSource.getAvailability();
      final requests = await remoteDataSource.listCompatibleRequests();
      final campaigns = await remoteDataSource.listAvailableCampaigns();
      final appointments = await remoteDataSource.listAppointments();

      return Right(
        DonorFeedEntity(
          availability: availability.toEntity(),
          compatibleRequests: requests
              .map((model) => model.toEntity())
              .toList(),
          availableCampaigns: campaigns
              .map((model) => model.toEntity())
              .toList(),
          appointments: appointments.map((model) => model.toEntity()).toList(),
        ),
      );
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<Failure, DonorAvailabilityEntity>> getAvailability() async {
    try {
      final model = await remoteDataSource.getAvailability();
      return Right(model.toEntity());
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<Failure, DonorAvailabilityEntity>> setAvailability(
    bool isAvailable,
  ) async {
    try {
      final model = await remoteDataSource.setAvailability(isAvailable);
      return Right(model.toEntity());
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<Failure, List<DonorBloodRequestEntity>>>
  listCompatibleRequests() async {
    try {
      final models = await remoteDataSource.listCompatibleRequests();
      return Right(models.map((model) => model.toEntity()).toList());
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<Failure, List<DonorCampaignEntity>>>
  listAvailableCampaigns() async {
    try {
      final models = await remoteDataSource.listAvailableCampaigns();
      return Right(models.map((model) => model.toEntity()).toList());
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<Failure, List<DonorAppointmentEntity>>>
  listAppointments() async {
    try {
      final models = await remoteDataSource.listAppointments();
      return Right(models.map((model) => model.toEntity()).toList());
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<Failure, List<DonationRecordEntity>>>
  listDonationRecords() async {
    try {
      final models = await remoteDataSource.listDonationRecords();
      return Right(models.map((model) => model.toEntity()).toList());
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<Failure, DonorAppointmentEntity>> acceptBloodRequest({
    required String requestId,
    required DateTime scheduledAt,
  }) async {
    try {
      final model = await remoteDataSource.acceptBloodRequest(
        requestId: requestId,
        scheduledAt: scheduledAt,
      );
      return Right(model.toEntity());
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<Failure, DonorAppointmentEntity>> cancelAppointment({
    required String appointmentId,
    required String reason,
  }) async {
    try {
      final model = await remoteDataSource.cancelAppointment(
        appointmentId: appointmentId,
        reason: reason,
      );
      return Right(model.toEntity());
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<Failure, DonationRecordEntity>> redeemRequestQr(
    String token,
  ) async {
    try {
      final model = await remoteDataSource.redeemRequestQr(token);
      return Right(model.toEntity());
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<Failure, DonationRecordEntity>> redeemCampaignQr(
    String token,
  ) async {
    try {
      final model = await remoteDataSource.redeemCampaignQr(token);
      return Right(model.toEntity());
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }
}
