import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tabare3/features/requester_home/data/datasources/request_remote_data_source.dart';
import 'package:tabare3/features/requester_home/data/models/request_models.dart';
import 'package:tabare3/features/requester_home/data/repositories/request_repository_impl.dart';
import 'package:tabare3/features/requester_home/domain/entities/blood_request_entity.dart';

class MockRequestRemoteDataSource extends Mock
    implements RequestRemoteDataSource {}

void main() {
  late MockRequestRemoteDataSource dataSource;
  late RequestRepositoryImpl repository;

  const hospital = HospitalModel(
    id: 'hospital-id',
    wilayaId: 16,
    nameAr: 'مستشفى',
    isActive: true,
  );
  final request = BloodRequestModel(
    id: 'request-id',
    requestedBy: 'recipient-id',
    hospital: hospital,
    bloodType: 'O+',
    urgency: 'normal',
    unitsNeeded: 1,
    unitsFulfilled: 0,
    status: 'open',
    createdAt: DateTime.utc(2030),
  );
  const draft = RequestDraft(
    hospitalId: 'hospital-id',
    bloodType: 'O+',
    priority: RequestPriority.normal,
    unitsNeeded: 1,
  );

  setUpAll(() {
    registerFallbackValue(draft);
  });

  setUp(() {
    dataSource = MockRequestRemoteDataSource();
    repository = RequestRepositoryImpl(remoteDataSource: dataSource);
  });

  test('listOwnRequests maps models to domain entities', () async {
    when(() => dataSource.listOwnRequests()).thenAnswer((_) async => [request]);

    final result = await repository.listOwnRequests();

    expect(result.getOrElse(() => const []).single.id, 'request-id');
  });

  test('createRequest maps the created model', () async {
    when(
      () => dataSource.createRequest(draft),
    ).thenAnswer((_) async => request);

    final result = await repository.createRequest(draft);

    expect(
      result.getOrElse(() => throw StateError('failure')).id,
      'request-id',
    );
  });

  test('repository maps datasource exceptions to failures', () async {
    when(() => dataSource.listOwnRequests()).thenThrow(Exception('offline'));

    final result = await repository.listOwnRequests();

    expect(result.isLeft(), true);
  });
}
