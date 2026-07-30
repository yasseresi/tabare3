import 'dart:convert';
import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tabare3/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:tabare3/features/donor_home/domain/entities/donor_feed_entity.dart';
import 'package:tabare3/features/donor_home/domain/entities/donor_card_entity.dart';
import 'package:tabare3/features/donor_home/presentation/bloc/donor_card_bloc.dart';
import 'package:tabare3/features/donor_home/presentation/bloc/donor_feed_bloc.dart';
import 'package:tabare3/features/donor_home/presentation/pages/donor_appointments_screen.dart';
import 'package:tabare3/features/donor_home/presentation/pages/donor_card_screen.dart';
import 'package:tabare3/features/donor_home/presentation/pages/donor_card_info_screen.dart';
import 'package:tabare3/features/donor_home/presentation/pages/donor_home_screen.dart';
import 'package:tabare3/features/donor_home/presentation/pages/donor_record_screen.dart';
import 'package:tabare3/features/donor_home/presentation/pages/donor_requests_screen.dart';

class MapAssetLoader extends AssetLoader {
  final Map<String, dynamic> translations;

  const MapAssetLoader(this.translations);

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) async {
    return translations;
  }
}

class MockDonorFeedBloc extends MockBloc<DonorFeedEvent, DonorFeedState>
    implements DonorFeedBloc {}

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

class MockDonorCardBloc extends MockBloc<DonorCardEvent, DonorCardState>
    implements DonorCardBloc {}

void main() {
  late MockDonorFeedBloc bloc;
  late MockAuthBloc authBloc;
  late Map<String, dynamic> translations;

  final hospital = DonorHospitalEntity(
    id: 'hospital-1',
    wilayaId: 16,
    nameAr: 'مستشفى الاختبار المعتمد',
    address: 'وسط الجزائر',
    isActive: true,
  );
  final request = DonorBloodRequestEntity(
    id: 'request-1',
    requestedBy: 'recipient-1',
    hospital: hospital,
    bloodType: 'A+',
    priority: DonorRequestPriority.urgent,
    unitsNeeded: 3,
    unitsFulfilled: 1,
    status: DonorBloodRequestStatus.open,
    neededBy: DateTime.utc(2026, 8, 5),
    createdAt: DateTime.utc(2026, 7, 30),
  );
  final campaign = DonorCampaignEntity(
    id: 'campaign-1',
    organizerName: 'جمعية الاختبار',
    title: 'حملة الاختبار',
    venueName: 'قاعة الاختبار',
    city: 'الجزائر',
    wilayaId: 16,
    status: DonorCampaignStatus.upcoming,
    startsAt: DateTime.utc(2026, 8, 4, 9),
    endsAt: DateTime.utc(2026, 8, 4, 16),
    publishedAt: DateTime.utc(2026, 7, 30),
    createdAt: DateTime.utc(2026, 7, 30),
  );
  final appointment = DonorAppointmentEntity(
    id: 'appointment-1',
    donorId: 'donor-1',
    scheduledAt: DateTime.utc(2026, 8, 2, 10),
    status: DonationAppointmentStatus.confirmed,
    createdAt: DateTime.utc(2026, 7, 30),
    bloodRequest: DonorAppointmentRequestRef(
      id: request.id,
      hospital: hospital,
      bloodType: request.bloodType,
      priority: request.priority,
    ),
  );
  final record = DonationRecordEntity(
    id: 'record-1',
    donorId: 'donor-1',
    source: DonationSource.request,
    requestId: request.id,
    hospitalId: hospital.id,
    donatedAt: DateTime.utc(2026, 7, 1),
    units: 1,
  );
  final loadedState = DonorFeedLoaded(
    feed: DonorFeedEntity(
      availability: const DonorAvailabilityEntity(
        userId: 'donor-1',
        isAccountActive: true,
        isAvailableForDonation: true,
        isDonor: true,
        bloodType: 'O-',
        wilayaId: 16,
        totalDonationsCount: 4,
      ),
      compatibleRequests: [request],
      availableCampaigns: [campaign],
      appointments: [appointment],
    ),
    records: [record],
  );

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    translations =
        json.decode(await File('assets/translations/ar.json').readAsString())
            as Map<String, dynamic>;
  });

  setUp(() {
    bloc = MockDonorFeedBloc();
    authBloc = MockAuthBloc();
    when(() => bloc.state).thenReturn(loadedState);
    when(() => authBloc.state).thenReturn(AuthInitial());
  });

  Future<void> pumpPage(WidgetTester tester, Widget page) async {
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('ar')],
        path: 'assets/translations',
        assetLoader: MapAssetLoader(translations),
        fallbackLocale: const Locale('ar'),
        startLocale: const Locale('ar'),
        child: Builder(
          builder: (context) => MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            home: MultiBlocProvider(
              providers: [
                BlocProvider<DonorFeedBloc>.value(value: bloc),
                BlocProvider<AuthBloc>.value(value: authBloc),
              ],
              child: Scaffold(body: page),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('renders compatible requests and published campaigns', (
    tester,
  ) async {
    await pumpPage(tester, const DonorRequestsScreen());

    expect(find.text('مستشفى الاختبار المعتمد'), findsOneWidget);
    expect(find.text('حملة الاختبار'), findsOneWidget);
    expect(find.text('A+'), findsOneWidget);
  });

  testWidgets('renders donor overview from backend state', (tester) async {
    await pumpPage(tester, const DonorHomeScreen());

    expect(find.text('O-'), findsOneWidget);
    expect(find.text('4'), findsOneWidget);
    expect(find.text('مستشفى الاختبار المعتمد'), findsOneWidget);
  });

  testWidgets('renders the donor appointment from backend state', (
    tester,
  ) async {
    await pumpPage(tester, const DonorAppointmentsScreen());

    expect(find.text('مستشفى الاختبار المعتمد'), findsOneWidget);
    expect(find.text('A+'), findsOneWidget);
  });

  testWidgets('renders the donation record from backend state', (tester) async {
    await pumpPage(tester, const DonorRecordScreen());

    expect(find.text('1'), findsWidgets);
    expect(find.text('01 Jul 2026'), findsOneWidget);
  });

  testWidgets('renders points, current level and earned badges from backend', (
    tester,
  ) async {
    final cardBloc = MockDonorCardBloc();
    when(() => cardBloc.state).thenReturn(
      DonorCardLoaded(
        DonorCardEntity(
          totalPoints: 18,
          totalDonations: 2,
          levels: const [
            DonorLevelEntity(levelNumber: 1, minPoints: 0, nameAr: 'قطرة أمل'),
            DonorLevelEntity(
              levelNumber: 2,
              minPoints: 10,
              nameAr: 'متبرع الاختبار',
            ),
            DonorLevelEntity(
              levelNumber: 3,
              minPoints: 50,
              nameAr: 'متبرع ملتزم',
            ),
          ],
          badges: [
            DonorBadgeEntity(
              id: 'badge-1',
              nameAr: 'شارة الاختبار',
              earnedAt: DateTime.utc(2026, 7, 30),
            ),
          ],
        ),
      ),
    );

    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('ar')],
        path: 'assets/translations',
        assetLoader: MapAssetLoader(translations),
        fallbackLocale: const Locale('ar'),
        startLocale: const Locale('ar'),
        child: Builder(
          builder: (context) => MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            home: BlocProvider<DonorCardBloc>.value(
              value: cardBloc,
              child: const DonorCardScreen(),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('متبرع الاختبار'), findsWidgets);
    expect(find.text('18 نقطة'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('شارة الاختبار'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('شارة الاختبار'), findsOneWidget);
  });

  testWidgets('donor card guide renders backend level thresholds', (
    tester,
  ) async {
    final cardBloc = MockDonorCardBloc();
    when(() => cardBloc.state).thenReturn(
      const DonorCardLoaded(
        DonorCardEntity(
          totalPoints: 18,
          totalDonations: 2,
          levels: [
            DonorLevelEntity(
              levelNumber: 1,
              minPoints: 0,
              nameAr: 'مستوى الدليل',
            ),
          ],
          badges: [],
        ),
      ),
    );

    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('ar')],
        path: 'assets/translations',
        assetLoader: MapAssetLoader(translations),
        fallbackLocale: const Locale('ar'),
        startLocale: const Locale('ar'),
        child: Builder(
          builder: (context) => MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            home: BlocProvider<DonorCardBloc>.value(
              value: cardBloc,
              child: const DonorCardInfoScreen(),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('مستوى الدليل'), findsOneWidget);
    expect(find.text('0'), findsOneWidget);
  });
}
