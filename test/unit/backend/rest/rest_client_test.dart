import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabare3/backend/rest/rest_client.dart';
import 'package:tabare3/backend/rest/token_store.dart';

class FakeTokenStore implements TokenStore {
  @override
  Future<void> clear() async {}
  @override
  Future<String?> readAccess() async => null;
  @override
  Future<String?> readRefresh() async => null;
  @override
  Future<void> save({required String access, required String refresh}) async {}
}

void main() {
  test('build() is idempotent — no duplicate interceptors on repeat calls', () {
    final dio = Dio();
    final factory = RestClientFactory(
      baseUrl: 'https://x/api/v1',
      dio: dio,
      tokenStore: FakeTokenStore(),
    );

    factory.build();
    final countAfterFirst = dio.interceptors.length;
    factory.build();
    final countAfterSecond = dio.interceptors.length;

    expect(countAfterSecond, countAfterFirst); // not stacked
    expect(countAfterFirst, greaterThan(0)); // auth interceptor present
  });
}
