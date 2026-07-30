import 'package:dartz/dartz.dart';

import '../../../../core/error/error_handler.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/blood_request_entity.dart';
import '../../domain/repositories/request_repository.dart';
import '../datasources/request_remote_data_source.dart';

class RequestRepositoryImpl implements RequestRepository {
  final RequestRemoteDataSource remoteDataSource;

  RequestRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<BloodRequestEntity>>> listOwnRequests() async {
    try {
      final models = await remoteDataSource.listOwnRequests();
      return Right(models.map((model) => model.toEntity()).toList());
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<Failure, BloodRequestEntity>> getRequest(
    String requestId,
  ) async {
    try {
      final model = await remoteDataSource.getRequest(requestId);
      return Right(model.toEntity());
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<Failure, List<HospitalEntity>>> listHospitals() async {
    try {
      final models = await remoteDataSource.listHospitals();
      return Right(models.map((model) => model.toEntity()).toList());
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<Failure, BloodRequestEntity>> createRequest(
    RequestDraft draft,
  ) async {
    try {
      final model = await remoteDataSource.createRequest(draft);
      return Right(model.toEntity());
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<Failure, BloodRequestEntity>> updateRequest({
    required String requestId,
    required RequestDraft draft,
  }) async {
    try {
      final model = await remoteDataSource.updateRequest(
        requestId: requestId,
        draft: draft,
      );
      return Right(model.toEntity());
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<Failure, BloodRequestEntity>> cancelRequest({
    required String requestId,
    required String reason,
  }) async {
    try {
      final model = await remoteDataSource.cancelRequest(
        requestId: requestId,
        reason: reason,
      );
      return Right(model.toEntity());
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<Failure, List<RequestDonorEntity>>> listRequestDonors(
    String requestId,
  ) async {
    try {
      final models = await remoteDataSource.listRequestDonors(requestId);
      return Right(models.map((model) => model.toEntity()).toList());
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<Failure, List<CompatibleDonorEntity>>> listCompatibleDonors(
    String requestId,
  ) async {
    try {
      final models = await remoteDataSource.listCompatibleDonors(requestId);
      return Right(models.map((model) => model.toEntity()).toList());
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<Failure, List<DirectInvitationEntity>>> listInvitations(
    String requestId,
  ) async {
    try {
      final models = await remoteDataSource.listInvitations(requestId);
      return Right(models.map((model) => model.toEntity()).toList());
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<Failure, void>> inviteDonor({
    required String requestId,
    required String donorId,
  }) async {
    try {
      await remoteDataSource.inviteDonor(
        requestId: requestId,
        donorId: donorId,
      );
      return const Right(null);
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<Failure, IssuedRequestQrEntity>> issueRequestQr(
    String requestId,
  ) async {
    try {
      final model = await remoteDataSource.issueRequestQr(requestId);
      return Right(model.toEntity());
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }
}
