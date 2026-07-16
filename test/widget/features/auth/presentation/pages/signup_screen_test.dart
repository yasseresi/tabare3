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
import 'package:tabare3/features/auth/presentation/pages/signup_screen.dart';

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

  testWidgets('renders step 1 with account info fields', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SignUpScreen()));
    await tester.pump();

    expect(find.text('إنشاء حساب'), findsOneWidget);
    expect(find.text('معلومات الحساب'), findsOneWidget);
    expect(find.text('الاسم الكامل'), findsOneWidget);
    expect(find.text('اسم المستخدم'), findsOneWidget);
    expect(find.text('رقم الجوال'), findsOneWidget);
    expect(find.text('التالي'), findsOneWidget);
  });

  testWidgets('advances to step 2 when tapping next', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SignUpScreen()));
    await tester.pump();

    await tester.scrollUntilVisible(
      find.text('التالي'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('التالي'));
    await tester.pump();

    expect(find.text('المعلومات الشخصية'), findsOneWidget);
    expect(find.text('تاريخ الميلاد'), findsOneWidget);
    expect(find.text('فصيلة الدم'), findsOneWidget);
    expect(find.text('الوزن'), findsOneWidget);
  });

  testWidgets('advances to step 3 and shows terms', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SignUpScreen()));
    await tester.pump();

    await tester.scrollUntilVisible(
      find.text('التالي'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('التالي'));
    await tester.pump();
    await tester.scrollUntilVisible(
      find.text('التالي'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('التالي'));
    await tester.pump();

    expect(find.text('الشروط والأحكام'), findsOneWidget);
    expect(find.text('أوافق على الشروط والأحكام'), findsOneWidget);
    expect(find.text('إنشاء حساب'), findsWidgets);
  });
}
