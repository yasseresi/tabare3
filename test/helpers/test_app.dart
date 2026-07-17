import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Must run once before pumping any localized widget in tests.
/// Call in setUpAll().
Future<void> setupTestLocalization() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
}

/// Wraps [home] in EasyLocalization + MaterialApp with Arabic translations
/// loaded from assets/translations (ar.json / en.json).
Widget buildTestApp(Widget home) {
  return EasyLocalization(
    supportedLocales: const [Locale('ar'), Locale('en')],
    path: 'assets/translations',
    fallbackLocale: const Locale('ar'),
    startLocale: const Locale('ar'),
    useOnlyLangCode: true,
    child: Builder(
      builder: (context) => MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        home: home,
      ),
    ),
  );
}

Future<void> pumpTestApp(WidgetTester tester, Widget home) async {
  await tester.pumpWidget(buildTestApp(home));
  await tester.pumpAndSettle();
}

/// Wraps a widget that provides its own MaterialApp (e.g. MyApp) in
/// EasyLocalization so `context.locale` resolves. Call
/// setupTestLocalization() in setUpAll() first.
Widget wrapWithLocalization(Widget child) {
  return EasyLocalization(
    supportedLocales: const [Locale('ar'), Locale('en')],
    path: 'assets/translations',
    fallbackLocale: const Locale('ar'),
    startLocale: const Locale('ar'),
    useOnlyLangCode: true,
    child: child,
  );
}
