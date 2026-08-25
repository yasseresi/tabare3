import '../../features/auth/domain/entities/user_entity.dart';
import '../../features/profile/domain/entities/profile_entity.dart';
import '../constants/algerian_wilayas.dart';

/// Maps the persisted profile onto the session user so screens reading
/// [SessionManager] (e.g. the self-request wilaya pre-fill) observe profile
/// edits without waiting for a re-login.
///
/// The profile stores the wilaya as its canonical Arabic name; the session
/// carries the 1-based id used by hospital filtering and the backend.
UserEntity profileToSessionUser(ProfileEntity profile) {
  final index = algerianWilayas.indexOf(profile.city.trim());
  return UserEntity(
    id: profile.id,
    email: profile.email,
    username: profile.username,
    fullName: profile.fullName,
    isDonor: profile.isDonor,
    isRecipient: profile.isRecipient,
    bloodType: profile.bloodType,
    wilayaId: index < 0 ? null : index + 1,
  );
}
