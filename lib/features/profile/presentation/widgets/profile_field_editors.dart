import 'dart:io';

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/algerian_wilayas.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/constants_manager.dart';
import '../../../../core/utils/font_manager.dart';
import '../../../../core/utils/language_manager.dart';
import '../../../../core/utils/string_manager.dart';
import '../../../../core/utils/styles_manager.dart';
import '../../../../core/utils/values_manager.dart';

/// Blood types available in the app (same set as signup).
const List<String> kBloodTypes = [
  'A+',
  'A-',
  'B+',
  'B-',
  'AB+',
  'AB-',
  'O+',
  'O-',
];

TextDirection appTextDirection(BuildContext context) =>
    context.locale.languageCode == arabic
    ? TextDirection.rtl
    : TextDirection.ltr;

/// Per-field editors used by the profile screen while in edit mode.
class ProfileFieldEditors {
  ProfileFieldEditors._();

  // ---------------------------------------------------------------- date

  /// Platform-adaptive date-of-birth picker.
  /// iOS: Cupertino wheel in a bottom sheet. Android: Material date picker.
  /// Returns the picked date as ISO `yyyy-MM-dd` via [onPicked].
  static Future<void> pickDateOfBirth(
    BuildContext context,
    String currentValue,
    ValueChanged<String> onPicked,
  ) async {
    final now = DateTime.now();
    final initial =
        DateTime.tryParse(currentValue) ?? DateTime(now.year - 20, 1, 1);
    final first = DateTime(now.year - 100);
    final last = now;

    if (Platform.isIOS) {
      var selected = initial;
      await showModalBottomSheet<void>(
        context: context,
        builder: (sheetContext) => Directionality(
          textDirection: appTextDirection(context),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: CupertinoButton(
                    onPressed: () {
                      Navigator.pop(sheetContext);
                      onPicked(_isoDate(selected));
                    },
                    child: Text(AppStrings.save.tr()),
                  ),
                ),
                SizedBox(
                  height: AppSize.s220,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: initial,
                    minimumDate: first,
                    maximumDate: last,
                    onDateTimeChanged: (date) => selected = date,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      return;
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: last,
      locale: context.locale,
    );
    if (picked != null) onPicked(_isoDate(picked));
  }

  static String _isoDate(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  // -------------------------------------------------------------- gender

  /// Male/female options, labels localized to the app language, mapped to
  /// canonical `male` / `female` values.
  static void pickGender(
    BuildContext context,
    String currentValue,
    ValueChanged<String> onPicked,
  ) {
    _showOptionsSheet(
      context: context,
      title: AppStrings.gender.tr(),
      options: [
        _SheetOption(value: 'male', label: AppStrings.male.tr()),
        _SheetOption(value: 'female', label: AppStrings.female.tr()),
      ],
      selectedValue: currentValue,
      onPicked: onPicked,
    );
  }

  // ---------------------------------------------------------- blood type

  static void pickBloodType(
    BuildContext context,
    String currentValue,
    ValueChanged<String> onPicked,
  ) {
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => Directionality(
        textDirection: appTextDirection(context),
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.p20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _SheetTitle(AppStrings.bloodType.tr()),
              const SizedBox(height: AppSize.s16),
              Wrap(
                spacing: AppSize.s12,
                runSpacing: AppSize.s12,
                alignment: WrapAlignment.center,
                children: [
                  for (final type in kBloodTypes)
                    ChoiceChip(
                      label: Text(type),
                      selected: type == currentValue,
                      selectedColor: ColorManager.primaryDark.withValues(
                        alpha: 0.15,
                      ),
                      labelStyle: getSemiBoldStyle(
                        fontSize: FontSize.s16,
                        color: type == currentValue
                            ? ColorManager.primaryDark
                            : ColorManager.textPrimary,
                      ),
                      onSelected: (_) {
                        Navigator.pop(sheetContext);
                        onPicked(type);
                      },
                    ),
                ],
              ),
              const SizedBox(height: AppSize.s20),
            ],
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------- weight

  /// Card with plus / minus stepper.
  static void pickWeight(
    BuildContext context,
    double? currentValue,
    ValueChanged<double> onPicked,
  ) {
    var weight = currentValue ?? AppConstants.defaultWeightKg;
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => Directionality(
        textDirection: appTextDirection(context),
        child: StatefulBuilder(
          builder: (context, setState) => Padding(
            padding: const EdgeInsets.all(AppPadding.p20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _SheetTitle(AppStrings.weight.tr()),
                const SizedBox(height: AppSize.s20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _StepperButton(
                      icon: Icons.remove,
                      onTap: () => setState(() {
                        if (weight > AppConstants.minWeightKg) {
                          weight -= 1;
                        }
                      }),
                    ),
                    SizedBox(
                      width: AppSize.s120,
                      child: Text(
                        '${weight.toStringAsFixed(0)} ${AppStrings.kg.tr()}',
                        textAlign: TextAlign.center,
                        style: getBoldStyle(
                          fontSize: FontSize.s24,
                          color: ColorManager.textPrimary,
                        ),
                      ),
                    ),
                    _StepperButton(
                      icon: Icons.add,
                      onTap: () => setState(() {
                        if (weight < AppConstants.maxWeightKg) {
                          weight += 1;
                        }
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: AppSize.s20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(sheetContext);
                      onPicked(weight);
                    },
                    child: Text(AppStrings.save.tr()),
                  ),
                ),
                const SizedBox(height: AppSize.s20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------- wilaya

  /// Search bar over all wilayas.
  static void pickWilaya(
    BuildContext context,
    String currentValue,
    ValueChanged<String> onPicked,
  ) {
    var query = '';
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => Directionality(
        textDirection: appTextDirection(context),
        child: StatefulBuilder(
          builder: (context, setState) {
            final results = filterWilayas(query);
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
                left: AppPadding.p20,
                right: AppPadding.p20,
                top: AppPadding.p20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _SheetTitle(AppStrings.governorate.tr()),
                  const SizedBox(height: AppSize.s16),
                  TextField(
                    autofocus: true,
                    onChanged: (value) => setState(() => query = value),
                    decoration: InputDecoration(
                      hintText: AppStrings.searchWilaya.tr(),
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSize.s16),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSize.s12),
                  SizedBox(
                    height: AppSize.s250,
                    child: ListView.separated(
                      itemCount: results.length,
                      separatorBuilder: (_, __) =>
                          const Divider(height: AppSize.s1),
                      itemBuilder: (context, index) {
                        final wilaya = results[index];
                        return ListTile(
                          dense: true,
                          selected: wilaya == currentValue,
                          selectedColor: ColorManager.primaryDark,
                          title: Text(
                            wilaya,
                            style: getRegularStyle(
                              fontSize: FontSize.s14,
                              color: wilaya == currentValue
                                  ? ColorManager.primaryDark
                                  : ColorManager.textPrimary,
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(sheetContext);
                            onPicked(wilaya);
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppSize.s20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // -------------------------------------------------------- options sheet

  static void _showOptionsSheet({
    required BuildContext context,
    required String title,
    required List<_SheetOption> options,
    required String selectedValue,
    required ValueChanged<String> onPicked,
  }) {
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => Directionality(
        textDirection: appTextDirection(context),
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.p20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _SheetTitle(title),
              const SizedBox(height: AppSize.s8),
              for (final option in options)
                ListTile(
                  title: Text(
                    option.label,
                    style: getMediumStyle(
                      fontSize: FontSize.s16,
                      color: option.value == selectedValue
                          ? ColorManager.primaryDark
                          : ColorManager.textPrimary,
                    ),
                  ),
                  trailing: option.value == selectedValue
                      ? Icon(Icons.check, color: ColorManager.primaryDark)
                      : null,
                  onTap: () {
                    Navigator.pop(sheetContext);
                    onPicked(option.value);
                  },
                ),
              const SizedBox(height: AppSize.s20),
            ],
          ),
        ),
      ),
    );
  }
}

class _SheetOption {
  final String value;
  final String label;

  const _SheetOption({required this.value, required this.label});
}

class _SheetTitle extends StatelessWidget {
  final String title;

  const _SheetTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: getBoldStyle(
        fontSize: FontSize.s18,
        color: ColorManager.textPrimary,
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _StepperButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSize.radiusCircle),
      child: Container(
        width: AppSize.s48,
        height: AppSize.s48,
        decoration: BoxDecoration(
          color: ColorManager.surfaceAlt,
          shape: BoxShape.circle,
          border: Border.all(color: ColorManager.borderGrey),
        ),
        child: Icon(icon, size: AppSize.s24, color: ColorManager.textPrimary),
      ),
    );
  }
}
