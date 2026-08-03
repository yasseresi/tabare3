import 'package:flutter/material.dart';

import '../../utils/color_manager.dart';

/// The warm pink → lilac wash every screen sits on. Figma paints it as a
/// 87.18° linear gradient over a solid white base, which maps to a
/// top-right → bottom-left [LinearGradient] on an opaque white container.
class AppGradientBackground extends StatelessWidget {
  final Widget child;

  const AppGradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorManager.white,
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            ColorManager.welcomeGradientStart,
            ColorManager.welcomeGradientEnd,
          ],
        ),
      ),
      child: child,
    );
  }
}
