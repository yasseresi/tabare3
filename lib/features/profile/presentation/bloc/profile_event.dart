import 'package:equatable/equatable.dart';

import '../../domain/entities/profile_entity.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {
  const LoadProfile();
}

class ToggleEditMode extends ProfileEvent {
  const ToggleEditMode();
}

class SaveProfile extends ProfileEvent {
  final ProfileEntity profile;

  const SaveProfile(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ChangeRoleRequested extends ProfileEvent {
  final bool isDonor;
  final bool isRecipient;

  const ChangeRoleRequested({required this.isDonor, required this.isRecipient});

  @override
  List<Object?> get props => [isDonor, isRecipient];
}

class AccountStatusToggled extends ProfileEvent {
  final bool isActive;

  const AccountStatusToggled(this.isActive);

  @override
  List<Object?> get props => [isActive];
}

class AvatarSelected extends ProfileEvent {
  final String filePath;

  const AvatarSelected(this.filePath);

  @override
  List<Object?> get props => [filePath];
}

class ProfileFieldChanged extends ProfileEvent {
  final ProfileEntity profile;

  const ProfileFieldChanged(this.profile);

  @override
  List<Object?> get props => [profile];
}
