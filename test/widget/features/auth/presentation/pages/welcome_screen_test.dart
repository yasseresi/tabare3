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

import '../../../../../helpers/test_app.dart';

class MockLogin extends Mock implements LoginWithUsernamePassword {}

class MockSignup extends Mock implements SignupWithUsernamePassword {}

class MockSignOut extends Mock implements SignOut {}

class MockSession extends Mock implements GetCurrentSession {}

class MockRole extends Mock implements UpdateUserRole {}

void main() {
  final sl = GetIt.instance;

  setUpAll(() async {
    await setupTestLocalization();
    registerFallbackValue(
      SignupParams(
        username: 'f',
        fullName: 'f',
        password: 'f',
        phone: '0000',
        dateOfBirth: DateTime(2000),
        gender: 'male',
        bloodType: 'O+',
        city: 'f',
      ),
    );
    registerFallbackValue(LoginParams(username: 'f', password: 'f'));
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
    sl.registerLazySingleton<LoginWithUsernamePassword>(() => MockLogin());
    sl.registerLazySingleton<SignupWithUsernamePassword>(() => MockSignup());
    sl.registerLazySingleton<SignOut>(() => MockSignOut());
    sl.registerLazySingleton<GetCurrentSession>(() => MockSession());
    sl.registerLazySingleton<UpdateUserRole>(() => MockRole());
  });

  testWidgets('renders welcome text, logo and both buttons', (tester) async {
    await pumpTestApp(tester, const WelcomeScreen());

    expect(find.text('مرحباً بك في'), findsOneWidget);
    expect(find.text('تسجيل الدخول'), findsOneWidget);
    expect(find.text('إنشاء حساب'), findsOneWidget);
  });

  testWidgets('tapping login navigates to LoginFormScreen', (tester) async {
    await pumpTestApp(tester, const WelcomeScreen());

    await tester.tap(find.text('تسجيل الدخول'));
    await tester.pumpAndSettle();

    expect(find.byType(LoginFormScreen), findsOneWidget);
  });

  testWidgets('tapping signup navigates to SignUpScreen', (tester) async {
    await pumpTestApp(tester, const WelcomeScreen());

    await tester.tap(find.text('إنشاء حساب'));
    await tester.pumpAndSettle();

    expect(find.byType(SignUpScreen), findsOneWidget);
  });
}
