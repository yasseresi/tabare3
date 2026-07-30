import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/font_manager.dart';
import '../../../../core/utils/string_manager.dart';
import '../../../../core/utils/styles_manager.dart';
import '../../../../core/utils/values_manager.dart';

class ProfileSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const ProfileSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p10),
            child: Text(
              title,
              textAlign: TextAlign.right,
              style: getSemiBoldStyle(
                fontSize: FontSize.s16,
                color: ColorManager.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: AppSize.s12),
          Container(
            decoration: BoxDecoration(
              color: ColorManager.white,
              borderRadius: BorderRadius.circular(AppSize.s24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: AppSize.s20,
                  offset: const Offset(0, AppSize.s4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData? iconData;
  final Widget? trailing;
  final VoidCallback? onTap;

  /// When true the value renders on its own line under the label
  /// (used for long values like the national ID).
  final bool stackValue;

  const ProfileRow({
    super.key,
    required this.label,
    required this.value,
    this.iconData,
    this.trailing,
    this.onTap,
    this.stackValue = false,
  });

  @override
  Widget build(BuildContext context) {
    final labelText = Text(
      label,
      style: getMediumStyle(
        fontSize: FontSize.s15,
        color: ColorManager.textPrimary,
      ),
    );
    final valueText = Text(
      value,
      style: getRegularStyle(
        fontSize: FontSize.s14,
        color: ColorManager.textSecondary,
      ),
    );

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.p20,
          vertical: AppPadding.p16,
        ),
        child: stackValue
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (iconData != null) ...[
                        Icon(
                          iconData,
                          size: AppSize.s20,
                          color: ColorManager.textSecondary,
                        ),
                        const SizedBox(width: AppSize.s10),
                      ],
                      labelText,
                    ],
                  ),
                  if (value.isNotEmpty) ...[
                    const SizedBox(height: AppSize.s5),
                    valueText,
                  ],
                ],
              )
            : Row(
                children: [
                  if (iconData != null) ...[
                    Icon(
                      iconData,
                      size: AppSize.s20,
                      color: ColorManager.textSecondary,
                    ),
                    const SizedBox(width: AppSize.s10),
                  ],
                  labelText,
                  const SizedBox(width: AppSize.s10),
                  Expanded(
                    child: value.isNotEmpty
                        ? Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: Text(
                              value,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: getRegularStyle(
                                fontSize: FontSize.s14,
                                color: ColorManager.textSecondary,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  if (trailing != null) ...[
                    const SizedBox(width: AppSize.s8),
                    trailing!,
                  ],
                ],
              ),
      ),
    );
  }
}

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
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.p20,
        vertical: AppPadding.p16,
      ),
      child: Row(
        children: [
          Icon(
            Icons.notifications_none_outlined,
            size: AppSize.s20,
            color: ColorManager.textSecondary,
          ),
          const SizedBox(width: AppSize.s10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.accountStatus.tr(),
                  style: getMediumStyle(
                    fontSize: FontSize.s15,
                    color: ColorManager.textPrimary,
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
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeTrackColor: ColorManager.success,
          ),
        ],
      ),
    );
  }
}
