import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabare3/core/presentation/widgets/adaptive_pickers.dart';

import '../../../../helpers/test_app.dart';

/// A button that opens the picker under test and records what it returned.
class _PickerHost extends StatefulWidget {
  final bool time;

  const _PickerHost({required this.time});

  @override
  State<_PickerHost> createState() => _PickerHostState();
}

class _PickerHostState extends State<_PickerHost> {
  Object? result;
  bool completed = false;

  Future<void> _open() async {
    final picked = widget.time
        ? await showAdaptiveTimePicker(
            context: context,
            initialTime: const TimeOfDay(hour: 10, minute: 0),
          )
        : await showAdaptiveDatePicker(
            context: context,
            initialDate: DateTime(2026, 6, 15),
            firstDate: DateTime(2020),
            lastDate: DateTime(2030),
          );
    if (!mounted) return;
    setState(() {
      result = picked;
      completed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(onPressed: _open, child: const Text('open')),
      ),
    );
  }
}

Widget _hostApp(TargetPlatform platform, {bool time = false}) {
  return Builder(
    builder: (context) => Theme(
      data: ThemeData(platform: platform),
      child: _PickerHost(time: time),
    ),
  );
}

Future<void> _openPicker(WidgetTester tester) async {
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(setupTestLocalization);

  group('showAdaptiveDatePicker', () {
    testWidgets('renders a Cupertino wheel on iOS', (tester) async {
      await pumpTestApp(tester, _hostApp(TargetPlatform.iOS));
      await _openPicker(tester);

      expect(find.byType(CupertinoDatePicker), findsOneWidget);
      expect(find.byType(CalendarDatePicker), findsNothing);
    });

    testWidgets('renders the Material dialog on Android', (tester) async {
      await pumpTestApp(tester, _hostApp(TargetPlatform.android));
      await _openPicker(tester);

      expect(find.byType(DatePickerDialog), findsOneWidget);
      expect(find.byType(CupertinoDatePicker), findsNothing);
    });

    testWidgets('the iOS sheet returns the wheel value when saved', (
      tester,
    ) async {
      await pumpTestApp(tester, _hostApp(TargetPlatform.iOS));
      await _openPicker(tester);

      await tester.tap(find.text('حفظ'));
      await tester.pumpAndSettle();

      final host = tester.state<_PickerHostState>(find.byType(_PickerHost));
      expect(host.completed, isTrue);
      expect(host.result, isA<DateTime>());
    });

    testWidgets('the iOS sheet returns null when cancelled', (tester) async {
      await pumpTestApp(tester, _hostApp(TargetPlatform.iOS));
      await _openPicker(tester);

      await tester.tap(find.text('إلغاء'));
      await tester.pumpAndSettle();

      final host = tester.state<_PickerHostState>(find.byType(_PickerHost));
      expect(host.completed, isTrue);
      expect(host.result, isNull);
    });

    testWidgets('the iOS sheet is mirrored for Arabic', (tester) async {
      await pumpTestApp(tester, _hostApp(TargetPlatform.iOS));
      await _openPicker(tester);

      final direction = Directionality.of(
        tester.element(find.byType(CupertinoDatePicker)),
      );
      expect(direction, TextDirection.rtl);
    });
  });

  group('showAdaptiveTimePicker', () {
    testWidgets('renders a Cupertino wheel on iOS', (tester) async {
      await pumpTestApp(tester, _hostApp(TargetPlatform.iOS, time: true));
      await _openPicker(tester);

      expect(find.byType(CupertinoDatePicker), findsOneWidget);
    });

    testWidgets('renders the Material dialog on Android', (tester) async {
      await pumpTestApp(tester, _hostApp(TargetPlatform.android, time: true));
      await _openPicker(tester);

      expect(find.byType(TimePickerDialog), findsOneWidget);
      expect(find.byType(CupertinoDatePicker), findsNothing);
    });

    testWidgets('the iOS sheet returns a TimeOfDay when saved', (tester) async {
      await pumpTestApp(tester, _hostApp(TargetPlatform.iOS, time: true));
      await _openPicker(tester);

      await tester.tap(find.text('حفظ'));
      await tester.pumpAndSettle();

      final host = tester.state<_PickerHostState>(find.byType(_PickerHost));
      expect(host.result, isA<TimeOfDay>());
    });
  });
}
