import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/app_dimensions.dart';
import '../../utils/assets_manager.dart';
import '../../utils/color_manager.dart';
import '../../utils/font_manager.dart';
import '../../utils/styles_manager.dart';
import '../../utils/values_manager.dart';
import 'app_gradient_background.dart';

/// Figma `Section - ArtistGrid` header: 60px top / 10px bottom / 32px side
/// padding, greeting stack on the trailing side and a 40x40 circular bell
/// button on the leading side.
class AppHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onNotifications;
  final Key? notificationsKey;

  const AppHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.onNotifications,
    this.notificationsKey,
  });

  @override
  Widget build(BuildContext context) {
    // Opaque wash behind the header so list content scrolls out of sight
    // beneath it instead of bleeding through the greeting text.
    return AppGradientBackground(
      child: Padding(
        padding: const EdgeInsets.only(
          top: AppPadding.p60,
          bottom: AppPadding.p10,
          left: AppPadding.p32,
          right: AppPadding.p32,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: getExtraBoldStyle(
                      fontSize: FontSize.s18,
                      color: ColorManager.black,
                      lineHeight: LineHeight.h28,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: getSemiBoldStyle(
                      fontSize: FontSize.s14,
                      color: ColorManager.textMuted,
                      lineHeight: LineHeight.h30,
                    ),
                  ),
                ],
              ),
            ),
            _NotificationsButton(
              onPressed: onNotifications,
              buttonKey: notificationsKey,
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationsButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Key? buttonKey;

  const _NotificationsButton({this.onPressed, this.buttonKey});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: buttonKey,
      onTap: onPressed,
      customBorder: const CircleBorder(),
      child: Container(
        width: AppSize.s40,
        height: AppSize.s40,
        decoration: BoxDecoration(
          color: ColorManager.headerIconBg,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: ColorManager.black.withValues(alpha: AppOpacity.subtle),
              offset: const Offset(AppSize.s0, AppSize.s1),
              blurRadius: AppSize.s1,
            ),
          ],
        ),
        child: Center(
          child: SvgPicture.asset(
            SvgAssets.headerBell,
            width: AppSize.s24,
            height: AppSize.s24,
          ),
        ),
      ),
    );
  }
}
