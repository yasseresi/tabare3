import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tabare3/features/requester_home/domain/entities/blood_request_entity.dart';
import 'package:tabare3/features/requester_home/domain/usecases/request_usecases.dart';
import 'package:tabare3/features/requester_home/presentation/bloc/request_detail_bloc.dart';

class MockGetRequestDonors extends Mock implements GetRequestDonors {}

class MockGetCompatibleDonors extends Mock implements GetCompatibleDonors {}

class MockGetRequestInvitations extends Mock implements GetRequestInvitations {}

class MockInviteCompatibleDonor extends Mock implements InviteCompatibleDonor {}

class MockIssueRequestQr extends Mock implements IssueRequestQr {}

void main() {
  late MockGetRequestDonors getDonors;
  late MockGetCompatibleDonors getCandidates;
  late MockGetRequestInvitations getInvitations;
  late MockInviteCompatibleDonor inviteDonor;
  late MockIssueRequestQr issueQr;

  final donor = RequestDonorEntity(
    donorId: 'donor-id',
    fullName: 'متبرع',
    bloodType: 'O+',
    appointmentId: 'appointment-id',
    status: DonationAppointmentStatus.pending,
    scheduledAt: DateTime.utc(2030),
  );
  const candidate = CompatibleDonorEntity(
    donorId: 'candidate-id',
    fullName: 'متبرع متاح',
    bloodType: 'O+',
    wilayaId: 16,
  );
  final qr = IssuedRequestQrEntity(
    token: 'opaque-token',
    expiresAt: DateTime.utc(2030),
  );

  setUpAll(() {
    registerFallbackValue(
      const InviteDonorParams(requestId: 'request-id', donorId: 'candidate-id'),
    );
  });

  setUp(() {
    getDonors = MockGetRequestDonors();
    getCandidates = MockGetCompatibleDonors();
    getInvitations = MockGetRequestInvitations();
    inviteDonor = MockInviteCompatibleDonor();
    issueQr = MockIssueRequestQr();
  });

  RequestDetailBloc buildBloc() => RequestDetailBloc(
    getDonors: getDonors,
    getCompatibleDonors: getCandidates,
    getInvitations: getInvitations,
    inviteDonor: inviteDonor,
    issueQr: issueQr,
  );

  blocTest<RequestDetailBloc, RequestDetailState>(
    'loads privacy-safe donors and compatible candidates',
    setUp: () {
      when(
        () => getDonors('request-id'),
      ).thenAnswer((_) async => Right([donor]));
      when(
        () => getCandidates('request-id'),
      ).thenAnswer((_) async => const Right([candidate]));
      when(
        () => getInvitations('request-id'),
      ).thenAnswer((_) async => const Right([]));
    },
    build: buildBloc,
    act: (bloc) => bloc.add(
      const RequestDetailLoadRequested(
        requestId: 'request-id',
        includeCompatibleDonors: true,
      ),
    ),
    expect: () => [
      const RequestDetailState(status: RequestDetailStatus.loading),
      RequestDetailState(
        status: RequestDetailStatus.loaded,
        donors: [donor],
        compatibleDonors: [candidate],
      ),
    ],
  );

  blocTest<RequestDetailBloc, RequestDetailState>(
    'issues a server-generated expiring QR',
    setUp: () {
      when(() => issueQr('request-id')).thenAnswer((_) async => Right(qr));
    },
    build: buildBloc,
    act: (bloc) =>
        bloc.add(const RequestQrIssueRequested(requestId: 'request-id')),
    expect: () => [
      const RequestDetailState(status: RequestDetailStatus.actionLoading),
      RequestDetailState(status: RequestDetailStatus.loaded, issuedQr: qr),
    ],
  );

  blocTest<RequestDetailBloc, RequestDetailState>(
    'invites a compatible donor and refreshes invitation status',
    setUp: () {
      when(() => inviteDonor(any())).thenAnswer((_) async => const Right(null));
      when(() => getInvitations('request-id')).thenAnswer(
        (_) async => Right([
          DirectInvitationEntity(
            invitationId: 'invitation-id',
            donorId: 'candidate-id',
            fullName: 'متبرع متاح',
            bloodType: 'O+',
            status: DirectInvitationStatus.sent,
            expiresAt: DateTime.utc(2030, 1, 2),
            createdAt: DateTime.utc(2030),
          ),
        ]),
      );
    },
    seed: () => const RequestDetailState(
      status: RequestDetailStatus.loaded,
      compatibleDonors: [candidate],
    ),
    build: buildBloc,
    act: (bloc) => bloc.add(
      const CompatibleDonorInviteRequested(
        requestId: 'request-id',
        donorId: 'candidate-id',
      ),
    ),
    expect: () => [
      const RequestDetailState(
        status: RequestDetailStatus.actionLoading,
        compatibleDonors: [candidate],
      ),
      isA<RequestDetailState>()
          .having((state) => state.status, 'status', RequestDetailStatus.loaded)
          .having(
            (state) => state.invitations.single.status,
            'invitation status',
            DirectInvitationStatus.sent,
          )
          .having(
            (state) => state.compatibleDonors,
            'candidate removed',
            isEmpty,
          ),
    ],
  );
}
