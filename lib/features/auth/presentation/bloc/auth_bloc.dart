import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/session/session_manager.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/check_username_availability.dart';
import '../../domain/usecases/get_current_session.dart';
import '../../domain/usecases/login_with_email_password.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/signup_with_email_password.dart';
import '../../domain/usecases/update_user_role.dart';
import 'auth_event.dart';
import 'auth_state.dart';

export 'auth_event.dart';
export 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginWithUsernamePassword loginWithUsernamePassword;
  final SignupWithUsernamePassword signupWithUsernamePassword;
  final CheckUsernameAvailability checkUsernameAvailability;
  final SignOut signOutUseCase;
  final GetCurrentSession getCurrentSession;
  final UpdateUserRole updateUserRole;
  final SessionManager sessionManager;

  AuthBloc({
    required this.loginWithUsernamePassword,
    required this.signupWithUsernamePassword,
    required this.checkUsernameAvailability,
    required this.signOutUseCase,
    required this.getCurrentSession,
    required this.updateUserRole,
    required this.sessionManager,
  }) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<SignupRequested>(_onSignupRequested);
    on<UsernameCheckRequested>(_onUsernameCheckRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<SessionCheckRequested>(_onSessionCheckRequested);
    on<UpdateRoleRequested>(_onUpdateRoleRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await loginWithUsernamePassword(
      LoginParams(username: event.username, password: event.password),
    );
    result.fold((failure) => emit(AuthError(failure)), (user) {
      sessionManager.setUser(user);
      emit(Authenticated(user));
    });
  }

  Future<void> _onSignupRequested(
    SignupRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    // Catch the collision before the account call so the user gets it on the
    // username field instead of as a generic dialog at the end of a three-step
    // form. The check is racy and only advisory: a failure here (offline, RPC
    // missing) must not block a sign-up that would otherwise succeed, and the
    // backend's own uniqueness error remains the authoritative answer.
    final availability = await checkUsernameAvailability(
      event.params.username,
    );
    final isTaken = availability.fold((_) => false, (available) => !available);
    if (isTaken) {
      emit(UsernameTaken(event.params.username));
      return;
    }

    final result = await signupWithUsernamePassword(event.params);
    result.fold((failure) => emit(AuthError(failure)), (user) {
      sessionManager.setUser(user);
      emit(Authenticated(user));
    });
  }

  /// Blur-time check. Stays silent unless the username is taken: no loading
  /// state, and no state at all on the happy path, so it cannot interrupt
  /// whatever the user is typing next.
  Future<void> _onUsernameCheckRequested(
    UsernameCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final username = event.username.trim();
    if (username.isEmpty) return;

    final availability = await checkUsernameAvailability(username);
    final isTaken = availability.fold((_) => false, (available) => !available);
    if (isTaken) {
      emit(UsernameTaken(username));
    }
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await signOutUseCase(NoParams());
    result.fold((failure) => emit(AuthError(failure)), (_) {
      sessionManager.clear();
      emit(Unauthenticated());
    });
  }

  Future<void> _onSessionCheckRequested(
    SessionCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await getCurrentSession(NoParams());
    result.fold((failure) => emit(Unauthenticated()), (user) {
      if (user != null) {
        sessionManager.setUser(user);
        emit(Authenticated(user));
      } else {
        sessionManager.clear();
        emit(Unauthenticated());
      }
    });
  }

  Future<void> _onUpdateRoleRequested(
    UpdateRoleRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await updateUserRole(
      UpdateRoleParams(isDonor: event.isDonor, isRecipient: event.isRecipient),
    );
    result.fold((failure) => emit(AuthError(failure)), (user) {
      sessionManager.setUser(user);
      emit(RoleUpdated(user));
    });
  }
}
