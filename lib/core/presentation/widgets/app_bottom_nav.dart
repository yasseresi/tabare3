import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/color_manager.dart';
import '../../utils/values_manager.dart';
import 'app_gradient_background.dart';

class AppBottomNavItem {
  final String asset;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final String? tooltip;
  final Key? itemKey;

  const AppBottomNavItem({
    required this.asset,
    required this.selected,
    required this.onTap,
    this.onLongPress,
    this.tooltip,
    this.itemKey,
  });
}

/// Figma `Bottom Nav`: 402x80, 32px horizontal padding, 35x35 icons laid out
/// with space-between. Active icons are primary red, inactive are `#5A5A5A`.
class AppBottomNav extends StatelessWidget {
  final List<AppBottomNavItem> items;

  /// Wraps the nav band in a background. Defaults to [AppGradientBackground]
  /// (the pink wash). Screens with a different page background (e.g. the dark
  /// donor-card screens) pass their own so the nav band matches the page it
  /// sits below instead of showing a mismatched colour band.
  final Widget Function(Widget child)? backgroundBuilder;

  const AppBottomNav({
    super.key,
    required this.items,
    this.backgroundBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final content = SizedBox(
      height: AppSize.s80,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.p32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final item in items) _AppBottomNavIcon(item: item),
            ],
          ),
        ),
      ),
    );

    return backgroundBuilder?.call(content) ??
        AppGradientBackground(child: content);
  }
}

class _AppBottomNavIcon extends StatelessWidget {
  final AppBottomNavItem item;

  const _AppBottomNavIcon({required this.item});

  @override
  Widget build(BuildContext context) {
    final icon = SvgPicture.asset(
      item.asset,
      width: AppSize.s35,
      height: AppSize.s35,
      colorFilter: ColorFilter.mode(
        item.selected ? ColorManager.navActive : ColorManager.navInactive,
        BlendMode.srcIn,
      ),
    );

    return InkWell(
      key: item.itemKey,
      onTap: item.onTap,
      onLongPress: item.onLongPress,
      customBorder: const CircleBorder(),
      child: Semantics(
        button: true,
        label: item.tooltip,
        child: SizedBox(
          width: AppSize.s35,
          height: AppSize.s35,
          child: icon,
        ),
      ),
    );
  }
}
