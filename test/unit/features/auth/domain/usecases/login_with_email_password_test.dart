import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:tabare3/core/error/failures.dart';
import 'package:tabare3/features/auth/domain/entities/user_entity.dart';
import 'package:tabare3/features/auth/domain/repositories/auth_repository.dart';
import 'package:tabare3/features/auth/domain/usecases/login_with_email_password.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginWithEmailPassword usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = LoginWithEmailPassword(mockRepository);
  });

  const testParams = LoginParams(email: 'test@test.com', password: 'password123');
  const testUser = UserEntity(
    id: '123',
    email: 'test@test.com',
    username: 'testuser',
    fullName: 'Test User',
    bloodType: 'O+',
  );

  test('should return UserEntity when repository returns Right', () async {
    when(() => mockRepository.loginWithEmailPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenAnswer((_) async => const Right(testUser));

    final result = await usecase(testParams);

    expect(result, const Right(testUser));
    verify(() => mockRepository.loginWithEmailPassword(
          email: testParams.email,
          password: testParams.password,
        )).called(1);
  });

  test('should return Failure when repository returns Left', () async {
    const failure = AuthFailure();
    when(() => mockRepository.loginWithEmailPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenAnswer((_) async => const Left(failure));

    final result = await usecase(testParams);

    expect(result, const Left(failure));
  });
}
