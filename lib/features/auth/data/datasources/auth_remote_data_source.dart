import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

/// Backend-agnostic contract for authentication.
///
/// Implementations live under `datasources/<backend>/`.
abstract class AuthRemoteDataSource {
  Future<UserModel> signIn({
    required String username,
    required String password,
  });
  Future<UserModel> signUp({required SignupParams params});
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
  Future<UserModel> updateUserRole({
    required bool isDonor,
    required bool isRecipient,
  });
}
