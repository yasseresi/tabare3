import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabare3/core/presentation/widgets/app_bottom_nav.dart';
import 'package:tabare3/core/presentation/widgets/app_gradient_background.dart';

void main() {
  final items = [
    AppBottomNavItem(asset: 'a.svg', selected: true, onTap: () {}),
    AppBottomNavItem(asset: 'b.svg', selected: false, onTap: () {}),
  ];

  group('AppBottomNav', () {
    testWidgets('defaults to the pink gradient background', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(bottomNavigationBar: AppBottomNav(items: items))),
      );

      expect(find.byType(AppGradientBackground), findsOneWidget);
    });

    testWidgets(
      'uses the provided backgroundBuilder instead of the pink gradient',
      (tester) async {
        const marker = Key('custom-nav-surface');
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              bottomNavigationBar: AppBottomNav(
                items: items,
                backgroundBuilder: (child) =>
                    ColoredBox(key: marker, color: const Color(0xFF000000), child: child),
              ),
            ),
          ),
        );

        expect(find.byKey(marker), findsOneWidget);
        expect(find.byType(AppGradientBackground), findsNothing);
      },
    );
  });
}
