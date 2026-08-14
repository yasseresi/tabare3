import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tabare3/backend/rest/constants/rest_paths.dart';
import 'package:tabare3/backend/rest/datasources/donor_feed_rest_data_source.dart';
import 'package:tabare3/features/donor_home/domain/entities/donor_feed_entity.dart';

class MockDio extends Mock implements Dio {}

Response<T> _res<T>(String path, T body) => Response<T>(
  requestOptions: RequestOptions(path: path),
  statusCode: 200,
  data: body,
);

Map<String, dynamic> _profile({String status = 'active'}) => {
  'id': 42,
  'mode': 'donor',
  'status': status,
  'blood_type': {'label': 'O+'},
  'wilaya': {'id': 16, 'name_ar': 'الجزائر'},
  'cooldown_until': null,
  'last_donation_at': null,
  'donations_count': 3,
};

Map<String, dynamic> _feedRequest() => {
  'id': 5,
  'recipient': 9,
  'display_patient_name': 'Sara',
  'hospital': {'id': 140, 'name': 'مستشفى الجزائر', 'wilaya': 16, 'is_active': true},
  'blood_type': {'label': 'O+'},
  'priority': 'urgent',
  'bags_required': 3,
  'bags_filled': 1,
  'status': 'active',
  'deadline': '2026-09-01',
  'created_at': '2026-08-14T10:00:00Z',
};

void main() {
  late MockDio dio;
  late DonorFeedRestDataSource source;

  setUp(() {
    dio = MockDio();
    source = DonorFeedRestDataSource(dio);
  });

  test('getAvailability maps the profile', () async {
    when(() => dio.get<Map<String, dynamic>>(RestPaths.profile))
        .thenAnswer((_) async => _res(RestPaths.profile, _profile()));

    final a = await source.getAvailability();

    expect(a.userId, '42');
    expect(a.isAvailableForDonation, isTrue); // status active
    expect(a.isDonor, isTrue);
    expect(a.bloodType, 'O+');
    expect(a.wilayaId, 16);
    expect(a.totalDonationsCount, 3);
  });

  test('setAvailability toggles only when the state must change', () async {
    when(() => dio.get<Map<String, dynamic>>(RestPaths.profile))
        .thenAnswer((_) async => _res(RestPaths.profile, _profile(status: 'active')));
    when(() => dio.post<Map<String, dynamic>>(RestPaths.toggleStatus))
        .thenAnswer((_) async => _res(RestPaths.toggleStatus, _profile(status: 'inactive')));

    // Already active → asking for available makes no toggle.
    await source.setAvailability(true);
    verifyNever(() => dio.post<Map<String, dynamic>>(RestPaths.toggleStatus));

    // Active → asking to become unavailable flips once.
    await source.setAvailability(false);
    verify(() => dio.post<Map<String, dynamic>>(RestPaths.toggleStatus)).called(1);
  });

  test('listCompatibleRequests maps the plain array + status vocab', () async {
    when(() => dio.get<List<dynamic>>(RestPaths.feedRequests))
        .thenAnswer((_) async => _res(RestPaths.feedRequests, [_feedRequest()]));

    final list = await source.listCompatibleRequests();

    expect(list, hasLength(1));
    final r = list.single;
    expect(r.id, '5');
    expect(r.patientName, 'Sara');
    expect(r.hospital.nameAr, 'مستشفى الجزائر');
    expect(r.bloodType, 'O+');
    expect(r.toEntity().status, DonorBloodRequestStatus.open); // active → open
    expect(r.toEntity().priority, DonorRequestPriority.urgent);
  });

  test('listAppointments maps the paginated viewset + status vocab', () async {
    Future<DonationAppointmentStatus> statusFor(String django) async {
      when(() => dio.get<Map<String, dynamic>>(RestPaths.appointments)).thenAnswer(
        (_) async => _res(RestPaths.appointments, {
          'next': null,
          'results': [
            {'id': 11, 'donor': 42, 'request': 5, 'blood_type': {'label': 'O+'}, 'status': django, 'created_at': '2026-08-14T10:00:00Z'},
          ],
        }),
      );
      final list = await source.listAppointments();
      return list.single.toEntity().status; // must not throw
    }

    expect(await statusFor('pending'), DonationAppointmentStatus.pending);
    expect(await statusFor('cancelled_by_donor'), DonationAppointmentStatus.cancelled);
    expect(await statusFor('auto_cancelled'), DonationAppointmentStatus.cancelled);
    expect(await statusFor('completed'), DonationAppointmentStatus.completed);
  });

  test('acceptBloodRequest posts to accept with no body', () async {
    when(() => dio.post<Map<String, dynamic>>(RestPaths.requestAccept('5'))).thenAnswer(
      (_) async => _res(RestPaths.requestAccept('5'),
          {'id': 11, 'donor': 42, 'request': 5, 'status': 'pending', 'created_at': '2026-08-14T10:00:00Z'}),
    );

    final appt = await source.acceptBloodRequest(requestId: '5', scheduledAt: DateTime(2026, 9, 1));
    expect(appt.id, '11');
    expect(appt.bloodRequest?.id, '5');
    verify(() => dio.post<Map<String, dynamic>>(RestPaths.requestAccept('5'))).called(1);
  });

  test('cancelAppointment posts to the cancel endpoint', () async {
    when(() => dio.post<Map<String, dynamic>>(RestPaths.appointmentCancel('11'))).thenAnswer(
      (_) async => _res(RestPaths.appointmentCancel('11'),
          {'id': 11, 'donor': 42, 'status': 'cancelled_by_donor', 'created_at': '2026-08-14T10:00:00Z', 'cancelled_at': '2026-08-14T11:00:00Z'}),
    );

    final appt = await source.cancelAppointment(appointmentId: '11', reason: 'busy');
    expect(appt.toEntity().status, DonationAppointmentStatus.cancelled);
  });

  test('remaining methods still throw', () async {
    expect(() => source.listAvailableCampaigns(), throwsA(isA<UnimplementedError>()));
    expect(() => source.listDonationRecords(), throwsA(isA<UnimplementedError>()));
    expect(() => source.redeemRequestQr('t'), throwsA(isA<UnimplementedError>()));
  });
}
