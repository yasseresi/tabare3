import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import 'package:tabare3/core/constants/widget_keys.dart';
import 'package:tabare3/core/usecases/usecase.dart';
import 'package:tabare3/features/auth/domain/repositories/auth_repository.dart';
import 'package:tabare3/features/auth/domain/usecases/get_current_session.dart';
import 'package:tabare3/features/auth/domain/usecases/login_with_email_password.dart';
import 'package:tabare3/features/auth/domain/usecases/sign_out.dart';
import 'package:tabare3/features/auth/domain/usecases/signup_with_email_password.dart';
import 'package:tabare3/features/auth/domain/usecases/update_user_role.dart';
import 'package:tabare3/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:tabare3/features/auth/presentation/pages/login_form_screen.dart';
import 'package:tabare3/features/auth/presentation/pages/signup_screen.dart';

import '../../../../../helpers/test_app.dart';

class MockLoginWithUsernamePassword extends Mock
    implements LoginWithUsernamePassword {}

class MockSignupWithUsernamePassword extends Mock
    implements SignupWithUsernamePassword {}

class MockSignOut extends Mock implements SignOut {}

class MockGetCurrentSession extends Mock implements GetCurrentSession {}

class MockUpdateUserRole extends Mock implements UpdateUserRole {}

void main() {
  final sl = GetIt.instance;

  setUpAll(() async {
    await setupTestLocalization();
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
    registerFallbackValue(
      LoginParams(username: 'fallback', password: 'fallback'),
    );
    registerFallbackValue(NoParams());
    registerFallbackValue(
      const UpdateRoleParams(isDonor: false, isRecipient: false),
    );
  });

  setUp(() {
    sl.reset();
    sl.registerFactory(
      () => AuthBloc(
        loginWithUsernamePassword: sl(),
        signupWithUsernamePassword: sl(),
        signOutUseCase: sl(),
        getCurrentSession: sl(),
        updateUserRole: sl(),
      ),
    );
    sl.registerLazySingleton<LoginWithUsernamePassword>(
      () => MockLoginWithUsernamePassword(),
    );
    sl.registerLazySingleton<SignupWithUsernamePassword>(
      () => MockSignupWithUsernamePassword(),
    );
    sl.registerLazySingleton<SignOut>(() => MockSignOut());
    sl.registerLazySingleton<GetCurrentSession>(() => MockGetCurrentSession());
    sl.registerLazySingleton<UpdateUserRole>(() => MockUpdateUserRole());
  });

  Future<void> pumpScreen(WidgetTester tester) async {
    await pumpTestApp(tester, const LoginFormScreen());
  }

  testWidgets('renders logo, title, form fields and login button', (
    tester,
  ) async {
    await pumpScreen(tester);

    expect(find.text('تسجيل الدخول'), findsWidgets);
    expect(find.text('اسم المستخدم'), findsOneWidget);
    expect(find.text('إنشاء حساب'), findsOneWidget);
    expect(find.byType(SvgPicture), findsWidgets);
  });

  testWidgets('uses the Figma login screen content inset', (tester) async {
    await pumpScreen(tester);

    // The page itself is inset 10px; the design puts the 32px gutter on the
    // form's content area rather than the whole screen.
    final scrollView = tester.widget<SingleChildScrollView>(
      find.byType(SingleChildScrollView),
    );
    expect(
      scrollView.padding,
      const EdgeInsets.symmetric(horizontal: 10, vertical: 32),
    );

    final contentArea = tester.widget<Padding>(
      find.byKey(WidgetKeys.loginContentArea),
    );
    expect(contentArea.padding, const EdgeInsets.symmetric(horizontal: 32));
  });

  testWidgets('tapping signup link navigates to SignUpScreen', (tester) async {
    await pumpScreen(tester);

    await tester.scrollUntilVisible(
      find.text('إنشاء حساب').last,
      100,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('إنشاء حساب').last);
    await tester.pumpAndSettle();

    expect(find.byType(SignUpScreen), findsOneWidget);
  });
}
