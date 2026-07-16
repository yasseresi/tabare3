import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

part 'auth_repository.freezed.dart';

@freezed
abstract class LoginParams with _$LoginParams {
  const factory LoginParams({required String username, required String password}) =
      _LoginParams;
}

@freezed
abstract class SignupParams with _$SignupParams {
  const factory SignupParams({
    required String username,
    required String fullName,
    required String password,
    required String phone,
    required DateTime dateOfBirth,
    required String gender,
    required String bloodType,
    required String city,
    String? nationalId,
    double? weight,
    String? chronicDiseases,
  }) = _SignupParams;
}

extension SignupParamsX on SignupParams {
  Map<String, dynamic> toMetadata() => {
    'username': username,
    'full_name': fullName,
    'phone': phone,
    'date_of_birth': dateOfBirth.toIso8601String().split('T')[0],
    'gender': gender,
    'blood_type': bloodType,
    'city': city,
    if (nationalId != null) 'national_id': nationalId,
    if (weight != null) 'weight': weight.toString(),
    if (chronicDiseases != null) 'chronic_diseases': chronicDiseases,
  };
}

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> loginWithUsernamePassword({
    required String username,
    required String password,
  });

  Future<Either<Failure, UserEntity>> signupWithUsernamePassword({
    required SignupParams params,
  });

  Future<Either<Failure, void>> signOut();

  Future<Either<Failure, UserEntity?>> getCurrentSession();

  Future<Either<Failure, UserEntity>> updateUserRole({
    required bool isDonor,
    required bool isRecipient,
  });
}
