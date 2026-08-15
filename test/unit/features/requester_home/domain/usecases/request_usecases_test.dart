import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tabare3/core/error/failures.dart';
import 'package:tabare3/core/usecases/usecase.dart';
import 'package:tabare3/features/requester_home/domain/entities/blood_request_entity.dart';
import 'package:tabare3/features/requester_home/domain/repositories/request_repository.dart';
import 'package:tabare3/features/requester_home/domain/usecases/request_usecases.dart';

class MockRequestRepository extends Mock implements RequestRepository {}

void main() {
  late MockRequestRepository repository;
  final now = DateTime.utc(2030);
  final request = BloodRequestEntity(
    id: 'request-id',
    requestedBy: 'recipient-id',
    hospital: const HospitalEntity(
      id: 'hospital-id',
      wilayaId: 16,
      nameAr: 'مستشفى',
      isActive: true,
    ),
    bloodType: 'O+',
    priority: RequestPriority.normal,
    unitsNeeded: 1,
    unitsFulfilled: 0,
    status: BloodRequestStatus.open,
    createdAt: now,
  );
  final validDraft = RequestDraft(
    hospitalId: 'hospital-id',
    bloodType: 'O+',
    priority: RequestPriority.normal,
    unitsNeeded: 1,
    neededBy: now.add(const Duration(days: 1)),
  );

  setUpAll(() {
    registerFallbackValue(validDraft);
  });

  setUp(() {
    repository = MockRequestRepository();
  });

  test('GetRecipientRequests forwards the repository result', () async {
    when(
      () => repository.listOwnRequests(),
    ).thenAnswer((_) async => Right([request]));

    final result = await GetRecipientRequests(repository)(NoParams());

    expect(result.getOrElse(() => const []), [request]);
  });

  test(
    'CreateRecipientRequest rejects non-positive units before I/O',
    () async {
      final invalid = validDraft.copyWith(unitsNeeded: 0);

      final result = await CreateRecipientRequest(repository, now: () => now)(
        invalid,
      );

      expect(
        result.fold((failure) => failure, (_) => null),
        isA<ValidationFailure>(),
      );
      verifyNever(() => repository.createRequest(any()));
    },
  );

  test('CreateRecipientRequest rejects a past needed-by date', () async {
    final invalid = validDraft.copyWith(
      neededBy: now.subtract(const Duration(minutes: 1)),
    );

    final result = await CreateRecipientRequest(repository, now: () => now)(
      invalid,
    );

    expect(
      result.fold((failure) => failure, (_) => null),
      isA<ValidationFailure>(),
    );
    verifyNever(() => repository.createRequest(any()));
  });

  test('CreateRecipientRequest forwards a valid draft', () async {
    when(
      () => repository.createRequest(validDraft),
    ).thenAnswer((_) async => Right(request));

    final result = await CreateRecipientRequest(repository, now: () => now)(
      validDraft,
    );

    expect(result, Right<Failure, BloodRequestEntity>(request));
    verify(() => repository.createRequest(validDraft)).called(1);
  });

  test('UpdateRecipientRequest validates before repository I/O', () async {
    final params = UpdateRequestParams(
      requestId: 'request-id',
      draft: validDraft.copyWith(unitsNeeded: -1),
    );

    final result = await UpdateRecipientRequest(repository, now: () => now)(
      params,
    );

    expect(
      result.fold((failure) => failure, (_) => null),
      isA<ValidationFailure>(),
    );
    verifyNever(
      () => repository.updateRequest(
        requestId: any(named: 'requestId'),
        draft: any(named: 'draft'),
      ),
    );
  });

  test(
    'recipient detail use cases delegate server-managed operations',
    () async {
      final expiresAt = now.add(const Duration(minutes: 15));
      final qr = IssuedRequestQrEntity(
        token: 'opaque-token',
        expiresAt: expiresAt,
      );
      when(
        () => repository.listRequestDonors('request-id'),
      ).thenAnswer((_) async => const Right([]));
      when(
        () => repository.listCompatibleDonors('request-id'),
      ).thenAnswer((_) async => const Right([]));
      when(
        () => repository.inviteDonor(
          requestId: 'request-id',
          donorId: 'donor-id',
        ),
      ).thenAnswer((_) async => const Right(null));
      when(
        () => repository.issueRequestQr('request-id'),
      ).thenAnswer((_) async => Right(qr));

      expect(
        await GetRequestDonors(repository)('request-id'),
        const Right<Failure, List<RequestDonorEntity>>([]),
      );
      expect(
        await GetCompatibleDonors(repository)('request-id'),
        const Right<Failure, List<CompatibleDonorEntity>>([]),
      );
      expect(
        await InviteCompatibleDonor(repository)(
          const InviteDonorParams(requestId: 'request-id', donorId: 'donor-id'),
        ),
        const Right<Failure, void>(null),
      );
      expect(await IssueRequestQr(repository)('request-id'), Right(qr));
    },
  );

  test('GetRecipientRequest forwards a single request by id', () async {
    when(
      () => repository.getRequest('request-id'),
    ).thenAnswer((_) async => Right(request));

    final result = await GetRecipientRequest(repository)('request-id');

    expect(result, Right<Failure, BloodRequestEntity>(request));
    verify(() => repository.getRequest('request-id')).called(1);
  });

  test('GetHospitals forwards the repository result', () async {
    const hospital = HospitalEntity(
      id: 'hospital-id',
      wilayaId: 16,
      nameAr: 'مستشفى',
      isActive: true,
    );
    when(
      () => repository.listHospitals(),
    ).thenAnswer((_) async => const Right([hospital]));

    final result = await GetHospitals(repository)(NoParams());

    expect(
      result,
      const Right<Failure, List<HospitalEntity>>([hospital]),
    );
  });

  test('GetRequestInvitations forwards the repository result', () async {
    when(
      () => repository.listInvitations('request-id'),
    ).thenAnswer((_) async => const Right([]));

    final result = await GetRequestInvitations(repository)('request-id');

    expect(
      result,
      const Right<Failure, List<DirectInvitationEntity>>([]),
    );
  });

  test(
    'CreateRecipientRequest forwards a valid for-someone-else draft',
    () async {
      final otherDraft = validDraft.copyWith(
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
      final created = request.copyWith(beneficiaryType: BeneficiaryType.other);
      when(
        () => repository.createRequest(otherDraft),
      ).thenAnswer((_) async => Right(created));

      final result = await CreateRecipientRequest(repository, now: () => now)(
        otherDraft,
      );

      expect(result, Right<Failure, BloodRequestEntity>(created));
      expect(
        result.getOrElse(() => request).isForSomeoneElse,
        isTrue,
      );
      verify(() => repository.createRequest(otherDraft)).called(1);
    },
  );

  test('UpdateRecipientRequest forwards a valid draft', () async {
    final params = UpdateRequestParams(
      requestId: 'request-id',
      draft: validDraft,
    );
    final updated = request.copyWith(unitsNeeded: 2);
    when(
      () => repository.updateRequest(
        requestId: 'request-id',
        draft: validDraft,
      ),
    ).thenAnswer((_) async => Right(updated));

    final result = await UpdateRecipientRequest(repository, now: () => now)(
      params,
    );

    expect(result, Right<Failure, BloodRequestEntity>(updated));
    verify(
      () => repository.updateRequest(requestId: 'request-id', draft: validDraft),
    ).called(1);
  });

  test('CancelRecipientRequest rejects an empty reason before I/O', () async {
    final result = await CancelRecipientRequest(repository)(
      const CancelRequestParams(requestId: 'request-id', reason: '   '),
    );

    expect(
      result.fold((failure) => failure, (_) => null),
      isA<ValidationFailure>(),
    );
    verifyNever(
      () => repository.cancelRequest(
        requestId: any(named: 'requestId'),
        reason: any(named: 'reason'),
      ),
    );
  });

  test('CancelRecipientRequest trims reason and returns cancelled state', () async {
    final cancelled = request.copyWith(status: BloodRequestStatus.cancelled);
    when(
      () => repository.cancelRequest(
        requestId: 'request-id',
        reason: 'duplicate',
      ),
    ).thenAnswer((_) async => Right(cancelled));

    final result = await CancelRecipientRequest(repository)(
      const CancelRequestParams(
        requestId: 'request-id',
        reason: '  duplicate  ',
      ),
    );

    expect(
      result.getOrElse(() => request).status,
      BloodRequestStatus.cancelled,
    );
    verify(
      () => repository.cancelRequest(
        requestId: 'request-id',
        reason: 'duplicate',
      ),
    ).called(1);
  });

  test('validateRequestDraft rejects blank hospital and blood type', () {
    expect(
      validateRequestDraft(validDraft.copyWith(hospitalId: '  '), now),
      isA<ValidationFailure>(),
    );
    expect(
      validateRequestDraft(validDraft.copyWith(bloodType: '  '), now),
      isA<ValidationFailure>(),
    );
    expect(validateRequestDraft(validDraft, now), isNull);
  });
}
