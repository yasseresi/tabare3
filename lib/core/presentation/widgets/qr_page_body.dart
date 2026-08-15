import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

import '../../utils/color_manager.dart';
import '../../utils/font_manager.dart';
import '../../utils/string_manager.dart';
import '../../utils/styles_manager.dart';
import '../../utils/values_manager.dart';

/// `رمز QR` heading, a one-line explanation and a square slot that holds either
/// the camera preview (donor) or the rendered code (recipient).
class QrPageBody extends StatelessWidget {
  final String description;
  final Widget square;

  const QrPageBody({
    super.key,
    required this.description,
    required this.square,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          AppStrings.qrCodeTitle.tr(),
          textAlign: TextAlign.center,
          style: getBoldStyle(
            fontSize: FontSize.s24,
            color: ColorManager.textPrimary,
          ),
        ),
        const SizedBox(height: AppSize.s10),
        Text(
          description,
          textAlign: TextAlign.center,
          style: getMediumStyle(
            fontSize: FontSize.s20,
            color: ColorManager.textMuted,
            lineHeight: LineHeight.h24,
          ),
        ),
        const SizedBox(height: AppSize.s12),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final side = math.min(
                constraints.maxWidth,
                constraints.maxHeight,
              );
              return Center(
                child: SizedBox(width: side, height: side, child: square),
              );
            },
          ),
        ),
      ],
    );
  }
}
