import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
    await tester.tap(find.text('fake scanner'));
    await tester.pumpAndSettle();

    expect(scannedToken, 'request-token');
  });
}
