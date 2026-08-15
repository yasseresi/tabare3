import 'package:flutter/material.dart';

import '../../utils/assets_manager.dart';
import '../../utils/color_manager.dart';
import '../../utils/font_manager.dart';
import '../../utils/styles_manager.dart';
import '../../utils/values_manager.dart';

/// Centred illustration, headline and one or two supporting paragraphs, used
/// wherever a list has nothing to show.
class AppEmptyState extends StatelessWidget {
  final String title;
  final String message;
  final String? secondaryMessage;
  final Widget? action;

  /// Illustration above the headline. Defaults to the patient artwork; the
  /// appointment and notification empty states pass their own.
  final String illustration;

  const AppEmptyState({
    super.key,
    required this.title,
    required this.message,
    this.secondaryMessage,
    this.action,
    this.illustration = ImageAssets.requestAvatar,
  });

  @override
  Widget build(BuildContext context) {
    final messageStyle = getMediumStyle(
      fontSize: FontSize.s20,
      color: ColorManager.textMuted,
      lineHeight: LineHeight.h24,
    );
    return Padding(
      padding: const EdgeInsets.only(
        top: AppPadding.p20,
        left: AppPadding.p40,
        right: AppPadding.p40,
      ),
      child: Column(
        children: [
          Image.asset(
            illustration,
            width: AppSize.s100,
            height: AppSize.s100,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: AppSize.s9_6),
          Text(
            title,
            textAlign: TextAlign.center,
            style: getBoldStyle(
              fontSize: FontSize.s24,
              color: ColorManager.textPrimary,
            ),
          ),
          const SizedBox(height: AppSize.s9_6),
          Text(message, textAlign: TextAlign.center, style: messageStyle),
          if (secondaryMessage != null) ...[
            const SizedBox(height: AppSize.s10),
            Text(
              secondaryMessage!,
              textAlign: TextAlign.center,
              style: messageStyle,
            ),
          ],
          if (action != null) ...[
            const SizedBox(height: AppSize.s20),
            action!,
          ],
        ],
      ),
    );
  }
}
