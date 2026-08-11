import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabare3/core/utils/color_manager.dart';
import 'package:tabare3/features/donor_home/presentation/widgets/donor_card_theme.dart';

void main() {
  group('DonorCardBackground', () {
    testWidgets(
      'paints an opaque black base beneath the translucent purple gradient',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: DonorCardBackground(child: SizedBox.shrink()),
          ),
        );

        final decorations = tester
            .widgetList<DecoratedBox>(find.byType(DecoratedBox))
            .map((box) => box.decoration)
            .whereType<BoxDecoration>()
            .toList();

        // The Figma background stacks a solid black fill under a translucent
        // purple wash. A BoxDecoration that sets `gradient` drops its `color`,
        // so the opaque base must be painted separately — either as its own
        // ColoredBox or a gradient-free BoxDecoration.
        final hasColoredBoxBase = tester
            .widgetList<ColoredBox>(find.byType(ColoredBox))
            .any((box) => box.color == ColorManager.donorCardBackground);
        final hasDecoratedBase = decorations.any(
          (d) =>
              d.gradient == null &&
              d.color == ColorManager.donorCardBackground,
        );
        final hasOpaqueBlackBase = hasColoredBoxBase || hasDecoratedBase;
        final hasGradient = decorations.any((d) => d.gradient != null);

        expect(
          hasOpaqueBlackBase,
          isTrue,
          reason: 'expected an opaque black base fill under the gradient',
        );
        expect(hasGradient, isTrue, reason: 'expected the purple gradient wash');
      },
    );
  });
}
