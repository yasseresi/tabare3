import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget buildTestApp(Widget home) {
  return EasyLocalization(
    supportedLocales: const [Locale('en'), Locale('ar')],
    path: 'assets/translations',
    fallbackLocale: const Locale('en'),
    startLocale: const Locale('en'),
    child: MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: const [Locale('en'), Locale('ar')],
      locale: const Locale('en'),
      home: home,
    ),
  );
}

Future<void> pumpTestApp(WidgetTester tester, Widget home) async {
  await tester.pumpWidget(buildTestApp(home));
  await tester.pumpAndSettle();
}
