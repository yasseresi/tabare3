import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tabare3/core/error/failures.dart';
import 'package:tabare3/features/profile/data/datasources/profile_local_data_source.dart';
import 'package:tabare3/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:tabare3/features/profile/data/models/profile_model.dart';
import 'package:tabare3/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:tabare3/features/profile/domain/entities/profile_entity.dart';

class MockProfileRemoteDataSource extends Mock
    implements ProfileRemoteDataSource {}

class MockProfileLocalDataSource extends Mock
    implements ProfileLocalDataSource {}

void main() {
  late MockProfileRemoteDataSource remoteDataSource;
  late MockProfileLocalDataSource localDataSource;
  late ProfileRepositoryImpl repository;

  const profileModel = ProfileModel(
    id: 'user-1',
    email: 'test@example.com',
    username: 'testuser',
    fullName: 'Ahmed Test',
    phone: '0555123456',
    dateOfBirth: '1995-05-12',
    gender: 'male',
    nationalId: '10101010101010101010',
    bloodType: 'O+',
    weight: 80,
    city: 'Algiers',
    chronicDiseases: null,
    avatarUrl: null,
    isDonor: true,
    isRecipient: false,
    isActive: true,
  );

  const profileEntity = ProfileEntity(
    id: 'user-1',
    email: 'test@example.com',
    username: 'testuser',
    fullName: 'Ahmed Test',
    phone: '0555123456',
    dateOfBirth: '1995-05-12',
    gender: 'male',
    nationalId: '10101010101010101010',
    bloodType: 'O+',
    weight: 80,
    city: 'Algiers',
    chronicDiseases: null,
    avatarUrl: null,
    isDonor: true,
    isRecipient: false,
    isActive: true,
  );

  setUp(() {
    remoteDataSource = MockProfileRemoteDataSource();
    localDataSource = MockProfileLocalDataSource();
    repository = ProfileRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
    );
  });

  group('getProfile', () {
    test('should return cached profile when remote fails', () async {
      when(
        () => localDataSource.getLastProfile(),
      ).thenAnswer((_) async => profileModel);
      when(
        () => remoteDataSource.getProfile(),
      ).thenThrow(Exception('network error'));

      final result = await repository.getProfile();

      expect(result, equals(const Right(profileEntity)));
      verify(() => localDataSource.getLastProfile()).called(1);
      verify(() => remoteDataSource.getProfile()).called(1);
    });

    test('should fetch from remote and cache when remote succeeds', () async {
      when(
        () => localDataSource.getLastProfile(),
      ).thenAnswer((_) async => null);
      when(
        () => remoteDataSource.getProfile(),
      ).thenAnswer((_) async => profileModel);
      when(
        () => localDataSource.cacheProfile(profileModel),
      ).thenAnswer((_) async {});

      final result = await repository.getProfile();

      expect(result, equals(const Right(profileEntity)));
      verify(() => localDataSource.cacheProfile(profileModel)).called(1);
    });

    test('should return failure when no cache and remote fails', () async {
      when(
        () => localDataSource.getLastProfile(),
      ).thenAnswer((_) async => null);
      when(
        () => remoteDataSource.getProfile(),
      ).thenThrow(Exception('network error'));

      final result = await repository.getProfile();

      expect(result, isA<Left<Failure, ProfileEntity>>());
      expect((result as Left).value, isA<ServerFailure>());
    });
  });

  group('updateProfile', () {
    test('should update profile and cache result', () async {
      when(
        () => remoteDataSource.updateProfile(profileModel),
      ).thenAnswer((_) async => profileModel);
      when(
        () => localDataSource.cacheProfile(profileModel),
      ).thenAnswer((_) async {});

      final result = await repository.updateProfile(profileEntity);

      expect(result, equals(const Right(profileEntity)));
      verify(() => remoteDataSource.updateProfile(profileModel)).called(1);
      verify(() => localDataSource.cacheProfile(profileModel)).called(1);
    });

    test('should return failure when update fails', () async {
      when(
        () => remoteDataSource.updateProfile(profileModel),
      ).thenThrow(Exception('server error'));

      final result = await repository.updateProfile(profileEntity);

      expect(result, isA<Left<Failure, ProfileEntity>>());
      expect((result as Left).value, isA<ServerFailure>());
    });
  });

  group('changeRole', () {
    test('should change role and cache result', () async {
      when(
        () => remoteDataSource.changeRole(isDonor: false, isRecipient: true),
      ).thenAnswer((_) async => profileModel);
      when(
        () => localDataSource.cacheProfile(profileModel),
      ).thenAnswer((_) async {});

      final result = await repository.changeRole(
        isDonor: false,
        isRecipient: true,
      );

      expect(result, equals(const Right(profileEntity)));
    });
  });

  group('uploadAvatar', () {
    test('should upload avatar and return public URL', () async {
      when(
        () => remoteDataSource.uploadAvatar('/path/to/photo.jpg'),
      ).thenAnswer((_) async => 'https://example.com/avatar.png');

      final result = await repository.uploadAvatar('/path/to/photo.jpg');

      expect(result, equals(const Right('https://example.com/avatar.png')));
    });
  });
}
