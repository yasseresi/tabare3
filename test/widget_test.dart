import 'package:flutter/material.dart';
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
import 'package:tabare3/features/splash/presentation/pages/splash_screen.dart';
import 'package:dartz/dartz.dart';

class MockLoginWithUsernamePassword extends Mock implements LoginWithUsernamePassword {}
class MockSignupWithUsernamePassword extends Mock implements SignupWithUsernamePassword {}
class MockSignOut extends Mock implements SignOut {}
class MockGetCurrentSession extends Mock implements GetCurrentSession {}
class MockUpdateUserRole extends Mock implements UpdateUserRole {}

void main() {
  final sl = GetIt.instance;

  setUpAll(() {
    registerFallbackValue(SignupParams(
      username: 'fallback',
      fullName: 'fallback',
      password: 'fallback',
      phone: '0000',
      dateOfBirth: DateTime(2000),
      gender: 'male',
      bloodType: 'O+',
      city: 'fallback',
    ));
    registerFallbackValue(LoginParams(username: 'fallback', password: 'fallback'));
    registerFallbackValue(NoParams());
    registerFallbackValue(const UpdateRoleParams(isDonor: false, isRecipient: false));
  });

  setUp(() {
    sl.reset();
    sl.registerFactory(() => AuthBloc(
          loginWithUsernamePassword: sl(),
          signupWithUsernamePassword: sl(),
          signOutUseCase: sl(),
          getCurrentSession: sl(),
          updateUserRole: sl(),
        ));
    sl.registerLazySingleton<LoginWithUsernamePassword>(() => MockLoginWithUsernamePassword());
    sl.registerLazySingleton<SignupWithUsernamePassword>(() => MockSignupWithUsernamePassword());
    sl.registerLazySingleton<SignOut>(() => MockSignOut());
    sl.registerLazySingleton<GetCurrentSession>(() => MockGetCurrentSession());
    sl.registerLazySingleton<UpdateUserRole>(() => MockUpdateUserRole());
  });

  testWidgets('SplashScreen renders logo and progress bar', (tester) async {
    when(() => sl<GetCurrentSession>().call(any()))
        .thenAnswer((_) async => const Right(null));

    await tester.pumpWidget(const MaterialApp(home: SplashScreen()));
    await tester.pump();

    expect(find.byType(Image), findsWidgets);
    expect(find.byKey(WidgetKeys.splashProgressBar), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
  });
}
