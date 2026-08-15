import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tabare3/backend/rest/constants/rest_paths.dart';
import 'package:tabare3/backend/rest/datasources/profile_rest_data_source.dart';
import 'package:tabare3/backend/rest/rest_error_mapper.dart'
    show RestValidationException;
import 'package:tabare3/backend/rest/reference/reference_models.dart';
import 'package:tabare3/backend/rest/reference/reference_remote_data_source.dart';
import 'package:tabare3/backend/rest/reference/reference_resolver.dart';
import 'package:tabare3/features/profile/data/models/profile_model.dart';

class MockDio extends Mock implements Dio {}

class FakeReferenceDataSource implements ReferenceRemoteDataSource {
  @override
  Future<List<WilayaRef>> listWilayas() async => const [
    WilayaRef(
      id: 16,
      code: '16',
      nameAr: 'الجزائر',
      nameFr: 'Alger',
      nameEn: 'Algiers',
    ),
  ];
  @override
  Future<List<BloodTypeRef>> listBloodTypes() async => const [
    BloodTypeRef(id: 7, label: 'O+'),
  ];
}

Response<Map<String, dynamic>> _res(String path, Map<String, dynamic> body) =>
    Response(
      requestOptions: RequestOptions(path: path),
      statusCode: 200,
      data: body,
    );

const _profileJson = {
  'id': 42,
  'email': 'ahmed@tabara3.dz',
  'full_name': 'Ahmed Ben Ali',
  'phone': '0555123456',
  'date_of_birth': '1990-03-07',
  'gender': 'male',
  'mode': 'donor',
  'status': 'active',
  'weight_kg': '72.00',
  'wilaya': {'id': 16, 'name_ar': 'الجزائر'},
  'blood_type': {'id': 7, 'label': 'O+'},
};

void main() {
  late MockDio dio;
  late ProfileRestDataSource source;

  setUp(() {
    dio = MockDio();
    source = ProfileRestDataSource(
      dio,
      reference: ReferenceResolver(FakeReferenceDataSource()),
    );
  });

  test('getProfile maps nested UserProfile onto ProfileModel', () async {
    when(
      () => dio.get<Map<String, dynamic>>(RestPaths.profile),
    ).thenAnswer((_) async => _res(RestPaths.profile, _profileJson));

    final p = await source.getProfile();

    expect(p.id, '42');
    expect(p.username, 'ahmed');
    expect(p.city, 'الجزائر'); // wilaya.name_ar
    expect(p.bloodType, 'O+'); // blood_type.label
    expect(p.weight, 72.0);
    expect(p.isDonor, isTrue);
    expect(p.isActive, isTrue); // status == active
    expect(p.avatarUrl, isNull); // deferred
  });

  test('updateProfile PATCHes with city/blood resolved to ids', () async {
    when(
      () => dio.patch<Map<String, dynamic>>(
        RestPaths.profile,
        data: any(named: 'data'),
      ),
    ).thenAnswer((_) async => _res(RestPaths.profile, _profileJson));

    await source.updateProfile(
      const ProfileModel(
        id: '42',
        email: 'ahmed@tabara3.dz',
        username: 'ahmed',
        fullName: 'Ahmed Ben Ali',
        phone: '0555123456',
        dateOfBirth: '1990-03-07',
        gender: 'male',
        bloodType: 'O+',
        weight: 72,
        city: 'الجزائر',
      ),
    );

    final body =
        verify(
              () => dio.patch<Map<String, dynamic>>(
                RestPaths.profile,
                data: captureAny(named: 'data'),
              ),
            ).captured.single
            as Map<String, dynamic>;

    expect(body['wilaya'], 16);
    expect(body['blood_type'], 7);
    expect(body['weight_kg'], '72.0');
    expect(body['phone'], '0555123456');
  });

  test('changeRole posts switch-mode and maps the echoed profile', () async {
    when(
      () => dio.post<Map<String, dynamic>>(
        RestPaths.switchMode,
        data: any(named: 'data'),
      ),
    ).thenAnswer((_) async => _res(RestPaths.switchMode, _profileJson));

    final p = await source.changeRole(isDonor: true, isRecipient: false);

    final body =
        verify(
              () => dio.post<Map<String, dynamic>>(
                RestPaths.switchMode,
                data: captureAny(named: 'data'),
              ),
            ).captured.single
            as Map<String, dynamic>;
    expect(body['mode'], 'donor');
    expect(p.isDonor, isTrue);
  });

  test(
    'setAccountStatus posts toggle-status and maps the server profile',
    () async {
      final inactiveProfile = {..._profileJson, 'status': 'inactive'};
      when(
        () => dio.post<Map<String, dynamic>>(RestPaths.toggleStatus),
      ).thenAnswer((_) async => _res(RestPaths.toggleStatus, inactiveProfile));

      final profile = await source.setAccountStatus(false);

      verify(
        () => dio.post<Map<String, dynamic>>(RestPaths.toggleStatus),
      ).called(1);
      expect(profile.isActive, isFalse);
    },
  );

  test('uploadAvatar surfaces an unsupported-operation error', () async {
    expect(
      () => source.uploadAvatar('/tmp/x.png'),
      throwsA(isA<UnsupportedRestOperation>()),
    );
  });

  test(
    'updateProfile fails fast (no PATCH) when the wilaya is unknown',
    () async {
      expect(
        () => source.updateProfile(
          const ProfileModel(
            id: '42',
            email: 'ahmed@tabara3.dz',
            username: 'ahmed',
            fullName: 'Ahmed Ben Ali',
            phone: '0555123456',
            dateOfBirth: '1990-03-07',
            gender: 'male',
            bloodType: 'O+',
            weight: 72,
            city: 'مدينة غير معروفة', // not in reference data
          ),
        ),
        throwsA(isA<RestValidationException>()),
      );
      verifyNever(
        () => dio.patch<Map<String, dynamic>>(
          RestPaths.profile,
          data: any(named: 'data'),
        ),
      );
    },
  );

  test(
    'updateProfile fails fast (no PATCH) when the blood type is unknown',
    () async {
      expect(
        () => source.updateProfile(
          const ProfileModel(
            id: '42',
            email: 'ahmed@tabara3.dz',
            username: 'ahmed',
            fullName: 'Ahmed Ben Ali',
            phone: '0555123456',
            dateOfBirth: '1990-03-07',
            gender: 'male',
            bloodType: 'ZZ', // valid city, unresolvable blood type
            weight: 72,
            city: 'الجزائر',
          ),
        ),
        throwsA(isA<RestValidationException>()),
      );
      verifyNever(
        () => dio.patch<Map<String, dynamic>>(
          RestPaths.profile,
          data: any(named: 'data'),
        ),
      );
    },
  );

  test('getProfile joins known + custom conditions into free text', () async {
    when(() => dio.get<Map<String, dynamic>>(RestPaths.profile)).thenAnswer(
      (_) async => _res(RestPaths.profile, {
        ..._profileJson,
        'conditions': [
          {'id': 1, 'name_ar': 'السكري'},
        ],
        'chronic_conditions': ['حساسية'],
      }),
    );

    final p = await source.getProfile();
    expect(p.chronicDiseases, 'السكري، حساسية');
  });

  test(
    'updateProfile sends free-text chronic diseases as custom_conditions',
    () async {
      when(
        () => dio.patch<Map<String, dynamic>>(
          RestPaths.profile,
          data: any(named: 'data'),
        ),
      ).thenAnswer((_) async => _res(RestPaths.profile, _profileJson));

      await source.updateProfile(
        const ProfileModel(
          id: '42',
          email: 'ahmed@tabara3.dz',
          username: 'ahmed',
          fullName: 'Ahmed Ben Ali',
          phone: '0555123456',
          dateOfBirth: '1990-03-07',
          gender: 'male',
          bloodType: 'O+',
          weight: 72,
          city: 'الجزائر',
          chronicDiseases: 'السكري، حساسية',
        ),
      );

      final body =
          verify(
                () => dio.patch<Map<String, dynamic>>(
                  RestPaths.profile,
                  data: captureAny(named: 'data'),
                ),
              ).captured.single
              as Map<String, dynamic>;
      expect(body['custom_conditions'], ['السكري', 'حساسية']);
      expect(body['condition_ids'], isEmpty);
    },
  );
}
