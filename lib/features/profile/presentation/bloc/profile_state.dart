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

  const ProfileLoaded({
    required this.profile,
    required this.isEditing,
    this.pendingAvatarPath,
  });

  @override
  List<Object?> get props => [profile, isEditing, pendingAvatarPath];
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
