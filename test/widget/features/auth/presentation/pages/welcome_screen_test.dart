import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tabare3/features/auth/presentation/pages/welcome_screen.dart';
import 'package:tabare3/features/auth/presentation/pages/login_form_screen.dart';
import 'package:tabare3/features/auth/presentation/pages/signup_screen.dart';

void main() {
  testWidgets('WelcomeScreen renders welcome text, logo and both buttons', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: WelcomeScreen()));

    expect(find.textContaining('مرحباً بك في'), findsOneWidget);
    expect(find.text('تسجيل الدخول'), findsOneWidget);
    expect(find.text('إنشاء حساب'), findsOneWidget);
    expect(find.byType(Image), findsWidgets);
  });

  testWidgets('tapping login navigates to LoginFormScreen', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: WelcomeScreen()));

    await tester.tap(find.text('تسجيل الدخول'));
    await tester.pumpAndSettle();

    expect(find.byType(LoginFormScreen), findsOneWidget);
  });

  testWidgets('tapping signup navigates to SignUpScreen', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: WelcomeScreen()));

    await tester.tap(find.text('إنشاء حساب'));
    await tester.pumpAndSettle();

    expect(find.byType(SignUpScreen), findsOneWidget);
  });
}
