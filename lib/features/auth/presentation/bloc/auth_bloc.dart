import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/session/session_manager.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/repositories/auth_repository.dart';
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
  final SignOut signOutUseCase;
  final GetCurrentSession getCurrentSession;
  final UpdateUserRole updateUserRole;
  final SessionManager sessionManager;

  AuthBloc({
    required this.loginWithUsernamePassword,
    required this.signupWithUsernamePassword,
    required this.signOutUseCase,
    required this.getCurrentSession,
    required this.updateUserRole,
    required this.sessionManager,
  }) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<SignupRequested>(_onSignupRequested);
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
    final result = await signupWithUsernamePassword(event.params);
    result.fold((failure) => emit(AuthError(failure)), (user) {
      sessionManager.setUser(user);
      emit(Authenticated(user));
    });
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
