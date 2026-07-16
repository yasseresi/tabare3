import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import 'package:tabare3/core/usecases/usecase.dart';
import 'package:tabare3/features/auth/domain/repositories/auth_repository.dart';
import 'package:tabare3/features/auth/domain/usecases/get_current_session.dart';
import 'package:tabare3/features/auth/domain/usecases/login_with_email_password.dart';
import 'package:tabare3/features/auth/domain/usecases/sign_out.dart';
import 'package:tabare3/features/auth/domain/usecases/signup_with_email_password.dart';
import 'package:tabare3/features/auth/domain/usecases/update_user_role.dart';
import 'package:tabare3/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:tabare3/features/auth/presentation/pages/welcome_screen.dart';
import 'package:tabare3/features/auth/presentation/pages/login_form_screen.dart';
import 'package:tabare3/features/auth/presentation/pages/signup_screen.dart';

class MockLoginWithEmailPassword extends Mock implements LoginWithEmailPassword {}
class MockSignupWithEmailPassword extends Mock implements SignupWithEmailPassword {}
class MockSignOut extends Mock implements SignOut {}
class MockGetCurrentSession extends Mock implements GetCurrentSession {}
class MockUpdateUserRole extends Mock implements UpdateUserRole {}

void main() {
  final sl = GetIt.instance;

  setUpAll(() {
    registerFallbackValue(SignupParams(
      username: 'fallback',
      fullName: 'fallback',
      email: 'fallback@test.com',
      password: 'fallback',
      phone: '0000',
      dateOfBirth: DateTime(2000),
      gender: 'male',
      bloodType: 'O+',
      city: 'fallback',
    ));
    registerFallbackValue(LoginParams(email: 'fallback', password: 'fallback'));
    registerFallbackValue(NoParams());
    registerFallbackValue(const UpdateRoleParams(isDonor: false, isRecipient: false));
  });

  setUp(() {
    sl.reset();
    sl.registerFactory(() => AuthBloc(
          loginWithEmailPassword: sl(),
          signupWithEmailPassword: sl(),
          signOutUseCase: sl(),
          getCurrentSession: sl(),
          updateUserRole: sl(),
        ));
    sl.registerLazySingleton<LoginWithEmailPassword>(() => MockLoginWithEmailPassword());
    sl.registerLazySingleton<SignupWithEmailPassword>(() => MockSignupWithEmailPassword());
    sl.registerLazySingleton<SignOut>(() => MockSignOut());
    sl.registerLazySingleton<GetCurrentSession>(() => MockGetCurrentSession());
    sl.registerLazySingleton<UpdateUserRole>(() => MockUpdateUserRole());
  });

  testWidgets('WelcomeScreen renders welcome text, logo and both buttons', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: WelcomeScreen()));

    expect(find.textContaining('مرحباً بك في'), findsOneWidget);
    expect(find.text('تسجيل الدخول'), findsOneWidget);
    expect(find.text('إنشاء حساب'), findsOneWidget);
    expect(find.byType(Image), findsWidgets);
  });

  testWidgets('tapping login navigates to LoginFormScreen', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: WelcomeScreen()));

    await tester.tap(find.text('تسجيل الدخول'));
    await tester.pumpAndSettle();

    expect(find.byType(LoginFormScreen), findsOneWidget);
  });

  testWidgets('tapping signup navigates to SignUpScreen', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: WelcomeScreen()));

    await tester.tap(find.text('إنشاء حساب'));
    await tester.pumpAndSettle();

    expect(find.byType(SignUpScreen), findsOneWidget);
  });
}
