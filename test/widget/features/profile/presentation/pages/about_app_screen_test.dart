import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabare3/features/profile/presentation/pages/about_app_screen.dart';

import '../../../../../helpers/test_app.dart';

void main() {
  setUpAll(setupTestLocalization);

  testWidgets('uses the shared Figma header and information cards', (
    tester,
  ) async {
    await pumpTestApp(tester, AboutAppScreen(onBack: () {}));

    expect(find.text('مرحباً، أحمد'), findsOneWidget);
    expect(find.text('معلومات التطبيق'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('التواصل مع المطور'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('التواصل مع المطور'), findsOneWidget);
    expect(find.byType(AppBar), findsNothing);
  });
}
