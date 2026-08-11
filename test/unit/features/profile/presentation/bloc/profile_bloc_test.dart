import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tabare3/core/error/failures.dart';
import 'package:tabare3/core/usecases/usecase.dart';
import 'package:tabare3/features/profile/domain/entities/profile_entity.dart';
import 'package:tabare3/features/profile/domain/usecases/change_role.dart';
import 'package:tabare3/features/profile/domain/usecases/get_cached_profile.dart';
import 'package:tabare3/features/profile/domain/usecases/get_profile.dart';
import 'package:tabare3/features/profile/domain/usecases/update_profile.dart';
import 'package:tabare3/features/profile/domain/usecases/upload_avatar.dart';
import 'package:tabare3/features/profile/presentation/bloc/profile_bloc.dart';

class MockGetProfile extends Mock implements GetProfile {}

class MockGetCachedProfile extends Mock implements GetCachedProfile {}

class MockUpdateProfile extends Mock implements UpdateProfile {}

class MockChangeRole extends Mock implements ChangeRole {}

class MockUploadAvatar extends Mock implements UploadAvatar {}

void main() {
  late MockGetProfile getProfile;
  late MockGetCachedProfile getCachedProfile;
  late MockUpdateProfile updateProfile;
  late MockChangeRole changeRole;
  late MockUploadAvatar uploadAvatar;

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

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(profile);
    registerFallbackValue(
      const ChangeRoleParams(isDonor: false, isRecipient: false),
    );
  });

  setUp(() {
    getProfile = MockGetProfile();
    getCachedProfile = MockGetCachedProfile();
    updateProfile = MockUpdateProfile();
    changeRole = MockChangeRole();
    uploadAvatar = MockUploadAvatar();
    // Default: no cache. Individual tests override for cache-first behavior.
    when(() => getCachedProfile()).thenAnswer((_) async => null);
  });

  ProfileBloc buildBloc() => ProfileBloc(
    getProfile: getProfile,
    getCachedProfile: getCachedProfile,
    updateProfile: updateProfile,
    changeRole: changeRole,
    uploadAvatar: uploadAvatar,
  );

  group('LoadProfile', () {
    blocTest<ProfileBloc, ProfileState>(
      'emits [loading, loaded] when profile is fetched',
      build: () {
        when(
          () => getProfile(any()),
        ).thenAnswer((_) async => const Right(profile));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const LoadProfile()),
      expect: () => const [
        ProfileLoading(),
        ProfileLoaded(profile: profile, isEditing: false),
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits [loading, error] when fetch fails',
      build: () {
        when(
          () => getProfile(any()),
        ).thenAnswer((_) async => const Left(ServerFailure()));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const LoadProfile()),
      expect: () => [const ProfileLoading(), isA<ProfileError>()],
    );

    blocTest<ProfileBloc, ProfileState>(
      'paints cached profile first (no spinner) then the refreshed profile',
      build: () {
        final refreshed = profile.copyWith(fullName: 'Refreshed Name');
        when(() => getCachedProfile()).thenAnswer((_) async => profile);
        when(
          () => getProfile(any()),
        ).thenAnswer((_) async => Right(refreshed));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const LoadProfile()),
      expect: () => [
        const ProfileLoaded(profile: profile, isEditing: false),
        ProfileLoaded(
          profile: profile.copyWith(fullName: 'Refreshed Name'),
          isEditing: false,
        ),
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      'keeps cached profile on-screen when the refresh fails',
      build: () {
        when(() => getCachedProfile()).thenAnswer((_) async => profile);
        when(
          () => getProfile(any()),
        ).thenAnswer((_) async => const Left(ServerFailure()));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const LoadProfile()),
      expect: () => const [ProfileLoaded(profile: profile, isEditing: false)],
    );
  });

  group('ToggleEditMode', () {
    blocTest<ProfileBloc, ProfileState>(
      'toggles isEditing flag',
      build: buildBloc,
      seed: () => const ProfileLoaded(profile: profile, isEditing: false),
      act: (bloc) => bloc.add(const ToggleEditMode()),
      expect: () => const [ProfileLoaded(profile: profile, isEditing: true)],
    );
  });

  group('SaveProfile', () {
    const updatedProfile = ProfileEntity(
      id: 'user-1',
      email: 'test@example.com',
      username: 'testuser',
      fullName: 'Updated Name',
      phone: '0555123456',
      dateOfBirth: '1995-05-12',
      gender: 'male',
      nationalId: '10101010101010101010',
      bloodType: 'O+',
      weight: 85,
      city: 'Algiers',
      chronicDiseases: null,
      avatarUrl: null,
      isDonor: true,
      isRecipient: false,
      isActive: true,
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits [loading, loaded] when save succeeds',
      build: () {
        when(
          () => updateProfile(updatedProfile),
        ).thenAnswer((_) async => const Right(updatedProfile));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const SaveProfile(updatedProfile)),
      expect: () => const [
        ProfileLoading(),
        ProfileLoaded(profile: updatedProfile, isEditing: false),
      ],
    );
  });

  group('ChangeRoleRequested', () {
    blocTest<ProfileBloc, ProfileState>(
      'emits role changed state when role update succeeds',
      build: () {
        const recipientProfile = ProfileEntity(
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
          isDonor: false,
          isRecipient: true,
          isActive: true,
        );
        when(
          () => changeRole(any()),
        ).thenAnswer((_) async => const Right(recipientProfile));
        return buildBloc();
      },
      act: (bloc) => bloc.add(
        const ChangeRoleRequested(isDonor: false, isRecipient: true),
      ),
      expect: () => [const ProfileLoading(), isA<ProfileRoleChanged>()],
    );
  });

  group('AvatarSelected', () {
    blocTest<ProfileBloc, ProfileState>(
      'waits for avatar upload and profile save before emitting the result',
      build: () {
        const avatarUrl = 'https://example.com/avatar.png';
        final updatedProfile = profile.copyWith(avatarUrl: avatarUrl);
        when(
          () => uploadAvatar('/tmp/avatar.png'),
        ).thenAnswer((_) async => const Right(avatarUrl));
        when(
          () => updateProfile(updatedProfile),
        ).thenAnswer((_) async => Right(updatedProfile));
        return buildBloc();
      },
      seed: () => const ProfileLoaded(profile: profile, isEditing: true),
      act: (bloc) => bloc.add(const AvatarSelected('/tmp/avatar.png')),
      expect: () => [
        const ProfileLoaded(
          profile: profile,
          isEditing: true,
          pendingAvatarPath: '/tmp/avatar.png',
        ),
        ProfileLoaded(
          profile: profile.copyWith(
            avatarUrl: 'https://example.com/avatar.png',
          ),
          isEditing: true,
        ),
      ],
      verify: (_) {
        verify(() => uploadAvatar('/tmp/avatar.png')).called(1);
        verify(
          () => updateProfile(
            profile.copyWith(avatarUrl: 'https://example.com/avatar.png'),
          ),
        ).called(1);
      },
    );

    blocTest<ProfileBloc, ProfileState>(
      'keeps the profile with a transient error (no blank page) and does not '
      'save when avatar upload fails',
      build: () {
        when(
          () => uploadAvatar('/tmp/avatar.png'),
        ).thenAnswer((_) async => const Left(ServerFailure()));
        return buildBloc();
      },
      seed: () => const ProfileLoaded(profile: profile, isEditing: false),
      act: (bloc) => bloc.add(const AvatarSelected('/tmp/avatar.png')),
      expect: () => [
        const ProfileLoaded(
          profile: profile,
          isEditing: false,
          pendingAvatarPath: '/tmp/avatar.png',
        ),
        const ProfileLoaded(
          profile: profile,
          isEditing: false,
          pendingAvatarPath: '/tmp/avatar.png',
          actionError: ServerFailure(),
        ),
      ],
      verify: (_) => verifyNever(() => updateProfile(any())),
    );
  });
}
