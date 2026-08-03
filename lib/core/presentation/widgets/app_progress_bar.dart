import 'package:flutter/material.dart';

import '../../utils/color_manager.dart';
import '../../utils/values_manager.dart';

/// 12px rounded fulfilment bar: pale blue track with a hairline border and a
/// dark red fill that grows from the leading (right) edge.
class AppProgressBar extends StatelessWidget {
  /// Completion between `0.0` and `1.0`.
  final double value;

  const AppProgressBar({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    final clamped = value.clamp(AppSize.s0, AppSize.s1);
    return Container(
      height: AppSize.s12,
      decoration: BoxDecoration(
        color: ColorManager.progressTrackLight,
        borderRadius: BorderRadius.circular(AppSize.radiusProgress),
        border: Border.all(
          color: ColorManager.progressTrackBorder,
          width: AppSize.s0_5,
        ),
      ),
      child: FractionallySizedBox(
        alignment: AlignmentDirectional.centerStart,
        widthFactor: clamped,
        child: Container(
          decoration: BoxDecoration(
            color: ColorManager.cardValue,
            borderRadius: BorderRadius.circular(AppSize.radiusProgress),
          ),
        ),
      ),
    );
  }
}
