import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabare3/core/presentation/widgets/loading_overlay.dart';

void main() {
  testWidgets('renders message and spinner when visible', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LoadingOverlay(
          visible: true,
          message: 'جاري تسجيل الدخول',
          child: Scaffold(body: Text('content')),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('جاري تسجيل الدخول'), findsOneWidget);
    expect(find.text('content'), findsOneWidget);
  });

  testWidgets('does not show overlay when visible is false', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LoadingOverlay(
          visible: false,
          message: 'جاري تسجيل الدخول',
          child: Scaffold(body: Text('content')),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('جاري تسجيل الدخول'), findsNothing);
    expect(find.text('content'), findsOneWidget);
  });
}
