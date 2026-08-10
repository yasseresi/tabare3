import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:tabare3/core/error/failures.dart';
import 'package:tabare3/features/donor_home/data/datasources/donor_feed_remote_data_source.dart';
import 'package:tabare3/features/donor_home/data/models/donor_feed_models.dart';
import 'package:tabare3/features/donor_home/data/repositories/donor_feed_repository_impl.dart';
import 'package:tabare3/features/donor_home/domain/entities/donor_feed_entity.dart';

class MockDonorFeedRemoteDataSource extends Mock
    implements DonorFeedRemoteDataSource {}

void main() {
  late MockDonorFeedRemoteDataSource dataSource;
  late DonorFeedRepositoryImpl repository;

  final availability = DonorAvailabilityModel(
    userId: 'donor-1',
    isAccountActive: true,
    isAvailableForDonation: true,
    isDonor: true,
    bloodType: 'O+',
    wilayaId: 16,
    totalDonationsCount: 2,
  );
  const hospital = DonorHospitalModel(
    id: 'hospital-1',
    wilayaId: 16,
    nameAr: 'مستشفى',
    isActive: true,
  );
  final request = DonorBloodRequestModel(
    id: 'request-1',
    requestedBy: 'recipient-1',
    hospital: hospital,
    bloodType: 'A+',
    urgency: 'normal',
    unitsNeeded: 1,
    unitsFulfilled: 0,
    status: 'open',
    createdAt: DateTime.utc(2030, 1, 10),
  );
  final campaign = DonorCampaignModel(
    id: 'campaign-1',
    organizerName: 'جمعية',
    title: 'حملة',
    venueName: 'قاعة',
    city: 'الجزائر',
    wilayaId: 16,
    hospitalId: 'hospital-1',
    bloodTypesNeeded: const ['O+'],
    status: 'active',
    startsAt: DateTime.utc(2030, 1, 10, 8),
    endsAt: DateTime.utc(2030, 1, 10, 18),
    publishedAt: DateTime.utc(2030, 1, 9),
    createdAt: DateTime.utc(2030, 1, 8),
  );
  final appointment = DonorAppointmentModel(
    id: 'appointment-1',
    donorId: 'donor-1',
    scheduledAt: DateTime.utc(2030, 1, 11),
    status: 'confirmed',
    createdAt: DateTime.utc(2030, 1, 10),
  );
  final record = DonationRecordModel(
    id: 'record-1',
    donorId: 'donor-1',
    source: 'request',
    requestId: 'request-1',
    appointmentId: 'appointment-1',
    donatedAt: DateTime.utc(2030, 1, 12),
    units: 1,
  );

  setUp(() {
    dataSource = MockDonorFeedRemoteDataSource();
    repository = DonorFeedRepositoryImpl(remoteDataSource: dataSource);
  });

  test('getFeed aggregates datasource models into a domain snapshot', () async {
    when(
      () => dataSource.getAvailability(),
    ).thenAnswer((_) async => availability);
    when(
      () => dataSource.listCompatibleRequests(),
    ).thenAnswer((_) async => [request]);
    when(
      () => dataSource.listAvailableCampaigns(),
    ).thenAnswer((_) async => [campaign]);
    when(
      () => dataSource.listAppointments(),
    ).thenAnswer((_) async => [appointment]);

    final result = await repository.getFeed();

    expect(result.isRight(), true);
    expect(
      result
          .getOrElse(() => throw StateError('failure'))
          .appointments
          .single
          .id,
      'appointment-1',
    );
  });

  test('mutation and record methods map models and failures', () async {
    when(() => dataSource.setAvailability(false)).thenAnswer(
      (_) async => DonorAvailabilityModel(
        userId: availability.userId,
        isAccountActive: availability.isAccountActive,
        isAvailableForDonation: false,
        isDonor: availability.isDonor,
        bloodType: availability.bloodType,
        wilayaId: availability.wilayaId,
        totalDonationsCount: availability.totalDonationsCount,
      ),
    );
    when(
      () => dataSource.acceptBloodRequest(
        requestId: 'request-1',
        scheduledAt: DateTime.utc(2030, 1, 11),
      ),
    ).thenAnswer((_) async => appointment);
    when(
      () => dataSource.cancelAppointment(
        appointmentId: 'appointment-1',
        reason: 'ازدحام',
      ),
    ).thenAnswer((_) async => appointment);
    when(
      () => dataSource.listDonationRecords(),
    ).thenAnswer((_) async => [record]);
    when(
      () => dataSource.redeemRequestQr('token'),
    ).thenAnswer((_) async => record);
    when(
      () => dataSource.listAvailableCampaigns(),
    ).thenThrow(Exception('offline'));

    expect(
      (await repository.setAvailability(
        false,
      )).getOrElse(() => throw StateError('failure')).isAvailableForDonation,
      false,
    );
    expect(
      (await repository.acceptBloodRequest(
        requestId: 'request-1',
        scheduledAt: DateTime.utc(2030, 1, 11),
      )).getOrElse(() => throw StateError('failure')).id,
      'appointment-1',
    );
    expect(
      (await repository.cancelAppointment(
        appointmentId: 'appointment-1',
        reason: 'ازدحام',
      )).getOrElse(() => throw StateError('failure')).id,
      'appointment-1',
    );
    expect(
      (await repository.listDonationRecords())
          .getOrElse(() => const <DonationRecordEntity>[])
          .single
          .id,
      'record-1',
    );
    expect(
      (await repository.redeemRequestQr(
        'token',
      )).getOrElse(() => throw StateError('failure')).id,
      'record-1',
    );
    expect((await repository.listAvailableCampaigns()).isLeft(), true);
  });

  test(
    'getFeed maps a dropped connection to NetworkFailure, not the generic default',
    () async {
      // Regression for the home-feed "unexpected error" screen: postgrest
      // throws http.ClientException (not SocketException) when connectivity
      // drops mid-request.
      when(() => dataSource.getAvailability()).thenThrow(
        http.ClientException('Failed host lookup: example.supabase.co'),
      );

      final result = await repository.getFeed();

      expect(result.isLeft(), true);
      final failure = result.fold((f) => f, (_) => throw StateError('right'));
      expect(failure, isA<NetworkFailure>());
    },
  );
}
