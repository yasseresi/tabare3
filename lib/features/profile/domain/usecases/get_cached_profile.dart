import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

/// Returns the locally cached profile (or null) without touching the network,
/// so the screen can paint immediately instead of showing a spinner.
class GetCachedProfile {
  final ProfileRepository repository;

  GetCachedProfile(this.repository);

  Future<ProfileEntity?> call() => repository.getCachedProfile();
}
