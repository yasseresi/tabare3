import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tabare3/backend/rest/rest_paginator.dart';

class MockDio extends Mock implements Dio {}

Response<Map<String, dynamic>> _res(String path, Map<String, dynamic> body) =>
    Response(requestOptions: RequestOptions(path: path), statusCode: 200, data: body);

void main() {
  late MockDio dio;

  setUp(() {
    dio = MockDio();
    when(() => dio.options).thenReturn(BaseOptions(baseUrl: 'https://api.test/api/v1'));
  });

  test('accumulates same-origin pages', () async {
    const p2 = 'https://api.test/api/v1/x/?page=2';
    when(() => dio.get<Map<String, dynamic>>('/x/')).thenAnswer(
      (_) async => _res('/x/', {'next': p2, 'results': [{'id': 1}]}),
    );
    when(() => dio.get<Map<String, dynamic>>(p2)).thenAnswer(
      (_) async => _res(p2, {'next': null, 'results': [{'id': 2}]}),
    );

    final rows = await fetchAllPages(dio, '/x/');
    expect(rows.map((r) => r['id']), [1, 2]);
  });

  test('does NOT follow a next pointing at a foreign host (token-leak guard)', () async {
    const evil = 'https://evil.tld/api/v1/x/?page=2';
    when(() => dio.get<Map<String, dynamic>>('/x/')).thenAnswer(
      (_) async => _res('/x/', {'next': evil, 'results': [{'id': 1}]}),
    );

    final rows = await fetchAllPages(dio, '/x/');

    expect(rows.map((r) => r['id']), [1]); // stopped, page 1 only
    verifyNever(() => dio.get<Map<String, dynamic>>(evil)); // never hit evil host
  });
}
