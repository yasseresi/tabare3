import 'package:flutter/material.dart';

import '../../utils/color_manager.dart';
import '../../utils/font_manager.dart';
import '../../utils/styles_manager.dart';
import '../../utils/values_manager.dart';

/// Section title with an optional `عرض الكل` action on the opposite side.
class AppSectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Key? actionKey;

  /// Centres the title, as the profile and notification screens do.
  final bool centered;

  const AppSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
    this.actionKey,
    this.centered = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p10),
      child: Row(
        mainAxisAlignment: centered
            ? MainAxisAlignment.center
            : MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              title,
              style: getSemiBoldStyle(
                fontSize: FontSize.s16,
                color: ColorManager.sectionTitle,
                lineHeight: LineHeight.h28,
              ),
            ),
          ),
          if (actionLabel != null)
            InkWell(
              key: actionKey,
              onTap: onAction,
              child: Text(
                actionLabel!,
                style: getMediumStyle(
                  fontSize: FontSize.s14,
                  color: ColorManager.primary,
                  lineHeight: LineHeight.h20,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
