import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/language_manager.dart';
import '../../utils/string_manager.dart';
import '../../utils/values_manager.dart';

/// Platform-adaptive date / time pickers shared by every feature.
///
/// iOS and macOS get a Cupertino wheel inside a modal bottom sheet with
/// cancel / save actions; every other platform delegates to the Material
/// [showDatePicker] / [showTimePicker] dialogs.
///
/// Platform is read from [Theme.of] so widget tests can override it via
/// `ThemeData(platform: ...)` — never from `dart:io`.

/// Text direction that matches the currently selected app language.
TextDirection adaptivePickerDirection(BuildContext context) =>
    context.locale.languageCode == arabic
    ? TextDirection.rtl
    : TextDirection.ltr;

bool _usesCupertinoPickers(BuildContext context) {
  final platform = Theme.of(context).platform;
  return platform == TargetPlatform.iOS || platform == TargetPlatform.macOS;
}

/// Asks the user for a date, clamped to [firstDate] .. [lastDate].
/// Returns `null` when the user dismisses or cancels the picker.
Future<DateTime?> showAdaptiveDatePicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) async {
  if (!_usesCupertinoPickers(context)) {
    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      locale: context.locale,
    );
  }

  final clamped = initialDate.isBefore(firstDate)
      ? firstDate
      : initialDate.isAfter(lastDate)
      ? lastDate
      : initialDate;
  var selected = clamped;

  return _showCupertinoPickerSheet<DateTime>(
    context: context,
    picker: CupertinoDatePicker(
      mode: CupertinoDatePickerMode.date,
      initialDateTime: clamped,
      minimumDate: firstDate,
      maximumDate: lastDate,
      onDateTimeChanged: (date) => selected = date,
    ),
    onConfirm: () => selected,
  );
}

/// Asks the user for a time of day.
/// Returns `null` when the user dismisses or cancels the picker.
Future<TimeOfDay?> showAdaptiveTimePicker({
  required BuildContext context,
  required TimeOfDay initialTime,
}) async {
  if (!_usesCupertinoPickers(context)) {
    return showTimePicker(context: context, initialTime: initialTime);
  }

  final now = DateTime.now();
  final anchor = DateTime(
    now.year,
    now.month,
    now.day,
    initialTime.hour,
    initialTime.minute,
  );
  var selected = initialTime;

  return _showCupertinoPickerSheet<TimeOfDay>(
    context: context,
    picker: CupertinoDatePicker(
      mode: CupertinoDatePickerMode.time,
      initialDateTime: anchor,
      onDateTimeChanged: (date) => selected = TimeOfDay.fromDateTime(date),
    ),
    onConfirm: () => selected,
  );
}

/// The shared Cupertino sheet chrome: cancel on the leading edge, save on the
/// trailing edge, wheel below, all mirrored for Arabic.
Future<T?> _showCupertinoPickerSheet<T>({
  required BuildContext context,
  required Widget picker,
  required T Function() onConfirm,
}) {
  return showModalBottomSheet<T>(
    context: context,
    builder: (sheetContext) => Directionality(
      textDirection: adaptivePickerDirection(context),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  onPressed: () => Navigator.pop(sheetContext),
                  child: Text(AppStrings.cancel.tr()),
                ),
                CupertinoButton(
                  onPressed: () => Navigator.pop(sheetContext, onConfirm()),
                  child: Text(AppStrings.save.tr()),
                ),
              ],
            ),
            SizedBox(height: AppSize.s220, child: picker),
          ],
        ),
      ),
    ),
  );
}
