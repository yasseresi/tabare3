import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tabare3/core/constants/widget_keys.dart';
import 'package:tabare3/features/requester_home/domain/entities/blood_request_entity.dart';
import 'package:tabare3/features/requester_home/domain/usecases/request_usecases.dart';
import 'package:tabare3/features/requester_home/presentation/bloc/request_detail_bloc.dart';
import 'package:tabare3/features/requester_home/presentation/pages/request_detail_screen.dart';

import '../../../../../helpers/test_app.dart';

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

  final request = BloodRequestEntity(
    id: 'request-id',
    requestedBy: 'recipient-id',
    hospital: const HospitalEntity(
      id: 'hospital-id',
      wilayaId: 16,
      nameAr: 'مستشفى تجريبي',
      isActive: true,
    ),
    bloodType: 'O+',
    priority: RequestPriority.urgent,
    unitsNeeded: 3,
    unitsFulfilled: 1,
    status: BloodRequestStatus.open,
    createdAt: DateTime.utc(2030),
  );
  const candidate = CompatibleDonorEntity(
    donorId: 'donor-id',
    fullName: 'متبرع متوافق',
    bloodType: 'O-',
    wilayaId: 16,
  );

  setUpAll(() async {
    await setupTestLocalization();
    registerFallbackValue(
      const InviteDonorParams(requestId: 'request-id', donorId: 'donor-id'),
    );
  });

  setUp(() {
    getDonors = MockGetRequestDonors();
    getCandidates = MockGetCompatibleDonors();
    getInvitations = MockGetRequestInvitations();
    inviteDonor = MockInviteCompatibleDonor();
    issueQr = MockIssueRequestQr();
    when(
      () => getDonors('request-id'),
    ).thenAnswer((_) async => const Right([]));
    when(
      () => getCandidates('request-id'),
    ).thenAnswer((_) async => const Right([candidate]));
    when(
      () => getInvitations('request-id'),
    ).thenAnswer((_) async => const Right([]));
  });

  RequestDetailBloc buildBloc() => RequestDetailBloc(
    getDonors: getDonors,
    getCompatibleDonors: getCandidates,
    getInvitations: getInvitations,
    inviteDonor: inviteDonor,
    issueQr: issueQr,
  );

  testWidgets('shows backend request and compatible donor details', (
    tester,
  ) async {
    await pumpTestApp(
      tester,
      BlocProvider(
        create: (_) => buildBloc(),
        child: RequestDetailScreen(request: request),
      ),
    );

    expect(find.text('مستشفى تجريبي'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.byKey(WidgetKeys.compatibleDonorInviteButton, skipOffstage: false),
      300,
    );
    expect(find.text('متبرع متوافق', skipOffstage: false), findsOneWidget);
    expect(find.text('O-', skipOffstage: false), findsOneWidget);
    expect(
      find.byKey(WidgetKeys.compatibleDonorInviteButton, skipOffstage: false),
      findsOneWidget,
    );
  });

  testWidgets('shows patient details for third-party requests', (tester) async {
    final otherRequest = request.copyWith(
      beneficiaryType: BeneficiaryType.other,
      patient: const PatientEntity(
        fullName: 'مريض تفصيل',
        nationalId: '9876543210',
        bloodType: 'B+',
        weight: 75,
        gender: 'ذكر',
        dateOfBirth: '1990-05-05',
        chronicDiseases: 'ضغط',
      ),
    );

    await pumpTestApp(
      tester,
      BlocProvider(
        create: (_) => buildBloc(),
        child: RequestDetailScreen(request: otherRequest),
      ),
    );

    expect(find.text('لشخص آخر'), findsOneWidget);
    expect(find.text('مريض تفصيل'), findsOneWidget);
    expect(find.text('9876543210'), findsOneWidget);
    expect(find.text('B+'), findsWidgets);
    expect(find.textContaining('75'), findsOneWidget);
    expect(find.text('ضغط'), findsOneWidget);
  });

  testWidgets('uses the receiver Figma page shell instead of an app bar', (
    tester,
  ) async {
    await pumpTestApp(
      tester,
      BlocProvider(
        create: (_) => buildBloc(),
        child: RequestDetailScreen(request: request),
      ),
    );

    expect(find.byType(AppBar), findsNothing);
    expect(find.text('تفاصيل الطلب'), findsOneWidget);
    expect(find.byType(DecoratedBox), findsWidgets);
  });

  testWidgets('renders a server-issued QR and its expiry', (tester) async {
    final qr = IssuedRequestQrEntity(
      token: 'opaque-token',
      expiresAt: DateTime.utc(2030, 1, 1, 12, 30),
    );
    when(() => issueQr('request-id')).thenAnswer((_) async => Right(qr));

    await pumpTestApp(
      tester,
      BlocProvider(
        create: (_) => buildBloc(),
        child: RequestDetailScreen(request: request),
      ),
    );

    await tester.dragFrom(
      const Offset(400, 300),
      const Offset(0, -400),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(WidgetKeys.requestQrIssueButton));
    await tester.pumpAndSettle();

    expect(find.byKey(WidgetKeys.requestQrView), findsOneWidget);
    expect(find.textContaining('صالح إلى'), findsOneWidget);
  });
}
