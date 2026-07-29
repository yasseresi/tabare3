import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tabare3/core/error/failures.dart';
import 'package:tabare3/core/usecases/usecase.dart';
import 'package:tabare3/features/profile/domain/entities/profile_entity.dart';
import 'package:tabare3/features/profile/domain/usecases/change_role.dart';
import 'package:tabare3/features/profile/domain/usecases/get_profile.dart';
import 'package:tabare3/features/profile/domain/usecases/update_profile.dart';
import 'package:tabare3/features/profile/domain/usecases/upload_avatar.dart';
import 'package:tabare3/features/profile/presentation/bloc/profile_bloc.dart';

class MockGetProfile extends Mock implements GetProfile {}

class MockUpdateProfile extends Mock implements UpdateProfile {}

class MockChangeRole extends Mock implements ChangeRole {}

class MockUploadAvatar extends Mock implements UploadAvatar {}

void main() {
  late MockGetProfile getProfile;
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
    registerFallbackValue(
      const ChangeRoleParams(isDonor: false, isRecipient: false),
    );
  });

  setUp(() {
    getProfile = MockGetProfile();
    updateProfile = MockUpdateProfile();
    changeRole = MockChangeRole();
    uploadAvatar = MockUploadAvatar();
  });

  ProfileBloc buildBloc() => ProfileBloc(
    getProfile: getProfile,
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
}
