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

  testWidgets('warning buttons match the 174 x 40.6 Figma box on one line', (
    tester,
  ) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.rtl,
        child: MaterialApp(
          home: Scaffold(
            body: AppDialog.warning(
              title: 'بيانات الملف الشخصي',
              message: 'يتم تعبئة بيانات هذا الطلب تلقائيًا من ملفك الشخصي.',
              actionLabel: 'تأكيد',
              secondaryLabel: 'تحديث الملف الشخصي',
            ),
          ),
        ),
      ),
    );

    // Figma button box is a fixed 174 wide; both labels — including the long
    // "تحديث الملف الشخصي" — stay on a single line rather than wrapping.
    for (final label in const ['تأكيد', 'تحديث الملف الشخصي']) {
      final button = find.ancestor(
        of: find.text(label),
        matching: find.byType(ElevatedButton),
      );
      expect(tester.getSize(button).width, moreOrLessEquals(174, epsilon: 0.5));

      final text = tester.widget<Text>(find.text(label));
      expect(text.maxLines, 1);
      expect(text.softWrap, isFalse);
    }
  });
}
