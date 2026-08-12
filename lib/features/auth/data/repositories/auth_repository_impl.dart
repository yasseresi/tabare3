import 'package:dartz/dartz.dart';

import '../../../../core/backend/backend_error_mapper.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserEntity>> loginWithUsernamePassword({
    required String username,
    required String password,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final userModel = await remoteDataSource.signIn(
        username: username,
        password: password,
      );
      return Right(userModel.toEntity());
    } catch (e) {
      // BackendOperation.signIn is what stops the mapper from telling the user
      // whether it was the username or the password that was wrong.
      return Left(ErrorHandler.handle(e, operation: BackendOperation.signIn));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signupWithUsernamePassword({
    required SignupParams params,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final userModel = await remoteDataSource.signUp(params: params);
      return Right(userModel.toEntity());
    } catch (e) {
      return Left(ErrorHandler.handle(e, operation: BackendOperation.signUp));
    }
  }

  @override
  Future<Either<Failure, bool>> isUsernameAvailable(String username) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      return Right(await remoteDataSource.isUsernameAvailable(username));
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentSession() async {
    try {
      final userModel = await remoteDataSource.getCurrentUser();
      if (userModel == null) return const Right(null);
      return Right(userModel.toEntity());
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateUserRole({
    required bool isDonor,
    required bool isRecipient,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final userModel = await remoteDataSource.updateUserRole(
        isDonor: isDonor,
        isRecipient: isRecipient,
      );
      return Right(userModel.toEntity());
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }
}
