import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tabare3/backend/rest/constants/rest_paths.dart';
import 'package:tabare3/backend/rest/datasources/request_rest_data_source.dart';
import 'package:tabare3/backend/rest/reference/reference_models.dart';
import 'package:tabare3/backend/rest/reference/reference_remote_data_source.dart';
import 'package:tabare3/backend/rest/reference/reference_resolver.dart';
import 'package:tabare3/features/requester_home/domain/entities/blood_request_entity.dart';

class MockDio extends Mock implements Dio {}

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
    source = RequestRestDataSource(
      dio,
      reference: ReferenceResolver(FakeReferenceDataSource()),
    );
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

  test('listHospitals follows pagination and maps every page', () async {
    const page2 = 'https://x/api/v1/references/hospitals/?page=2';
    when(() => dio.get<Map<String, dynamic>>(RestPaths.refHospitals)).thenAnswer(
      (_) async => _res(RestPaths.refHospitals, {
        'count': 2,
        'next': page2,
        'results': [
          {'id': 140, 'name': 'مستشفى الجزائر', 'wilaya': 16, 'is_active': true},
        ],
      }),
    );
    when(() => dio.get<Map<String, dynamic>>(page2)).thenAnswer(
      (_) async => _res(page2, {
        'count': 2,
        'next': null,
        'results': [
          {'id': 141, 'name': 'مستشفى وهران', 'wilaya': 31, 'is_active': false},
        ],
      }),
    );

    final hospitals = await source.listHospitals();

    expect(hospitals, hasLength(2)); // both pages
    expect(hospitals[0].id, '140');
    expect(hospitals[0].nameAr, 'مستشفى الجزائر');
    expect(hospitals[1].wilayaId, 31);
    expect(hospitals[1].isActive, isFalse);
  });

  test('createRequest maps the draft to the Django body (blood label→id)', () async {
    when(() => dio.post<Map<String, dynamic>>(RestPaths.requests, data: any(named: 'data')))
        .thenAnswer((_) async => _res(RestPaths.requests, _requestJson()));

    await source.createRequest(
      RequestDraft(
        hospitalId: '140',
        bloodType: 'O+',
        priority: RequestPriority.urgent,
        unitsNeeded: 2,
        neededBy: DateTime(2026, 9, 1),
        notes: 'help',
      ),
    );

    final body = verify(
      () => dio.post<Map<String, dynamic>>(RestPaths.requests, data: captureAny(named: 'data')),
    ).captured.single as Map<String, dynamic>;
    expect(body['request_for'], 'self');
    expect(body['hospital'], 140); // string id → int
    expect(body['blood_type'], 7); // label → id
    expect(body['priority'], 'urgent');
    expect(body['bags_required'], 2);
    expect(body['deadline'], '2026-09-01');
  });

  test('cancelRequest posts the reason and maps the result', () async {
    when(() => dio.post<Map<String, dynamic>>(RestPaths.requestCancel('5'), data: any(named: 'data')))
        .thenAnswer((_) async => _res(RestPaths.requestCancel('5'), _requestJson(status: 'cancelled')));

    final r = await source.cancelRequest(requestId: '5', reason: 'no longer needed');

    final body = verify(
      () => dio.post<Map<String, dynamic>>(RestPaths.requestCancel('5'), data: captureAny(named: 'data')),
    ).captured.single as Map<String, dynamic>;
    expect(body['reason'], 'no longer needed');
    expect(r.toEntity().status, BloodRequestStatus.cancelled);
  });

  test('updateRequest PATCHes the editable fields only', () async {
    when(() => dio.patch<Map<String, dynamic>>(RestPaths.request('5'), data: any(named: 'data')))
        .thenAnswer((_) async => _res(RestPaths.request('5'), _requestJson()));

    await source.updateRequest(
      requestId: '5',
      draft: const RequestDraft(
        hospitalId: '140',
        bloodType: 'O+',
        priority: RequestPriority.semiUrgent,
        unitsNeeded: 4,
      ),
    );

    final body = verify(
      () => dio.patch<Map<String, dynamic>>(RestPaths.request('5'), data: captureAny(named: 'data')),
    ).captured.single as Map<String, dynamic>;
    expect(body['hospital'], 140);
    expect(body['priority'], 'semi_urgent');
    expect(body['bags_required'], 4);
    expect(body.containsKey('blood_type'), isFalse); // not editable via PATCH
  });

  test('donor-matching / invite / QR still throw until their task lands', () async {
    expect(() => source.listCompatibleDonors('5'), throwsA(isA<UnimplementedError>()));
    expect(() => source.inviteDonor(requestId: '5', donorId: '9'),
        throwsA(isA<UnimplementedError>()));
    expect(() => source.issueRequestQr('5'), throwsA(isA<UnimplementedError>()));
  });
}
