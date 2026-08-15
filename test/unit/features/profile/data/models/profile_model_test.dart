import 'package:flutter_test/flutter_test.dart';
import 'package:tabare3/features/profile/data/models/profile_model.dart';
import 'package:tabare3/features/profile/domain/entities/profile_entity.dart';

void main() {
  group('ProfileModel', () {
    const json = {
      'id': 'user-1',
      'email': 'test@example.com',
      'username': 'testuser',
      'full_name': 'Ahmed Test',
      'phone': '0555123456',
      'date_of_birth': '1995-05-12',
      'gender': 'male',
      'national_id': '10101010101010101010',
      'blood_type': 'O+',
      'weight': 80.0,
      'city': 'Algiers',
      'chronic_diseases': null,
      'avatar_url': 'https://example.com/avatar.png',
      'is_donor': true,
      'is_recipient': false,
      'is_active': true,
    };

    test('should parse JSON from Supabase users row', () {
      final model = ProfileModel.fromJson(json);

      expect(model.id, 'user-1');
      expect(model.fullName, 'Ahmed Test');
      expect(model.weight, 80.0);
      expect(model.avatarUrl, 'https://example.com/avatar.png');
      expect(model.isDonor, true);
      expect(model.isActive, true);
    });

    test('should convert to entity', () {
      final model = ProfileModel.fromJson(json);
      final entity = model.toEntity();

      expect(entity, isA<ProfileEntity>());
      expect(entity.id, model.id);
      expect(entity.weight, model.weight);
      expect(entity.isActive, model.isActive);
    });

    test('should handle null optional fields', () {
      final model = ProfileModel.fromJson({
        ...json,
        'national_id': null,
        'weight': null,
        'chronic_diseases': null,
        'avatar_url': null,
      });

      expect(model.nationalId, isNull);
      expect(model.weight, isNull);
      expect(model.chronicDiseases, isNull);
      expect(model.avatarUrl, isNull);
    });
  });
}
