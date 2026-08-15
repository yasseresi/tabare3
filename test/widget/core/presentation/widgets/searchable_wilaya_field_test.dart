import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tabare3/core/presentation/widgets/searchable_wilaya_field.dart';

import '../../../../helpers/test_app.dart';

void main() {
  setUpAll(setupTestLocalization);

  Widget fieldUnderTest({TextEditingController? controller}) {
    return buildTestApp(
      Scaffold(body: SearchableWilayaField(controller: controller)),
    );
  }

  testWidgets('renders search wilaya hint', (tester) async {
    await pumpTestApp(tester, fieldUnderTest());

    expect(find.text('ابحث عن الولاية...'), findsOneWidget);
  });

  testWidgets('shows matching wilayas while typing', (tester) async {
    await pumpTestApp(tester, fieldUnderTest());

    await tester.enterText(find.byType(TextFormField), 'الجزا');
    await tester.pumpAndSettle();

    expect(find.text('الجزائر'), findsOneWidget);
    expect(find.text('وهران'), findsNothing);
  });

  testWidgets('matches wilaya when ال prefix is omitted', (tester) async {
    await pumpTestApp(tester, fieldUnderTest());

    await tester.enterText(find.byType(TextFormField), 'جزائر');
    await tester.pumpAndSettle();

    expect(find.text('الجزائر'), findsOneWidget);
  });

  testWidgets('updates controller when option is selected', (tester) async {
    final controller = TextEditingController();
    await pumpTestApp(tester, fieldUnderTest(controller: controller));

    await tester.enterText(find.byType(TextFormField), 'وهر');
    await tester.pumpAndSettle();

    await tester.tap(find.text('وهران'));
    await tester.pumpAndSettle();

    expect(controller.text, equals('وهران'));
  });
}
