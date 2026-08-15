import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/app_dimensions.dart';
import '../../utils/assets_manager.dart';
import '../../utils/color_manager.dart';
import '../../utils/font_manager.dart';
import '../../utils/styles_manager.dart';
import '../../utils/values_manager.dart';

/// Figma `Search Bar`: 52px white pill with a pale rose border, a soft shadow
/// and a trailing magnifier glyph.
class AppSearchField extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final Key? fieldKey;

  const AppSearchField({
    super.key,
    required this.hintText,
    this.onChanged,
    this.controller,
    this.fieldKey,
  });

  @override
  Widget build(BuildContext context) {
    final hintStyle = getRegularStyle(
      fontSize: FontSize.s14,
      color: ColorManager.textMuted,
    );
    return Container(
      height: AppSize.s52,
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p20),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(AppSize.radiusXLarge),
        border: Border.all(
          color: ColorManager.searchBorder,
          width: AppSize.s0_876,
        ),
        boxShadow: [
          BoxShadow(
            color: ColorManager.black.withValues(alpha: AppOpacity.faint),
            offset: const Offset(AppSize.s0, AppSize.offsetCard),
            blurRadius: AppSize.blurRequestCard,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              key: fieldKey,
              controller: controller,
              onChanged: onChanged,
              textAlign: TextAlign.center,
              style: hintStyle,
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: hintStyle,
              ),
            ),
          ),
          const SizedBox(width: AppSize.s10),
          SvgPicture.asset(
            SvgAssets.search,
            width: AppSize.s18,
            height: AppSize.s18,
          ),
        ],
      ),
    );
  }
}
