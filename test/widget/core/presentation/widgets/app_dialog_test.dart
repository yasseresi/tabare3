import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabare3/core/presentation/widgets/app_dialog.dart';

void main() {
  Future<void> pumpDialog(WidgetTester tester, AppDialog dialog) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => dialog,
              ),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  group('AppDialog.success', () {
    testWidgets('renders title, icon and action button', (tester) async {
      await pumpDialog(
        tester,
        AppDialog.success(
          title: 'لقد سجلت الدخول بنجاح إلى تطبيق',
          actionLabel: 'الصفحة الرئيسية',
        ),
      );

      expect(find.text('لقد سجلت الدخول بنجاح إلى تطبيق'), findsOneWidget);
      expect(find.text('الصفحة الرئيسية'), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('calls onAction when button tapped', (tester) async {
      var actionCalled = false;
      await pumpDialog(
        tester,
        AppDialog.success(
          title: 'success',
          actionLabel: 'continue',
          onAction: () => actionCalled = true,
        ),
      );

      await tester.tap(find.text('continue'));
      await tester.pumpAndSettle();

      expect(actionCalled, isTrue);
    });
  });

  group('AppDialog.error', () {
    testWidgets('renders title, message and action button', (tester) async {
      await pumpDialog(
        tester,
        AppDialog.error(
          title: 'خطأ',
          message: 'البريد الإلكتروني أو كلمة المرور غير صحيحة',
          actionLabel: 'إعادة المحاولة',
        ),
      );

      expect(find.text('خطأ'), findsOneWidget);
      expect(
        find.text('البريد الإلكتروني أو كلمة المرور غير صحيحة'),
        findsOneWidget,
      );
      expect(find.text('إعادة المحاولة'), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
    });
  });

  group('AppDialog.loading', () {
    testWidgets('renders title and spinner without action button', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) =>
                      const AppDialog.loading(title: 'جاري التحميل'),
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pump();

      expect(find.text('جاري التحميل'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(Dialog),
          matching: find.byType(ElevatedButton),
        ),
        findsNothing,
      );
    });
  });
}
