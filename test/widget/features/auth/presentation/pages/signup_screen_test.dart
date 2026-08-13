import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import 'package:tabare3/core/usecases/usecase.dart';
import 'package:tabare3/core/utils/values_manager.dart';
import 'package:tabare3/features/auth/domain/repositories/auth_repository.dart';
import 'package:tabare3/features/auth/domain/usecases/check_username_availability.dart';
import 'package:tabare3/features/auth/domain/usecases/get_current_session.dart';
import 'package:tabare3/features/auth/domain/usecases/login_with_email_password.dart';
import 'package:tabare3/features/auth/domain/usecases/sign_out.dart';
import 'package:tabare3/features/auth/domain/usecases/signup_with_email_password.dart';
import 'package:tabare3/features/auth/domain/usecases/update_user_role.dart';
import 'package:tabare3/core/session/session_manager.dart';
import 'package:tabare3/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:tabare3/features/auth/presentation/pages/signup_screen.dart';

import '../../../../../helpers/test_app.dart';

class MockLoginWithUsernamePassword extends Mock
    implements LoginWithUsernamePassword {}

class MockSignupWithUsernamePassword extends Mock
    implements SignupWithUsernamePassword {}

class MockCheckUsernameAvailability extends Mock
    implements CheckUsernameAvailability {}

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
    sl.registerLazySingleton(() => SessionManager());

    sl.registerFactory(
      () => AuthBloc(
        loginWithUsernamePassword: sl(),
        signupWithUsernamePassword: sl(),
        checkUsernameAvailability: sl(),
        signOutUseCase: sl(),
        getCurrentSession: sl(),
        updateUserRole: sl(),
      sessionManager: sl(),
      ),
    );
    sl.registerLazySingleton<LoginWithUsernamePassword>(
      () => MockLoginWithUsernamePassword(),
    );
    sl.registerLazySingleton<SignupWithUsernamePassword>(
      () => MockSignupWithUsernamePassword(),
    );
    sl.registerLazySingleton<CheckUsernameAvailability>(
      () => MockCheckUsernameAvailability(),
    );
    // The username field checks availability on blur, so every step-1 keystroke
    // sequence reaches this use case.
    when(
      () => sl<CheckUsernameAvailability>().call(any()),
    ).thenAnswer((_) async => const Right(true));
    sl.registerLazySingleton<SignOut>(() => MockSignOut());
    sl.registerLazySingleton<GetCurrentSession>(() => MockGetCurrentSession());
    sl.registerLazySingleton<UpdateUserRole>(() => MockUpdateUserRole());
  });

  Widget signUpUnderTest() =>
      BlocProvider(create: (_) => sl<AuthBloc>(), child: const SignUpScreen());

  Future<void> fillStep1(WidgetTester tester) async {
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Test User');
    await tester.enterText(fields.at(1), 'testuser1');
    await tester.enterText(fields.at(2), '0555123456');
    await tester.enterText(fields.at(3), 'Str0ng!Passw0rd');
    await tester.enterText(fields.at(4), 'Str0ng!Passw0rd');
  }

  // Gender is a placeholder dropdown on step 2, so it must be picked before the
  // step can advance; blood type and wilaya are the other required fields.
  Future<void> fillStep2Required(WidgetTester tester) async {
    final scrollable = find.byType(Scrollable).first;

    await tester.scrollUntilVisible(
      find.widgetWithText(DropdownButtonFormField<String>, 'الجنس'),
      400,
      scrollable: scrollable,
    );
    await tester.tap(
      find.widgetWithText(DropdownButtonFormField<String>, 'الجنس'),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('ذكر').last);
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.widgetWithText(DropdownButtonFormField<String>, 'فصيلة الدم'),
      400,
      scrollable: scrollable,
    );
    await tester.tap(
      find.widgetWithText(DropdownButtonFormField<String>, 'فصيلة الدم'),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('O+').last);
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.widgetWithText(TextFormField, 'ابحث عن الولاية...'),
      400,
      scrollable: scrollable,
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'ابحث عن الولاية...'),
      'الجزائر',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('الجزائر').last);
    await tester.pumpAndSettle();
  }

  testWidgets('renders step 1 with account info fields', (tester) async {
    await pumpTestApp(tester, signUpUnderTest());

    final scrollView = tester.widget<SingleChildScrollView>(
      find.byType(SingleChildScrollView),
    );
    expect(
      scrollView.padding,
      const EdgeInsets.symmetric(
        horizontal: AppPadding.p30,
        vertical: AppPadding.p60,
      ),
    );
    expect(find.text('إنشاء حساب'), findsOneWidget);
    expect(find.text('معلومات الحساب'), findsOneWidget);
    expect(find.text('الاسم واللقب'), findsOneWidget);
    expect(find.text('اسم المستخدم'), findsOneWidget);
    expect(find.text('رقم الجوال'), findsOneWidget);
    expect(find.text('التالي'), findsOneWidget);
  });

  testWidgets('advances to step 2 when tapping next', (tester) async {
    await pumpTestApp(tester, signUpUnderTest());

    await fillStep1(tester);

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
    await pumpTestApp(tester, signUpUnderTest());

    await fillStep1(tester);

    await tester.scrollUntilVisible(
      find.text('التالي'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('التالي'));
    await tester.pump();

    await tester.enterText(
      find.widgetWithText(TextFormField, 'تاريخ الميلاد'),
      '2000-01-01',
    );

    await fillStep2Required(tester);

    await tester.scrollUntilVisible(
      find.text('التالي'),
      400,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('التالي'));
    await tester.pump();

    expect(find.text('الشروط والأحكام'), findsOneWidget);
    expect(find.text('أوافق على الشروط والأحكام'), findsOneWidget);
    expect(find.text('إنشاء حساب'), findsWidgets);
  });

  testWidgets('selects wilaya from searchable dropdown in step 2', (
    tester,
  ) async {
    await pumpTestApp(tester, signUpUnderTest());

    await fillStep1(tester);

    await tester.scrollUntilVisible(
      find.text('التالي'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('التالي'));
    await tester.pump();

    await tester.enterText(
      find.widgetWithText(TextFormField, 'تاريخ الميلاد'),
      '2000-01-01',
    );

    await tester.scrollUntilVisible(
      find.widgetWithText(DropdownButtonFormField<String>, 'فصيلة الدم'),
      400,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(
      find.widgetWithText(DropdownButtonFormField<String>, 'فصيلة الدم'),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('O+').last);
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.widgetWithText(TextFormField, 'ابحث عن الولاية...'),
      400,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'ابحث عن الولاية...'),
      'وهر',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('وهران').last);
    await tester.pumpAndSettle();

    expect(find.widgetWithText(TextFormField, 'وهران'), findsOneWidget);
  });
}
