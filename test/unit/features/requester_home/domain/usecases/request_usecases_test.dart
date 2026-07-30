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
}
