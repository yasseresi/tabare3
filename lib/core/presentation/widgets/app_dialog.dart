import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/app_dimensions.dart';
import '../../utils/assets_manager.dart';
import '../../utils/color_manager.dart';
import '../../utils/font_manager.dart';
import '../../utils/string_manager.dart';
import '../../utils/styles_manager.dart';
import '../../utils/values_manager.dart';

enum AppDialogType { success, error, warning, loading }

/// White rounded modal used for every confirmation and result card in the
/// design: a status glyph, a bold title, optional body copy and one or two
/// stacked pill buttons.
class AppDialog extends StatelessWidget {
  final AppDialogType type;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final String? secondaryLabel;
  final VoidCallback? onSecondaryAction;
  final Key? actionKey;
  final Key? secondaryKey;

  const AppDialog.success({
    super.key,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.actionKey,
  }) : type = AppDialogType.success,
       secondaryLabel = null,
       onSecondaryAction = null,
       secondaryKey = null;

  const AppDialog.error({
    super.key,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.actionKey,
  }) : type = AppDialogType.error,
       secondaryLabel = null,
       onSecondaryAction = null,
       secondaryKey = null;

  /// Destructive confirmation: red warning triangle over a red primary button
  /// and a grey secondary button.
  const AppDialog.warning({
    super.key,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.secondaryLabel,
    this.onSecondaryAction,
    this.actionKey,
    this.secondaryKey,
  }) : type = AppDialogType.warning;

  const AppDialog.loading({super.key, required this.title})
    : message = null,
      actionLabel = null,
      onAction = null,
      secondaryLabel = null,
      onSecondaryAction = null,
      actionKey = null,
      secondaryKey = null,
      type = AppDialogType.loading;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: ColorManager.transparent,
      elevation: AppSize.s0,
      child: Container(
        width: AppSize.s320,
        padding: const EdgeInsets.all(AppPadding.p40),
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.circular(AppSize.s40),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _buildContent(),
        ),
      ),
    );
  }

  List<Widget> _buildContent() {
    switch (type) {
      case AppDialogType.success:
        return [
          _buildBadge(ColorManager.dialogSuccess, Icons.check),
          const SizedBox(height: AppSize.s10),
          _buildTitle(),
          if (message != null) ...[
            const SizedBox(height: AppSize.s10),
            Text(
              message!,
              textAlign: TextAlign.center,
              style: getBoldStyle(
                fontSize: FontSize.s16,
                color: ColorManager.welcomeText,
              ),
            ),
            const SizedBox(height: AppSize.s10),
          ] else ...[
            const SizedBox(height: AppSize.s10),
            _buildLogo(),
            const SizedBox(height: AppSize.s20),
          ],
          _buildPrimaryButton(),
        ];
      case AppDialogType.error:
        return [
          _buildBadge(ColorManager.error, Icons.close),
          const SizedBox(height: AppSize.s10),
          _buildTitle(),
          if (message != null) ...[
            const SizedBox(height: AppSize.s8),
            Text(
              message!,
              textAlign: TextAlign.center,
              style: getRegularStyle(
                fontSize: FontSize.s14,
                color: ColorManager.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: AppSize.s20),
          _buildPrimaryButton(),
        ];
      case AppDialogType.warning:
        return [
          SvgPicture.asset(
            SvgAssets.warning,
            width: AppSize.s60,
            height: AppSize.s60,
          ),
          const SizedBox(height: AppSize.s10),
          _buildTitle(),
          if (message != null) ...[
            const SizedBox(height: AppSize.s10),
            Text(
              message!,
              textAlign: TextAlign.center,
              style: getBoldStyle(
                fontSize: FontSize.s16,
                color: ColorManager.navInactive,
              ),
            ),
          ],
          const SizedBox(height: AppSize.s10),
          _buildPrimaryButton(),
          if (secondaryLabel != null) ...[
            const SizedBox(height: AppSize.s10),
            _buildActionButton(
              label: secondaryLabel,
              onPressed: onSecondaryAction,
              background: ColorManager.navInactive,
              buttonKey: secondaryKey,
            ),
          ],
        ];
      case AppDialogType.loading:
        return [
          SizedBox(
            width: AppSize.s60,
            height: AppSize.s60,
            child: CircularProgressIndicator(
              color: ColorManager.primary,
              strokeWidth: AppSize.s4,
            ),
          ),
          const SizedBox(height: AppSize.s20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: getSemiBoldStyle(
              fontSize: FontSize.s16,
              color: ColorManager.textPrimary,
            ),
          ),
        ];
    }
  }

  Widget _buildBadge(Color color, IconData icon) {
    return Container(
      width: AppSize.s62,
      height: AppSize.s63,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Icon(icon, color: ColorManager.white, size: AppSize.s40),
    );
  }

  Widget _buildTitle() {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: getBoldStyle(
        fontSize: FontSize.s16,
        color: ColorManager.navInactive,
      ),
    );
  }

  Widget _buildLogo() {
    return Image.asset(
      ImageAssets.icon6,
      width: AppSize.s76,
      height: AppSize.s76,
      errorBuilder: (_, _, _) => Icon(
        Icons.bloodtype_outlined,
        color: ColorManager.primary,
        size: AppSize.s76,
      ),
    );
  }

  Widget _buildPrimaryButton() => _buildActionButton(
    label: actionLabel,
    onPressed: onAction,
    buttonKey: actionKey,
  );

  Widget _buildActionButton({
    String? label,
    VoidCallback? onPressed,
    Color? background,
    Key? buttonKey,
  }) {
    return SizedBox(
      width: AppSize.s174,
      child: ElevatedButton(
        key: buttonKey,
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: background ?? ColorManager.primary,
          foregroundColor: ColorManager.white,
          padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.p20,
            vertical: AppSize.s11_6,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.radiusDialogAction),
          ),
          shadowColor: ColorManager.black.withValues(alpha: AppOpacity.muted),
          elevation: AppSize.s8,
          textStyle: getBoldStyle(
            fontSize: FontSize.s14,
            color: ColorManager.white,
          ),
        ),
        child: Text(label ?? AppStrings.continueAction.tr()),
      ),
    );
  }
}
