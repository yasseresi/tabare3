import 'package:flutter/material.dart';

import '../../utils/color_manager.dart';
import '../../utils/font_manager.dart';
import '../../utils/styles_manager.dart';
import '../../utils/values_manager.dart';

/// Figma `Button - Tag: Discipline`: a fully rounded chip with an optional
/// 8px status dot. Used for eligibility, urgency and stat values.
class AppTagPill extends StatelessWidget {
  final String label;
  final Color? dotColor;
  final Color? background;
  final Color? labelColor;
  final EdgeInsetsGeometry padding;

  const AppTagPill({
    super.key,
    required this.label,
    this.dotColor,
    this.background,
    this.labelColor,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppPadding.p12,
      vertical: AppPadding.p6,
    ),
  });

  /// Compact variant used for the stat values on the profile card.
  const AppTagPill.value({super.key, required this.label})
    : dotColor = null,
      background = null,
      labelColor = null,
      padding = const EdgeInsets.symmetric(
        horizontal: AppPadding.p8,
        vertical: AppPadding.p2,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: background ?? ColorManager.surfaceLight,
        borderRadius: BorderRadius.circular(AppSize.radiusCircle),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dotColor != null) ...[
            Container(
              width: AppSize.s8,
              height: AppSize.s8,
              decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
            ),
            const SizedBox(width: AppSize.s8),
          ],
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: getRegularStyle(
                fontSize: FontSize.s12,
                color: labelColor ?? ColorManager.black,
                lineHeight: LineHeight.h16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
