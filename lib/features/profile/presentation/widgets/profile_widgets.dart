import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/font_manager.dart';
import '../../../../core/utils/string_manager.dart';
import '../../../../core/utils/styles_manager.dart';
import '../../../../core/utils/values_manager.dart';

/// Figma `Section - Settings Group 1`: an optional centred 16px title followed
/// by a white 24px-radius card that clips its rows.
class ProfileSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;

  const ProfileSection({super.key, this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (title != null) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p10),
            child: Text(
              title!,
              textAlign: TextAlign.center,
              style: getSemiBoldStyle(
                fontSize: FontSize.s16,
                color: ColorManager.sectionTitle,
                lineHeight: LineHeight.h28,
              ),
            ),
          ),
          const SizedBox(height: AppSize.s12),
        ],
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSize.s24),
          child: Container(
            decoration: BoxDecoration(
              color: ColorManager.white,
              borderRadius: BorderRadius.circular(AppSize.s24),
              boxShadow: [
                BoxShadow(
                  color: ColorManager.black.withValues(alpha: 0.04),
                  blurRadius: AppSize.s20,
                  offset: const Offset(AppSize.s0, AppSize.s4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
        ),
      ],
    );
  }
}

/// Figma `Button - Mode`: 20/21 vertical and 20 horizontal padding, a hairline
/// `#F9FAFB` bottom rule, the icon + label on the reading side and the value
/// (plus an optional chevron) on the opposite side.
class ProfileRow extends StatelessWidget {
  final String label;
  final String value;
  final String? icon;
  final Widget? trailing;
  final VoidCallback? onTap;

  /// When true the value renders on its own line under the label
  /// (used for long values like the national ID).
  final bool stackValue;

  /// Stretches a stacked value to the full row width and centres it, as the
  /// `التواصل مع المطور` row does.
  final bool centerStackedValue;

  /// Fixed row height used by the `الأمراض المزمنة` row (105 in Figma).
  final double? height;

  const ProfileRow({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.trailing,
    this.onTap,
    this.stackValue = false,
    this.centerStackedValue = false,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final labelText = Text(
      label,
      style: getMediumStyle(fontSize: FontSize.s15, color: ColorManager.black),
    );
    final valueStyle = getRegularStyle(
      fontSize: FontSize.s14,
      color: ColorManager.textSecondary,
      lineHeight: LineHeight.h21,
    );

    final labelRow = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          ProfileRowIcon(asset: icon!),
          const SizedBox(width: AppSize.s10),
        ],
        labelText,
      ],
    );

    final Widget content = stackValue
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              labelRow,
              if (value.isNotEmpty) ...[
                if (!centerStackedValue) const SizedBox(height: AppSize.s5),
                centerStackedValue
                    ? SizedBox(
                        width: double.infinity,
                        child: Text(
                          value,
                          textAlign: TextAlign.center,
                          style: valueStyle,
                        ),
                      )
                    : Text(value, style: valueStyle),
              ],
            ],
          )
        : Row(
            crossAxisAlignment: height == null
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              labelRow,
              Expanded(
                child: value.isEmpty
                    ? const SizedBox.shrink()
                    : Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: Text(
                          value,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: valueStyle,
                        ),
                      ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: AppSize.s8),
                trailing!,
              ],
            ],
          );

    return InkWell(
      onTap: onTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: ColorManager.surfaceLight,
              width: AppSize.s1,
            ),
          ),
        ),
        padding: const EdgeInsets.only(
          top: AppPadding.p20,
          bottom: AppPadding.p21,
          left: AppPadding.p20,
          right: AppPadding.p20,
        ),
        child: content,
      ),
    );
  }
}

/// 20x20 leading glyph of a [ProfileRow].
class ProfileRowIcon extends StatelessWidget {
  final String asset;

  const ProfileRowIcon({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(asset, width: AppSize.s20, height: AppSize.s20);
  }
}

/// 16x16 disclosure chevron. Figma flips the right-pointing base glyph 180° for
/// navigation rows and 90° for the account-type dropdown.
class ProfileRowChevron extends StatelessWidget {
  final bool pointsDown;

  const ProfileRowChevron({super.key, this.pointsDown = false});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: pointsDown ? _quarterTurn : _halfTurn,
      child: SvgPicture.asset(
        SvgAssets.rowChevron,
        width: AppSize.s16,
        height: AppSize.s16,
      ),
    );
  }

  static const double _halfTurn = 3.141592653589793;
  static const double _quarterTurn = _halfTurn / 2;
}

/// Figma `حالة الحساب` row: label + subtitle stack with a 44x24 pill switch.
class AccountStatusToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const AccountStatusToggle({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: ColorManager.surfaceLight,
            width: AppSize.s1,
          ),
        ),
      ),
      padding: const EdgeInsets.only(
        top: AppPadding.p20,
        bottom: AppPadding.p21,
        left: AppPadding.p20,
        right: AppPadding.p20,
      ),
      child: Row(
        children: [
          const ProfileRowIcon(asset: SvgAssets.profileAccountStatus),
          const SizedBox(width: AppSize.s10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.accountStatus.tr(),
                  style: getMediumStyle(
                    fontSize: FontSize.s15,
                    color: ColorManager.black,
                  ),
                ),
                Text(
                  AppStrings.accountStatusSubtitle.tr(),
                  style: getRegularStyle(
                    fontSize: FontSize.s12,
                    color: ColorManager.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSize.s8),
          _StatusSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _StatusSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _StatusSwitch({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: SizedBox(
        width: AppSize.s44,
        height: AppSize.s24,
        child: Stack(
          children: [
            Container(
              width: AppSize.s44,
              height: AppSize.s24,
              decoration: BoxDecoration(
                color: value ? ColorManager.success : ColorManager.toggleTrack,
                borderRadius: BorderRadius.circular(AppSize.radiusCircle),
              ),
            ),
            Positioned(
              top: AppSize.s2,
              left: value ? AppSize.s2 : null,
              right: value ? null : AppSize.s2,
              child: Container(
                width: AppSize.s20,
                height: AppSize.s20,
                decoration: BoxDecoration(
                  color: ColorManager.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ColorManager.toggleKnobBorder,
                    width: AppSize.s1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
