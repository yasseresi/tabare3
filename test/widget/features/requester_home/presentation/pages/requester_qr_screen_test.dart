import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tabare3/core/constants/widget_keys.dart';
import 'package:tabare3/features/requester_home/domain/entities/blood_request_entity.dart';
import 'package:tabare3/features/requester_home/domain/usecases/request_usecases.dart';
import 'package:tabare3/features/requester_home/presentation/bloc/request_detail_bloc.dart';
import 'package:tabare3/features/requester_home/presentation/pages/requester_qr_screen.dart';

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

  setUpAll(setupTestLocalization);

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

  testWidgets('issues and renders a QR for the recipient active request', (
    tester,
  ) async {
    final qr = IssuedRequestQrEntity(
      token: 'opaque-token',
      expiresAt: DateTime.utc(2030, 1, 1, 12, 30),
    );
    when(() => issueQr('request-id')).thenAnswer((_) async => Right(qr));

    await pumpTestApp(
      tester,
      BlocProvider(
        create: (_) => buildBloc(),
        child: RequesterQrScreen(request: request),
      ),
    );

    verify(() => issueQr('request-id')).called(1);
    expect(find.text('رمز QR'), findsOneWidget);
    expect(
      find.text('اعرض رمز QR الخاص بك لإتمام عملية التبرع.'),
      findsOneWidget,
    );
    expect(find.byKey(WidgetKeys.requestQrView), findsOneWidget);
  });

  testWidgets('explains that there is nothing to show without a request', (
    tester,
  ) async {
    await pumpTestApp(
      tester,
      BlocProvider(
        create: (_) => buildBloc(),
        child: const RequesterQrScreen(),
      ),
    );

    verifyNever(() => issueQr(any()));
    expect(find.byKey(WidgetKeys.requestQrView), findsNothing);
    expect(find.text('لا توجد طلبات حالياً'), findsOneWidget);
  });
}
