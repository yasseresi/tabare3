import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:tabare3/core/error/failures.dart';
import 'package:tabare3/core/usecases/usecase.dart';
import 'package:tabare3/features/auth/domain/repositories/auth_repository.dart';
import 'package:tabare3/features/auth/domain/usecases/sign_out.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late SignOut usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = SignOut(mockRepository);
  });

  test('should return Right(void) when repository succeeds', () async {
    when(
      () => mockRepository.signOut(),
    ).thenAnswer((_) async => const Right(null));

    final result = await usecase(NoParams());

    expect(result, const Right(null));
    verify(() => mockRepository.signOut()).called(1);
  });

  test('should return Failure when repository fails', () async {
    const failure = AuthFailure();
    when(
      () => mockRepository.signOut(),
    ).thenAnswer((_) async => const Left(failure));

    final result = await usecase(NoParams());

    expect(result, const Left(failure));
  });
}
