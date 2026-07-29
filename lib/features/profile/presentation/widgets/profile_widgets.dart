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

  const ProfileRow({
    super.key,
    required this.label,
    required this.value,
    this.iconData,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.p20,
          vertical: AppPadding.p16,
        ),
        child: Row(
          children: [
            if (trailing != null) trailing!,
            const SizedBox(width: AppSize.s8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    label,
                    textAlign: TextAlign.right,
                    style: getMediumStyle(
                      fontSize: FontSize.s15,
                      color: ColorManager.textPrimary,
                    ),
                  ),
                  if (value.isNotEmpty) ...[
                    const SizedBox(height: AppSize.s4),
                    Text(
                      value,
                      textAlign: TextAlign.right,
                      style: getRegularStyle(
                        fontSize: FontSize.s14,
                        color: ColorManager.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppSize.s10),
            if (iconData != null)
              Icon(
                iconData,
                size: AppSize.s20,
                color: ColorManager.textSecondary,
              ),
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
    return ProfileRow(
      label: AppStrings.accountStatus.tr(),
      value: AppStrings.accountStatusSubtitle.tr(),
      iconData: Icons.notifications_none_outlined,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: ColorManager.success,
      ),
    );
  }
}
