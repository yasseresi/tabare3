import 'package:flutter_test/flutter_test.dart';
import 'package:tabare3/features/profile/data/datasources/supabase/profile_supabase_data_source.dart';
import 'package:tabare3/features/profile/data/models/profile_model.dart';

void main() {
  const profile = ProfileModel(
    id: 'user-id',
    email: 'user@example.com',
    username: 'user',
    fullName: 'Immutable Name',
    phone: '0550000000',
    dateOfBirth: '2000-01-01',
    gender: 'male',
    nationalId: 'immutable-id',
    bloodType: 'O+',
    weight: 72,
    city: 'الجزائر',
    chronicDiseases: null,
    avatarUrl: 'avatar.png',
    isDonor: true,
    isRecipient: false,
    isActive: false,
  );

  test('profile payload excludes identity and system-owned fields', () {
    final payload = buildProfileUpdatePayload(profile);

    expect(payload, {
      'username': 'user',
      'phone': '0550000000',
      'weight': 72,
      'city': 'الجزائر',
      'chronic_diseases': null,
      'avatar_url': 'avatar.png',
      'is_active': false,
    });
    expect(payload, isNot(contains('full_name')));
    expect(payload, isNot(contains('national_id')));
    expect(payload, isNot(contains('date_of_birth')));
    expect(payload, isNot(contains('gender')));
    expect(payload, isNot(contains('blood_type')));
    expect(payload, isNot(contains('is_available_for_donation')));
    expect(payload, isNot(contains('updated_at')));
  });

  test('profile select exposes the actual account status', () {
    expect(profileSelectColumns, contains('is_active'));
    expect(profileSelectColumns, isNot(contains('is_available_for_donation')));
  });

  group('avatar object name', () {
    // A fixed object name reuses one public URL for every upload, so the image
    // cache and the storage CDN keep serving the previous photo — the new
    // avatar flashes on screen and then reverts to the old one.
    test('changes on every upload so the public URL is never reused', () {
      final first = buildAvatarObjectName(
        extension: 'jpg',
        at: DateTime.fromMillisecondsSinceEpoch(1000),
      );
      final second = buildAvatarObjectName(
        extension: 'jpg',
        at: DateTime.fromMillisecondsSinceEpoch(2000),
      );

      expect(first, isNot(second));
    });

    test('keeps the picked file extension', () {
      final name = buildAvatarObjectName(
        extension: 'png',
        at: DateTime.fromMillisecondsSinceEpoch(1000),
      );

      expect(name, endsWith('.png'));
    });
  });
}
