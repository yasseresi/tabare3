import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../domain/repositories/auth_repository.dart';
import '../../models/user_model.dart';
import '../auth_remote_data_source.dart';

const _fakeEmailDomain = 'tabara3.dz';

/// Supabase auth requires an email, so usernames are mapped onto a fake domain.
String _usernameToEmail(String username) => '$username@$_fakeEmailDomain';

/// `security definer` RPC added by
/// `20260812140000_add_is_username_available_rpc.sql`.
const isUsernameAvailableRpcName = 'is_username_available';

Map<String, dynamic> buildRoleUpdatePayload({
  required bool isDonor,
  required bool isRecipient,
}) => {
  'is_donor': isDonor,
  'is_recipient': isRecipient,
  'active_mode': isDonor ? 'donor' : 'recipient',
};

class AuthSupabaseDataSource implements AuthRemoteDataSource {
  final SupabaseClient client;

  AuthSupabaseDataSource({required this.client});

  @override
  Future<UserModel> signIn({
    required String username,
    required String password,
  }) async {
    final response = await client.auth.signInWithPassword(
      email: _usernameToEmail(username),
      password: password,
    );
    return _fetchUserProfile(response.user!.id);
  }

  @override
  Future<UserModel> signUp({required SignupParams params}) async {
    final response = await client.auth.signUp(
      email: _usernameToEmail(params.username),
      password: params.password,
      data: params.toMetadata(),
    );
    return _fetchUserProfile(response.user!.id);
  }

  /// `public.users` is closed to anon, so the lookup goes through a
  /// `security definer` RPC that answers with a bare boolean and leaks nothing
  /// else about the account.
  @override
  Future<bool> isUsernameAvailable(String username) async {
    final result = await client.rpc(
      isUsernameAvailableRpcName,
      params: {'p_username': username},
    );
    return result == true;
  }

  @override
  Future<void> signOut() async {
    await client.auth.signOut();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final session = client.auth.currentSession;
    if (session == null) return null;
    return _fetchUserProfile(session.user.id);
  }

  @override
  Future<UserModel> updateUserRole({
    required bool isDonor,
    required bool isRecipient,
  }) async {
    final userId = client.auth.currentUser!.id;
    final response = await client
        .from('users')
        .update(
          buildRoleUpdatePayload(isDonor: isDonor, isRecipient: isRecipient),
        )
        .eq('id', userId)
        .select()
        .single();

    return UserModel.fromJson(response);
  }

  Future<UserModel> _fetchUserProfile(String userId) async {
    final response = await client
        .from('users')
        .select()
        .eq('id', userId)
        .single();

    return UserModel.fromJson(response);
  }
}
