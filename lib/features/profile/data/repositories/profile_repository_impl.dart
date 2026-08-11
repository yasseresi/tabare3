import 'package:dartz/dartz.dart';

import '../../../../core/error/error_handler.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_data_source.dart';
import '../datasources/profile_remote_data_source.dart';
import '../models/profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final ProfileLocalDataSource localDataSource;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<ProfileEntity?> getCachedProfile() async {
    final cached = await localDataSource.getLastProfile();
    return cached?.toEntity();
  }

  @override
  Future<Either<Failure, ProfileEntity>> getProfile() async {
    try {
      final remoteProfile = await remoteDataSource.getProfile();
      await localDataSource.cacheProfile(remoteProfile);
      return Right(remoteProfile.toEntity());
    } catch (e) {
      final cached = await localDataSource.getLastProfile();
      if (cached != null) {
        return Right(cached.toEntity());
      }
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> updateProfile(
    ProfileEntity profile,
  ) async {
    try {
      final model = _toModel(profile);
      final updated = await remoteDataSource.updateProfile(model);
      await localDataSource.cacheProfile(updated);
      return Right(updated.toEntity());
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> changeRole({
    required bool isDonor,
    required bool isRecipient,
  }) async {
    try {
      final updated = await remoteDataSource.changeRole(
        isDonor: isDonor,
        isRecipient: isRecipient,
      );
      await localDataSource.cacheProfile(updated);
      return Right(updated.toEntity());
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, String>> uploadAvatar(String filePath) async {
    try {
      final url = await remoteDataSource.uploadAvatar(filePath);
      return Right(url);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  ProfileModel _toModel(ProfileEntity entity) => ProfileModel(
    id: entity.id,
    email: entity.email,
    username: entity.username,
    fullName: entity.fullName,
    phone: entity.phone,
    dateOfBirth: entity.dateOfBirth,
    gender: entity.gender,
    nationalId: entity.nationalId,
    bloodType: entity.bloodType,
    weight: entity.weight,
    city: entity.city,
    chronicDiseases: entity.chronicDiseases,
    avatarUrl: entity.avatarUrl,
    isDonor: entity.isDonor,
    isRecipient: entity.isRecipient,
    isActive: entity.isActive,
  );
}
