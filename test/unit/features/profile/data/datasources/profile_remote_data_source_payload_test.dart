import 'package:flutter_test/flutter_test.dart';
import 'package:tabare3/features/profile/data/datasources/profile_remote_data_source_impl.dart';
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
      'date_of_birth': '2000-01-01',
      'gender': 'male',
      'blood_type': 'O+',
      'weight': 72,
      'city': 'الجزائر',
      'chronic_diseases': null,
      'avatar_url': 'avatar.png',
      'is_available_for_donation': false,
    });
    expect(payload, isNot(contains('full_name')));
    expect(payload, isNot(contains('national_id')));
    expect(payload, isNot(contains('is_active')));
    expect(payload, isNot(contains('updated_at')));
  });

  test(
    'profile select aliases donation availability to the legacy model key',
    () {
      expect(
        profileSelectColumns,
        contains('is_active:is_available_for_donation'),
      );
    },
  );
}
