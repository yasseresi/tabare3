import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/profile_entity.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final ProfileEntity profile;
  final bool isEditing;
  final String? pendingAvatarPath;

  /// A non-fatal failure from the last action (e.g. an avatar upload that
  /// didn't persist). The profile stays on-screen; the view surfaces this as a
  /// transient message rather than replacing the page with a full error state.
  final Failure? actionError;

  const ProfileLoaded({
    required this.profile,
    required this.isEditing,
    this.pendingAvatarPath,
    this.actionError,
  });

  @override
  List<Object?> get props => [profile, isEditing, pendingAvatarPath, actionError];
}

class ProfileError extends ProfileState {
  final Failure failure;

  const ProfileError({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class ProfileRoleChanged extends ProfileState {
  final ProfileEntity profile;

  const ProfileRoleChanged({required this.profile});

  @override
  List<Object?> get props => [profile];
}
