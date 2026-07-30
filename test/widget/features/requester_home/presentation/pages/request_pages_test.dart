import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tabare3/core/constants/widget_keys.dart';
import 'package:tabare3/core/usecases/usecase.dart';
import 'package:tabare3/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:tabare3/features/requester_home/domain/entities/blood_request_entity.dart';
import 'package:tabare3/features/requester_home/domain/usecases/request_usecases.dart';
import 'package:tabare3/features/requester_home/presentation/bloc/request_bloc.dart';
import 'package:tabare3/features/requester_home/presentation/pages/create_request_screen.dart';
import 'package:tabare3/features/requester_home/presentation/pages/edit_request_screen.dart';
import 'package:tabare3/features/requester_home/presentation/pages/requests_screen.dart';
import 'package:tabare3/features/requester_home/presentation/pages/requester_home_screen.dart';
import 'package:tabare3/features/requester_home/presentation/pages/donor_history_screen.dart';

import '../../../../../helpers/test_app.dart';

class MockGetRecipientRequests extends Mock implements GetRecipientRequests {}

class MockGetHospitals extends Mock implements GetHospitals {}

class MockCreateRecipientRequest extends Mock
    implements CreateRecipientRequest {}

class MockUpdateRecipientRequest extends Mock
    implements UpdateRecipientRequest {}

class MockCancelRecipientRequest extends Mock
    implements CancelRecipientRequest {}

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

void main() {
  late MockGetRecipientRequests getRequests;
  late MockGetHospitals getHospitals;
  late MockCreateRecipientRequest createRequest;
  late MockUpdateRecipientRequest updateRequest;
  late MockCancelRecipientRequest cancelRequest;

  const hospital = HospitalEntity(
    id: 'hospital-id',
    wilayaId: 16,
    nameAr: 'مستشفى مصطفى باشا',
    isActive: true,
  );
  final request = BloodRequestEntity(
    id: 'request-id',
    requestedBy: 'recipient-id',
    hospital: hospital,
    bloodType: 'O+',
    priority: RequestPriority.urgent,
    unitsNeeded: 3,
    unitsFulfilled: 1,
    status: BloodRequestStatus.open,
    neededBy: DateTime.utc(2030, 1, 2),
    createdAt: DateTime.utc(2030),
  );

  setUpAll(() async {
    await setupTestLocalization();
    registerFallbackValue(NoParams());
    registerFallbackValue(
      const RequestDraft(
        hospitalId: 'hospital-id',
        bloodType: 'O+',
        priority: RequestPriority.normal,
        unitsNeeded: 1,
      ),
    );
    registerFallbackValue(
      const UpdateRequestParams(
        requestId: 'request-id',
        draft: RequestDraft(
          hospitalId: 'hospital-id',
          bloodType: 'O+',
          priority: RequestPriority.normal,
          unitsNeeded: 1,
        ),
      ),
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
    when(
      () => getHospitals(any()),
    ).thenAnswer((_) async => const Right([hospital]));
  });

  RequestBloc buildBloc() => RequestBloc(
    getRequests: getRequests,
    getHospitals: getHospitals,
    createRequest: createRequest,
    updateRequest: updateRequest,
    cancelRequest: cancelRequest,
  )..add(const RequestsLoadRequested());

  testWidgets('requests screen renders backend request data', (tester) async {
    when(() => getRequests(any())).thenAnswer((_) async => Right([request]));

    await pumpTestApp(
      tester,
      BlocProvider(create: (_) => buildBloc(), child: const RequestsScreen()),
    );

    expect(find.text('مستشفى مصطفى باشا'), findsOneWidget);
    expect(find.text('O+'), findsOneWidget);
    expect(find.text('1 / 3'), findsOneWidget);
  });

  testWidgets('requester dashboard renders backend request data', (
    tester,
  ) async {
    final dashboardRequest = request.copyWith(
      hospital: hospital.copyWith(nameAr: 'مستشفى لوحة التحكم'),
    );
    when(
      () => getRequests(any()),
    ).thenAnswer((_) async => Right([dashboardRequest]));
    final authBloc = MockAuthBloc();
    when(() => authBloc.state).thenReturn(AuthInitial());

    await pumpTestApp(
      tester,
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => buildBloc()),
          BlocProvider<AuthBloc>.value(value: authBloc),
        ],
        child: const RequesterHomeScreen(),
      ),
    );

    expect(find.text('مستشفى لوحة التحكم'), findsOneWidget);
    expect(find.text('O+'), findsOneWidget);
    expect(find.text('1 / 3'), findsOneWidget);
  });

  testWidgets('donor history links backend requests to their donor details', (
    tester,
  ) async {
    final donorRequest = request.copyWith(
      hospital: hospital.copyWith(nameAr: 'مستشفى سجل المتبرعين'),
    );
    when(
      () => getRequests(any()),
    ).thenAnswer((_) async => Right([donorRequest]));

    await pumpTestApp(
      tester,
      BlocProvider(
        create: (_) => buildBloc(),
        child: const DonorHistoryScreen(),
      ),
    );

    expect(find.text('مستشفى سجل المتبرعين'), findsOneWidget);
    expect(find.text('تفاصيل الطلب'), findsOneWidget);
  });

  testWidgets('requests screen renders the backend empty state', (
    tester,
  ) async {
    when(() => getRequests(any())).thenAnswer((_) async => const Right([]));

    await pumpTestApp(
      tester,
      BlocProvider(create: (_) => buildBloc(), child: const RequestsScreen()),
    );

    expect(find.text('لا توجد طلبات حالياً'), findsOneWidget);
  });

  testWidgets('create request submits governed hospital data to the bloc', (
    tester,
  ) async {
    when(() => getRequests(any())).thenAnswer((_) async => const Right([]));
    when(
      () => createRequest(any()),
    ).thenAnswer((invocation) async => Right(request));

    await pumpTestApp(
      tester,
      BlocProvider(
        create: (_) => buildBloc(),
        child: const CreateRequestScreen(),
      ),
    );

    await tester.tap(find.text('تأكيد'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(WidgetKeys.requestHospitalField));
    await tester.pumpAndSettle();
    await tester.tap(find.text('مستشفى مصطفى باشا').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(WidgetKeys.requestBloodTypeField));
    await tester.pumpAndSettle();
    await tester.tap(find.text('O+').last);
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(WidgetKeys.requestUnitsField), '2');
    await tester.ensureVisible(find.byKey(WidgetKeys.requestSubmitButton));
    await tester.tap(find.byKey(WidgetKeys.requestSubmitButton));
    await tester.pumpAndSettle();

    final captured =
        verify(() => createRequest(captureAny())).captured.single
            as RequestDraft;
    expect(captured.hospitalId, 'hospital-id');
    expect(captured.bloodType, 'O+');
    expect(captured.unitsNeeded, 2);
  });

  testWidgets('edit request submits the existing request id and new values', (
    tester,
  ) async {
    when(() => getRequests(any())).thenAnswer((_) async => Right([request]));
    when(
      () => updateRequest(any()),
    ).thenAnswer((_) async => Right(request.copyWith(unitsNeeded: 2)));

    await pumpTestApp(
      tester,
      BlocProvider(
        create: (_) => buildBloc(),
        child: EditRequestScreen(request: request),
      ),
    );

    await tester.enterText(find.byKey(WidgetKeys.requestUnitsField), '2');
    await tester.ensureVisible(find.byKey(WidgetKeys.requestEditSaveButton));
    await tester.tap(find.byKey(WidgetKeys.requestEditSaveButton));
    await tester.pumpAndSettle();

    final captured =
        verify(() => updateRequest(captureAny())).captured.single
            as UpdateRequestParams;
    expect(captured.requestId, 'request-id');
    expect(captured.draft.unitsNeeded, 2);
  });

  testWidgets('edit request cancellation requires and submits a reason', (
    tester,
  ) async {
    when(() => getRequests(any())).thenAnswer((_) async => Right([request]));
    when(() => cancelRequest(any())).thenAnswer(
      (_) async =>
          Right(request.copyWith(status: BloodRequestStatus.cancelled)),
    );

    await pumpTestApp(
      tester,
      BlocProvider(
        create: (_) => buildBloc(),
        child: EditRequestScreen(request: request),
      ),
    );

    await tester.ensureVisible(find.byKey(WidgetKeys.requestCancelButton));
    await tester.tap(find.byKey(WidgetKeys.requestCancelButton));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(WidgetKeys.requestCancelReasonField),
      'تم تأجيل العملية',
    );
    await tester.tap(find.byKey(WidgetKeys.requestCancelConfirmButton));
    await tester.pumpAndSettle();

    final captured =
        verify(() => cancelRequest(captureAny())).captured.single
            as CancelRequestParams;
    expect(captured.requestId, 'request-id');
    expect(captured.reason, 'تم تأجيل العملية');
  });
}
