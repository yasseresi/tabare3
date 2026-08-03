import 'package:flutter/material.dart';

import '../../constants/app_dimensions.dart';
import '../../utils/color_manager.dart';
import '../../utils/values_manager.dart';

/// White surface used for every content block in the design: `#E1E3E4` hairline
/// border, generous corner radius and a very soft drop shadow.
class AppCard extends StatelessWidget {
  final Widget child;
  final double radius;
  final double blurRadius;
  final EdgeInsetsGeometry padding;

  const AppCard({
    super.key,
    required this.child,
    this.radius = AppSize.radiusXXLarge,
    this.blurRadius = AppSize.blurCard,
    this.padding = const EdgeInsets.all(AppPadding.pCard),
  });

  /// Variant used for request/appointment/record list items: slightly tighter
  /// radius and a shallower shadow.
  const AppCard.list({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppPadding.pCard),
  }) : radius = AppSize.radiusRequestCard,
       blurRadius = AppSize.blurRequestCard;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: ColorManager.borderGrey,
          width: AppSize.s0_876,
        ),
        boxShadow: [
          BoxShadow(
            color: ColorManager.black.withValues(alpha: AppOpacity.faint),
            offset: const Offset(AppSize.s0, AppSize.offsetCard),
            blurRadius: blurRadius,
          ),
        ],
      ),
      child: child,
    );
  }
}
