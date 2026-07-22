import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:tabare3/core/constants/widget_keys.dart';
import 'package:tabare3/core/presentation/widgets/logout_dialog.dart';

Future<void> _pumpDialog(
  WidgetTester tester, {
  required VoidCallback? onConfirm,
  required VoidCallback? onCancel,
  String title = 'تأكيد تسجيل الخروج',
  String message =
      'سيتم إنهاء جلستك الحالية وستحتاج إلى تسجيل الدخول مرة أخرى.',
  String confirmLabel = 'تسجيل الخروج',
  String cancelLabel = 'إلغاء',
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => showDialog<void>(
              context: context,
              barrierDismissible: false,
              builder: (_) => LogoutDialog(
                title: title,
                message: message,
                confirmLabel: confirmLabel,
                cancelLabel: cancelLabel,
                onConfirm: onConfirm,
                onCancel: onCancel,
              ),
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

void main() {
  group('LogoutDialog', () {
    testWidgets('renders title, message, warning icon and both action labels',
        (tester) async {
      await _pumpDialog(tester, onConfirm: () {}, onCancel: () {});

      expect(find.text('تأكيد تسجيل الخروج'), findsOneWidget);
      expect(
        find.text('سيتم إنهاء جلستك الحالية وستحتاج إلى تسجيل الدخول مرة أخرى.'),
        findsOneWidget,
      );
      expect(find.text('تسجيل الخروج'), findsOneWidget);
      expect(find.text('إلغاء'), findsOneWidget);
      expect(find.byType(SvgPicture), findsOneWidget);
    });

    testWidgets('uses stable widget keys for confirm and cancel buttons',
        (tester) async {
      await _pumpDialog(tester, onConfirm: () {}, onCancel: () {});

      expect(
        find.byKey(WidgetKeys.logoutDialogConfirmButton),
        findsOneWidget,
      );
      expect(
        find.byKey(WidgetKeys.logoutDialogCancelButton),
        findsOneWidget,
      );
    });

    testWidgets('confirm button invokes onConfirm callback', (tester) async {
      var confirmed = false;
      await _pumpDialog(
        tester,
        onConfirm: () => confirmed = true,
        onCancel: () {},
      );

      await tester.tap(find.byKey(WidgetKeys.logoutDialogConfirmButton));
      await tester.pumpAndSettle();

      expect(confirmed, isTrue);
    });

    testWidgets('cancel button invokes onCancel callback and dismisses dialog',
        (tester) async {
      var cancelled = false;
      await _pumpDialog(
        tester,
        onConfirm: () {},
        onCancel: () => cancelled = true,
      );

      await tester.tap(find.byKey(WidgetKeys.logoutDialogCancelButton));
      await tester.pumpAndSettle();

      expect(cancelled, isTrue);
      expect(find.byType(LogoutDialog), findsNothing);
    });

    testWidgets('confirm button dismisses the dialog after invoking callback',
        (tester) async {
      await _pumpDialog(tester, onConfirm: () {}, onCancel: () {});

      await tester.tap(find.byKey(WidgetKeys.logoutDialogConfirmButton));
      await tester.pumpAndSettle();

      expect(find.byType(LogoutDialog), findsNothing);
    });
  });
}
