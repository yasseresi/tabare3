import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tabare3/core/error/failures.dart';
import 'package:tabare3/core/usecases/usecase.dart';
import 'package:tabare3/features/requester_home/domain/entities/blood_request_entity.dart';
import 'package:tabare3/features/requester_home/domain/usecases/request_usecases.dart';
import 'package:tabare3/features/requester_home/presentation/bloc/request_bloc.dart';

class MockGetRecipientRequests extends Mock implements GetRecipientRequests {}

class MockGetHospitals extends Mock implements GetHospitals {}

class MockCreateRecipientRequest extends Mock
    implements CreateRecipientRequest {}

class MockUpdateRecipientRequest extends Mock
    implements UpdateRecipientRequest {}

class MockCancelRecipientRequest extends Mock
    implements CancelRecipientRequest {}

class MockReactivateRecipientRequest extends Mock implements ReactivateRecipientRequest {}

class MockGetRequestDonors extends Mock implements GetRequestDonors {}

void main() {
  late MockGetRecipientRequests getRequests;
  late MockGetHospitals getHospitals;
  late MockCreateRecipientRequest createRequest;
  late MockUpdateRecipientRequest updateRequest;
  late MockCancelRecipientRequest cancelRequest;
  late MockReactivateRecipientRequest reactivateRequest;
  late MockGetRequestDonors getDonors;

  const hospital = HospitalEntity(
    id: 'hospital-id',
    wilayaId: 16,
    nameAr: 'مستشفى',
    isActive: true,
  );
  final request = BloodRequestEntity(
    id: 'request-id',
    requestedBy: 'recipient-id',
    hospital: hospital,
    bloodType: 'O+',
    priority: RequestPriority.normal,
    unitsNeeded: 1,
    unitsFulfilled: 0,
    status: BloodRequestStatus.open,
    createdAt: DateTime.utc(2030),
  );
  const draft = RequestDraft(
    hospitalId: 'hospital-id',
    bloodType: 'O+',
    priority: RequestPriority.normal,
    unitsNeeded: 1,
  );

  RequestBloc buildBloc() => RequestBloc(
    getRequests: getRequests,
    getHospitals: getHospitals,
    createRequest: createRequest,
    updateRequest: updateRequest,
    cancelRequest: cancelRequest,
    reactivateRequest: reactivateRequest,
    getDonors: getDonors,
  );

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(draft);
    registerFallbackValue(
      const UpdateRequestParams(requestId: 'request-id', draft: draft),
    );
    registerFallbackValue(
      const CancelRequestParams(requestId: 'request-id', reason: 'reason'),
    );
  });

  setUp(() {
    getRequests = MockGetRecipientRequests();
    getHospitals = MockGetHospitals();
    createRequest = MockCreateRecipientRequest();
    updateRequest = MockUpdateRecipientRequest();
    cancelRequest = MockCancelRecipientRequest();
    reactivateRequest = MockReactivateRecipientRequest();
    getDonors = MockGetRequestDonors();
  });

  blocTest<RequestBloc, RequestState>(
    'load emits loading then populated state',
    setUp: () {
      when(() => getRequests(any())).thenAnswer((_) async => Right([request]));
      when(
        () => getHospitals(any()),
      ).thenAnswer((_) async => const Right([hospital]));
    },
    build: buildBloc,
    act: (bloc) => bloc.add(const RequestsLoadRequested()),
    expect: () => [
      const RequestState(status: RequestViewStatus.loading),
      RequestState(
        status: RequestViewStatus.loaded,
        requests: [request],
        hospitals: const [hospital],
      ),
    ],
  );

  blocTest<RequestBloc, RequestState>(
    'load emits empty when no requests exist but retains hospitals',
    setUp: () {
      when(() => getRequests(any())).thenAnswer((_) async => const Right([]));
      when(
        () => getHospitals(any()),
      ).thenAnswer((_) async => const Right([hospital]));
    },
    build: buildBloc,
    act: (bloc) => bloc.add(const RequestsLoadRequested()),
    expect: () => [
      const RequestState(status: RequestViewStatus.loading),
      const RequestState(
        status: RequestViewStatus.empty,
        hospitals: [hospital],
      ),
    ],
  );

  blocTest<RequestBloc, RequestState>(
    'load donors maps responders by request id and marks them loaded',
    setUp: () {
      when(() => getRequests(any())).thenAnswer((_) async => Right([request]));
      when(
        () => getHospitals(any()),
      ).thenAnswer((_) async => const Right([hospital]));
      when(() => getDonors('request-id')).thenAnswer(
        (_) async => Right([
          RequestDonorEntity(
            donorId: 'donor-1',
            fullName: 'متبرع',
            bloodType: 'O+',
            appointmentId: 'appt-1',
            status: DonationAppointmentStatus.completed,
            scheduledAt: DateTime.utc(2030, 1, 1),
            completedAt: DateTime.utc(2030, 1, 2),
          ),
        ]),
      );
    },
    build: buildBloc,
    act: (bloc) async {
      bloc.add(const RequestsLoadRequested());
      await bloc.stream.firstWhere(
        (state) => state.status == RequestViewStatus.loaded,
      );
      bloc.add(const RequestDonorsLoadRequested());
    },
    skip: 2,
    expect: () => [
      isA<RequestState>()
          .having((s) => s.donorsLoaded, 'donorsLoaded', isTrue)
          .having(
            (s) => s.donorsByRequestId['request-id']?.single.donorId,
            'donor id',
            'donor-1',
          ),
    ],
  );

  blocTest<RequestBloc, RequestState>(
    'create prepends the backend request and emits success',
    setUp: () {
      when(() => createRequest(draft)).thenAnswer((_) async => Right(request));
    },
    build: buildBloc,
    seed: () => const RequestState(
      status: RequestViewStatus.empty,
      hospitals: [hospital],
    ),
    act: (bloc) => bloc.add(const RequestCreateSubmitted(draft)),
    expect: () => [
      const RequestState(
        status: RequestViewStatus.submitting,
        hospitals: [hospital],
      ),
      RequestState(
        status: RequestViewStatus.success,
        requests: [request],
        hospitals: const [hospital],
      ),
    ],
  );

  blocTest<RequestBloc, RequestState>(
    'create exposes a typed validation failure',
    setUp: () {
      when(
        () => createRequest(draft),
      ).thenAnswer((_) async => const Left(ValidationFailure()));
    },
    build: buildBloc,
    act: (bloc) => bloc.add(const RequestCreateSubmitted(draft)),
    expect: () => [
      const RequestState(status: RequestViewStatus.submitting),
      const RequestState(
        status: RequestViewStatus.failure,
        errorMessage: 'البيانات المدخلة غير صالحة',
      ),
    ],
  );
}
