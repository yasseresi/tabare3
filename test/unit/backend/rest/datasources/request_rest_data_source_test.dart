import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tabare3/backend/rest/constants/rest_paths.dart';
import 'package:tabare3/backend/rest/datasources/request_rest_data_source.dart';
import 'package:tabare3/features/requester_home/domain/entities/blood_request_entity.dart';

class MockDio extends Mock implements Dio {}

Response<Map<String, dynamic>> _res(String path, Map<String, dynamic> body) =>
    Response(
      requestOptions: RequestOptions(path: path),
      statusCode: 200,
      data: body,
    );

Map<String, dynamic> _requestJson({
  String status = 'active',
  String requestFor = 'self',
}) => {
  'id': 5,
  'recipient': 42,
  'request_for': requestFor,
  'is_for_someone_else': requestFor == 'other',
  'patient_name': 'Sara',
  'patient_gender': 'female',
  'patient_date_of_birth': '2000-01-01',
  'patient_weight_kg': '60.00',
  'patient_conditions': [
    {'id': 1, 'name': 'السكري'},
  ],
  'hospital': {'id': 140, 'name': 'مستشفى الجزائر', 'name_fr': 'CHU Alger', 'wilaya': 16, 'address': 'x'},
  'blood_type': {'id': 7, 'label': 'O+'},
  'priority': 'urgent',
  'bags_required': 3,
  'bags_filled': 1,
  'deadline': '2026-09-01T00:00:00Z',
  'notes': 'help',
  'status': status,
  'created_at': '2026-08-14T10:00:00Z',
};

void main() {
  late MockDio dio;
  late RequestRestDataSource source;

  setUp(() {
    dio = MockDio();
    source = RequestRestDataSource(dio);
  });

  test('listOwnRequests unwraps the paginated results and maps each', () async {
    when(() => dio.get<Map<String, dynamic>>(RestPaths.requests)).thenAnswer(
      (_) async => _res(RestPaths.requests, {
        'count': 1,
        'next': null,
        'results': [_requestJson()],
      }),
    );

    final list = await source.listOwnRequests();

    expect(list, hasLength(1));
    final r = list.single;
    expect(r.id, '5');
    expect(r.requestedBy, '42');
    expect(r.bloodType, 'O+'); // nested label
    expect(r.urgency, 'urgent'); // priority passthrough
    expect(r.unitsNeeded, 3); // bags_required
    expect(r.unitsFulfilled, 1); // bags_filled
    expect(r.hospital?.nameAr, 'مستشفى الجزائر'); // name → name_ar
    expect(r.hospital?.wilayaId, 16);
  });

  test('translates Django status to the app vocabulary', () async {
    Future<BloodRequestStatus> statusFor(String django) async {
      when(() => dio.get<Map<String, dynamic>>(RestPaths.request('5'))).thenAnswer(
        (_) async => _res(RestPaths.request('5'), _requestJson(status: django)),
      );
      final r = await source.getRequest('5');
      return r.toEntity().status;
    }

    expect(await statusFor('active'), BloodRequestStatus.open);
    expect(await statusFor('completed'), BloodRequestStatus.fulfilled);
    expect(await statusFor('cancelled'), BloodRequestStatus.cancelled);
  });

  test('maps patient block only for someone-else requests', () async {
    when(() => dio.get<Map<String, dynamic>>(RestPaths.request('5'))).thenAnswer(
      (_) async => _res(RestPaths.request('5'), _requestJson(requestFor: 'other')),
    );

    final r = await source.getRequest('5');

    expect(r.toEntity().beneficiaryType, BeneficiaryType.other);
    expect(r.patient?.fullName, 'Sara');
    expect(r.patient?.bloodType, 'O+');
    expect(r.patient?.chronicDiseases, 'السكري');
  });

  test('self request has no patient block', () async {
    when(() => dio.get<Map<String, dynamic>>(RestPaths.request('5'))).thenAnswer(
      (_) async => _res(RestPaths.request('5'), _requestJson()),
    );

    final r = await source.getRequest('5');
    expect(r.patient, isNull);
    expect(r.toEntity().beneficiaryType, BeneficiaryType.self);
  });

  test('write methods still throw until their slice lands', () async {
    expect(() => source.createRequest(
      const RequestDraft(
        hospitalId: '1',
        bloodType: 'O+',
        priority: RequestPriority.normal,
        unitsNeeded: 1,
      ),
    ), throwsA(isA<UnimplementedError>()));
    expect(() => source.listHospitals(), throwsA(isA<UnimplementedError>()));
  });
}
