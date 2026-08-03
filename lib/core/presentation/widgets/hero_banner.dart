import 'package:flutter/material.dart';

import '../../constants/app_dimensions.dart';
import '../../utils/assets_manager.dart';
import '../../utils/color_manager.dart';
import '../../utils/font_manager.dart';
import '../../utils/styles_manager.dart';
import '../../utils/values_manager.dart';

/// The red gradient banner that introduces the appointments, record and donor
/// list screens: an IV-bag illustration on one side, a title and a paragraph of
/// explanatory copy on the other.
class HeroBanner extends StatelessWidget {
  final String title;
  final String message;

  const HeroBanner({super.key, required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppPadding.pCard),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.radiusXXLarge),
        border: Border.all(
          color: ColorManager.borderGrey,
          width: AppSize.s0_876,
        ),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            ColorManager.heroGradientStart,
            ColorManager.heroGradientEnd,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: ColorManager.black.withValues(alpha: AppOpacity.faint),
            offset: const Offset(AppSize.s0, AppSize.offsetCard),
            blurRadius: AppSize.blurCard,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: AppSize.s200,
            child: Column(
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: getSemiBoldStyle(
                    fontSize: FontSize.s24,
                    color: ColorManager.white,
                    lineHeight: LineHeight.h28,
                  ),
                ),
                const SizedBox(height: AppSize.s10),
                Padding(
                  padding: const EdgeInsets.only(top: AppPadding.p4),
                  child: Text(
                    message,
                    style: getMediumStyle(
                      fontSize: FontSize.s12,
                      color: ColorManager.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Image.asset(
            ImageAssets.heroIvBag,
            width: AppSize.s130,
            height: AppSize.s104,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
