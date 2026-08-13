import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tabare3/core/error/failures.dart';
import 'package:tabare3/core/usecases/usecase.dart';
import 'package:tabare3/features/requester_home/data/models/request_models.dart';
import 'package:tabare3/features/requester_home/data/repositories/request_repository_impl.dart';
import 'package:tabare3/features/requester_home/domain/entities/blood_request_entity.dart';
import 'package:tabare3/features/requester_home/domain/repositories/request_repository.dart';
import 'package:tabare3/features/requester_home/domain/usecases/request_usecases.dart';

import '../../../support/fake_backend.dart';

/// Slice integration test: real use-cases → real [RequestRepositoryImpl] →
/// fake data source. Unlike the use-case unit tests (which mock the whole
/// repository), this exercises the repository's model→entity mapping and the
/// [ErrorHandler] path — the exact seam a Supabase→REST migration replaces.
///
/// Models are built with [BloodRequestModel.fromJson] using PostgREST-shaped
/// payloads, so the JSON→model→entity parse chain is under test too. When the
/// custom backend lands, its data source must keep this green.
void main() {
  late FakeRequestRemoteDataSource dataSource;
  late RequestRepository repository;
  final now = DateTime.utc(2030);

  Map<String, dynamic> requestJson({
    String id = 'req-1',
    String beneficiaryType = 'self',
    Map<String, dynamic>? patient,
    String status = 'open',
    int unitsNeeded = 1,
    int unitsFulfilled = 0,
  }) => {
    'id': id,
    'requested_by': 'user-1',
    'hospital': {
      'id': 'hospital-1',
      'wilaya_id': 16,
      'name_ar': 'مستشفى',
      'is_active': true,
    },
    'beneficiary_type': beneficiaryType,
    'patient': patient,
    'blood_type': 'O+',
    'urgency': 'normal',
    'units_needed': unitsNeeded,
    'units_fulfilled': unitsFulfilled,
    'status': status,
    'created_at': '2030-01-02T00:00:00.000Z',
  };

  final patientJson = <String, dynamic>{
    'full_name': 'مريض',
    'national_id': '123456789012345678',
    'blood_type': 'O+',
    'weight': 70.0,
    'gender': 'male',
    'date_of_birth': '1990-01-01',
  };

  final selfDraft = RequestDraft(
    hospitalId: 'hospital-1',
    bloodType: 'O+',
    priority: RequestPriority.normal,
    unitsNeeded: 1,
    neededBy: now.add(const Duration(days: 1)),
  );

  final otherDraft = selfDraft.copyWith(
    beneficiaryType: BeneficiaryType.other,
    patient: const PatientDraft(
      fullName: 'مريض',
      nationalId: '123456789012345678',
      bloodType: 'O+',
      weight: 70,
      gender: 'male',
      dateOfBirth: '1990-01-01',
    ),
  );

  setUpAll(() {
    registerFallbackValue(selfDraft);
  });

  setUp(() {
    dataSource = FakeRequestRemoteDataSource();
    repository = RequestRepositoryImpl(remoteDataSource: dataSource);
  });

  test('creates a request for self and maps the payload to an entity', () async {
    when(
      () => dataSource.createRequest(any()),
    ).thenAnswer((_) async => BloodRequestModel.fromJson(requestJson()));

    final result = await CreateRecipientRequest(repository, now: () => now)(
      selfDraft,
    );

    final entity = result.getOrElse(() => throw StateError('expected Right'));
    expect(entity.id, 'req-1');
    expect(entity.beneficiaryType, BeneficiaryType.self);
    expect(entity.isForSomeoneElse, isFalse);
    expect(entity.status, BloodRequestStatus.open);
    verify(() => dataSource.createRequest(selfDraft)).called(1);
  });

  test('creates a request for someone else with a patient embed', () async {
    when(() => dataSource.createRequest(any())).thenAnswer(
      (_) async => BloodRequestModel.fromJson(
        requestJson(beneficiaryType: 'other', patient: patientJson),
      ),
    );

    final result = await CreateRecipientRequest(repository, now: () => now)(
      otherDraft,
    );

    final entity = result.getOrElse(() => throw StateError('expected Right'));
    expect(entity.isForSomeoneElse, isTrue);
    expect(entity.patient?.nationalId, '123456789012345678');
    verify(() => dataSource.createRequest(otherDraft)).called(1);
  });

  test('validation short-circuits before touching the data source', () async {
    final result = await CreateRecipientRequest(repository, now: () => now)(
      selfDraft.copyWith(unitsNeeded: 0),
    );

    expect(result.isLeft(), isTrue);
    verifyNever(() => dataSource.createRequest(any()));
  });

  test('updates a request and reflects the new units', () async {
    when(
      () => dataSource.updateRequest(
        requestId: any(named: 'requestId'),
        draft: any(named: 'draft'),
      ),
    ).thenAnswer((_) async => BloodRequestModel.fromJson(requestJson(unitsNeeded: 3)));

    final result = await UpdateRecipientRequest(repository, now: () => now)(
      UpdateRequestParams(requestId: 'req-1', draft: selfDraft),
    );

    expect(
      result.getOrElse(() => throw StateError('expected Right')).unitsNeeded,
      3,
    );
  });

  test('cancels a request and surfaces the cancelled state', () async {
    when(
      () => dataSource.cancelRequest(
        requestId: 'req-1',
        reason: 'duplicate',
      ),
    ).thenAnswer(
      (_) async => BloodRequestModel.fromJson(requestJson(status: 'cancelled')),
    );

    final result = await CancelRecipientRequest(repository)(
      const CancelRequestParams(requestId: 'req-1', reason: '  duplicate  '),
    );

    expect(
      result.getOrElse(() => throw StateError('expected Right')).status,
      BloodRequestStatus.cancelled,
    );
    verify(
      () => dataSource.cancelRequest(requestId: 'req-1', reason: 'duplicate'),
    ).called(1);
  });

  test('lists own requests across mixed states', () async {
    when(() => dataSource.listOwnRequests()).thenAnswer(
      (_) async => [
        BloodRequestModel.fromJson(requestJson(id: 'open-1', status: 'open')),
        BloodRequestModel.fromJson(
          requestJson(id: 'done-1', status: 'fulfilled'),
        ),
        BloodRequestModel.fromJson(
          requestJson(id: 'gone-1', status: 'expired'),
        ),
      ],
    );

    final result = await GetRecipientRequests(repository)(NoParams());

    final requests = result.getOrElse(() => const []);
    expect(requests.map((r) => r.status), [
      BloodRequestStatus.open,
      BloodRequestStatus.fulfilled,
      BloodRequestStatus.expired,
    ]);
    expect(requests.where((r) => r.isActive).length, 1);
  });

  test('a thrown data-source error becomes a ServerFailure', () async {
    when(() => dataSource.getRequest(any())).thenThrow(Exception('boom'));

    final result = await GetRecipientRequest(repository)('req-1');

    expect(
      result.fold((f) => f, (_) => null),
      isA<ServerFailure>(),
    );
  });

  test('a malformed payload becomes a ParseFailure, not a crash', () async {
    // `requested_by` is required in the model but null here — mirrors a column
    // that a migrated backend forgot to project.
    final broken = requestJson()..remove('requested_by');
    when(
      () => dataSource.getRequest(any()),
    ).thenAnswer((_) async => BloodRequestModel.fromJson(broken));

    final result = await GetRecipientRequest(repository)('req-1');

    expect(
      result.fold((f) => f, (_) => null),
      isA<ParseFailure>(),
    );
  });
}
