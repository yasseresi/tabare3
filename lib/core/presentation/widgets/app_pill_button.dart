import 'package:flutter/material.dart';

import '../../utils/color_manager.dart';
import '../../utils/font_manager.dart';
import '../../utils/styles_manager.dart';
import '../../utils/values_manager.dart';

/// Small rounded action button that sits at the foot of a list card
/// (`قبول الطلب`, `تعديل الطلب`, `إلغاء` …).
class AppPillButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color? background;
  final Key? buttonKey;

  const AppPillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.background,
    this.buttonKey,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppSize.radiusPillButton);
    return Material(
      color: background ?? ColorManager.navInactive,
      borderRadius: radius,
      child: InkWell(
        key: buttonKey,
        onTap: onPressed,
        borderRadius: radius,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.pPillHorizontal,
            vertical: AppPadding.pPillVertical,
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              maxLines: 1,
              style: getSemiBoldStyle(
                fontSize: FontSize.s12_3,
                color: ColorManager.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
