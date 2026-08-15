import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tabare3/backend/rest/constants/rest_paths.dart';
import 'package:tabare3/backend/rest/reference/reference_remote_data_source.dart';

class MockDio extends Mock implements Dio {}

Response<List<dynamic>> _ok(String path, List<dynamic> body) => Response(
  requestOptions: RequestOptions(path: path),
  statusCode: 200,
  data: body,
);

void main() {
  late MockDio dio;
  late ReferenceRestDataSource source;

  setUp(() {
    dio = MockDio();
    source = ReferenceRestDataSource(dio);
  });

  test('listWilayas hits the wilayas path and maps the array', () async {
    when(() => dio.get<List<dynamic>>(RestPaths.refWilayas)).thenAnswer(
      (_) async => _ok(RestPaths.refWilayas, [
        {'id': 16, 'code': '16', 'name_ar': 'الجزائر', 'name_fr': 'Alger', 'name_en': 'Algiers'},
      ]),
    );

    final wilayas = await source.listWilayas();

    expect(wilayas, hasLength(1));
    expect(wilayas.single.id, 16);
    expect(wilayas.single.nameAr, 'الجزائر');
  });

  test('listBloodTypes hits the blood-types path and maps the array', () async {
    when(() => dio.get<List<dynamic>>(RestPaths.refBloodTypes)).thenAnswer(
      (_) async => _ok(RestPaths.refBloodTypes, [
        {'id': 7, 'label': 'O+', 'abo': 'O', 'rh': '+'},
      ]),
    );

    final types = await source.listBloodTypes();

    expect(types.single.id, 7);
    expect(types.single.label, 'O+');
  });

  test('tolerates a null body', () async {
    when(() => dio.get<List<dynamic>>(RestPaths.refWilayas)).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: RestPaths.refWilayas),
        statusCode: 200,
      ),
    );

    expect(await source.listWilayas(), isEmpty);
  });
}
