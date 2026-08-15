import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tabare3/core/error/failures.dart';
import 'package:tabare3/core/usecases/usecase.dart';
import 'package:tabare3/features/donor_home/data/models/donor_feed_models.dart';
import 'package:tabare3/features/donor_home/data/repositories/donor_feed_repository_impl.dart';
import 'package:tabare3/features/donor_home/domain/entities/donor_feed_entity.dart';
import 'package:tabare3/features/donor_home/domain/repositories/donor_feed_repository.dart';
import 'package:tabare3/features/donor_home/domain/usecases/donor_feed_usecases.dart';

import '../../../support/fake_backend.dart';

/// Donor-side mirror of the requester lifecycle slice: real use-cases →
/// real [DonorFeedRepositoryImpl] → fake data source. Pins the donor model→
/// entity mapping and the [ErrorHandler] path a Supabase→REST swap replaces.
///
/// Models are built with `fromJson` on PostgREST-shaped payloads so the
/// JSON→model→entity parse chain (availability, compatible requests,
/// appointments, donation records) is under test.
void main() {
  late FakeDonorFeedRemoteDataSource dataSource;
  late DonorFeedRepository repository;
  final now = DateTime.utc(2030, 1, 10, 12);

  Map<String, dynamic> availabilityJson({bool available = true}) => {
    'id': 'donor-1',
    'is_active': true,
    'is_available_for_donation': available,
    'is_donor': true,
    'blood_type': 'O+',
    'wilaya_id': 16,
    'total_donations_count': 2,
  };

  Map<String, dynamic> compatibleRequestJson({
    String id = 'req-1',
    String status = 'open',
  }) => {
    'id': id,
    'requested_by': 'recipient-1',
    'hospital': {
      'id': 'hospital-1',
      'wilaya_id': 16,
      'name_ar': 'مستشفى',
      'is_active': true,
    },
    'blood_type': 'O+',
    'urgency': 'urgent',
    'units_needed': 2,
    'units_fulfilled': 0,
    'status': status,
    'created_at': '2030-01-09T00:00:00.000Z',
  };

  Map<String, dynamic> appointmentJson({String status = 'confirmed'}) => {
    'id': 'appointment-1',
    'donor_id': 'donor-1',
    'scheduled_at': '2030-01-11T12:00:00.000Z',
    'status': status,
    'created_at': '2030-01-10T12:00:00.000Z',
  };

  Map<String, dynamic> recordJson() => {
    'id': 'record-1',
    'donor_id': 'donor-1',
    'source': 'request',
    'request_id': 'req-1',
    'appointment_id': 'appointment-1',
    'donated_at': '2030-01-11T12:30:00.000Z',
    'units': 1,
  };

  setUp(() {
    dataSource = FakeDonorFeedRemoteDataSource();
    repository = DonorFeedRepositoryImpl(remoteDataSource: dataSource);
  });

  test('sets availability and maps the returned state', () async {
    when(() => dataSource.setAvailability(false)).thenAnswer(
      (_) async =>
          DonorAvailabilityModel.fromJson(availabilityJson(available: false)),
    );

    final result = await SetDonorAvailability(repository)(false);

    expect(
      result
          .getOrElse(() => throw StateError('expected Right'))
          .isAvailableForDonation,
      isFalse,
    );
    verify(() => dataSource.setAvailability(false)).called(1);
  });

  test('lists compatible requests across mixed states', () async {
    when(() => dataSource.listCompatibleRequests()).thenAnswer(
      (_) async => [
        DonorBloodRequestModel.fromJson(compatibleRequestJson(id: 'open-1')),
        DonorBloodRequestModel.fromJson(
          compatibleRequestJson(id: 'done-1', status: 'fulfilled'),
        ),
      ],
    );

    final result = await GetCompatibleDonationRequests(repository)(NoParams());

    final requests = result.getOrElse(() => const []);
    expect(requests.map((r) => r.status), [
      DonorBloodRequestStatus.open,
      DonorBloodRequestStatus.fulfilled,
    ]);
  });

  test('accept validation short-circuits before touching the data source', () async {
    final result = await AcceptBloodRequest(repository, now: () => now)(
      AcceptBloodRequestParams(
        requestId: 'req-1',
        scheduledAt: now.subtract(const Duration(minutes: 1)),
      ),
    );

    expect(result.isLeft(), isTrue);
    verifyNever(
      () => dataSource.acceptBloodRequest(
        requestId: any(named: 'requestId'),
        scheduledAt: any(named: 'scheduledAt'),
      ),
    );
  });

  test('accepts a request and produces a confirmed appointment', () async {
    final scheduledAt = now.add(const Duration(days: 1));
    when(
      () => dataSource.acceptBloodRequest(
        requestId: 'req-1',
        scheduledAt: scheduledAt,
      ),
    ).thenAnswer((_) async => DonorAppointmentModel.fromJson(appointmentJson()));

    final result = await AcceptBloodRequest(repository, now: () => now)(
      AcceptBloodRequestParams(requestId: ' req-1 ', scheduledAt: scheduledAt),
    );

    final appointment =
        result.getOrElse(() => throw StateError('expected Right'));
    expect(appointment.status, DonationAppointmentStatus.confirmed);
    verify(
      () => dataSource.acceptBloodRequest(
        requestId: 'req-1',
        scheduledAt: scheduledAt,
      ),
    ).called(1);
  });

  test('cancels an appointment and surfaces the cancelled state', () async {
    when(
      () => dataSource.cancelAppointment(
        appointmentId: 'appointment-1',
        reason: 'sick',
      ),
    ).thenAnswer(
      (_) async =>
          DonorAppointmentModel.fromJson(appointmentJson(status: 'cancelled')),
    );

    final result = await CancelDonationAppointment(repository)(
      const CancelDonationAppointmentParams(
        appointmentId: '  appointment-1  ',
        reason: '  sick  ',
      ),
    );

    expect(
      result.getOrElse(() => throw StateError('expected Right')).status,
      DonationAppointmentStatus.cancelled,
    );
    verify(
      () => dataSource.cancelAppointment(
        appointmentId: 'appointment-1',
        reason: 'sick',
      ),
    ).called(1);
  });

  test('redeems a QR token into a donation record', () async {
    when(
      () => dataSource.redeemQr('scan-token'),
    ).thenAnswer((_) async => DonationRecordModel.fromJson(recordJson()));

    final result = await RedeemDonation(repository)(' scan-token ');

    final record = result.getOrElse(() => throw StateError('expected Right'));
    expect(record.source, DonationSource.request);
    expect(record.units, 1);
    verify(() => dataSource.redeemQr('scan-token')).called(1);
  });

  test('a thrown data-source error becomes a ServerFailure', () async {
    when(() => dataSource.getAvailability()).thenThrow(Exception('boom'));

    final result = await GetDonorAvailability(repository)(NoParams());

    expect(result.fold((f) => f, (_) => null), isA<ServerFailure>());
  });

  test('a malformed payload becomes a ParseFailure, not a crash', () async {
    // `blood_type` is required in the model but null here — mirrors a column a
    // migrated backend forgot to project.
    final broken = availabilityJson()..remove('blood_type');
    when(
      () => dataSource.getAvailability(),
    ).thenAnswer((_) async => DonorAvailabilityModel.fromJson(broken));

    final result = await GetDonorAvailability(repository)(NoParams());

    expect(result.fold((f) => f, (_) => null), isA<ParseFailure>());
  });
}
