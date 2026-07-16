import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:tabare3/core/error/failures.dart';
import 'package:tabare3/features/auth/domain/entities/user_entity.dart';
import 'package:tabare3/features/auth/domain/repositories/auth_repository.dart';
import 'package:tabare3/features/auth/domain/usecases/signup_with_email_password.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late SignupWithUsernamePassword usecase;
  late MockAuthRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(SignupParams(
      username: 'fallback',
      fullName: 'fallback',
      password: 'fallback',
      phone: '0000',
      dateOfBirth: DateTime(2000),
      gender: 'male',
      bloodType: 'O+',
      city: 'fallback',
    ));
  });

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = SignupWithUsernamePassword(mockRepository);
  });

  final testParams = SignupParams(
    username: 'testuser',
    fullName: 'Test User',
    password: 'password123',
    phone: '0555123456',
    dateOfBirth: DateTime(2000, 1, 1),
    gender: 'male',
    bloodType: 'O+',
    city: 'Algiers',
  );

  test('should return UserEntity when repository returns Right', () async {
    const testUser = UserEntity(
      id: '123',
      email: 'testuser@tabara3.dz',
      username: 'testuser',
      fullName: 'Test User',
      bloodType: 'O+',
    );
    when(() => mockRepository.signupWithUsernamePassword(
          params: any(named: 'params'),
        )).thenAnswer((_) async => const Right(testUser));

    final result = await usecase(testParams);

    expect(result, const Right(testUser));
    verify(() => mockRepository.signupWithUsernamePassword(params: testParams)).called(1);
  });

  test('should return Failure when repository returns Left', () async {
    const failure = AuthFailure(-9, 'Username already taken');
    when(() => mockRepository.signupWithUsernamePassword(
          params: any(named: 'params'),
        )).thenAnswer((_) async => const Left(failure));

    final result = await usecase(testParams);

    expect(result, const Left(failure));
  });
}
