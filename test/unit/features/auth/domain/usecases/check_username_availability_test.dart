import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:tabare3/core/error/failures.dart';
import 'package:tabare3/features/auth/domain/repositories/auth_repository.dart';
import 'package:tabare3/features/auth/domain/usecases/check_username_availability.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late CheckUsernameAvailability usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = CheckUsernameAvailability(mockRepository);
  });

  test('returns the repository verdict for a free username', () async {
    when(
      () => mockRepository.isUsernameAvailable(any()),
    ).thenAnswer((_) async => const Right(true));

    final result = await usecase('newuser');

    expect(result, const Right(true));
    verify(() => mockRepository.isUsernameAvailable('newuser')).called(1);
  });

  test('returns the repository verdict for a taken username', () async {
    when(
      () => mockRepository.isUsernameAvailable(any()),
    ).thenAnswer((_) async => const Right(false));

    expect(await usecase('taken'), const Right(false));
  });

  test('passes a failure through for the caller to fail open on', () async {
    const failure = NetworkFailure();
    when(
      () => mockRepository.isUsernameAvailable(any()),
    ).thenAnswer((_) async => const Left(failure));

    expect(await usecase('newuser'), const Left(failure));
  });
}
