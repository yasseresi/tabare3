import 'package:equatable/equatable.dart';

import '../../domain/repositories/auth_repository.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final String username;
  final String password;

  const LoginRequested({required this.username, required this.password});

  @override
  List<Object?> get props => [username, password];
}

class SignupRequested extends AuthEvent {
  final SignupParams params;

  const SignupRequested(this.params);

  @override
  List<Object?> get props => [params];
}

class SignOutRequested extends AuthEvent {}

class SessionCheckRequested extends AuthEvent {}

class UpdateRoleRequested extends AuthEvent {
  final bool isDonor;
  final bool isRecipient;

  const UpdateRoleRequested({required this.isDonor, required this.isRecipient});

  @override
  List<Object?> get props => [isDonor, isRecipient];
}
