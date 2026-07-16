import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:tabare3/core/error/failures.dart';
import 'package:tabare3/core/usecases/usecase.dart';
import 'package:tabare3/features/auth/domain/entities/user_entity.dart';
import 'package:tabare3/features/auth/domain/repositories/auth_repository.dart';
import 'package:tabare3/features/auth/domain/usecases/get_current_session.dart';
import 'package:tabare3/features/auth/domain/usecases/login_with_email_password.dart';
import 'package:tabare3/features/auth/domain/usecases/sign_out.dart';
import 'package:tabare3/features/auth/domain/usecases/signup_with_email_password.dart';
import 'package:tabare3/features/auth/domain/usecases/update_user_role.dart';
import 'package:tabare3/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:tabare3/features/auth/presentation/bloc/auth_event.dart';
import 'package:tabare3/features/auth/presentation/bloc/auth_state.dart';

class MockLoginWithEmailPassword extends Mock
    implements LoginWithEmailPassword {}
class MockSignupWithEmailPassword extends Mock
    implements SignupWithEmailPassword {}
class MockSignOut extends Mock implements SignOut {}
class MockGetCurrentSession extends Mock implements GetCurrentSession {}
class MockUpdateUserRole extends Mock implements UpdateUserRole {}

const testUser = UserEntity(
  id: '123',
  email: 'test@test.com',
  username: 'testuser',
  fullName: 'Test User',
  bloodType: 'O+',
  isDonor: true,
);

void main() {
  late AuthBloc bloc;
  late MockLoginWithEmailPassword mockLogin;
  late MockSignupWithEmailPassword mockSignup;
  late MockSignOut mockSignOut;
  late MockGetCurrentSession mockGetCurrentSession;
  late MockUpdateUserRole mockUpdateUserRole;

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
    mockLogin = MockLoginWithEmailPassword();
    mockSignup = MockSignupWithEmailPassword();
    mockSignOut = MockSignOut();
    mockGetCurrentSession = MockGetCurrentSession();
    mockUpdateUserRole = MockUpdateUserRole();

    bloc = AuthBloc(
      loginWithEmailPassword: mockLogin,
      signupWithEmailPassword: mockSignup,
      signOutUseCase: mockSignOut,
      getCurrentSession: mockGetCurrentSession,
      updateUserRole: mockUpdateUserRole,
    );
  });

  test('initial state is AuthInitial', () {
    expect(bloc.state, isA<AuthInitial>());
  });

  group('LoginRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Authenticated] on success',
      build: () {
        when(() => mockLogin(any()))
            .thenAnswer((_) async => const Right(testUser));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoginRequested(
        email: 'test@test.com',
        password: 'password',
      )),
      expect: () => [isA<AuthLoading>(), const Authenticated(testUser)],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] on failure',
      build: () {
        when(() => mockLogin(any()))
            .thenAnswer((_) async => const Left(AuthFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoginRequested(
        email: 'wrong@test.com',
        password: 'wrong',
      )),
      expect: () => [isA<AuthLoading>(), isA<AuthError>()],
    );
  });

  group('SignupRequested', () {
    final signupParams = SignupParams(
      username: 'testuser',
      fullName: 'Test User',
      email: 'test@test.com',
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
        when(() => mockSignup(any()))
            .thenAnswer((_) async => const Right(testUser));
        return bloc;
      },
      act: (bloc) => bloc.add(SignupRequested(signupParams)),
      expect: () => [isA<AuthLoading>(), const Authenticated(testUser)],
    );
  });

  group('SignOutRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Unauthenticated] on success',
      build: () {
        when(() => mockSignOut(any()))
            .thenAnswer((_) async => const Right(null));
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
        when(() => mockGetCurrentSession(any()))
            .thenAnswer((_) async => const Right(testUser));
        return bloc;
      },
      act: (bloc) => bloc.add(SessionCheckRequested()),
      expect: () => [isA<AuthLoading>(), const Authenticated(testUser)],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Unauthenticated] when no session',
      build: () {
        when(() => mockGetCurrentSession(any()))
            .thenAnswer((_) async => const Right(null));
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
        when(() => mockUpdateUserRole(any()))
            .thenAnswer((_) async => const Right(testUser));
        return bloc;
      },
      act: (bloc) => bloc.add(const UpdateRoleRequested(
        isDonor: true,
        isRecipient: false,
      )),
      expect: () => [isA<AuthLoading>(), isA<RoleUpdated>()],
    );
  });
}
