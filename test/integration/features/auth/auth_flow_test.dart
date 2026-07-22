import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import 'package:tabare3/core/network/network_info.dart';
import 'package:tabare3/core/usecases/usecase.dart';
import 'package:tabare3/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:tabare3/features/auth/data/models/user_model.dart';
import 'package:tabare3/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:tabare3/features/auth/domain/repositories/auth_repository.dart';
import 'package:tabare3/features/auth/domain/usecases/get_current_session.dart';
import 'package:tabare3/features/auth/domain/usecases/login_with_email_password.dart';
import 'package:tabare3/features/auth/domain/usecases/sign_out.dart';
import 'package:tabare3/features/auth/domain/usecases/signup_with_email_password.dart';
import 'package:tabare3/features/auth/domain/usecases/update_user_role.dart';
import 'package:tabare3/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:tabare3/features/auth/presentation/pages/login_form_screen.dart';
import 'package:tabare3/features/auth/presentation/pages/role_selection_screen.dart';
import 'package:tabare3/features/auth/presentation/pages/signup_screen.dart';
import 'package:tabare3/features/auth/presentation/pages/welcome_screen.dart';
import 'package:tabare3/features/counter/data/datasources/counter_local_data_source.dart';
import 'package:tabare3/features/counter/data/repositories/counter_repository_impl.dart';
import 'package:tabare3/features/counter/domain/repositories/counter_repository.dart';
import 'package:tabare3/features/counter/domain/usecases/get_counter.dart';
import 'package:tabare3/features/counter/domain/usecases/increment_counter.dart';
import 'package:tabare3/features/counter/presentation/bloc/counter_bloc.dart';
import 'package:tabare3/features/donor_home/presentation/pages/donor_home_screen.dart';
import 'package:tabare3/features/requester_home/presentation/pages/requester_home_screen.dart';
import 'package:tabare3/features/splash/presentation/pages/splash_screen.dart';
import 'package:tabare3/main.dart';

import '../../../helpers/test_app.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

const testDonorModel = UserModel(
  id: 'user-123',
  email: 'testuser@tabara3.dz',
  username: 'testuser',
  fullName: 'Test User',
  bloodType: 'O+',
  isDonor: true,
);

const testRecipientModel = UserModel(
  id: 'user-123',
  email: 'testuser@tabara3.dz',
  username: 'testuser',
  fullName: 'Test User',
  bloodType: 'O+',
  isDonor: false,
  isRecipient: true,
);

const testUserModel = UserModel(
  id: 'user-123',
  email: 'testuser@tabara3.dz',
  username: 'testuser',
  fullName: 'Test User',
  bloodType: 'O+',
);

void registerAllDependencies({
  required MockAuthRemoteDataSource mockDataSource,
  required MockNetworkInfo mockNetworkInfo,
}) {
  final sl = GetIt.instance;

  sl.registerLazySingleton<AuthRemoteDataSource>(() => mockDataSource);
  sl.registerLazySingleton<NetworkInfo>(() => mockNetworkInfo);

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  sl.registerLazySingleton(() => LoginWithUsernamePassword(sl()));
  sl.registerLazySingleton(() => SignupWithUsernamePassword(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));
  sl.registerLazySingleton(() => GetCurrentSession(sl()));
  sl.registerLazySingleton(() => UpdateUserRole(sl()));

  sl.registerFactory(
    () => AuthBloc(
      loginWithUsernamePassword: sl(),
      signupWithUsernamePassword: sl(),
      signOutUseCase: sl(),
      getCurrentSession: sl(),
      updateUserRole: sl(),
    ),
  );

  sl.registerLazySingleton<CounterLocalDataSource>(
    () => CounterLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<CounterRepository>(
    () => CounterRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetCounter(sl()));
  sl.registerLazySingleton(() => IncrementCounter(sl()));
  sl.registerFactory(
    () => CounterBloc(getCounter: sl(), incrementCounter: sl()),
  );
}

void main() {
  final sl = GetIt.instance;
  late MockAuthRemoteDataSource mockDataSource;
  late MockNetworkInfo mockNetworkInfo;

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
    registerFallbackValue(LoginParams(username: 'fallback', password: 'fallback'));
    registerFallbackValue(NoParams());
    registerFallbackValue(
      const UpdateRoleParams(isDonor: false, isRecipient: false),
    );
  });

  setUp(() {
    sl.reset();
    mockDataSource = MockAuthRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    registerAllDependencies(
      mockDataSource: mockDataSource,
      mockNetworkInfo: mockNetworkInfo,
    );
  });

  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(wrapWithLocalization(const MyApp()));
    await tester.pump();
  }

  group('Auth Flow Integration', () {
    group('Login Path', () {
      testWidgets('completes full login flow to donor home', (tester) async {
        when(
          () => mockDataSource.getCurrentUser(),
        ).thenAnswer((_) async => null);

        await pumpApp(tester);

        expect(find.byType(SplashScreen), findsOneWidget);

        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle();

        expect(find.byType(WelcomeScreen), findsOneWidget);

        when(
          () => mockDataSource.signIn(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => testUserModel);

        await tester.tap(find.text('تسجيل الدخول'));
        await tester.pumpAndSettle();

        expect(find.byType(LoginFormScreen), findsOneWidget);

        final emailFields = find.byType(TextFormField);
        await tester.enterText(emailFields.at(0), 'test@test.com');
        await tester.enterText(emailFields.at(1), 'password123');

        await tester.ensureVisible(find.text('تسجيل الدخول').last);
        await tester.pumpAndSettle();
        await tester.tap(find.text('تسجيل الدخول').last);
        await tester.pumpAndSettle();

        expect(find.byType(Dialog), findsOneWidget);

        when(
          () => mockDataSource.getCurrentUser(),
        ).thenAnswer((_) async => testUserModel);

        await tester.tap(find.text('الصفحة الرئيسية'));
        await tester.pumpAndSettle();

        expect(find.byType(RoleSelectionScreen), findsOneWidget);

        when(
          () => mockDataSource.updateUserRole(
            isDonor: any(named: 'isDonor'),
            isRecipient: any(named: 'isRecipient'),
          ),
        ).thenAnswer((_) async => testDonorModel);

        await tester.tap(find.text('أنا متبرع'));
        await tester.pumpAndSettle();

        expect(find.byType(DonorHomeScreen), findsOneWidget);
      });

      testWidgets('completes full login flow to requester home', (
        tester,
      ) async {
        when(
          () => mockDataSource.getCurrentUser(),
        ).thenAnswer((_) async => null);

        await pumpApp(tester);
        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle();

        when(
          () => mockDataSource.signIn(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => testUserModel);

        await tester.tap(find.text('تسجيل الدخول'));
        await tester.pumpAndSettle();

        final emailFields = find.byType(TextFormField);
        await tester.enterText(emailFields.at(0), 'test@test.com');
        await tester.enterText(emailFields.at(1), 'password123');

        await tester.ensureVisible(find.text('تسجيل الدخول').last);
        await tester.pumpAndSettle();
        await tester.tap(find.text('تسجيل الدخول').last);
        await tester.pumpAndSettle();

        when(
          () => mockDataSource.getCurrentUser(),
        ).thenAnswer((_) async => testUserModel);

        await tester.tap(find.text('الصفحة الرئيسية'));
        await tester.pumpAndSettle();

        when(
          () => mockDataSource.updateUserRole(
            isDonor: any(named: 'isDonor'),
            isRecipient: any(named: 'isRecipient'),
          ),
        ).thenAnswer((_) async {
          final updatedModel = UserModel(
            id: 'user-123',
            username: 'testuser',
            fullName: 'Test User',
            bloodType: 'O+',
            isDonor: false,
            isRecipient: true,
          );
          return updatedModel;
        });

        await tester.tap(find.text('أحتاج دم'));
        await tester.pumpAndSettle();

        expect(find.byType(Dialog), findsOneWidget);

        await tester.tap(find.text('تأكيد'));
        await tester.pumpAndSettle();

        expect(find.byType(RequesterHomeScreen), findsOneWidget);
      });

      testWidgets('shows error on invalid login credentials', (tester) async {
        when(
          () => mockDataSource.getCurrentUser(),
        ).thenAnswer((_) async => null);

        await pumpApp(tester);
        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle();

        when(
          () => mockDataSource.signIn(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ).thenThrow(Exception('Invalid credentials'));

        await tester.tap(find.text('تسجيل الدخول'));
        await tester.pumpAndSettle();

        final emailFields = find.byType(TextFormField);
        await tester.enterText(emailFields.at(0), 'wrong@test.com');
        await tester.enterText(emailFields.at(1), 'wrongpassword');

        await tester.ensureVisible(find.text('تسجيل الدخول').last);
        await tester.pumpAndSettle();
        await tester.tap(find.text('تسجيل الدخول').last);
        await tester.pumpAndSettle();

        expect(find.byType(Dialog), findsOneWidget);
        expect(find.byIcon(Icons.close), findsOneWidget);
      });
    });

    group('Signup Path', () {
      testWidgets('completes signup form through all 3 steps', (tester) async {
        when(
          () => mockDataSource.getCurrentUser(),
        ).thenAnswer((_) async => null);

        await pumpApp(tester);
        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle();

        expect(find.byType(WelcomeScreen), findsOneWidget);

        await tester.tap(find.text('إنشاء حساب'));
        await tester.pumpAndSettle();

        expect(find.byType(SignUpScreen), findsOneWidget);

        expect(find.text('معلومات الحساب'), findsOneWidget);

        final step1Fields = find.byType(TextFormField);
        await tester.enterText(step1Fields.at(0), 'Test User');
        await tester.enterText(step1Fields.at(1), 'testuser1');
        await tester.enterText(step1Fields.at(2), '0555123456');
        await tester.enterText(step1Fields.at(3), 'password123');
        await tester.enterText(step1Fields.at(4), 'password123');

        await tester.ensureVisible(
          find.widgetWithText(ElevatedButton, 'التالي'),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(ElevatedButton, 'التالي'));
        await tester.pumpAndSettle();

        expect(find.text('البيانات الشخصية'), findsOneWidget);

        await tester.enterText(
            find.widgetWithText(TextFormField, 'تاريخ الميلاد'), '1990-01-01');

        final bloodTypeDropdown =
            find.widgetWithText(DropdownButtonFormField<String>, 'فصيلة الدم');
        await tester.tap(bloodTypeDropdown);
        await tester.pumpAndSettle();
        await tester.tap(find.text('O+').last);
        await tester.pumpAndSettle();

        await tester.enterText(
            find.widgetWithText(TextFormField, 'ابحث عن الولاية...'),
            'الجزائر');

        await tester.ensureVisible(
          find.widgetWithText(ElevatedButton, 'التالي'),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(ElevatedButton, 'التالي'));
        await tester.pumpAndSettle();

        expect(find.text('الشروط والأحكام'), findsOneWidget);

        final createButton = find.widgetWithText(ElevatedButton, 'إنشاء حساب');
        expect(tester.widget<ElevatedButton>(createButton).onPressed, isNull);

        await tester.tap(find.byType(Switch));
        await tester.pumpAndSettle();

        final enabledButton = tester.widget<ElevatedButton>(createButton);
        expect(enabledButton.onPressed, isNotNull);
      });
    });

    group('Splash Session', () {
      testWidgets('navigates to donor home when session exists and is donor', (
        tester,
      ) async {
        final sessionUser = UserModel(
          id: 'user-456',
          username: 'donoruser',
          fullName: 'Donor User',
          bloodType: 'A+',
          isDonor: true,
        );

        when(
          () => mockDataSource.getCurrentUser(),
        ).thenAnswer((_) async => sessionUser);

        await pumpApp(tester);

        expect(find.byType(SplashScreen), findsOneWidget);

        await tester.pump(const Duration(seconds: 2));
        await tester.pumpAndSettle();

        expect(find.byType(DonorHomeScreen), findsOneWidget);
      });

      testWidgets(
        'navigates to requester home when session exists and is recipient',
        (tester) async {
          final sessionUser = UserModel(
            id: 'user-789',
            email: 'recipient@test.com',
            username: 'recipientuser',
            fullName: 'Recipient User',
            bloodType: 'B+',
            isDonor: false,
            isRecipient: true,
          );

          when(
            () => mockDataSource.getCurrentUser(),
          ).thenAnswer((_) async => sessionUser);

          await pumpApp(tester);

          expect(find.byType(SplashScreen), findsOneWidget);

          await tester.pump(const Duration(seconds: 2));
          await tester.pumpAndSettle();

          expect(find.byType(RequesterHomeScreen), findsOneWidget);
        },
      );

      testWidgets('navigates to welcome when no session', (tester) async {
        when(
          () => mockDataSource.getCurrentUser(),
        ).thenAnswer((_) async => null);

        await pumpApp(tester);

        expect(find.byType(SplashScreen), findsOneWidget);

        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle();

        expect(find.byType(WelcomeScreen), findsOneWidget);
      });
    });

    group('Role Selection', () {
      testWidgets('shows confirmation dialog when selecting recipient', (
        tester,
      ) async {
        when(
          () => mockDataSource.getCurrentUser(),
        ).thenAnswer((_) async => null);

        await pumpApp(tester);
        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle();

        when(
          () => mockDataSource.signIn(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => testUserModel);

        await tester.tap(find.text('تسجيل الدخول'));
        await tester.pumpAndSettle();

        final emailFields = find.byType(TextFormField);
        await tester.enterText(emailFields.at(0), 'test@test.com');
        await tester.enterText(emailFields.at(1), 'password123');

        await tester.ensureVisible(find.text('تسجيل الدخول').last);
        await tester.pumpAndSettle();
        await tester.tap(find.text('تسجيل الدخول').last);
        await tester.pumpAndSettle();

        when(
          () => mockDataSource.getCurrentUser(),
        ).thenAnswer((_) async => testUserModel);

        await tester.tap(find.text('الصفحة الرئيسية'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('أحتاج دم'));
        await tester.pumpAndSettle();

        expect(find.byType(Dialog), findsOneWidget);
        expect(find.text('تأكيد'), findsOneWidget);
        expect(find.text('إلغاء'), findsOneWidget);
      });

      testWidgets('cancels recipient confirmation and stays on role screen', (
        tester,
      ) async {
        when(
          () => mockDataSource.getCurrentUser(),
        ).thenAnswer((_) async => null);

        await pumpApp(tester);
        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle();

        when(
          () => mockDataSource.signIn(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => testUserModel);

        await tester.tap(find.text('تسجيل الدخول'));
        await tester.pumpAndSettle();

        final emailFields = find.byType(TextFormField);
        await tester.enterText(emailFields.at(0), 'test@test.com');
        await tester.enterText(emailFields.at(1), 'password123');

        await tester.ensureVisible(find.text('تسجيل الدخول').last);
        await tester.pumpAndSettle();
        await tester.tap(find.text('تسجيل الدخول').last);
        await tester.pumpAndSettle();

        when(
          () => mockDataSource.getCurrentUser(),
        ).thenAnswer((_) async => testUserModel);

        await tester.tap(find.text('الصفحة الرئيسية'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('أحتاج دم'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('إلغاء'));
        await tester.pumpAndSettle();

        expect(find.byType(RoleSelectionScreen), findsOneWidget);
        expect(find.byType(Dialog), findsNothing);
      });
    });
  });
}
