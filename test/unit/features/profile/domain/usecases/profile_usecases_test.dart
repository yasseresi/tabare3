import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tabare3/core/error/failures.dart';
import 'package:tabare3/core/usecases/usecase.dart';
import 'package:tabare3/features/profile/domain/entities/profile_entity.dart';
import 'package:tabare3/features/profile/domain/repositories/profile_repository.dart';
import 'package:tabare3/features/profile/domain/usecases/change_role.dart';
import 'package:tabare3/features/profile/domain/usecases/get_profile.dart';
import 'package:tabare3/features/profile/domain/usecases/set_account_status.dart';
import 'package:tabare3/features/profile/domain/usecases/update_profile.dart';
import 'package:tabare3/features/profile/domain/usecases/upload_avatar.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late MockProfileRepository repository;
  const profile = ProfileEntity(
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
    repository = MockProfileRepository();
  });

  group('GetProfile', () {
    test('should return profile from repository', () async {
      final usecase = GetProfile(repository);
      when(
        () => repository.getProfile(),
      ).thenAnswer((_) async => const Right(profile));

      final result = await usecase(NoParams());

      expect(result, equals(const Right<Failure, ProfileEntity>(profile)));
      verify(() => repository.getProfile()).called(1);
    });
  });

  group('UpdateProfile', () {
    test('should update profile through repository', () async {
      final usecase = UpdateProfile(repository);
      when(
        () => repository.updateProfile(profile),
      ).thenAnswer((_) async => const Right(profile));

      final result = await usecase(profile);

      expect(result, equals(const Right<Failure, ProfileEntity>(profile)));
      verify(() => repository.updateProfile(profile)).called(1);
    });
  });

  group('ChangeRole', () {
    test('should switch to recipient role', () async {
      final usecase = ChangeRole(repository);
      const params = ChangeRoleParams(isDonor: false, isRecipient: true);
      when(
        () => repository.changeRole(
          isDonor: params.isDonor,
          isRecipient: params.isRecipient,
        ),
      ).thenAnswer((_) async => const Right(profile));

      final result = await usecase(params);

      expect(result, equals(const Right<Failure, ProfileEntity>(profile)));
    });
  });

  group('SetAccountStatus', () {
    test('should persist account status through repository', () async {
      final usecase = SetAccountStatus(repository);
      when(
        () => repository.setAccountStatus(false),
      ).thenAnswer((_) async => const Right(profile));

      final result = await usecase(false);

      expect(result, equals(const Right<Failure, ProfileEntity>(profile)));
      verify(() => repository.setAccountStatus(false)).called(1);
    });
  });

  group('UploadAvatar', () {
    test('should upload avatar and return URL', () async {
      final usecase = UploadAvatar(repository);
      const path = '/path/to/photo.jpg';
      when(
        () => repository.uploadAvatar(path),
      ).thenAnswer((_) async => const Right('https://example.com/avatar.png'));

      final result = await usecase(path);

      expect(
        result,
        equals(const Right<Failure, String>('https://example.com/avatar.png')),
      );
    });
  });
}
