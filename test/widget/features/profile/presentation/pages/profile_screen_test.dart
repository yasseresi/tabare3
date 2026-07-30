import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:tabare3/features/profile/presentation/pages/profile_screen.dart';
import 'package:tabare3/features/profile/presentation/pages/requester_profile_screen.dart';

import '../../../../../helpers/test_app.dart';

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
    fullName: 'أحمد اختبار',
    phone: '0555123456',
    dateOfBirth: '1995-05-12',
    gender: 'male',
    nationalId: '10101010101010101010',
    bloodType: 'O+',
    city: 'الجزائر',
    isDonor: true,
    isRecipient: false,
    isActive: true,
    avatarUrl: null,
    chronicDiseases: null,
  );

  setUpAll(() async {
    await setupTestLocalization();
    registerFallbackValue(NoParams());
    registerFallbackValue(profile);
    registerFallbackValue(
      const ChangeRoleParams(isDonor: false, isRecipient: true),
    );
    registerFallbackValue('x.png');
  });

  setUp(() {
    getProfile = MockGetProfile();
    updateProfile = MockUpdateProfile();
    changeRole = MockChangeRole();
    uploadAvatar = MockUploadAvatar();

    when(
      () => getProfile.call(any()),
    ).thenAnswer((_) async => const Right(profile));
    when(
      () => updateProfile.call(any()),
    ).thenAnswer((_) async => const Right(profile));
    when(
      () => changeRole.call(any()),
    ).thenAnswer((_) async => const Right(profile));
    when(
      () => uploadAvatar.call(any()),
    ).thenAnswer((_) async => const Right('https://example.com/avatar.png'));
  });

  ProfileBloc buildProfileBloc() {
    return ProfileBloc(
      getProfile: getProfile,
      updateProfile: updateProfile,
      changeRole: changeRole,
      uploadAvatar: uploadAvatar,
    )..add(LoadProfile());
  }

  group('ProfileScreen', () {
    testWidgets('renders profile fields when loaded', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          BlocProvider(
            create: (_) => buildProfileBloc(),
            child: const ProfileScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('أحمد اختبار'), findsOneWidget);
      expect(find.text('test@example.com'), findsOneWidget);
      expect(find.text('مرحباً، أحمد'), findsOneWidget);
      expect(find.text('البيانات الشخصية'), findsOneWidget);
      expect(find.text('معلومات الحساب'), findsOneWidget);
    });

    testWidgets(
      'receiver profile uses the shared profile details without a donor card',
      (tester) async {
        final recipientProfile = profile.copyWith(
          isDonor: false,
          isRecipient: true,
        );
        when(
          () => getProfile.call(any()),
        ).thenAnswer((_) async => Right(recipientProfile));

        await tester.pumpWidget(
          buildTestApp(
            BlocProvider(
              create: (_) => buildProfileBloc(),
              child: const RequesterProfileScreen(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('أحمد اختبار'), findsOneWidget);
        expect(find.text('test@example.com'), findsOneWidget);
        expect(find.text('معلومات الحساب'), findsOneWidget);
        expect(find.text('البيانات الشخصية'), findsOneWidget);
        expect(find.text('بطاقة المتبرع'), findsNothing);
      },
    );

    testWidgets('tapping edit button shows save changes button', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          BlocProvider(
            create: (_) => buildProfileBloc(),
            child: const ProfileScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('تعديل'));
      await tester.pumpAndSettle();

      expect(find.text('حفظ التعديلات'), findsOneWidget);
    });

    testWidgets('tapping save changes dispatches SaveProfile', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          BlocProvider(
            create: (_) => buildProfileBloc(),
            child: const ProfileScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('تعديل'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('حفظ التعديلات'));
      await tester.pumpAndSettle();

      verify(() => updateProfile.call(any())).called(1);
    });

    testWidgets('shows error message on error state', (tester) async {
      when(
        () => getProfile.call(any()),
      ).thenAnswer((_) async => const Left(ServerFailure(0, 'fail')));

      await tester.pumpWidget(
        buildTestApp(
          BlocProvider(
            create: (_) => buildProfileBloc(),
            child: const ProfileScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('fail'), findsOneWidget);
    });
  });
}
