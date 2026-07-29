import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tabare3/features/profile/data/datasources/profile_local_data_source_impl.dart';
import 'package:tabare3/features/profile/data/models/profile_model.dart';

void main() {
  late ProfileLocalDataSourceImpl dataSource;

  const profileModel = ProfileModel(
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

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    dataSource = ProfileLocalDataSourceImpl();
  });

  group('cacheProfile', () {
    test('should write profile to shared preferences', () async {
      await dataSource.cacheProfile(profileModel);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('CACHED_PROFILE'), isNotNull);
    });
  });

  group('getLastProfile', () {
    test('should return cached profile when present', () async {
      await dataSource.cacheProfile(profileModel);

      final result = await dataSource.getLastProfile();

      expect(result, equals(profileModel));
    });

    test('should return null when no cached profile', () async {
      final result = await dataSource.getLastProfile();

      expect(result, isNull);
    });
  });

  group('clearCache', () {
    test('should remove cached profile', () async {
      await dataSource.cacheProfile(profileModel);
      await dataSource.clearCache();

      final result = await dataSource.getLastProfile();

      expect(result, isNull);
    });
  });
}
