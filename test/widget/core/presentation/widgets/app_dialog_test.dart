import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabare3/core/presentation/widgets/app_dialog.dart';

void main() {
  testWidgets('renders a Figma success message instead of the logo', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppDialog.success(
            title: 'تم قبول الطلب بنجاح',
            message: 'تم إشعار صاحب الطلب باستعدادك للتبرع.',
            actionLabel: 'تأكيد',
          ),
        ),
      ),
    );

    expect(find.text('تم قبول الطلب بنجاح'), findsOneWidget);
    expect(find.text('تم إشعار صاحب الطلب باستعدادك للتبرع.'), findsOneWidget);
    expect(find.byType(Image), findsNothing);
  });
}
