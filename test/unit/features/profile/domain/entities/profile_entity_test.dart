import 'package:flutter_test/flutter_test.dart';
import 'package:tabare3/features/profile/domain/entities/profile_entity.dart';

void main() {
  group('ProfileEntity', () {
    const entity = ProfileEntity(
      id: 'user-1',
      email: 'test@example.com',
      username: 'testuser',
      fullName: 'Ahmed Test',
      phone: '0555123456',
      dateOfBirth: '1995-05-12',
      gender: 'male',
      nationalId: '10101010101010101010',
      bloodType: 'O+',
      weight: 80,
      city: 'Algiers',
      chronicDiseases: null,
      avatarUrl: null,
      isDonor: true,
      isRecipient: false,
      isActive: true,
    );

    test('should hold all profile fields', () {
      expect(entity.id, 'user-1');
      expect(entity.fullName, 'Ahmed Test');
      expect(entity.isDonor, true);
      expect(entity.isRecipient, false);
      expect(entity.isActive, true);
    });

    test('copyWith updates fields immutably', () {
      final updated = entity.copyWith(
        fullName: 'Updated Name',
        weight: 85,
        isActive: false,
      );

      expect(updated.fullName, 'Updated Name');
      expect(updated.weight, 85);
      expect(updated.isActive, false);
      expect(updated.phone, entity.phone);
    });

    test('copyWith can null optional fields', () {
      final cleared = entity.copyWith(nationalId: null, weight: null);

      expect(cleared.nationalId, isNull);
      expect(cleared.weight, isNull);
    });

    test('equality works for identical values', () {
      const same = ProfileEntity(
        id: 'user-1',
        email: 'test@example.com',
        username: 'testuser',
        fullName: 'Ahmed Test',
        phone: '0555123456',
        dateOfBirth: '1995-05-12',
        gender: 'male',
        nationalId: '10101010101010101010',
        bloodType: 'O+',
        weight: 80,
        city: 'Algiers',
        chronicDiseases: null,
        avatarUrl: null,
        isDonor: true,
        isRecipient: false,
        isActive: true,
      );

      expect(entity, same);
    });
  });
}
