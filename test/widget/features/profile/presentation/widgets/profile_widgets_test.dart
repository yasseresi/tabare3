import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabare3/features/profile/presentation/widgets/profile_widgets.dart';

void main() {
  testWidgets('truncates a long profile value within a narrow row', (
    tester,
  ) async {
    const value = 'a-very-long-profile-value-that-must-not-overflow-the-row';

    await tester.pumpWidget(
      const MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: SizedBox(
              width: 342,
              child: ProfileRow(label: 'البريد الإلكتروني', value: value),
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    final valueText = tester.widget<Text>(find.text(value));
    expect(valueText.maxLines, 1);
    expect(valueText.overflow, TextOverflow.ellipsis);
  });
}
