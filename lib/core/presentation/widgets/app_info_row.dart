import 'package:flutter/material.dart';

import '../../utils/color_manager.dart';
import '../../utils/font_manager.dart';
import '../../utils/styles_manager.dart';

/// A label/value pair spread across the full card width — grey label on the
/// leading (right) side, red value on the trailing (left) side.
class AppInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const AppInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            label,
            style: getMediumStyle(
              fontSize: FontSize.s14,
              color: ColorManager.navInactive,
              lineHeight: LineHeight.h14,
            ),
          ),
        ),
        Text(
          value,
          style: getMediumStyle(
            fontSize: FontSize.s14,
            color: valueColor ?? ColorManager.cardValue,
            lineHeight: LineHeight.h14,
          ),
        ),
      ],
    );
  }
}
