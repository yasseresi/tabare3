import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:tabare3/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:tabare3/features/auth/data/models/user_model.dart';
import 'package:tabare3/features/auth/domain/repositories/auth_repository.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

class MockUserResponse extends Mock implements UserResponse {}

class MockAuthResponse extends Mock implements AuthResponse {}

class MockPostgrestClient extends Mock implements PostgrestClient {}

class MockPostgrestQueryBuilder extends Mock implements PostgrestQueryBuilder {}

class MockPostgrestFilterBuilder extends Mock
    implements PostgrestFilterBuilder<Map<String, dynamic>> {}

class MockUser extends Mock implements User {}

const testUserJson = {
  'id': 'user-123',
  'email': 'test@test.com',
  'username': 'testuser',
  'fullName': 'Test User',
  'isDonor': false,
  'isRecipient': false,
  'bloodType': 'O+',
};

void main() {
  late AuthRemoteDataSourceImpl dataSource;
  late MockSupabaseClient mockClient;

  setUpAll(() {
    registerFallbackValue(
      SignupParams(
        username: 'fallback',
        fullName: 'fallback',
        email: 'fallback@test.com',
        password: 'fallback',
        phone: '0000',
        dateOfBirth: DateTime(2000),
        gender: 'male',
        bloodType: 'O+',
        city: 'fallback',
      ),
    );
  });

  setUp(() {
    mockClient = MockSupabaseClient();
    dataSource = AuthRemoteDataSourceImpl(client: mockClient);
  });

  test('UserModel.fromJson creates correct model', () {
    final model = UserModel.fromJson(testUserJson);

    expect(model.id, 'user-123');
    expect(model.email, 'test@test.com');
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
