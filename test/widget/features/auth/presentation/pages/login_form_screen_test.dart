import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:tabare3/core/error/failures.dart';
import 'package:tabare3/core/usecases/usecase.dart';
import 'package:tabare3/core/network/network_info.dart';
import 'package:tabare3/features/auth/domain/entities/user_entity.dart';
import 'package:tabare3/features/auth/domain/repositories/auth_repository.dart';
import 'package:tabare3/features/auth/domain/usecases/get_current_session.dart';
import 'package:tabare3/features/auth/domain/usecases/login_with_email_password.dart';
import 'package:tabare3/features/auth/domain/usecases/sign_out.dart';
import 'package:tabare3/features/auth/domain/usecases/signup_with_email_password.dart';
import 'package:tabare3/features/auth/domain/usecases/update_user_role.dart';
import 'package:tabare3/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:tabare3/features/auth/presentation/pages/login_form_screen.dart';
import 'package:tabare3/features/auth/presentation/pages/signup_screen.dart';
import 'package:get_it/get_it.dart';
import 'package:dartz/dartz.dart';

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

  Future<void> pumpScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LoginFormScreen(),
      ),
    );
    await tester.pump();
  }

  testWidgets('renders logo, title, form fields and login button', (tester) async {
    await pumpScreen(tester);

    expect(find.text('تسجيل الدخول'), findsWidgets);
    expect(find.text('اسم المستخدم'), findsOneWidget);
    expect(find.text('تذكرني في المرة القادمة'), findsOneWidget);
    expect(find.text('إنشاء حساب'), findsOneWidget);
    expect(find.byIcon(Icons.lock_outline), findsOneWidget);
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
