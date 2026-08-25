import 'package:flutter_test/flutter_test.dart';
import 'package:tabare3/core/constants/algerian_wilayas.dart';
import 'package:tabare3/core/session/profile_user_mapper.dart';
import 'package:tabare3/features/profile/domain/entities/profile_entity.dart';

void main() {
  const base = ProfileEntity(
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
    city: '',
    chronicDiseases: null,
    avatarUrl: null,
    isDonor: true,
    isRecipient: false,
    isActive: true,
  );

  group('profileToSessionUser', () {
    test('maps a canonical wilaya name to its 1-based id', () {
      final user = profileToSessionUser(base.copyWith(city: 'الجزائر'));
      expect(user.wilayaId, algerianWilayas.indexOf('الجزائر') + 1);
      expect(user.id, base.id);
      expect(user.fullName, base.fullName);
      expect(user.bloodType, base.bloodType);
      expect(user.isDonor, isTrue);
      expect(user.isRecipient, isFalse);
    });

    test('trims surrounding whitespace before resolving', () {
      final user = profileToSessionUser(base.copyWith(city: ' وهران '));
      expect(user.wilayaId, algerianWilayas.indexOf('وهران') + 1);
    });

    test('yields null wilayaId for an unknown name', () {
      final user = profileToSessionUser(base.copyWith(city: 'Algiers'));
      expect(user.wilayaId, isNull);
    });

    test('yields null wilayaId for an empty city', () {
      final user = profileToSessionUser(base.copyWith(city: ''));
      expect(user.wilayaId, isNull);
    });
  });
}
