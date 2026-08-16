import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:tabare3/core/error/failures.dart';
import 'package:tabare3/core/usecases/usecase.dart';
import 'package:tabare3/features/auth/domain/entities/user_entity.dart';
import 'package:tabare3/features/auth/domain/repositories/auth_repository.dart';
import 'package:tabare3/features/auth/domain/usecases/check_username_availability.dart';
import 'package:tabare3/features/auth/domain/usecases/get_current_session.dart';
import 'package:tabare3/features/auth/domain/usecases/login_with_email_password.dart';
import 'package:tabare3/features/auth/domain/usecases/sign_out.dart';
import 'package:tabare3/features/auth/domain/usecases/signup_with_email_password.dart';
import 'package:tabare3/features/auth/domain/usecases/update_user_role.dart';
import 'package:tabare3/core/session/session_manager.dart';
import 'package:tabare3/features/auth/presentation/bloc/auth_bloc.dart';

class MockLoginWithUsernamePassword extends Mock
    implements LoginWithUsernamePassword {}

class MockSignupWithUsernamePassword extends Mock
    implements SignupWithUsernamePassword {}

class MockCheckUsernameAvailability extends Mock
    implements CheckUsernameAvailability {}

class MockSignOut extends Mock implements SignOut {}

class MockGetCurrentSession extends Mock implements GetCurrentSession {}

class MockUpdateUserRole extends Mock implements UpdateUserRole {}

const testUser = UserEntity(
  id: '123',
  email: 'testuser@tabara3.dz',
  username: 'testuser',
  fullName: 'Test User',
  bloodType: 'O+',
  isDonor: true,
);

void main() {
  late AuthBloc bloc;
  late MockLoginWithUsernamePassword mockLogin;
  late MockSignupWithUsernamePassword mockSignup;
  late MockCheckUsernameAvailability mockCheckUsername;
  late MockSignOut mockSignOut;
  late MockGetCurrentSession mockGetCurrentSession;
  late MockUpdateUserRole mockUpdateUserRole;

  setUpAll(() {
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
    mockLogin = MockLoginWithUsernamePassword();
    mockSignup = MockSignupWithUsernamePassword();
    mockCheckUsername = MockCheckUsernameAvailability();
    // Availability is a pre-flight step of every signup: default it to
    // available so the existing signup cases keep exercising the signup call.
    when(
      () => mockCheckUsername(any()),
    ).thenAnswer((_) async => const Right(true));
    mockSignOut = MockSignOut();
    mockGetCurrentSession = MockGetCurrentSession();
    mockUpdateUserRole = MockUpdateUserRole();

    bloc = AuthBloc(
      loginWithUsernamePassword: mockLogin,
      signupWithUsernamePassword: mockSignup,
      checkUsernameAvailability: mockCheckUsername,
      signOutUseCase: mockSignOut,
      getCurrentSession: mockGetCurrentSession,
      updateUserRole: mockUpdateUserRole,
      sessionManager: SessionManager(),
    );
  });

  test('initial state is AuthInitial', () {
    expect(bloc.state, isA<AuthInitial>());
  });

  group('LoginRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Authenticated] on success',
      build: () {
        when(
          () => mockLogin(any()),
        ).thenAnswer((_) async => const Right(testUser));
        return bloc;
      },
      act: (bloc) => bloc.add(
        const LoginRequested(username: 'testuser', password: 'password'),
      ),
      expect: () => [isA<AuthLoading>(), const Authenticated(testUser)],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] on failure',
      build: () {
        when(
          () => mockLogin(any()),
        ).thenAnswer((_) async => const Left(AuthFailure()));
        return bloc;
      },
      act: (bloc) =>
          bloc.add(const LoginRequested(username: 'wrong', password: 'wrong')),
      expect: () => [isA<AuthLoading>(), isA<AuthError>()],
    );
  });

  group('SignupRequested', () {
    final signupParams = SignupParams(
      username: 'testuser',
      fullName: 'Test User',
      password: 'password',
      phone: '0555123456',
      dateOfBirth: DateTime(2000, 1, 1),
      gender: 'male',
      bloodType: 'O+',
      city: 'Algiers',
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Authenticated] on success',
      build: () {
        when(
          () => mockSignup(any()),
        ).thenAnswer((_) async => const Right(testUser));
        return bloc;
      },
      act: (bloc) => bloc.add(SignupRequested(signupParams)),
      expect: () => [isA<AuthLoading>(), const Authenticated(testUser)],
    );

    blocTest<AuthBloc, AuthState>(
      'stops at the username field when the name is taken',
      build: () {
        when(
          () => mockCheckUsername('testuser'),
        ).thenAnswer((_) async => const Right(false));
        return bloc;
      },
      act: (bloc) => bloc.add(SignupRequested(signupParams)),
      expect: () => [isA<AuthLoading>(), const UsernameTaken('testuser')],
      verify: (_) => verifyNever(() => mockSignup(any())),
    );

    blocTest<AuthBloc, AuthState>(
      // The check is a convenience, not a gate: if it cannot answer, the signup
      // still goes through and the backend's uniqueness error is the backstop.
      'fails open and signs up anyway when the check itself fails',
      build: () {
        when(
          () => mockCheckUsername(any()),
        ).thenAnswer((_) async => const Left(NetworkFailure()));
        when(
          () => mockSignup(any()),
        ).thenAnswer((_) async => const Right(testUser));
        return bloc;
      },
      act: (bloc) => bloc.add(SignupRequested(signupParams)),
      expect: () => [isA<AuthLoading>(), const Authenticated(testUser)],
      verify: (_) => verify(() => mockSignup(any())).called(1),
    );
  });

  group('UsernameCheckRequested', () {
    blocTest<AuthBloc, AuthState>(
      'reports a taken username without a loading state',
      build: () {
        when(
          () => mockCheckUsername('testuser'),
        ).thenAnswer((_) async => const Right(false));
        return bloc;
      },
      act: (bloc) => bloc.add(const UsernameCheckRequested('testuser')),
      expect: () => [const UsernameTaken('testuser')],
    );

    blocTest<AuthBloc, AuthState>(
      'reports the username available when it is free',
      build: () => bloc,
      act: (bloc) => bloc.add(const UsernameCheckRequested('testuser')),
      expect: () => [const UsernameAvailable('testuser')],
    );

    blocTest<AuthBloc, AuthState>(
      'treats a failed check as available so it never blocks progress',
      build: () {
        when(
          () => mockCheckUsername(any()),
        ).thenAnswer((_) async => const Left(NetworkFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(const UsernameCheckRequested('testuser')),
      expect: () => [const UsernameAvailable('testuser')],
    );

    blocTest<AuthBloc, AuthState>(
      'does not call the backend for an empty field',
      build: () => bloc,
      act: (bloc) => bloc.add(const UsernameCheckRequested('   ')),
      expect: () => <AuthState>[],
      verify: (_) => verifyNever(() => mockCheckUsername(any())),
    );
  });

  group('SignOutRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Unauthenticated] on success',
      build: () {
        when(
          () => mockSignOut(any()),
        ).thenAnswer((_) async => const Right(null));
        return bloc;
      },
      act: (bloc) => bloc.add(SignOutRequested()),
      expect: () => [isA<AuthLoading>(), isA<Unauthenticated>()],
    );
  });

  group('SessionCheckRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Authenticated] when session exists',
      build: () {
        when(
          () => mockGetCurrentSession(any()),
        ).thenAnswer((_) async => const Right(testUser));
        return bloc;
      },
      act: (bloc) => bloc.add(SessionCheckRequested()),
      expect: () => [isA<AuthLoading>(), const Authenticated(testUser)],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Unauthenticated] when no session',
      build: () {
        when(
          () => mockGetCurrentSession(any()),
        ).thenAnswer((_) async => const Right(null));
        return bloc;
      },
      act: (bloc) => bloc.add(SessionCheckRequested()),
      expect: () => [isA<AuthLoading>(), isA<Unauthenticated>()],
    );
  });

  group('UpdateRoleRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, RoleUpdated] on success',
      build: () {
        when(
          () => mockUpdateUserRole(any()),
        ).thenAnswer((_) async => const Right(testUser));
        return bloc;
      },
      act: (bloc) => bloc.add(
        const UpdateRoleRequested(isDonor: true, isRecipient: false),
      ),
      expect: () => [isA<AuthLoading>(), isA<RoleUpdated>()],
    );
  });
}
