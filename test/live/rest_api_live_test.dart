import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabare3/backend/rest/constants/rest_paths.dart';
import 'package:tabare3/backend/rest/datasources/auth_rest_data_source.dart';

const _baseUrl = String.fromEnvironment('REST_LIVE_BASE_URL');
const _username = String.fromEnvironment('REST_LIVE_USERNAME');
const _password = String.fromEnvironment('REST_LIVE_PASSWORD');

void main() {
  final hasBaseUrl = _baseUrl.startsWith('https://');
  final hasCredentials = _username.isNotEmpty && _password.isNotEmpty;

  Dio liveClient() => Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
    ),
  );

  test(
    'live REST references satisfy the app contract',
    () async {
      final response = await liveClient().get<List<dynamic>>(
        RestPaths.refBloodTypes,
      );

      expect(response.statusCode, 200);
      expect(response.data, isNotEmpty);
      expect(
        response.data!.first,
        isA<Map<String, dynamic>>()
            .having((row) => row['id'], 'id', isA<num>())
            .having((row) => row['label'], 'label', isA<String>()),
      );
    },
    skip: hasBaseUrl
        ? false
        : 'Set REST_LIVE_BASE_URL to run the live Django contract tests.',
  );

  test(
    'live REST login, profile, and refresh contracts stay compatible',
    () async {
      final dio = liveClient();
      final login = await dio.post<Map<String, dynamic>>(
        RestPaths.login,
        data: {'email': usernameToEmail(_username), 'password': _password},
      );
      final access = login.data?['access'];
      final refresh = login.data?['refresh'];
      expect(
        access,
        isA<String>().having((token) => token, 'access', isNotEmpty),
      );
      expect(
        refresh,
        isA<String>().having((token) => token, 'refresh', isNotEmpty),
      );

      final profile = await dio.get<Map<String, dynamic>>(
        RestPaths.profile,
        options: Options(headers: {'authorization': 'Bearer $access'}),
      );
      expect(profile.statusCode, 200);
      expect(profile.data?['id'], isNotNull);
      expect(profile.data?['mode'], anyOf('donor', 'recipient'));
      expect(profile.data?['blood_type'], isA<Map<String, dynamic>>());

      final refreshed = await dio.post<Map<String, dynamic>>(
        RestPaths.refresh,
        data: {'refresh': refresh},
      );
      expect(refreshed.data?['access'], isA<String>());
    },
    skip: hasBaseUrl && hasCredentials
        ? false
        : 'Set REST_LIVE_BASE_URL, REST_LIVE_USERNAME, and REST_LIVE_PASSWORD.',
  );
}
