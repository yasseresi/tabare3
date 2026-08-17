import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tabare3/core/constants/widget_keys.dart';
import 'package:tabare3/core/error/failures.dart';
import 'package:tabare3/core/presentation/widgets/searchable_wilaya_field.dart';
import 'package:tabare3/core/session/session_manager.dart';
import 'package:tabare3/core/usecases/usecase.dart';
import 'package:tabare3/features/auth/domain/entities/user_entity.dart';
import 'package:tabare3/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:tabare3/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:tabare3/injection_container.dart';
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

class MockGetRequestDonors extends Mock implements GetRequestDonors {}

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

class MockNotificationsBloc
    extends MockBloc<NotificationsEvent, NotificationsState>
    implements NotificationsBloc {}

MockNotificationsBloc buildNotificationsBloc() {
  final bloc = MockNotificationsBloc();
  when(() => bloc.state).thenReturn(const NotificationsInitial());
  return bloc;
}

/// Registers a signed-in recipient in the service locator so self-request
/// flows can read the profile blood type and wilaya. Caller resets `sl`.
void registerSessionUser({String bloodType = '', int? wilayaId}) {
  sl.registerLazySingleton(() => SessionManager());
  sl<SessionManager>().setUser(
    UserEntity(
      id: 'recipient-id',
      email: 'me@example.com',
      username: 'me',
      fullName: 'Me',
      isRecipient: true,
      bloodType: bloodType,
      wilayaId: wilayaId,
    ),
  );
}

/// Picks the wilaya that the seeded hospital (wilayaId 16) belongs to, so the
/// hospital dropdown narrows to it. The list stays empty until a wilaya is set.
Future<void> selectSeededWilaya(WidgetTester tester) async {
  final wilayaInput = find.descendant(
    of: find.byType(SearchableWilayaField),
    matching: find.byType(TextFormField),
  );
  await tester.ensureVisible(wilayaInput);
  await tester.pumpAndSettle();
  await tester.enterText(wilayaInput, 'الجزائر');
  await tester.pumpAndSettle();
  await tester.tap(find.text('الجزائر').last);
  await tester.pumpAndSettle();
}

void main() {
  late MockGetRecipientRequests getRequests;
  late MockGetHospitals getHospitals;
  late MockCreateRecipientRequest createRequest;
  late MockUpdateRecipientRequest updateRequest;
  late MockCancelRecipientRequest cancelRequest;
  late MockGetRequestDonors getDonors;

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
    getDonors = MockGetRequestDonors();
    when(
      () => getHospitals(any()),
    ).thenAnswer((_) async => const Right([hospital]));
    when(() => getDonors(any())).thenAnswer((_) async => const Right([]));
  });

  RequestBloc buildBloc() => RequestBloc(
    getRequests: getRequests,
    getHospitals: getHospitals,
    createRequest: createRequest,
    updateRequest: updateRequest,
    cancelRequest: cancelRequest,
    getDonors: getDonors,
  )..add(const RequestsLoadRequested());

  testWidgets('requests screen renders backend request data', (tester) async {
    when(() => getRequests(any())).thenAnswer((_) async => Right([request]));

    await pumpTestApp(
      tester,
      BlocProvider(create: (_) => buildBloc(), child: const RequestsScreen()),
    );

    expect(find.text('مستشفى مصطفى باشا'), findsWidgets);
    expect(find.text('O+'), findsOneWidget);
    expect(find.text('1/3'), findsOneWidget);
    expect(find.text('المتبرعين المتاحين'), findsOneWidget);
    expect(find.text('تعديل الطلب'), findsOneWidget);
    expect(find.text('مرحباً'), findsWidgets);
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
          BlocProvider<NotificationsBloc>(
            create: (_) => buildNotificationsBloc(),
          ),
        ],
        child: const RequesterHomeScreen(),
      ),
    );

    expect(find.byType(Image), findsWidgets);
    await tester.scrollUntilVisible(
      find.text('مستشفى لوحة التحكم'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('مستشفى لوحة التحكم'), findsOneWidget);
    expect(find.text('O+'), findsOneWidget);
    expect(find.text('1/3'), findsOneWidget);
  });

  testWidgets('requester dashboard edits requests inside the receiver shell', (
    tester,
  ) async {
    when(() => getRequests(any())).thenAnswer((_) async => Right([request]));
    final authBloc = MockAuthBloc();
    when(() => authBloc.state).thenReturn(AuthInitial());

    await pumpTestApp(
      tester,
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => buildBloc()),
          BlocProvider<AuthBloc>.value(value: authBloc),
          BlocProvider<NotificationsBloc>(
            create: (_) => buildNotificationsBloc(),
          ),
        ],
        child: const RequesterHomeScreen(),
      ),
    );

    await tester.scrollUntilVisible(
      find.text('تعديل الطلب'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(find.text('تعديل الطلب'));
    await tester.pump();
    await tester.tap(find.text('تعديل الطلب'), warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(find.byType(EditRequestScreen), findsOneWidget);
  });

  testWidgets('requester navigation keeps the Figma order and create action', (
    tester,
  ) async {
    when(() => getRequests(any())).thenAnswer((_) async => Right([request]));
    final authBloc = MockAuthBloc();
    when(() => authBloc.state).thenReturn(AuthInitial());

    await pumpTestApp(
      tester,
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => buildBloc()),
          BlocProvider<AuthBloc>.value(value: authBloc),
          BlocProvider<NotificationsBloc>(
            create: (_) => buildNotificationsBloc(),
          ),
        ],
        child: const RequesterHomeScreen(),
      ),
    );

    final home = find.byKey(WidgetKeys.requesterNavigationHome);
    final create = find.byKey(WidgetKeys.requesterNavigationCreate);
    final profile = find.byKey(WidgetKeys.requesterNavigationProfile);

    expect(home, findsOneWidget);
    expect(create, findsOneWidget);
    expect(profile, findsOneWidget);
    expect(tester.getCenter(home).dx, lessThan(tester.getCenter(create).dx));
    expect(tester.getCenter(create).dx, lessThan(tester.getCenter(profile).dx));
  });

  testWidgets('request edit stays inside the receiver navigation shell', (
    tester,
  ) async {
    when(() => getRequests(any())).thenAnswer((_) async => Right([request]));
    final authBloc = MockAuthBloc();
    when(() => authBloc.state).thenReturn(AuthInitial());

    await pumpTestApp(
      tester,
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => buildBloc()),
          BlocProvider<AuthBloc>.value(value: authBloc),
          BlocProvider<NotificationsBloc>(
            create: (_) => buildNotificationsBloc(),
          ),
        ],
        child: const RequesterHomeScreen(),
      ),
    );

    await tester.tap(find.byKey(WidgetKeys.requesterNavigationRequests));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(WidgetKeys.requestEditButton));
    await tester.pump();
    await tester.tap(
      find.byKey(WidgetKeys.requestEditButton),
      warnIfMissed: false,
    );
    await tester.pumpAndSettle();

    expect(find.byType(EditRequestScreen), findsOneWidget);
    expect(find.byKey(WidgetKeys.requesterNavigationRequests), findsOneWidget);
  });

  testWidgets('request details delegates to the receiver navigation shell', (
    tester,
  ) async {
    when(() => getRequests(any())).thenAnswer((_) async => Right([request]));
    BloodRequestEntity? openedRequest;

    await pumpTestApp(
      tester,
      BlocProvider(
        create: (_) => buildBloc(),
        child: RequestsScreen(onDetail: (value) => openedRequest = value),
      ),
    );

    await tester.tap(find.byKey(WidgetKeys.requestDetailsButton));
    await tester.pump();

    expect(openedRequest, request);
  });

  testWidgets('create request delegates notifications to the receiver shell', (
    tester,
  ) async {
    when(() => getRequests(any())).thenAnswer((_) async => Right([request]));
    var notificationsOpened = false;

    await pumpTestApp(
      tester,
      BlocProvider(
        create: (_) => buildBloc(),
        child: CreateRequestScreen(
          onNotifications: () => notificationsOpened = true,
        ),
      ),
    );

    expect(
      tester.getSize(find.byKey(WidgetKeys.requesterNotificationsButton)),
      const Size(40, 40),
    );

    await tester.tap(find.text('تأكيد'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(WidgetKeys.requestForSelfButton));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(WidgetKeys.requesterNotificationsButton));
    await tester.pump();

    expect(notificationsOpened, isTrue);
  });

  testWidgets(
    'create request delegates profile updates to the receiver shell',
    (tester) async {
      when(() => getRequests(any())).thenAnswer((_) async => Right([request]));
      var profileOpened = false;

      await pumpTestApp(
        tester,
        BlocProvider(
          create: (_) => buildBloc(),
          child: CreateRequestScreen(onProfile: () => profileOpened = true),
        ),
      );

      await tester.tap(find.text('تحديث الملف الشخصي'));
      await tester.pump();

      expect(profileOpened, isTrue);
    },
  );

  testWidgets(
    'donor history shows the empty state (not a spinner) with no requests',
    (tester) async {
      when(() => getRequests(any())).thenAnswer((_) async => const Right([]));

      await pumpTestApp(
        tester,
        BlocProvider(
          create: (_) => buildBloc(),
          child: const DonorHistoryScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // No requests means nothing to fetch — the tab must settle on the empty
      // state rather than spinning forever.
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('لا يوجد متبرعون أكملوا التبرع بعد'), findsOneWidget);
    },
  );

  testWidgets(
    'donor history splits donors by tab and never shows one in both',
    (tester) async {
      final donorRequest = request.copyWith(
        hospital: hospital.copyWith(nameAr: 'مستشفى سجل المتبرعين'),
      );
      when(
        () => getRequests(any()),
      ).thenAnswer((_) async => Right([donorRequest]));
      when(() => getDonors('request-id')).thenAnswer(
        (_) async => Right([
          RequestDonorEntity(
            donorId: 'donor-completed',
            fullName: 'متبرع مكتمل',
            bloodType: 'O+',
            appointmentId: 'appt-1',
            status: DonationAppointmentStatus.completed,
            scheduledAt: DateTime.utc(2030, 1, 1),
            completedAt: DateTime.utc(2030, 1, 2),
          ),
          RequestDonorEntity(
            donorId: 'donor-accepted',
            fullName: 'متبرع مقبول',
            bloodType: 'A+',
            appointmentId: 'appt-2',
            status: DonationAppointmentStatus.pending,
            scheduledAt: DateTime.utc(2030, 1, 3),
          ),
        ]),
      );

      await pumpTestApp(
        tester,
        BlocProvider(
          create: (_) => buildBloc(),
          child: const DonorHistoryScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Completed tab (default): only the donor who finished the donation.
      expect(find.text('مستشفى سجل المتبرعين'), findsOneWidget);
      expect(find.text('متبرع مكتمل'), findsOneWidget);
      expect(find.text('تم التبرع بنجاح'), findsOneWidget);
      expect(find.text('متبرع مقبول'), findsNothing);

      // Accepted tab: only the donor who accepted but has not donated.
      await tester.tap(find.text('المقبولين'));
      await tester.pumpAndSettle();
      expect(find.text('متبرع مقبول'), findsOneWidget);
      expect(find.text('متبرع مكتمل'), findsNothing);
      expect(find.text('تم التبرع بنجاح'), findsNothing);
    },
  );

  testWidgets(
    'donor history delegates notifications with the Figma bell size',
    (tester) async {
      when(() => getRequests(any())).thenAnswer((_) async => Right([request]));
      var notificationsOpened = false;

      await pumpTestApp(
        tester,
        BlocProvider(
          create: (_) => buildBloc(),
          child: DonorHistoryScreen(
            onNotifications: () => notificationsOpened = true,
          ),
        ),
      );

      expect(
        tester.getSize(find.byKey(WidgetKeys.requesterNotificationsButton)),
        const Size(40, 40),
      );

      await tester.tap(find.byKey(WidgetKeys.requesterNotificationsButton));
      await tester.pump();

      expect(notificationsOpened, isTrue);
    },
  );

  testWidgets('requests screen shows beneficiary badge for third-party requests', (
    tester,
  ) async {
    final otherRequest = request.copyWith(
      beneficiaryType: BeneficiaryType.other,
      patient: const PatientEntity(
        fullName: 'مريض تجريبي',
        nationalId: '1234567890',
        bloodType: 'A+',
        weight: 70,
        gender: 'ذكر',
        dateOfBirth: '1980-01-01',
        chronicDiseases: 'سكري',
      ),
    );
    when(() => getRequests(any())).thenAnswer((_) async => Right([otherRequest]));

    await pumpTestApp(
      tester,
      BlocProvider(create: (_) => buildBloc(), child: const RequestsScreen()),
    );

    expect(find.text('لشخص آخر'), findsOneWidget);
    expect(find.text('مريض تجريبي'), findsWidgets);
  });

  testWidgets('requests screen searches by patient name', (tester) async {
    final otherRequest = request.copyWith(
      beneficiaryType: BeneficiaryType.other,
      patient: const PatientEntity(
        fullName: 'مريض فريد',
        nationalId: '1234567890',
        bloodType: 'A+',
        weight: 70,
        gender: 'ذكر',
        dateOfBirth: '1980-01-01',
      ),
    );
    when(
      () => getRequests(any()),
    ).thenAnswer((_) async => Right([otherRequest]));

    await pumpTestApp(
      tester,
      BlocProvider(create: (_) => buildBloc(), child: const RequestsScreen()),
    );

    await tester.enterText(find.byType(TextField), 'مريض فريد');
    await tester.pump();

    expect(find.text('مريض فريد'), findsWidgets);
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

    // Self requester with a known wilaya (16) but no blood type on file, so the
    // wilaya is pre-filled/hidden and the blood-type picker is shown.
    registerSessionUser(wilayaId: 16);
    addTearDown(() => sl.reset());

    await pumpTestApp(
      tester,
      BlocProvider(
        create: (_) => buildBloc(),
        child: const CreateRequestScreen(),
      ),
    );

    expect(find.text('بيانات الملف الشخصي'), findsOneWidget);
    await tester.tap(find.text('تأكيد'));
    await tester.pumpAndSettle();

    expect(find.text('لمن هذا الطلب؟'), findsOneWidget);
    expect(find.text('طلب لنفسي'), findsOneWidget);
    expect(find.text('طلب لشخص آخر'), findsOneWidget);
    await tester.tap(find.byKey(WidgetKeys.requestForSelfButton));
    await tester.pumpAndSettle();

    // The wilaya is known for a self request, so its field is hidden.
    expect(find.byType(SearchableWilayaField), findsNothing);

    await tester.scrollUntilVisible(
      find.byKey(WidgetKeys.requestHospitalField),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(find.byKey(WidgetKeys.requestHospitalField));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(WidgetKeys.requestHospitalField));
    await tester.pumpAndSettle();
    await tester.tap(find.text('مستشفى مصطفى باشا').last);
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.byKey(WidgetKeys.requestBloodTypeField),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(find.byKey(WidgetKeys.requestBloodTypeField));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(WidgetKeys.requestBloodTypeField));
    await tester.pumpAndSettle();
    await tester.tap(find.text('O+').last);
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.byKey(WidgetKeys.requestUnitsField),
      -200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(find.byKey(WidgetKeys.requestUnitsField));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(WidgetKeys.requestUnitsField), '2');
    await tester.scrollUntilVisible(
      find.byKey(WidgetKeys.requestSubmitButton),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(find.byKey(WidgetKeys.requestSubmitButton));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(WidgetKeys.requestSubmitButton));
    await tester.pumpAndSettle();

    final captured =
        verify(() => createRequest(captureAny())).captured.single
            as RequestDraft;
    expect(captured.hospitalId, 'hospital-id');
    expect(captured.beneficiaryType, BeneficiaryType.self);
    expect(captured.bloodType, 'O+');
    expect(captured.unitsNeeded, 2);
  });

  testWidgets(
    'self request locks blood type to the profile value and submits it',
    (tester) async {
      when(() => getRequests(any())).thenAnswer((_) async => const Right([]));
      when(
        () => createRequest(any()),
      ).thenAnswer((invocation) async => Right(request));

      registerSessionUser(bloodType: 'AB-', wilayaId: 16);
      addTearDown(() => sl.reset());

      await pumpTestApp(
        tester,
        BlocProvider(
          create: (_) => buildBloc(),
          child: const CreateRequestScreen(),
        ),
      );

      await tester.tap(find.text('تأكيد'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(WidgetKeys.requestForSelfButton));
      await tester.pumpAndSettle();

      expect(find.byType(SearchableWilayaField), findsNothing);

      await tester.scrollUntilVisible(
        find.byKey(WidgetKeys.requestHospitalField),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.ensureVisible(find.byKey(WidgetKeys.requestHospitalField));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(WidgetKeys.requestHospitalField));
      await tester.pumpAndSettle();
      await tester.tap(find.text('مستشفى مصطفى باشا').last);
      await tester.pumpAndSettle();

      // Blood type is shown read-only from the profile — no dropdown to open.
      await tester.scrollUntilVisible(
        find.byKey(WidgetKeys.requestBloodTypeField),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('AB-'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byKey(WidgetKeys.requestBloodTypeField),
          matching: find.byType(DropdownButtonFormField<String>),
        ),
        findsNothing,
      );

      await tester.scrollUntilVisible(
        find.byKey(WidgetKeys.requestUnitsField),
        -200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.ensureVisible(find.byKey(WidgetKeys.requestUnitsField));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(WidgetKeys.requestUnitsField), '2');
      await tester.scrollUntilVisible(
        find.byKey(WidgetKeys.requestSubmitButton),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.ensureVisible(find.byKey(WidgetKeys.requestSubmitButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(WidgetKeys.requestSubmitButton));
      await tester.pumpAndSettle();

      final captured =
          verify(() => createRequest(captureAny())).captured.single
              as RequestDraft;
      expect(captured.beneficiaryType, BeneficiaryType.self);
      expect(captured.bloodType, 'AB-');
    },
  );

  testWidgets(
    'third-party hospital dropdown lists nothing until a wilaya is selected',
    (tester) async {
      when(() => getRequests(any())).thenAnswer((_) async => const Right([]));

      await pumpTestApp(
        tester,
        BlocProvider(
          create: (_) => buildBloc(),
          child: const CreateRequestScreen(),
        ),
      );

      // Third-party flow keeps the wilaya field (the patient's wilaya is
      // unknown), so it drives the empty-until-selected behaviour.
      await tester.tap(find.text('تأكيد'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(WidgetKeys.requestForOtherButton));
      await tester.pumpAndSettle();
      // Advance past the patient identity step to the request step.
      await tester.scrollUntilVisible(
        find.text('التالي'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('التالي'));
      await tester.pumpAndSettle();

      expect(find.byType(SearchableWilayaField), findsOneWidget);

      await tester.scrollUntilVisible(
        find.byKey(WidgetKeys.requestHospitalField),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.ensureVisible(find.byKey(WidgetKeys.requestHospitalField));
      await tester.pumpAndSettle();
      expect(find.text('اختر الولاية أولاً'), findsOneWidget);
      await tester.tap(find.byKey(WidgetKeys.requestHospitalField));
      await tester.pumpAndSettle();
      expect(find.text('مستشفى مصطفى باشا'), findsNothing);

      // Selecting the hospital's wilaya reveals it in the picker.
      await selectSeededWilaya(tester);
      await tester.ensureVisible(find.byKey(WidgetKeys.requestHospitalField));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(WidgetKeys.requestHospitalField));
      await tester.pumpAndSettle();
      expect(find.text('مستشفى مصطفى باشا'), findsWidgets);
    },
  );

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

    expect(find.text('مرحباً'), findsOneWidget);
    expect(find.text('تعديل طلب تبرع بالدم'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.byKey(WidgetKeys.requestUnitsField),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.enterText(find.byKey(WidgetKeys.requestUnitsField), '2');
    await tester.scrollUntilVisible(
      find.byKey(WidgetKeys.requestEditSaveButton),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('محو'), findsOneWidget);
    await tester.tap(find.byKey(WidgetKeys.requestEditSaveButton));
    await tester.pumpAndSettle();

    final captured =
        verify(() => updateRequest(captureAny())).captured.single
            as UpdateRequestParams;
    expect(captured.requestId, 'request-id');
    expect(captured.draft.unitsNeeded, 2);
  });

  testWidgets('edit request delegates notifications to the receiver shell', (
    tester,
  ) async {
    when(() => getRequests(any())).thenAnswer((_) async => Right([request]));
    var notificationsOpened = false;

    await pumpTestApp(
      tester,
      BlocProvider(
        create: (_) => buildBloc(),
        child: EditRequestScreen(
          request: request,
          onNotifications: () => notificationsOpened = true,
        ),
      ),
    );

    expect(
      tester.getSize(find.byKey(WidgetKeys.requesterNotificationsButton)),
      const Size(40, 40),
    );

    await tester.tap(find.byKey(WidgetKeys.requesterNotificationsButton));
    await tester.pump();

    expect(notificationsOpened, isTrue);
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

    await tester.scrollUntilVisible(
      find.byKey(WidgetKeys.requestCancelButton),
      200,
      scrollable: find.byType(Scrollable).first,
    );
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

  testWidgets('requests screen deletes a request from the list card', (
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
        // A Scaffold ancestor mirrors RequesterHomeScreen, whose Scaffold hosts
        // the snackbar in production; RequestsScreen builds only an AppPage.
        child: const Scaffold(body: RequestsScreen()),
      ),
    );

    await tester.tap(find.byKey(WidgetKeys.requestDeleteButton));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(WidgetKeys.requestCancelReasonField),
      'لم يعد الطلب مطلوباً',
    );
    await tester.tap(find.byKey(WidgetKeys.requestCancelConfirmButton));
    await tester.pumpAndSettle();

    final captured =
        verify(() => cancelRequest(captureAny())).captured.single
            as CancelRequestParams;
    expect(captured.requestId, 'request-id');
    expect(captured.reason, 'لم يعد الطلب مطلوباً');
    // The card flips to a cancelled state and a confirmation snackbar shows.
    expect(find.text('تم إلغاء الطلب'), findsOneWidget);
  });

  testWidgets(
    'requests screen keeps the list and reports a failed cancellation',
    (tester) async {
      when(() => getRequests(any())).thenAnswer((_) async => Right([request]));
      when(
        () => cancelRequest(any()),
      ).thenAnswer((_) async => const Left(ServerFailure()));

      await pumpTestApp(
        tester,
        BlocProvider(
          create: (_) => buildBloc(),
          child: const Scaffold(body: RequestsScreen()),
        ),
      );

      await tester.tap(find.byKey(WidgetKeys.requestDeleteButton));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(WidgetKeys.requestCancelReasonField),
        'محاولة فاشلة',
      );
      await tester.tap(find.byKey(WidgetKeys.requestCancelConfirmButton));
      await tester.pumpAndSettle();

      // A transient cancel failure must not swap the whole list for the
      // load-error/retry view — the list stays and the error is a snackbar.
      expect(find.byKey(WidgetKeys.requestsRetryButton), findsNothing);
      expect(find.text('مستشفى مصطفى باشا'), findsWidgets);
      expect(find.text('خطأ في الخادم، يرجى المحاولة لاحقاً'), findsOneWidget);
    },
  );
}
