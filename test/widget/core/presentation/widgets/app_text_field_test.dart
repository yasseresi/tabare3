import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabare3/core/presentation/widgets/app_text_field.dart';

void main() {
  testWidgets('renders hint text and prefix icon', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppTextField(
            hintText: 'اسم المستخدم',
            prefixIcon: Icons.person_outline,
          ),
        ),
      ),
    );

    expect(find.text('اسم المستخدم'), findsOneWidget);
    expect(find.byIcon(Icons.person_outline), findsOneWidget);
  });

  testWidgets('shows obscure toggle when isPassword true', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppTextField(
            hintText: 'كلمة المرور',
            prefixIcon: Icons.lock_outline,
            isPassword: true,
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);

    await tester.tap(find.byIcon(Icons.visibility_off_outlined));
    await tester.pump();

    expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
  });

  testWidgets('calls onChanged when text entered', (tester) async {
    String? changedValue;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppTextField(
            hintText: 'email',
            prefixIcon: Icons.email_outlined,
            onChanged: (v) => changedValue = v,
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(AppTextField), 'test@test.com');
    await tester.pump();

    expect(changedValue, 'test@test.com');
  });

  testWidgets('validator returns error for empty input in Form', (
    tester,
  ) async {
    final formKey = GlobalKey<FormState>();
    String? validationResult;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Form(
            key: formKey,
            child: AppTextField(
              hintText: 'email',
              prefixIcon: Icons.email_outlined,
              validator: (v) {
                validationResult = v;
                return v == null || v.isEmpty ? 'required' : null;
              },
            ),
          ),
        ),
      ),
    );

    formKey.currentState!.validate();
    await tester.pump();

    expect(validationResult, '');
  });
}
