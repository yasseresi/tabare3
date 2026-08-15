import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tabare3/core/constants/widget_keys.dart';
import 'package:tabare3/core/error/failures.dart';
import 'package:tabare3/features/donor_home/domain/entities/donor_feed_entity.dart';
import 'package:tabare3/features/donor_home/presentation/bloc/donor_feed_bloc.dart';
import 'package:tabare3/features/donor_home/presentation/pages/donor_qr_scanner_screen.dart';

class MockDonorFeedBloc extends MockBloc<DonorFeedEvent, DonorFeedState>
    implements DonorFeedBloc {}

DonorFeedLoaded _loaded({DonorFeedMutation? mutation}) => DonorFeedLoaded(
  feed: DonorFeedEntity(
    availability: const DonorAvailabilityEntity(
      userId: 'donor-1',
      isAccountActive: true,
      isAvailableForDonation: true,
      isDonor: true,
      bloodType: 'O-',
      wilayaId: 16,
      totalDonationsCount: 0,
    ),
    compatibleRequests: const [],
    availableCampaigns: const [],
    appointments: const [],
  ),
  records: const [],
  lastMutation: mutation,
);

void main() {
  late MockDonorFeedBloc bloc;
  late StreamController<DonorFeedState> states;

  setUpAll(() {
    registerFallbackValue(const DonorQrRedeemed(''));
  });

  setUp(() {
    bloc = MockDonorFeedBloc();
    states = StreamController<DonorFeedState>.broadcast();
    whenListen(bloc, states.stream, initialState: _loaded());
  });

  tearDown(() => states.close());

  Widget wrap(Widget child) => MaterialApp(
    home: BlocProvider<DonorFeedBloc>.value(value: bloc, child: child),
  );

  testWidgets('dispatches a kind-agnostic redeem event when a QR is scanned', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        DonorQrScannerScreen(
          scannerBuilder: (onScanned) => TextButton(
            onPressed: () => onScanned('scanned-token'),
            child: const Text('fake scanner'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('fake scanner'));
    await tester.pump();

    verify(() => bloc.add(const DonorQrRedeemed('scanned-token'))).called(1);
  });

  testWidgets('closes the scanner once the donation is recorded', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        Builder(
          builder: (context) => TextButton(
            onPressed: () => Navigator.push<void>(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider<DonorFeedBloc>.value(
                  value: bloc,
                  child: DonorQrScannerScreen(
                    scannerBuilder: (_) => const SizedBox.shrink(),
                  ),
                ),
              ),
            ),
            child: const Text('open'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.byKey(WidgetKeys.donorScannerManualToggle), findsOneWidget);

    states.add(_loaded(mutation: DonorFeedMutation.donationRecorded));
    await tester.pumpAndSettle();

    expect(find.text('open'), findsOneWidget);
    expect(find.byKey(WidgetKeys.donorScannerManualToggle), findsNothing);
  });

  testWidgets('shows a message and stays open when redemption fails', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        DonorQrScannerScreen(
          scannerBuilder: (_) => const SizedBox.shrink(),
        ),
      ),
    );

    states.add(const DonorFeedError(ValidationFailure(-1, 'qr_invalid')));
    await tester.pumpAndSettle();

    expect(find.byKey(WidgetKeys.donorScannerError), findsOneWidget);
    expect(find.byKey(WidgetKeys.donorScannerManualToggle), findsOneWidget);
  });

  testWidgets('manual fallback redeems the typed token', (tester) async {
    await tester.pumpWidget(
      wrap(
        DonorQrScannerScreen(
          scannerBuilder: (_) => const SizedBox.shrink(),
        ),
      ),
    );

    await tester.tap(find.byKey(WidgetKeys.donorScannerManualToggle));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(WidgetKeys.donorScannerManualField),
      'typed-token',
    );
    await tester.tap(find.byKey(WidgetKeys.donorScannerManualSubmit));
    await tester.pump();

    verify(() => bloc.add(const DonorQrRedeemed('typed-token'))).called(1);
  });

  testWidgets('does not dispatch or spin when the feed is not loaded', (
    tester,
  ) async {
    whenListen(
      bloc,
      states.stream,
      initialState: const DonorFeedError(ValidationFailure(-6, 'offline')),
    );

    await tester.pumpWidget(
      wrap(
        DonorQrScannerScreen(
          scannerBuilder: (onScanned) => TextButton(
            onPressed: () => onScanned('scanned-token'),
            child: const Text('fake scanner'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('fake scanner'));
    await tester.pump();

    verifyNever(() => bloc.add(any()));
    expect(find.byKey(WidgetKeys.donorScannerProgress), findsNothing);
    expect(find.byKey(WidgetKeys.donorScannerError), findsOneWidget);
  });

  testWidgets('delegates donor navigation back to the enclosing shell', (
    tester,
  ) async {
    DonorScannerDestination? destination;

    await tester.pumpWidget(
      wrap(
        DonorQrScannerScreen(
          onNavigate: (value) => destination = value,
          scannerBuilder: (_) => const SizedBox.shrink(),
        ),
      ),
    );

    await tester.tap(find.byKey(WidgetKeys.donorNavigationAppointments));
    await tester.pumpAndSettle();

    expect(destination, DonorScannerDestination.appointments);
  });
}
