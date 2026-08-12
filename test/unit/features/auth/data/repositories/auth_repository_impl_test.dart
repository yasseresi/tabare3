import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:supabase_flutter/supabase_flutter.dart' show AuthException;
import 'package:tabare3/backend/supabase/supabase_error_mapper.dart';
import 'package:tabare3/core/error/error_handler.dart';
import 'package:tabare3/core/error/failures.dart';
import 'package:tabare3/core/utils/error_messages.dart';
import 'package:tabare3/core/utils/string_manager.dart';
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
  email: 'testuser@tabara3.dz',
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

  group('loginWithUsernamePassword', () {
    test('returns Right(UserEntity) on success', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => mockDataSource.signIn(
          username: any(named: 'username'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => testUserModel);

      final result = await repository.loginWithUsernamePassword(
        username: 'testuser',
        password: 'password',
      );

      expect(result.isRight(), isTrue);
      final user = result.fold((l) => null, (r) => r);
      expect(user, isA<UserEntity>());
      expect(user!.username, 'testuser');
    });

    test('returns Left(NetworkFailure) when offline', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final result = await repository.loginWithUsernamePassword(
        username: 'testuser',
        password: 'password',
      );

      expect(result, const Left(NetworkFailure()));
    });

    test('returns Left(Failure) when datasource throws', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => mockDataSource.signIn(
          username: any(named: 'username'),
          password: any(named: 'password'),
        ),
      ).thenThrow(Exception('Auth failed'));

      final result = await repository.loginWithUsernamePassword(
        username: 'testuser',
        password: 'password',
      );

      expect(result.isLeft(), isTrue);
    });
  });

  group('signupWithUsernamePassword', () {
    test('returns Right(UserEntity) on success', () async {
      final params = SignupParams(
        username: 'testuser',
        fullName: 'Test User',
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

      final result = await repository.signupWithUsernamePassword(
        params: params,
      );

      expect(result.isRight(), isTrue);
    });

    test('returns Left(NetworkFailure) when offline', () async {
      final params = SignupParams(
        username: 'testuser',
        fullName: 'Test User',
        password: 'password',
        phone: '0555123456',
        dateOfBirth: DateTime(2000, 1, 1),
        gender: 'male',
        bloodType: 'O+',
        city: 'Algiers',
      );

      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final result = await repository.signupWithUsernamePassword(
        params: params,
      );

      expect(result, const Left(NetworkFailure()));
    });
  });

  group('sign-in failure disclosure', () {
    // The repository is the seam that tells the mapper which operation is
    // running. With the real Supabase mapper installed, a GoTrue answer that
    // names the missing user has to come out of login as the generic message —
    // and out of signup unchanged.
    setUp(() {
      ErrorHandler.configure(const SupabaseErrorMapper());
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });

    tearDown(ErrorHandler.reset);

    test('login never reports which factor was wrong', () async {
      when(
        () => mockDataSource.signIn(
          username: any(named: 'username'),
          password: any(named: 'password'),
        ),
      ).thenThrow(AuthException('User not found', statusCode: '400'));

      final result = await repository.loginWithUsernamePassword(
        username: 'ghost',
        password: 'password',
      );

      expect(
        result.fold((f) => f.message, (_) => null),
        ErrorMessages.getMessage(AppStrings.invalidLoginCredentials),
      );
    });

    test('signup keeps the actionable "already registered" message', () async {
      when(
        () => mockDataSource.signUp(params: any(named: 'params')),
      ).thenThrow(AuthException('User already registered', statusCode: '400'));

      final result = await repository.signupWithUsernamePassword(
        params: SignupParams(
          username: 'taken',
          fullName: 'Test User',
          password: 'password',
          phone: '0555123456',
          dateOfBirth: DateTime(2000, 1, 1),
          gender: 'male',
          bloodType: 'O+',
          city: 'Algiers',
        ),
      );

      expect(
        result.fold((f) => f.message, (_) => null),
        ErrorMessages.getMessage(AppStrings.userAlreadyRegistered),
      );
    });
  });

  group('isUsernameAvailable', () {
    test('passes the datasource verdict through', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => mockDataSource.isUsernameAvailable('taken'),
      ).thenAnswer((_) async => false);

      final result = await repository.isUsernameAvailable('taken');

      expect(result, const Right(false));
    });

    test('returns Left(NetworkFailure) when offline', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final result = await repository.isUsernameAvailable('testuser');

      expect(result, const Left(NetworkFailure()));
      verifyNever(() => mockDataSource.isUsernameAvailable(any()));
    });

    test('returns Left(Failure) when the RPC throws', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => mockDataSource.isUsernameAvailable(any()),
      ).thenThrow(Exception('rpc missing'));

      final result = await repository.isUsernameAvailable('testuser');

      expect(result.isLeft(), isTrue);
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
