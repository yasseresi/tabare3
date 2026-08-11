import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabare3/core/presentation/widgets/app_progress_bar.dart';

void main() {
  /// Regression: [AppProgressBar] used to sit inside a [Column] with the
  /// default center [CrossAxisAlignment], so the track (which had no width
  /// of its own) collapsed to the size of its fill — a floating pill instead
  /// of a full-width bordered track. Wrapping the parent in a fixed-width
  /// box reproduces that Column-without-stretch context.
  Future<void> pump(WidgetTester tester, double value) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 300,
            child: Column(
              children: [AppProgressBar(value: value)],
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('track spans the full available width', (tester) async {
    await pump(tester, 0);

    final trackSize = tester.getSize(find.byType(AppProgressBar));
    expect(trackSize.width, 300);
  });

  testWidgets('track stays full width even when fill is 0', (tester) async {
    await pump(tester, 0);

    final trackSize = tester.getSize(find.byType(AppProgressBar));
    expect(trackSize.width, 300);
  });

  testWidgets('fill hugs the right edge and grows leftward', (tester) async {
    await pump(tester, 0.5);

    final trackBox = tester.renderObject<RenderBox>(
      find.byType(AppProgressBar),
    );
    final trackRight = trackBox.localToGlobal(
      Offset(trackBox.size.width, 0),
    );

    final fill = find.descendant(
      of: find.byType(AppProgressBar),
      matching: find.byType(FractionallySizedBox),
    );
    final fillBox = tester.renderObject<RenderBox>(fill);
    final fillTopLeft = fillBox.localToGlobal(Offset.zero);
    final fillTopRight = fillBox.localToGlobal(Offset(fillBox.size.width, 0));

    expect(fillTopRight.dx, closeTo(trackRight.dx, 0.5));
    expect(fillTopLeft.dx, greaterThan(0));
  });
}
