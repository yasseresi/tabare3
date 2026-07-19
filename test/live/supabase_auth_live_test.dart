import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const supabaseUrl = 'https://nzsaghjwyitjhyagdbjb.supabase.co';
const supabaseKey = 'sb_publishable_1n_-1Jz7yiiERq3odEIPOg_0eKi2ly1';

void main() {
  late SupabaseClient client;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await Supabase.initialize(
      url: supabaseUrl,
      publishableKey: supabaseKey,
    );
    client = Supabase.instance.client;
  });

  tearDownAll(() async {
    await client.dispose();
  });

  group('Live Supabase Auth Integration', skip: 'Requires valid Supabase credentials', () {
    test('handle_new_user trigger creates profile on signUp', () async {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final email = 'test_live_$timestamp@example.com';
      final username = 'testuser_$timestamp';

      final response = await client.auth.signUp(
        email: email,
        password: 'Test1234!',
        data: {
          'username': username,
          'full_name': 'Test User Live',
          'phone': '0555123456',
          'date_of_birth': '1995-06-15',
          'gender': 'male',
          'blood_type': 'O+',
          'city': 'Algiers',
        },
      );

      expect(response.user, isNotNull);
      expect(response.user!.email, email);

      final profile = await client
          .from('users')
          .select()
          .eq('id', response.user!.id)
          .single();

      expect(profile['username'], username);
      expect(profile['full_name'], 'Test User Live');
      expect(profile['phone'], '0555123456');
      expect(profile['blood_type'], 'O+');
      expect(profile['city'], 'Algiers');
      expect(profile['is_donor'], false);
      expect(profile['is_recipient'], false);

      await client.auth.admin.deleteUser(response.user!.id);
    });

    test('signUp with optional fields stores national_id, weight, chronic_diseases', () async {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final email = 'test_optional_$timestamp@example.com';

      final response = await client.auth.signUp(
        email: email,
        password: 'Test1234!',
        data: {
          'username': 'optional_$timestamp',
          'full_name': 'Optional User',
          'phone': '0555987654',
          'date_of_birth': '2000-01-01',
          'gender': 'female',
          'blood_type': 'A-',
          'city': 'Oran',
          'national_id': '1234567890',
          'weight': '65.5',
          'chronic_diseases': 'Diabetes type 2',
        },
      );

      expect(response.user, isNotNull);

      final profile = await client
          .from('users')
          .select()
          .eq('id', response.user!.id)
          .single();

      expect(profile['national_id'], '1234567890');
      expect(profile['weight'], 65.5);
      expect(profile['chronic_diseases'], 'Diabetes type 2');

      await client.auth.admin.deleteUser(response.user!.id);
    });

    test('updateUserRole sets is_donor flag', () async {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final email = 'test_role_$timestamp@example.com';

      final response = await client.auth.signUp(
        email: email,
        password: 'Test1234!',
        data: {
          'username': 'role_$timestamp',
          'full_name': 'Role User',
          'phone': '0555111222',
          'date_of_birth': '1990-03-20',
          'gender': 'male',
          'blood_type': 'B+',
          'city': 'Constantine',
        },
      );

      expect(response.user, isNotNull);

      await client
          .from('users')
          .update({
            'is_donor': true,
            'updated_at': DateTime.now().toUtc().toIso8601String(),
          })
          .eq('id', response.user!.id);

      final profile = await client
          .from('users')
          .select()
          .eq('id', response.user!.id)
          .single();

      expect(profile['is_donor'], true);
      expect(profile['is_recipient'], false);

      await client.auth.admin.deleteUser(response.user!.id);
    });

    test('missing required metadata causes signUp to fail', () async {
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      expect(
        () async => await client.auth.signUp(
          email: 'test_fail_$timestamp@example.com',
          password: 'Test1234!',
          data: {
            'username': 'incomplete_$timestamp',
          },
        ),
        throwsA(isA<AuthException>()),
      );
    });
  });
}
