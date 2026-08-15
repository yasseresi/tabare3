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
    when(() => dio.options).thenReturn(BaseOptions(baseUrl: 'https://x/api/v1'));
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

  test('listDonationRecords maps the paginated donation history', () async {
    when(() => dio.get<Map<String, dynamic>>(RestPaths.donations)).thenAnswer(
      (_) async => _res(RestPaths.donations, {
        'next': null,
        'results': [
          {'id': 7, 'donor': 42, 'source_type': 'request', 'request': 5, 'patient_name': 'Sara', 'appointment': 11, 'hospital': 140, 'donated_at': '2026-08-14T10:00:00Z', 'bags_deducted': 1},
        ],
      }),
    );

    final list = await source.listDonationRecords();
    final d = list.single;
    expect(d.id, '7');
    expect(d.toEntity().source, DonationSource.request);
    expect(d.units, 1);
    expect(d.requestId, '5');
    expect(d.bloodRequest?.recipient?.fullName, 'Sara');
  });

  test('redeemRequestQr posts the token to the body scan', () async {
    when(() => dio.post<Map<String, dynamic>>(RestPaths.donationScan, data: any(named: 'data')))
        .thenAnswer((_) async => _res(RestPaths.donationScan, {'id': 7, 'donor': 42, 'source_type': 'request', 'donated_at': '2026-08-14T10:00:00Z', 'bags_deducted': 1}));

    final d = await source.redeemRequestQr('https://x/appointments/scan/abc/');
    expect(d.id, '7');
    final body = verify(() => dio.post<Map<String, dynamic>>(RestPaths.donationScan, data: captureAny(named: 'data'))).captured.single as Map<String, dynamic>;
    expect(body['token'], 'https://x/appointments/scan/abc/'); // body variant strips server-side
  });

  test('redeemCampaignQr extracts the bare token from a scanned URL', () async {
    when(() => dio.post<Map<String, dynamic>>(RestPaths.campaignScan('tok9')))
        .thenAnswer((_) async => _res(RestPaths.campaignScan('tok9'), {'id': 8, 'donor': 42, 'source_type': 'campaign', 'campaign': 3, 'campaign_title': 'Drive', 'donated_at': '2026-08-14T10:00:00Z', 'bags_deducted': 1}));

    final d = await source.redeemCampaignQr('https://x/campaigns/scan/tok9/');
    expect(d.campaignId, '3');
    verify(() => dio.post<Map<String, dynamic>>(RestPaths.campaignScan('tok9'))).called(1);
  });

  test('redeemQr routes campaign URLs to the campaign scan', () async {
    when(() => dio.post<Map<String, dynamic>>(RestPaths.campaignScan('c1')))
        .thenAnswer((_) async => _res(RestPaths.campaignScan('c1'), {'id': 8, 'donor': 42, 'source_type': 'campaign', 'donated_at': '2026-08-14T10:00:00Z', 'bags_deducted': 1}));
    when(() => dio.post<Map<String, dynamic>>(RestPaths.donationScan, data: any(named: 'data')))
        .thenAnswer((_) async => _res(RestPaths.donationScan, {'id': 7, 'donor': 42, 'source_type': 'request', 'donated_at': '2026-08-14T10:00:00Z', 'bags_deducted': 1}));

    final campaign = await source.redeemQr('https://x/campaigns/scan/c1/');
    expect(campaign.toEntity().source, DonationSource.campaign);
    final request = await source.redeemQr('https://x/appointments/scan/r1/');
    expect(request.toEntity().source, DonationSource.request);
  });

  test('listAvailableCampaigns maps the array + translates status', () async {
    Future<DonorCampaignStatus> statusFor(String django) async {
      when(() => dio.get<List<dynamic>>(RestPaths.feedCampaigns)).thenAnswer(
        (_) async => _res(RestPaths.feedCampaigns, [
          {
            'id': 3,
            'title': 'Drive',
            'organizer_label': 'جمعية',
            'location_text': 'Hall A',
            'wilaya': {'id': 16, 'name_ar': 'الجزائر'},
            'hospital': 140,
            'status': django,
            'starts_at': '2026-09-01T09:00:00Z',
            'ends_at': '2026-09-01T17:00:00Z',
          },
        ]),
      );
      final list = await source.listAvailableCampaigns();
      return list.single.toEntity().status;
    }

    expect(await statusFor('published'), DonorCampaignStatus.active);
    expect(await statusFor('ended'), DonorCampaignStatus.completed);
    expect(await statusFor('draft'), DonorCampaignStatus.upcoming);
  });

  test('campaign maps organizer/venue/wilaya', () async {
    when(() => dio.get<List<dynamic>>(RestPaths.feedCampaigns)).thenAnswer(
      (_) async => _res(RestPaths.feedCampaigns, [
        {
          'id': 3,
          'title': 'Drive',
          'organizer_label': 'جمعية',
          'location_text': 'Hall A',
          'wilaya': {'id': 16, 'name_ar': 'الجزائر'},
          'hospital': 140,
          'status': 'published',
          'starts_at': '2026-09-01T09:00:00Z',
          'ends_at': '2026-09-01T17:00:00Z',
        },
      ]),
    );

    final c = (await source.listAvailableCampaigns()).single;
    expect(c.organizerName, 'جمعية');
    expect(c.venueName, 'Hall A');
    expect(c.city, 'الجزائر');
    expect(c.wilayaId, 16);
    expect(c.hospitalId, '140');
  });
}
