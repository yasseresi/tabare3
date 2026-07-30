import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tabare3/core/usecases/usecase.dart';
import 'package:tabare3/features/donor_home/domain/entities/donor_feed_entity.dart';
import 'package:tabare3/features/donor_home/domain/usecases/donor_feed_usecases.dart';
import 'package:tabare3/features/donor_home/presentation/bloc/donor_feed_bloc.dart';

class MockGetDonorFeed extends Mock implements GetDonorFeed {}

class MockGetDonationRecords extends Mock implements GetDonationRecords {}

class MockAcceptBloodRequest extends Mock implements AcceptBloodRequest {}

class MockCancelDonationAppointment extends Mock
    implements CancelDonationAppointment {}

class MockRedeemRequestDonation extends Mock implements RedeemRequestDonation {}

class MockRedeemCampaignDonation extends Mock
    implements RedeemCampaignDonation {}

class MockSetDonorAvailability extends Mock implements SetDonorAvailability {}

void main() {
  late MockGetDonorFeed getFeed;
  late MockGetDonationRecords getRecords;
  late MockAcceptBloodRequest acceptRequest;
  late MockCancelDonationAppointment cancelAppointment;
  late MockRedeemRequestDonation redeemRequestQr;
  late MockRedeemCampaignDonation redeemCampaignQr;
  late MockSetDonorAvailability setAvailability;

  final hospital = DonorHospitalEntity(
    id: 'hospital-1',
    wilayaId: 16,
    nameAr: 'مستشفى معتمد',
    isActive: true,
  );
  final request = DonorBloodRequestEntity(
    id: 'request-1',
    requestedBy: 'recipient-1',
    hospital: hospital,
    bloodType: 'A+',
    priority: DonorRequestPriority.urgent,
    unitsNeeded: 3,
    unitsFulfilled: 1,
    status: DonorBloodRequestStatus.open,
    createdAt: DateTime.utc(2026, 7, 30),
  );
  final appointment = DonorAppointmentEntity(
    id: 'appointment-1',
    donorId: 'donor-1',
    scheduledAt: DateTime.utc(2026, 8, 2),
    status: DonationAppointmentStatus.pending,
    createdAt: DateTime.utc(2026, 7, 30),
  );
  final record = DonationRecordEntity(
    id: 'record-1',
    donorId: 'donor-1',
    source: DonationSource.request,
    requestId: request.id,
    donatedAt: DateTime.utc(2026, 7, 1),
    units: 1,
  );
  final feed = DonorFeedEntity(
    availability: const DonorAvailabilityEntity(
      userId: 'donor-1',
      isAccountActive: true,
      isAvailableForDonation: true,
      isDonor: true,
      bloodType: 'O-',
      wilayaId: 16,
      totalDonationsCount: 4,
    ),
    compatibleRequests: [request],
    availableCampaigns: const [],
    appointments: [appointment],
  );

  DonorFeedBloc buildBloc() => DonorFeedBloc(
    getFeed: getFeed,
    getRecords: getRecords,
    acceptRequest: acceptRequest,
    cancelAppointment: cancelAppointment,
    redeemRequestQr: redeemRequestQr,
    redeemCampaignQr: redeemCampaignQr,
    setAvailability: setAvailability,
  );

  void stubLoad() {
    when(() => getFeed(any())).thenAnswer((_) async => Right(feed));
    when(() => getRecords(any())).thenAnswer((_) async => Right([record]));
  }

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(
      AcceptBloodRequestParams(
        requestId: request.id,
        scheduledAt: DateTime.utc(2026, 8, 2),
      ),
    );
    registerFallbackValue(
      const CancelDonationAppointmentParams(
        appointmentId: 'appointment-1',
        reason: 'تعذر الحضور',
      ),
    );
  });

  setUp(() {
    getFeed = MockGetDonorFeed();
    getRecords = MockGetDonationRecords();
    acceptRequest = MockAcceptBloodRequest();
    cancelAppointment = MockCancelDonationAppointment();
    redeemRequestQr = MockRedeemRequestDonation();
    redeemCampaignQr = MockRedeemCampaignDonation();
    setAvailability = MockSetDonorAvailability();
  });

  blocTest<DonorFeedBloc, DonorFeedState>(
    'loads the server-filtered donor feed and donation records',
    build: () {
      stubLoad();
      return buildBloc();
    },
    act: (bloc) => bloc.add(const DonorFeedRequested()),
    expect: () => [
      const DonorFeedLoading(),
      DonorFeedLoaded(feed: feed, records: [record]),
    ],
  );

  blocTest<DonorFeedBloc, DonorFeedState>(
    'updates manual donor availability and refreshes eligibility',
    build: () {
      stubLoad();
      when(
        () => setAvailability(any()),
      ).thenAnswer((_) async => Right(feed.availability));
      return buildBloc();
    },
    seed: () => DonorFeedLoaded(feed: feed, records: [record]),
    act: (bloc) => bloc.add(const DonorAvailabilityChanged(false)),
    expect: () => [
      DonorFeedLoaded(feed: feed, records: [record], isMutating: true),
      const DonorFeedLoading(),
      DonorFeedLoaded(
        feed: feed,
        records: [record],
        lastMutation: DonorFeedMutation.availabilityChanged,
      ),
    ],
    verify: (_) => verify(() => setAvailability(false)).called(1),
  );

  blocTest<DonorFeedBloc, DonorFeedState>(
    'accepts a compatible request and refreshes server state',
    build: () {
      stubLoad();
      when(
        () => acceptRequest(any()),
      ).thenAnswer((_) async => Right(appointment));
      return buildBloc();
    },
    seed: () => DonorFeedLoaded(feed: feed, records: [record]),
    act: (bloc) => bloc.add(
      DonorRequestAccepted(
        requestId: request.id,
        scheduledAt: DateTime.utc(2026, 8, 2),
      ),
    ),
    expect: () => [
      DonorFeedLoaded(feed: feed, records: [record], isMutating: true),
      const DonorFeedLoading(),
      DonorFeedLoaded(
        feed: feed,
        records: [record],
        lastMutation: DonorFeedMutation.requestAccepted,
      ),
    ],
    verify: (_) {
      final params =
          verify(() => acceptRequest(captureAny())).captured.single
              as AcceptBloodRequestParams;
      expect(params.requestId, request.id);
    },
  );

  blocTest<DonorFeedBloc, DonorFeedState>(
    'redeems a request QR and refreshes records',
    build: () {
      stubLoad();
      when(() => redeemRequestQr(any())).thenAnswer((_) async => Right(record));
      return buildBloc();
    },
    seed: () => DonorFeedLoaded(feed: feed, records: const []),
    act: (bloc) => bloc.add(const DonorRequestQrRedeemed('request-token')),
    expect: () => [
      DonorFeedLoaded(feed: feed, records: const [], isMutating: true),
      const DonorFeedLoading(),
      DonorFeedLoaded(
        feed: feed,
        records: [record],
        lastMutation: DonorFeedMutation.donationRecorded,
      ),
    ],
  );
}
