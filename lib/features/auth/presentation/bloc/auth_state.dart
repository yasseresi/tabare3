import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/user_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final UserEntity user;

  const Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthError extends AuthState {
  final Failure failure;

  const AuthError(this.failure);

  @override
  List<Object?> get props => [failure];
}

/// The username the user is trying to claim is already taken. Reported on the
/// field rather than as a dialog, because the fix is to edit that one field.
class UsernameTaken extends AuthState {
  final String username;

  const UsernameTaken(this.username);

  @override
  List<Object?> get props => [username];
}

/// The username cleared the availability check (or the check failed and is
/// treated advisorily as free). Emitted so the sign-up form can advance past
/// step 1 only once the "Next" tap's check has come back.
class UsernameAvailable extends AuthState {
  final String username;

  const UsernameAvailable(this.username);

  @override
  List<Object?> get props => [username];
}

class Unauthenticated extends AuthState {}

class RoleUpdated extends AuthState {
  final UserEntity user;

  const RoleUpdated(this.user);

  @override
  List<Object?> get props => [user];
}
