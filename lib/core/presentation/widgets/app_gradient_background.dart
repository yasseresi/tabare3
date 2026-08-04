import 'package:flutter/material.dart';

import '../../utils/color_manager.dart';

/// The warm pink → lilac wash every screen sits on.
///
/// Figma paints a ~86° gradient of two 25%-opacity colours over a solid white
/// base, so the white has to be a real layer underneath: [BoxDecoration]
/// ignores its `color` whenever a `gradient` is set, and the app's
/// `scaffoldBackgroundColor` is transparent, so a single decorated container
/// would composite the wash against nothing and render it near full strength.
class AppGradientBackground extends StatelessWidget {
  final Widget child;

  const AppGradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: ColorManager.white,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              ColorManager.welcomeGradientStart,
              ColorManager.welcomeGradientEnd,
            ],
          ),
        ),
        child: child,
      ),
    );
  }
}
