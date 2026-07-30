import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/change_role.dart';
import '../../domain/usecases/get_profile.dart';
import '../../domain/usecases/update_profile.dart';
import '../../domain/usecases/upload_avatar.dart';
import 'profile_event.dart';
import 'profile_state.dart';

export 'profile_event.dart';
export 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfile getProfile;
  final UpdateProfile updateProfile;
  final ChangeRole changeRole;
  final UploadAvatar uploadAvatar;

  ProfileBloc({
    required this.getProfile,
    required this.updateProfile,
    required this.changeRole,
    required this.uploadAvatar,
  }) : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<ToggleEditMode>(_onToggleEditMode);
    on<SaveProfile>(_onSaveProfile);
    on<ChangeRoleRequested>(_onChangeRole);
    on<AccountStatusToggled>(_onAccountStatusToggled);
    on<AvatarSelected>(_onAvatarSelected);
    on<ProfileFieldChanged>(_onProfileFieldChanged);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    final result = await getProfile(NoParams());
    result.fold(
      (failure) => emit(ProfileError(failure: failure)),
      (profile) => emit(ProfileLoaded(profile: profile, isEditing: false)),
    );
  }

  void _onToggleEditMode(ToggleEditMode event, Emitter<ProfileState> emit) {
    final current = state;
    if (current is ProfileLoaded) {
      emit(
        ProfileLoaded(profile: current.profile, isEditing: !current.isEditing),
      );
    }
  }

  Future<void> _onSaveProfile(
    SaveProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    final result = await updateProfile(event.profile);
    result.fold(
      (failure) => emit(ProfileError(failure: failure)),
      (profile) => emit(ProfileLoaded(profile: profile, isEditing: false)),
    );
  }

  Future<void> _onChangeRole(
    ChangeRoleRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    final result = await changeRole(
      ChangeRoleParams(isDonor: event.isDonor, isRecipient: event.isRecipient),
    );
    result.fold(
      (failure) => emit(ProfileError(failure: failure)),
      (profile) => emit(ProfileRoleChanged(profile: profile)),
    );
  }

  Future<void> _onAccountStatusToggled(
    AccountStatusToggled event,
    Emitter<ProfileState> emit,
  ) async {
    final current = state;
    if (current is! ProfileLoaded) return;

    final updated = current.profile.copyWith(isActive: event.isActive);
    emit(ProfileLoading());
    final result = await updateProfile(updated);
    result.fold(
      (failure) => emit(ProfileError(failure: failure)),
      (profile) =>
          emit(ProfileLoaded(profile: profile, isEditing: current.isEditing)),
    );
  }

  Future<void> _onAvatarSelected(
    AvatarSelected event,
    Emitter<ProfileState> emit,
  ) async {
    final current = state;
    if (current is! ProfileLoaded) return;

    emit(
      ProfileLoaded(
        profile: current.profile,
        isEditing: current.isEditing,
        pendingAvatarPath: event.filePath,
      ),
    );

    final uploadResult = await uploadAvatar(event.filePath);
    final url = uploadResult.fold((failure) {
      emit(ProfileError(failure: failure));
      return null;
    }, (url) => url);
    if (url == null) return;

    final updated = current.profile.copyWith(avatarUrl: url);
    final saveResult = await updateProfile(updated);
    saveResult.fold(
      (failure) => emit(ProfileError(failure: failure)),
      (profile) =>
          emit(ProfileLoaded(profile: profile, isEditing: current.isEditing)),
    );
  }

  void _onProfileFieldChanged(
    ProfileFieldChanged event,
    Emitter<ProfileState> emit,
  ) {
    final current = state;
    if (current is ProfileLoaded) {
      emit(ProfileLoaded(profile: event.profile, isEditing: current.isEditing));
    }
  }
}
