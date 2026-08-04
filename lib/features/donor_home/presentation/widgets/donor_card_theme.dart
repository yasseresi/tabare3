import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/font_manager.dart';
import '../../../../core/utils/styles_manager.dart';
import '../../../../core/utils/values_manager.dart';

/// The near-black canvas with a purple wash that both donor-card screens sit
/// on, matching the Figma `iPhone 17 - 81` background.
class DonorCardBackground extends StatelessWidget {
  final Widget child;

  const DonorCardBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorManager.donorCardBackground,
        gradient: LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          colors: [
            ColorManager.donorCardGradientStart,
            ColorManager.donorCardGradientEnd,
          ],
        ),
      ),
      child: child,
    );
  }
}

/// `Section - Progress Card`: the dark grey rounded panel used for the level
/// progress block and each badge tile.
class DonorCardPanel extends StatelessWidget {
  final Widget child;
  final double? width;

  const DonorCardPanel({super.key, required this.child, this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(AppPadding.p24),
      decoration: BoxDecoration(
        color: ColorManager.donorCardSurface,
        borderRadius: BorderRadius.circular(AppSize.radiusDonorCard),
        boxShadow: [
          BoxShadow(
            color: ColorManager.donorCardShadow.withValues(
              alpha: AppOpacity.faint,
            ),
            offset: const Offset(AppSize.s0, AppSize.s8),
            blurRadius: AppSize.blurDonorCard,
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Purple-tinted `N نقطة` chip with a trailing dot.
class DonorPointsChip extends StatelessWidget {
  final String label;

  const DonorPointsChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.p12,
        vertical: AppPadding.p6,
      ),
      decoration: BoxDecoration(
        color: ColorManager.donorCardAccent.withValues(alpha: AppOpacity.chip),
        borderRadius: BorderRadius.circular(AppSize.radiusCircle),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: getRegularStyle(
                fontSize: FontSize.s12,
                color: ColorManager.white,
                lineHeight: LineHeight.h16,
              ),
            ),
          ),
          const SizedBox(width: AppSize.s10),
          Container(
            width: AppSize.s8,
            height: AppSize.s8,
            decoration: BoxDecoration(
              color: ColorManager.donorCardAccent,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}

/// Level name chip in the wrap above the progress card. The donor's current
/// level is filled dark purple with white text; the rest stay light.
class DonorLevelChip extends StatelessWidget {
  final String label;
  final bool active;

  const DonorLevelChip({
    super.key,
    required this.label,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.p12,
        vertical: AppPadding.p6,
      ),
      decoration: BoxDecoration(
        color: active
            ? ColorManager.donorCardChipActive
            : ColorManager.surfaceLight,
        borderRadius: BorderRadius.circular(AppSize.radiusCircle),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: AppSize.s8,
            height: AppSize.s8,
            decoration: BoxDecoration(
              color: ColorManager.donorCardDot,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSize.s8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: getRegularStyle(
              fontSize: FontSize.s12,
              color: active
                  ? ColorManager.white
                  : ColorManager.donorCardChipLabel,
              lineHeight: LineHeight.h16,
            ),
          ),
        ],
      ),
    );
  }
}

/// 16px rounded level progress bar with the purple gradient fill.
class DonorLevelProgressBar extends StatelessWidget {
  /// Completion between `0.0` and `1.0`.
  final double value;

  const DonorLevelProgressBar({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSize.s16,
      decoration: BoxDecoration(
        color: ColorManager.donorCardTrack,
        borderRadius: BorderRadius.circular(AppSize.radiusCircle),
      ),
      child: FractionallySizedBox(
        alignment: AlignmentDirectional.centerStart,
        widthFactor: value.clamp(AppSize.s0, AppSize.s1),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSize.radiusCircle),
            gradient: LinearGradient(
              colors: [
                ColorManager.donorCardAccent.withValues(
                  alpha: AppOpacity.strong,
                ),
                ColorManager.donorCardAccent,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Full-width purple pill button (`ماهي بطاقة المتبرع`).
class DonorCardButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Key? buttonKey;

  const DonorCardButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.buttonKey,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppSize.radiusDialogAction);
    return SizedBox(
      width: AppSize.s174,
      child: Material(
        color: ColorManager.donorCardAccentSoft,
        borderRadius: radius,
        child: InkWell(
          key: buttonKey,
          onTap: onPressed,
          borderRadius: radius,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppPadding.p11_6),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: getBoldStyle(
                fontSize: FontSize.s14,
                color: ColorManager.white,
                lineHeight: LineHeight.h17,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
