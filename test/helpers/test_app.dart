import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tabare3/core/utils/route_manager.dart';

class MapAssetLoader extends AssetLoader {
  final Map<String, dynamic> translations;
  const MapAssetLoader(this.translations);

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) async {
    return translations;
  }
}

late Map<String, dynamic> _testTranslations;

/// Call in setUpAll() — mocks SharedPreferences and loads translation JSON.
/// Do NOT call EasyLocalization.ensureInitialized() here — it creates a
/// singleton that leaks between tests. Each test's EasyLocalization widget
/// handles its own initialization when pumped.
Future<void> setupTestLocalization() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  final file = File('assets/translations/ar.json');
  final jsonString = await file.readAsString();
  _testTranslations = json.decode(jsonString);
}

/// Wraps [home] in EasyLocalization + MaterialApp with Arabic translations
/// loaded from assets/translations (ar.json / en.json).
Widget buildTestApp(Widget home) {
  return EasyLocalization(
    supportedLocales: const [Locale('ar'), Locale('en')],
    path: 'assets/translations',
    assetLoader: MapAssetLoader(_testTranslations),
    fallbackLocale: const Locale('ar'),
    startLocale: const Locale('ar'),
    useOnlyLangCode: true,
    child: Builder(
      builder: (context) => MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        onGenerateRoute: RouteGenerator.getRoute,
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
    assetLoader: MapAssetLoader(_testTranslations),
    fallbackLocale: const Locale('ar'),
    startLocale: const Locale('ar'),
    useOnlyLangCode: true,
    child: child,
  );
}
