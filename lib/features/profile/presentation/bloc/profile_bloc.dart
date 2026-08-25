import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/session/profile_user_mapper.dart';
import '../../../../core/session/session_manager.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/usecases/change_role.dart';
import '../../domain/usecases/get_cached_profile.dart';
import '../../domain/usecases/get_profile.dart';
import '../../domain/usecases/set_account_status.dart';
import '../../domain/usecases/update_profile.dart';
import '../../domain/usecases/upload_avatar.dart';
import 'profile_event.dart';
import 'profile_state.dart';

export 'profile_event.dart';
export 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfile getProfile;
  final GetCachedProfile getCachedProfile;
  final UpdateProfile updateProfile;
  final ChangeRole changeRole;
  final SetAccountStatus setAccountStatus;
  final UploadAvatar uploadAvatar;
  final SessionManager sessionManager;

  ProfileBloc({
    required this.getProfile,
    required this.getCachedProfile,
    required this.updateProfile,
    required this.changeRole,
    required this.setAccountStatus,
    required this.uploadAvatar,
    required this.sessionManager,
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
    // Paint the cached profile instantly; only fall back to the spinner when
    // there is nothing to show yet.
    final cached = await getCachedProfile();
    if (cached != null) {
      emit(ProfileLoaded(profile: cached, isEditing: false));
    } else {
      emit(ProfileLoading());
    }

    final result = await getProfile(NoParams());
    result.fold(
      (failure) {
        // Keep the cached view on-screen if the refresh fails. Keyed off
        // `cached` rather than the current state, which a concurrent event
        // could have changed.
        if (cached == null) emit(ProfileError(failure: failure));
      },
      (profile) {
        _syncSession(profile);
        emit(ProfileLoaded(profile: profile, isEditing: false));
      },
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
    result.fold((failure) => emit(ProfileError(failure: failure)), (profile) {
      _syncSession(profile);
      emit(ProfileLoaded(profile: profile, isEditing: false));
    });
  }

  Future<void> _onChangeRole(
    ChangeRoleRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    final result = await changeRole(
      ChangeRoleParams(isDonor: event.isDonor, isRecipient: event.isRecipient),
    );
    result.fold((failure) => emit(ProfileError(failure: failure)), (profile) {
      _syncSession(profile);
      emit(ProfileRoleChanged(profile: profile));
    });
  }

  Future<void> _onAccountStatusToggled(
    AccountStatusToggled event,
    Emitter<ProfileState> emit,
  ) async {
    final current = state;
    if (current is! ProfileLoaded) return;
    if (current.profile.isActive == event.isActive) return;

    emit(ProfileLoading());
    final result = await setAccountStatus(event.isActive);
    result.fold(
      // Keep the profile on-screen and report the failure transiently rather
      // than replacing the page with a full error state.
      (failure) => emit(
        ProfileLoaded(
          profile: current.profile,
          isEditing: current.isEditing,
          actionError: failure,
        ),
      ),
      (profile) {
        _syncSession(profile);
        emit(ProfileLoaded(profile: profile, isEditing: current.isEditing));
      },
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
      // Keep the profile (and the picked preview) on-screen and report the
      // failure as a transient message instead of blanking the page.
      emit(
        ProfileLoaded(
          profile: current.profile,
          isEditing: current.isEditing,
          pendingAvatarPath: event.filePath,
          actionError: failure,
        ),
      );
      return null;
    }, (url) => url);
    if (url == null) return;

    final updated = current.profile.copyWith(avatarUrl: url);
    final saveResult = await updateProfile(updated);
    saveResult.fold(
      (failure) => emit(
        ProfileLoaded(
          profile: current.profile,
          isEditing: current.isEditing,
          pendingAvatarPath: event.filePath,
          actionError: failure,
        ),
      ),
      (profile) {
        _syncSession(profile);
        emit(ProfileLoaded(profile: profile, isEditing: current.isEditing));
      },
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

  /// Mirrors the freshly persisted profile into [SessionManager] so
  /// synchronous readers (greetings, self-request wilaya pre-fill) never see a
  /// stale user between profile edits and re-login.
  ///
  /// When the profile's city cannot be resolved to a wilaya id (data drift
  /// between the backend and the canonical list), the id already held by the
  /// session is preserved rather than demoted to null.
  void _syncSession(ProfileEntity profile) {
    final previous = sessionManager.currentUser;
    final mapped = profileToSessionUser(profile);
    final wilayaId = mapped.wilayaId ?? previous?.wilayaId;
    sessionManager.setUser(
      wilayaId == null ? mapped : mapped.copyWith(wilayaId: wilayaId),
    );
  }
}
