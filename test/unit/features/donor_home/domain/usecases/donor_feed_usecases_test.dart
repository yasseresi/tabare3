import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tabare3/core/error/failures.dart';
import 'package:tabare3/core/usecases/usecase.dart';
import 'package:tabare3/features/donor_home/domain/entities/donor_feed_entity.dart';
import 'package:tabare3/features/donor_home/domain/repositories/donor_feed_repository.dart';
import 'package:tabare3/features/donor_home/domain/usecases/donor_feed_usecases.dart';

class MockDonorFeedRepository extends Mock implements DonorFeedRepository {}

void main() {
  late MockDonorFeedRepository repository;
  final now = DateTime.utc(2030, 1, 10, 12);
  final feed = DonorFeedEntity(
    availability: const DonorAvailabilityEntity(
      userId: 'donor-1',
      isAccountActive: true,
      isAvailableForDonation: true,
      isDonor: true,
      bloodType: 'O+',
      wilayaId: 16,
      totalDonationsCount: 2,
    ),
    compatibleRequests: const [],
    availableCampaigns: const [],
    appointments: const [],
  );
  final appointment = DonorAppointmentEntity(
    id: 'appointment-1',
    donorId: 'donor-1',
    scheduledAt: now.add(const Duration(days: 1)),
    status: DonationAppointmentStatus.confirmed,
    createdAt: now,
  );
  final record = DonationRecordEntity(
    id: 'record-1',
    donorId: 'donor-1',
    source: DonationSource.request,
    donatedAt: now,
    units: 1,
    requestId: 'request-1',
    appointmentId: 'appointment-1',
  );

  setUp(() {
    repository = MockDonorFeedRepository();
  });

  test('GetDonorFeed forwards the repository result', () async {
    when(() => repository.getFeed()).thenAnswer((_) async => Right(feed));

    final result = await GetDonorFeed(repository)(NoParams());

    expect(result, Right<Failure, DonorFeedEntity>(feed));
  });

  test('SetDonorAvailability forwards the requested value', () async {
    when(() => repository.setAvailability(false)).thenAnswer(
      (_) async => const Right(
        DonorAvailabilityEntity(
          userId: 'donor-1',
          isAccountActive: true,
          isAvailableForDonation: false,
          isDonor: true,
          bloodType: 'O+',
          wilayaId: 16,
          totalDonationsCount: 2,
        ),
      ),
    );

    final result = await SetDonorAvailability(repository)(false);

    expect(
      result
          .getOrElse(() => throw StateError('failure'))
          .isAvailableForDonation,
      false,
    );
    verify(() => repository.setAvailability(false)).called(1);
  });

  test('AcceptBloodRequest validates future scheduling before I/O', () async {
    final result = await AcceptBloodRequest(repository, now: () => now)(
      AcceptBloodRequestParams(
        requestId: 'request-1',
        scheduledAt: now.subtract(const Duration(minutes: 1)),
      ),
    );

    expect(
      result.fold((failure) => failure, (_) => null),
      isA<ValidationFailure>(),
    );
    verifyNever(
      () => repository.acceptBloodRequest(
        requestId: any(named: 'requestId'),
        scheduledAt: any(named: 'scheduledAt'),
      ),
    );
  });

  test('AcceptBloodRequest trims ids and delegates valid input', () async {
    when(
      () => repository.acceptBloodRequest(
        requestId: 'request-1',
        scheduledAt: now.add(const Duration(hours: 2)),
      ),
    ).thenAnswer((_) async => Right(appointment));

    final result = await AcceptBloodRequest(repository, now: () => now)(
      AcceptBloodRequestParams(
        requestId: ' request-1 ',
        scheduledAt: now.add(const Duration(hours: 2)),
      ),
    );

    expect(result, Right<Failure, DonorAppointmentEntity>(appointment));
  });

  test('CancelDonationAppointment requires a non-empty reason', () async {
    final result = await CancelDonationAppointment(repository)(
      const CancelDonationAppointmentParams(
        appointmentId: 'appointment-1',
        reason: '   ',
      ),
    );

    expect(
      result.fold((failure) => failure, (_) => null),
      isA<ValidationFailure>(),
    );
    verifyNever(
      () => repository.cancelAppointment(
        appointmentId: any(named: 'appointmentId'),
        reason: any(named: 'reason'),
      ),
    );
  });

  test(
    'redeem QR use cases reject empty tokens and delegate valid ones',
    () async {
      final redeemRequest = RedeemRequestDonation(repository);
      final redeemCampaign = RedeemCampaignDonation(repository);

      expect(
        await redeemRequest('   '),
        isA<Left<Failure, DonationRecordEntity>>(),
      );
      expect(
        await redeemCampaign('   '),
        isA<Left<Failure, DonationRecordEntity>>(),
      );

      when(
        () => repository.redeemRequestQr('request-token'),
      ).thenAnswer((_) async => Right(record));
      when(
        () => repository.redeemCampaignQr('campaign-token'),
      ).thenAnswer((_) async => Right(record));

      expect(await redeemRequest(' request-token '), Right(record));
      expect(await redeemCampaign(' campaign-token '), Right(record));
    },
  );
}
