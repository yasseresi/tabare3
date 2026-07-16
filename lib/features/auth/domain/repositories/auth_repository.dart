import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class SignupParams extends Equatable {
  final String username;
  final String fullName;
  final String email;
  final String password;
  final String phone;
  final DateTime dateOfBirth;
  final String gender;
  final String bloodType;
  final String city;
  final String? nationalId;
  final double? weight;
  final String? chronicDiseases;

  const SignupParams({
    required this.username,
    required this.fullName,
    required this.email,
    required this.password,
    required this.phone,
    required this.dateOfBirth,
    required this.gender,
    required this.bloodType,
    required this.city,
    this.nationalId,
    this.weight,
    this.chronicDiseases,
  });

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

  @override
  List<Object?> get props => [
        username, fullName, email, password, phone,
        dateOfBirth, gender, bloodType, city,
        nationalId, weight, chronicDiseases,
      ];
}

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> signupWithEmailPassword({
    required SignupParams params,
  });

  Future<Either<Failure, void>> signOut();

  Future<Either<Failure, UserEntity?>> getCurrentSession();

  Future<Either<Failure, UserEntity>> updateUserRole({
    required bool isDonor,
    required bool isRecipient,
  });
}
