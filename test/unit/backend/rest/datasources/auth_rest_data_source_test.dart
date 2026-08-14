import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tabare3/backend/rest/constants/rest_paths.dart';
import 'package:tabare3/backend/rest/datasources/auth_rest_data_source.dart';
import 'package:tabare3/backend/rest/reference/reference_models.dart';
import 'package:tabare3/backend/rest/reference/reference_remote_data_source.dart';
import 'package:tabare3/backend/rest/reference/reference_resolver.dart';
import 'package:tabare3/backend/rest/token_store.dart';
import 'package:tabare3/features/auth/domain/repositories/auth_repository.dart';

class MockDio extends Mock implements Dio {}

class FakeTokenStore implements TokenStore {
  String? access;
  String? refresh;
  bool cleared = false;
  @override
  Future<void> save({required String access, required String refresh}) async {
    this.access = access;
    this.refresh = refresh;
  }

  @override
  Future<String?> readAccess() async => access;
  @override
  Future<String?> readRefresh() async => refresh;
  @override
  Future<void> clear() async {
    cleared = true;
    access = null;
    refresh = null;
  }
}

class FakeReferenceDataSource implements ReferenceRemoteDataSource {
  @override
  Future<List<WilayaRef>> listWilayas() async => const [
    WilayaRef(id: 16, code: '16', nameAr: 'الجزائر', nameFr: 'Alger', nameEn: 'Algiers'),
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
  'mode': 'donor',
  'blood_type': {'id': 7, 'label': 'O+', 'abo': 'O', 'rh': '+'},
};

void main() {
  late MockDio dio;
  late FakeTokenStore tokens;
  late AuthRestDataSource source;

  setUpAll(() {
    registerFallbackValue(RequestOptions(path: '/'));
  });

  setUp(() {
    dio = MockDio();
    tokens = FakeTokenStore();
    source = AuthRestDataSource(
      dio,
      tokenStore: tokens,
      reference: ReferenceResolver(FakeReferenceDataSource()),
    );
  });

  void stubProfile() {
    when(
      () => dio.get<Map<String, dynamic>>(RestPaths.profile),
    ).thenAnswer((_) async => _res(RestPaths.profile, _profileJson));
  }

  group('signIn', () {
    test('bridges username to email, persists tokens, maps the profile', () async {
      when(
        () => dio.post<Map<String, dynamic>>(RestPaths.login, data: any(named: 'data')),
      ).thenAnswer(
        (_) async => _res(RestPaths.login, {'access': 'a1', 'refresh': 'r1'}),
      );
      stubProfile();

      final user = await source.signIn(username: 'ahmed', password: 'pw');

      final captured = verify(
        () => dio.post<Map<String, dynamic>>(
          RestPaths.login,
          data: captureAny(named: 'data'),
        ),
      ).captured.single as Map<String, dynamic>;
      expect(captured['email'], 'ahmed@tabara3.dz');
      expect(tokens.access, 'a1');
      expect(tokens.refresh, 'r1');
      // profile mapping
      expect(user.id, '42');
      expect(user.username, 'ahmed'); // email → username reversed
      expect(user.bloodType, 'O+'); // nested blood_type.label
      expect(user.isDonor, isTrue);
      expect(user.isRecipient, isFalse);
    });
  });

  group('signUp', () {
    test('maps names/city/blood to ids; uses tokens from the register response', () async {
      when(
        () => dio.post<Map<String, dynamic>>(RestPaths.register, data: any(named: 'data')),
      ).thenAnswer(
        (_) async => _res(RestPaths.register, {
          'user': _profileJson,
          'access': 'a1',
          'refresh': 'r1',
        }),
      );

      final user = await source.signUp(
        params: SignupParams(
          username: 'ahmed',
          fullName: 'Ahmed Ben Ali',
          password: 'pw',
          phone: '0555123456',
          dateOfBirth: DateTime(1990, 3, 7),
          gender: 'male',
          bloodType: 'O+',
          city: 'الجزائر',
          weight: 72,
        ),
      );

      final body = verify(
        () => dio.post<Map<String, dynamic>>(
          RestPaths.register,
          data: captureAny(named: 'data'),
        ),
      ).captured.single as Map<String, dynamic>;

      expect(body['first_name'], 'Ahmed');
      expect(body['last_name'], 'Ben Ali');
      expect(body['email'], 'ahmed@tabara3.dz');
      expect(body['wilaya'], 16); // resolved id
      expect(body['blood_type'], 7); // resolved id
      expect(body['gender'], 'male');
      expect(body['date_of_birth'], '1990-03-07');
      expect(body['weight_kg'], '72.0');
      expect(body['password_confirm'], 'pw');

      // Tokens came from register; no extra login round-trip.
      expect(tokens.access, 'a1');
      expect(user.username, 'ahmed');
      verifyNever(
        () => dio.post<Map<String, dynamic>>(RestPaths.login, data: any(named: 'data')),
      );
    });
  });

  group('isUsernameAvailable', () {
    test('queries email-available with the bridged email', () async {
      when(
        () => dio.get<Map<String, dynamic>>(
          RestPaths.emailAvailable,
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => _res(RestPaths.emailAvailable, {'available': true}),
      );

      expect(await source.isUsernameAvailable('ahmed'), isTrue);

      final q = verify(
        () => dio.get<Map<String, dynamic>>(
          RestPaths.emailAvailable,
          queryParameters: captureAny(named: 'queryParameters'),
        ),
      ).captured.single as Map<String, dynamic>;
      expect(q['email'], 'ahmed@tabara3.dz');
    });
  });

  group('session', () {
    test('getCurrentUser returns null when no token is stored', () async {
      expect(await source.getCurrentUser(), isNull);
      verifyNever(() => dio.get<Map<String, dynamic>>(RestPaths.profile));
    });

    test('getCurrentUser fetches the profile when a token exists', () async {
      tokens.access = 'a1';
      stubProfile();
      final user = await source.getCurrentUser();
      expect(user?.username, 'ahmed');
    });

    test('signOut clears the token store', () async {
      await source.signOut();
      expect(tokens.cleared, isTrue);
    });
  });
}
