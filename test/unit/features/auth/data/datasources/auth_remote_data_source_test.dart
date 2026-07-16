import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:tabare3/features/auth/data/models/user_model.dart';
import 'package:tabare3/features/auth/domain/repositories/auth_repository.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

const testUserJson = {
  'id': 'user-123',
  'email': 'testuser@tabara3.dz',
  'username': 'testuser',
  'full_name': 'Test User',
  'is_donor': false,
  'is_recipient': false,
  'blood_type': 'O+',
};

void main() {
  setUpAll(() {
    registerFallbackValue(SignupParams(
      username: 'fallback',
      fullName: 'fallback',
      password: 'fallback',
      phone: '0000',
      dateOfBirth: DateTime(2000),
      gender: 'male',
      bloodType: 'O+',
      city: 'fallback',
    ));
  });

  test('UserModel.fromJson creates correct model', () {
    final model = UserModel.fromJson(testUserJson);

    expect(model.id, 'user-123');
    expect(model.email, 'testuser@tabara3.dz');
    expect(model.username, 'testuser');
    expect(model.fullName, 'Test User');
    expect(model.bloodType, 'O+');
  });

  test('UserModel.toEntity creates correct entity', () {
    final model = UserModel.fromJson(testUserJson);
    final entity = model.toEntity();

    expect(entity.id, model.id);
    expect(entity.email, model.email);
    expect(entity.username, model.username);
    expect(entity.fullName, model.fullName);
    expect(entity.bloodType, model.bloodType);
  });
}
