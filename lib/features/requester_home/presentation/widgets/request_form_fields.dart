import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/font_manager.dart';
import '../../../../core/utils/styles_manager.dart';
import '../../../../core/utils/values_manager.dart';

/// Figma `Form Fields` input surface: a white 16px-radius pill with 16/11
/// padding and a 20x20 glyph pinned 16px from the leading (right) edge — the
/// 48px trailing gutter comes from the 14px padding around that glyph.
InputDecorationTheme requestFieldTheme({required Color hintColor}) {
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppSize.radiusField),
    borderSide: BorderSide.none,
  );
  return InputDecorationTheme(
    filled: true,
    fillColor: ColorManager.white,
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppPadding.p16,
      vertical: AppPadding.p11,
    ),
    border: border,
    enabledBorder: border,
    disabledBorder: border,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSize.radiusField),
      borderSide: BorderSide(color: ColorManager.primary, width: AppSize.s1),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSize.radiusField),
      borderSide: BorderSide(color: ColorManager.error, width: AppSize.s1),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSize.radiusField),
      borderSide: BorderSide(color: ColorManager.error, width: AppSize.s1),
    ),
    hintStyle: getRegularStyle(fontSize: FontSize.s16, color: hintColor),
    prefixIconColor: hintColor,
  );
}

/// The 15px-gapped stack of inputs, with the Figma field decoration applied to
/// every descendant field.
class RequestFormSection extends StatelessWidget {
  final List<Widget> children;
  final Color? hintColor;

  const RequestFormSection({super.key, required this.children, this.hintColor});

  @override
  Widget build(BuildContext context) {
    final fields = <Widget>[];
    for (var index = 0; index < children.length; index++) {
      if (index > 0) fields.add(const SizedBox(height: AppSize.s15));
      fields.add(children[index]);
    }
    return Theme(
      data: Theme.of(context).copyWith(
        inputDecorationTheme: requestFieldTheme(
          hintColor: hintColor ?? ColorManager.navInactive,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: fields,
      ),
    );
  }
}

/// Leading glyph shared by every field in the section.
class RequestFieldIcon extends StatelessWidget {
  final String asset;

  const RequestFieldIcon({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppPadding.p14),
      child: SvgPicture.asset(asset, width: AppSize.s20, height: AppSize.s20),
    );
  }
}

/// Select rendered as one of the Figma inputs (hospital, blood type, gender).
class RequestDropdownField<T> extends StatelessWidget {
  final T? value;
  final String hintText;
  final String prefixSvg;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final Key? fieldKey;

  const RequestDropdownField({
    super.key,
    required this.value,
    required this.hintText,
    required this.prefixSvg,
    required this.items,
    required this.onChanged,
    this.fieldKey,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      key: fieldKey,
      initialValue: value,
      isExpanded: true,
      icon: const SizedBox.shrink(),
      style: getRegularStyle(
        fontSize: FontSize.s16,
        color: ColorManager.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: RequestFieldIcon(asset: prefixSvg),
      ),
      items: items,
      onChanged: onChanged,
    );
  }
}

/// Read-only field that opens a picker (deadline, date of birth).
class RequestPickerField extends StatelessWidget {
  final String label;
  final String prefixSvg;
  final bool isPlaceholder;
  final VoidCallback onTap;
  final Key? fieldKey;

  const RequestPickerField({
    super.key,
    required this.label,
    required this.prefixSvg,
    required this.isPlaceholder,
    required this.onTap,
    this.fieldKey,
  });

  @override
  Widget build(BuildContext context) {
    final decorationTheme = Theme.of(context).inputDecorationTheme;
    return InkWell(
      key: fieldKey,
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSize.radiusField),
      child: InputDecorator(
        decoration: InputDecoration(
          prefixIcon: RequestFieldIcon(asset: prefixSvg),
        ),
        child: Text(
          label,
          style: isPlaceholder
              ? decorationTheme.hintStyle
              : getRegularStyle(
                  fontSize: FontSize.s16,
                  color: ColorManager.textPrimary,
                ),
        ),
      ),
    );
  }
}

/// Non-interactive field that renders a value the user cannot change — used for
/// the self-request blood type, which is taken from the signed-in profile.
class RequestReadOnlyField extends StatelessWidget {
  final String label;
  final String prefixSvg;
  final Key? fieldKey;

  const RequestReadOnlyField({
    super.key,
    required this.label,
    required this.prefixSvg,
    this.fieldKey,
  });

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      key: fieldKey,
      decoration: InputDecoration(
        prefixIcon: RequestFieldIcon(asset: prefixSvg),
      ),
      child: Text(
        label,
        style: getRegularStyle(
          fontSize: FontSize.s16,
          color: ColorManager.textPrimary,
        ),
      ),
    );
  }
}

/// Figma `Tags Grid`: the `درجة الاستعجال` caption over three urgency chips
/// spread across the row.
class RequestUrgencySelector<T> extends StatelessWidget {
  final String title;
  final List<RequestUrgencyOption<T>> options;
  final T selected;
  final ValueChanged<T> onSelected;
  final Color unselectedBackground;

  const RequestUrgencySelector({
    super.key,
    required this.title,
    required this.options,
    required this.selected,
    required this.onSelected,
    required this.unselectedBackground,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: getSemiBoldStyle(
            fontSize: FontSize.s14,
            color: ColorManager.black,
            lineHeight: LineHeight.h20,
          ),
        ),
        const SizedBox(height: AppSize.s20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.p30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: options
                .map(
                  (option) => _UrgencyChip(
                    option: option,
                    selected: option.value == selected,
                    unselectedBackground: unselectedBackground,
                    onTap: () => onSelected(option.value),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

class RequestUrgencyOption<T> {
  final T value;
  final String label;
  final Color dotColor;

  const RequestUrgencyOption({
    required this.value,
    required this.label,
    required this.dotColor,
  });
}

class _UrgencyChip extends StatelessWidget {
  final RequestUrgencyOption option;
  final bool selected;
  final Color unselectedBackground;
  final VoidCallback onTap;

  const _UrgencyChip({
    required this.option,
    required this.selected,
    required this.unselectedBackground,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSize.radiusCircle),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.p12,
          vertical: AppPadding.p6,
        ),
        decoration: BoxDecoration(
          color: selected ? ColorManager.chipSelected : unselectedBackground,
          borderRadius: BorderRadius.circular(AppSize.radiusCircle),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: AppSize.s8,
              height: AppSize.s8,
              decoration: BoxDecoration(
                color: option.dotColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppSize.s8),
            Text(
              option.label,
              textAlign: TextAlign.center,
              style: getRegularStyle(
                fontSize: FontSize.s12,
                color: ColorManager.black,
                lineHeight: LineHeight.h16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Figma `FooterButtons`: the outlined `محو` button beside the filled primary
/// action, centred under the form with 24px padding and a 20px gap.
class RequestFooterButtons extends StatelessWidget {
  final String clearLabel;
  final VoidCallback? onClear;
  final String actionLabel;
  final VoidCallback? onAction;
  final bool isBusy;
  final Key? actionKey;

  const RequestFooterButtons({
    super.key,
    required this.clearLabel,
    required this.onClear,
    required this.actionLabel,
    required this.onAction,
    this.isBusy = false,
    this.actionKey,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppPadding.p24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _FooterButton(
            onPressed: onAction,
            buttonKey: actionKey,
            background: ColorManager.actionPrimary,
            horizontalPadding: AppPadding.p40,
            verticalPadding: AppPadding.p15,
            child: isBusy
                ? SizedBox(
                    width: AppSize.s20,
                    height: AppSize.s20,
                    child: CircularProgressIndicator(
                      strokeWidth: AppSize.s2,
                      color: ColorManager.white,
                    ),
                  )
                : Text(
                    actionLabel,
                    style: getSemiBoldStyle(
                      fontSize: FontSize.s16,
                      color: ColorManager.white,
                    ),
                  ),
          ),
          const SizedBox(width: AppSize.s20),
          _FooterButton(
            onPressed: onClear,
            background: ColorManager.white,
            borderColor: ColorManager.outlineButtonBorder,
            horizontalPadding: AppSize.s41_5,
            verticalPadding: AppSize.s16_5,
            child: Text(
              clearLabel,
              textAlign: TextAlign.center,
              style: getSemiBoldStyle(
                fontSize: FontSize.s16,
                color: ColorManager.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color background;
  final Color? borderColor;
  final double horizontalPadding;
  final double verticalPadding;
  final Widget child;
  final Key? buttonKey;

  const _FooterButton({
    required this.onPressed,
    required this.background,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.child,
    this.borderColor,
    this.buttonKey,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppSize.radiusXLarge);
    return Material(
      color: background,
      borderRadius: radius,
      child: InkWell(
        key: buttonKey,
        onTap: onPressed,
        borderRadius: radius,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: radius,
            border: borderColor == null
                ? null
                : Border.all(color: borderColor!, width: AppSize.s1_5),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: child,
        ),
      ),
    );
  }
}
