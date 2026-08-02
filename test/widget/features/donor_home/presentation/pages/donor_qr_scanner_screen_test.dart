import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabare3/core/constants/widget_keys.dart';
import 'package:tabare3/features/donor_home/presentation/pages/donor_qr_scanner_screen.dart';

void main() {
  testWidgets('returns the first scanned QR token to the donor flow', (
    tester,
  ) async {
    String? scannedToken;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () async {
                scannedToken = await Navigator.push<String>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DonorQrScannerScreen(
                      scannerBuilder: (onScanned) => Align(
                        alignment: Alignment.topLeft,
                        child: TextButton(
                          onPressed: () => onScanned('request-token'),
                          child: const Text('fake scanner'),
                        ),
                      ),
                    ),
                  ),
                );
              },
              child: const Text('open scanner'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open scanner'));
    await tester.pumpAndSettle();
    expect(find.byType(AppBar), findsNothing);
    expect(find.byKey(WidgetKeys.donorNavigationHome), findsOneWidget);
    expect(find.byKey(WidgetKeys.donorNavigationAppointments), findsOneWidget);
    expect(find.byKey(WidgetKeys.donorNavigationProfile), findsOneWidget);
    await tester.tap(find.text('fake scanner'));
    await tester.pumpAndSettle();

    expect(scannedToken, 'request-token');
  });

  testWidgets('delegates donor navigation back to the enclosing shell', (
    tester,
  ) async {
    DonorScannerDestination? destination;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DonorQrScannerScreen(
                      onNavigate: (value) => destination = value,
                      scannerBuilder: (_) => const SizedBox.shrink(),
                    ),
                  ),
                );
              },
              child: const Text('open scanner'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open scanner'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(WidgetKeys.donorNavigationAppointments));
    await tester.pumpAndSettle();

    expect(destination, DonorScannerDestination.appointments);
    expect(find.text('open scanner'), findsOneWidget);
  });

  testWidgets('delegates scanner notifications to the enclosing donor shell', (
    tester,
  ) async {
    DonorScannerDestination? destination;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DonorQrScannerScreen(
                      onNavigate: (value) => destination = value,
                      scannerBuilder: (_) => const SizedBox.shrink(),
                    ),
                  ),
                );
              },
              child: const Text('open scanner'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open scanner'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.notifications_none_rounded));
    await tester.pumpAndSettle();

    expect(destination, DonorScannerDestination.notifications);
  });
}
