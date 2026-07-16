import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tabare3/features/splash/presentation/pages/splash_screen.dart';

void main() {
  testWidgets('SplashScreen renders logo and progress indicator', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SplashScreen()));

    expect(find.byType(Image), findsWidgets);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle(const Duration(seconds: 3));
  });
}
