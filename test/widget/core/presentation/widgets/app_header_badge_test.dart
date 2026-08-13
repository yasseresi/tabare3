import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tabare3/core/constants/widget_keys.dart';
import 'package:tabare3/core/presentation/widgets/app_header.dart';
import 'package:tabare3/core/presentation/widgets/app_page.dart';
import 'package:tabare3/features/notifications/domain/entities/notification_entity.dart';
import 'package:tabare3/features/notifications/presentation/bloc/notifications_bloc.dart';

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

/// The bell badge is rendered by the shared [AppHeader], which every screen
/// outside the two home pages reaches through [AppPage]. These tests pin the
/// badge to the header itself rather than to any one screen, so the count shows
/// up everywhere a header sits under a NotificationsBloc.
void main() {
  late MockNotificationsBloc bloc;
  late Map<String, dynamic> translations;

  NotificationEntity notification({
    required String id,
    required bool isRead,
  }) {
    return NotificationEntity(
      id: id,
      userId: 'user-1',
      type: 'new_request',
      title: 'حاجة مستعجلة',
      body: 'هناك طلب جديد يحتاج إلى متبرع',
      refId: 'request-1',
      refType: 'blood_request',
      isRead: isRead,
      createdAt: DateTime.parse('2026-07-30T10:00:00.000Z'),
    );
  }

  NotificationsLoaded loadedWith(List<NotificationEntity> notifications) {
    return NotificationsLoaded(
      notifications: notifications,
      visibleNotifications: notifications,
    );
  }

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    final file = File('assets/translations/ar.json');
    translations =
        json.decode(await file.readAsString()) as Map<String, dynamic>;
  });

  setUp(() {
    bloc = MockNotificationsBloc();
  });

  /// Pumps [child] under localization, optionally providing the notifications
  /// bloc — omitting it mirrors the auth screens and isolated widget tests
  /// where no bloc is in scope.
  Future<void> pumpWithHeader(
    WidgetTester tester,
    Widget child, {
    bool provideBloc = true,
  }) async {
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('ar'), Locale('en')],
        path: 'assets/translations',
        assetLoader: MapAssetLoader(translations),
        fallbackLocale: const Locale('ar'),
        startLocale: const Locale('ar'),
        useOnlyLangCode: true,
        child: Builder(
          builder: (context) => MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            home: provideBloc
                ? BlocProvider<NotificationsBloc>.value(
                    value: bloc,
                    child: child,
                  )
                : child,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Widget headerOnlyScreen() {
    return const Scaffold(
      body: AppHeader(title: 'مرحباً', subtitle: 'كل تبرع فرصة جديدة'),
    );
  }

  Widget appPageScreen() {
    return const AppPage(
      title: 'مرحباً',
      subtitle: 'كل تبرع فرصة جديدة',
      children: [SizedBox.shrink()],
    );
  }

  testWidgets(
    'header derives the unread badge from the bloc without being passed a count',
    (tester) async {
      when(() => bloc.state).thenReturn(
        loadedWith([
          notification(id: 'notification-1', isRead: false),
          notification(id: 'notification-2', isRead: false),
          notification(id: 'notification-3', isRead: true),
        ]),
      );

      await pumpWithHeader(tester, headerOnlyScreen());

      expect(find.byKey(WidgetKeys.headerUnreadBadge), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
    },
  );

  testWidgets('a non-home screen built on AppPage shows the unread badge', (
    tester,
  ) async {
    when(() => bloc.state).thenReturn(
      loadedWith([notification(id: 'notification-1', isRead: false)]),
    );

    await pumpWithHeader(tester, appPageScreen());

    expect(find.byKey(WidgetKeys.headerUnreadBadge), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('no badge is shown when every notification is read', (
    tester,
  ) async {
    when(() => bloc.state).thenReturn(
      loadedWith([notification(id: 'notification-1', isRead: true)]),
    );

    await pumpWithHeader(tester, headerOnlyScreen());

    expect(find.byKey(WidgetKeys.headerUnreadBadge), findsNothing);
  });

  testWidgets('no badge is shown before notifications have loaded', (
    tester,
  ) async {
    when(() => bloc.state).thenReturn(const NotificationsLoading());

    await pumpWithHeader(tester, headerOnlyScreen());

    expect(find.byKey(WidgetKeys.headerUnreadBadge), findsNothing);
  });

  testWidgets('badge tracks the bloc as notifications are marked read', (
    tester,
  ) async {
    final states = StreamController<NotificationsState>();
    addTearDown(states.close);
    whenListen(
      bloc,
      states.stream,
      initialState: loadedWith([
        notification(id: 'notification-1', isRead: false),
      ]),
    );

    await pumpWithHeader(tester, headerOnlyScreen());

    // The badge is on screen first, so the disappearance below is real
    // reactivity rather than a header that never rendered one.
    expect(find.byKey(WidgetKeys.headerUnreadBadge), findsOneWidget);
    expect(find.text('1'), findsOneWidget);

    states.add(loadedWith([notification(id: 'notification-1', isRead: true)]));
    await tester.pumpAndSettle();

    expect(find.byKey(WidgetKeys.headerUnreadBadge), findsNothing);
  });

  testWidgets('header degrades to no badge when no bloc is in scope', (
    tester,
  ) async {
    await pumpWithHeader(
      tester,
      headerOnlyScreen(),
      provideBloc: false,
    );

    expect(find.byKey(WidgetKeys.headerUnreadBadge), findsNothing);
  });

  testWidgets('an explicit count overrides the bloc', (tester) async {
    when(() => bloc.state).thenReturn(
      loadedWith([notification(id: 'notification-1', isRead: false)]),
    );

    await pumpWithHeader(
      tester,
      const Scaffold(
        body: AppHeader(
          title: 'مرحباً',
          subtitle: 'كل تبرع فرصة جديدة',
          unreadCount: 7,
        ),
      ),
    );

    expect(find.text('7'), findsOneWidget);
  });
}
