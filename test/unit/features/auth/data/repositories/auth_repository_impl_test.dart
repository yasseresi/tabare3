import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:tabare3/core/error/failures.dart';
import 'package:tabare3/core/network/network_info.dart';
import 'package:tabare3/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:tabare3/features/auth/data/models/user_model.dart';
import 'package:tabare3/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:tabare3/features/auth/domain/entities/user_entity.dart';
import 'package:tabare3/features/auth/domain/repositories/auth_repository.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

const testUserModel = UserModel(
  id: 'user-123',
  email: 'test@test.com',
  username: 'testuser',
  fullName: 'Test User',
  bloodType: 'O+',
);

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUpAll(() {
    registerFallbackValue(
      SignupParams(
        username: 'fallback',
        fullName: 'fallback',
        email: 'fallback@test.com',
        password: 'fallback',
        phone: '0000',
        dateOfBirth: DateTime(2000),
        gender: 'male',
        bloodType: 'O+',
        city: 'fallback',
      ),
    );
  });

  setUp(() {
    mockDataSource = MockAuthRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = AuthRepositoryImpl(
      remoteDataSource: mockDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('loginWithEmailPassword', () {
    test('returns Right(UserEntity) on success', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => mockDataSource.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => testUserModel);

      final result = await repository.loginWithEmailPassword(
        email: 'test@test.com',
        password: 'password',
      );

      expect(result.isRight(), isTrue);
      final user = result.fold((l) => null, (r) => r);
      expect(user, isA<UserEntity>());
      expect(user!.email, 'test@test.com');
    });

    test('returns Left(NetworkFailure) when offline', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final result = await repository.loginWithEmailPassword(
        email: 'test@test.com',
        password: 'password',
      );

      expect(result, const Left(NetworkFailure()));
    });

    test('returns Left(Failure) when datasource throws', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => mockDataSource.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(Exception('Auth failed'));

      final result = await repository.loginWithEmailPassword(
        email: 'test@test.com',
        password: 'password',
      );

      expect(result.isLeft(), isTrue);
    });
  });

  group('signupWithEmailPassword', () {
    test('returns Right(UserEntity) on success', () async {
      final params = SignupParams(
        username: 'testuser',
        fullName: 'Test User',
        email: 'test@test.com',
        password: 'password',
        phone: '0555123456',
        dateOfBirth: DateTime(2000, 1, 1),
        gender: 'male',
        bloodType: 'O+',
        city: 'Algiers',
      );

      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => mockDataSource.signUp(params: any(named: 'params')),
      ).thenAnswer((_) async => testUserModel);

      final result = await repository.signupWithEmailPassword(params: params);

      expect(result.isRight(), isTrue);
    });

    test('returns Left(NetworkFailure) when offline', () async {
      final params = SignupParams(
        username: 'testuser',
        fullName: 'Test User',
        email: 'test@test.com',
        password: 'password',
        phone: '0555123456',
        dateOfBirth: DateTime(2000, 1, 1),
        gender: 'male',
        bloodType: 'O+',
        city: 'Algiers',
      );

      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final result = await repository.signupWithEmailPassword(params: params);

      expect(result, const Left(NetworkFailure()));
    });
  });

  group('signOut', () {
    test('returns Right(null) on success', () async {
      when(() => mockDataSource.signOut()).thenAnswer((_) async {});

      final result = await repository.signOut();

      expect(result, const Right(null));
    });

    test('returns Left(Failure) when datasource throws', () async {
      when(() => mockDataSource.signOut()).thenThrow(Exception('fail'));

      final result = await repository.signOut();

      expect(result.isLeft(), isTrue);
    });
  });

  group('getCurrentSession', () {
    test('returns Right(null) when no session', () async {
      when(() => mockDataSource.getCurrentUser()).thenAnswer((_) async => null);

      final result = await repository.getCurrentSession();

      expect(result, const Right(null));
    });

    test('returns Right(UserEntity) when session exists', () async {
      when(
        () => mockDataSource.getCurrentUser(),
      ).thenAnswer((_) async => testUserModel);

      final result = await repository.getCurrentSession();

      expect(result.isRight(), isTrue);
      final user = result.fold((l) => null, (r) => r);
      expect(user, isA<UserEntity>());
    });
  });
}
