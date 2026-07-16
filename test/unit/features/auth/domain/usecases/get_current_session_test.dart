import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:tabare3/core/error/failures.dart';
import 'package:tabare3/core/usecases/usecase.dart';
import 'package:tabare3/features/auth/domain/entities/user_entity.dart';
import 'package:tabare3/features/auth/domain/repositories/auth_repository.dart';
import 'package:tabare3/features/auth/domain/usecases/get_current_session.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late GetCurrentSession usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = GetCurrentSession(mockRepository);
  });

  const testUser = UserEntity(
    id: '123',
    email: 'test@test.com',
    username: 'testuser',
    fullName: 'Test User',
    bloodType: 'O+',
    isDonor: true,
  );

  test('should return UserEntity when session exists', () async {
    when(() => mockRepository.getCurrentSession())
        .thenAnswer((_) async => const Right(testUser));

    final result = await usecase(NoParams());

    expect(result, const Right(testUser));
  });

  test('should return null when no session', () async {
    when(() => mockRepository.getCurrentSession())
        .thenAnswer((_) async => const Right(null));

    final result = await usecase(NoParams());

    expect(result, const Right(null));
  });

  test('should return Failure on error', () async {
    const failure = AuthFailure();
    when(() => mockRepository.getCurrentSession())
        .thenAnswer((_) async => const Left(failure));

    final result = await usecase(NoParams());

    expect(result, const Left(failure));
  });
}
