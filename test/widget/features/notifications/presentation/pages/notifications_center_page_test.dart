import 'dart:convert';
import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tabare3/core/presentation/widgets/app_card.dart';
import 'package:tabare3/features/notifications/domain/entities/notification_entity.dart';
import 'package:tabare3/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:tabare3/features/notifications/presentation/pages/notifications_center_page.dart';

class MapAssetLoader extends AssetLoader {
  final Map<String, dynamic> translations;

  const MapAssetLoader(this.translations);

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) async {
    return translations;
  }
}

class MockNotificationsBloc
    extends MockBloc<NotificationsEvent, NotificationsState>
    implements NotificationsBloc {}

void main() {
  late MockNotificationsBloc bloc;
  late Map<String, dynamic> translations;

  final unreadNotification = NotificationEntity(
    id: 'notification-1',
    userId: 'user-1',
    type: 'new_request',
    title: 'حاجة مستعجلة',
    body: 'هناك طلب جديد يحتاج إلى متبرع',
    refId: 'request-1',
    refType: 'blood_request',
    isRead: false,
    createdAt: DateTime.parse('2026-07-30T10:00:00.000Z'),
  );

  final readNotification = NotificationEntity(
    id: 'notification-2',
    userId: 'user-1',
    type: 'thank_you',
    title: 'شكراً لك',
    body: 'تم اكتمال الطلب بنجاح',
    refId: null,
    refType: null,
    isRead: true,
    createdAt: DateTime.parse('2026-07-29T10:00:00.000Z'),
  );

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    final file = File('assets/translations/ar.json');
    translations =
        json.decode(await file.readAsString()) as Map<String, dynamic>;
    registerFallbackValue(const NotificationsRequested());
    registerFallbackValue(const NotificationsSearchChanged(''));
    registerFallbackValue(const NotificationReadRequested('notification-1'));
  });

  setUp(() {
    bloc = MockNotificationsBloc();
    when(() => bloc.state).thenReturn(
      NotificationsLoaded(
        notifications: [unreadNotification, readNotification],
        visibleNotifications: [unreadNotification, readNotification],
      ),
    );
  });

  Future<void> pumpPage(
    WidgetTester tester, {
    Locale startLocale = const Locale('ar'),
  }) async {
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('ar'), Locale('en')],
        path: 'assets/translations',
        assetLoader: MapAssetLoader(translations),
        fallbackLocale: const Locale('ar'),
        startLocale: startLocale,
        useOnlyLangCode: true,
        child: Builder(
          builder: (context) => MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            home: BlocProvider<NotificationsBloc>.value(
              value: bloc,
              child: const NotificationsCenterPage(),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('renders header, search field and notification cards', (
    tester,
  ) async {
    await pumpPage(tester);

    expect(find.byType(DecoratedBox), findsWidgets);
    expect(find.text('الاشعارات'), findsOneWidget);
    expect(find.text('ابحث عن الاشعارات...'), findsOneWidget);
    expect(find.text('حاجة مستعجلة'), findsOneWidget);
    expect(find.text('شكراً لك'), findsOneWidget);
    // Figma gives every card a 48x48 slot holding a 40x40 type glyph.
    expect(find.byType(SvgPicture), findsWidgets);
    expect(
      tester.getSize(find.byType(AppCard).first).width,
      greaterThan(0),
    );
  });

  testWidgets('forces RTL layout independently of the active locale', (
    tester,
  ) async {
    await pumpPage(tester, startLocale: const Locale('en'));

    final directionality = tester.widget<Directionality>(
      find
          .ancestor(
            of: find.byType(Scaffold),
            matching: find.byType(Directionality),
          )
          .first,
    );

    expect(directionality.textDirection, TextDirection.rtl);
  });

  testWidgets('shows the empty state when there are no notifications', (
    tester,
  ) async {
    when(() => bloc.state).thenReturn(
      const NotificationsLoaded(notifications: [], visibleNotifications: []),
    );

    await pumpPage(tester);

    expect(find.text('لا توجد إشعارات حالياً'), findsOneWidget);
  });

  testWidgets('dispatches search changes as the user types', (tester) async {
    await pumpPage(tester);

    await tester.enterText(find.byType(TextField), 'مستعجلة');
    await tester.pump();

    verify(
      () => bloc.add(const NotificationsSearchChanged('مستعجلة')),
    ).called(1);
  });

  testWidgets('dispatches mark-as-read when an unread card is tapped', (
    tester,
  ) async {
    await pumpPage(tester);

    await tester.tap(find.text('حاجة مستعجلة'));
    await tester.pump();

    verify(
      () => bloc.add(const NotificationReadRequested('notification-1')),
    ).called(1);
  });
}
