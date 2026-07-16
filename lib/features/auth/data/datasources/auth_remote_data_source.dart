import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signIn({required String email, required String password});
  Future<UserModel> signUp({required SignupParams params});
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
  Future<UserModel> updateUserRole({required bool isDonor, required bool isRecipient});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<UserModel> signIn({required String email, required String password}) async {
    final response = await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return _fetchUserProfile(response.user!.id);
  }

  @override
  Future<UserModel> signUp({required SignupParams params}) async {
    final response = await client.auth.signUp(
      email: params.email,
      password: params.password,
      data: params.toMetadata(),
    );
    return _fetchUserProfile(response.user!.id);
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
        .update({
          'is_donor': isDonor,
          'is_recipient': isRecipient,
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        })
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
