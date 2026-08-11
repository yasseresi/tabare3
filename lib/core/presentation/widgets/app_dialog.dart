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
      // The design frame insets the card by 20 horizontally and centres it
      // vertically; the default Material inset would squeeze the two-button
      // variants, whose copy can run to several lines.
      insetPadding: const EdgeInsets.symmetric(horizontal: AppPadding.p20),
      child: Container(
        width: AppSize.s320,
        padding: const EdgeInsets.all(AppPadding.p40),
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.circular(AppSize.s40),
        ),
        // Keeps the card intact rather than overflowing when the viewport is
        // shorter than the card (small phones, split screen).
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _buildContent(),
          ),
        ),
      ),
    );
  }

  /// Every card in the design stacks its children with a uniform `10` gap, so
  /// the variants only differ in which children they contribute.
  List<Widget> _buildContent() {
    switch (type) {
      case AppDialogType.success:
        return _withGaps([
          // The "logo" flavour of the card (signup/login success) uses the
          // slightly larger 62x63 tick; the body-copy flavour uses 60x60.
          _buildSuccessBadge(
            message == null ? AppSize.s62 : AppSize.s60,
            message == null ? AppSize.s63 : AppSize.s60,
          ),
          _buildTitle(),
          if (message != null) _buildBody(message!) else _buildLogo(),
          _buildPrimaryButton(),
        ]);
      case AppDialogType.error:
        return _withGaps([
          _buildErrorBadge(),
          _buildTitle(),
          if (message != null)
            Text(
              message!,
              textAlign: TextAlign.center,
              style: getRegularStyle(
                fontSize: FontSize.s14,
                color: ColorManager.textSecondary,
              ),
            ),
          _buildPrimaryButton(),
        ]);
      case AppDialogType.warning:
        return _withGaps([
          SvgPicture.asset(
            SvgAssets.warning,
            width: AppSize.s60,
            height: AppSize.s60,
          ),
          _buildTitle(),
          if (message != null) _buildBody(message!),
          _buildPrimaryButton(),
          if (secondaryLabel != null)
            _buildActionButton(
              label: secondaryLabel,
              onPressed: onSecondaryAction,
              background: ColorManager.navInactive,
              buttonKey: secondaryKey,
            ),
        ]);
      case AppDialogType.loading:
        return _withGaps([
          SizedBox(
            width: AppSize.s60,
            height: AppSize.s60,
            child: CircularProgressIndicator(
              color: ColorManager.primary,
              strokeWidth: AppSize.s4,
            ),
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: getSemiBoldStyle(
              fontSize: FontSize.s16,
              color: ColorManager.textPrimary,
            ),
          ),
        ]);
    }
  }

  /// Interleaves the Figma `gap: 10` between the card's children.
  List<Widget> _withGaps(List<Widget> children) => [
    for (var i = 0; i < children.length; i++) ...[
      if (i > 0) const SizedBox(height: AppSize.s10),
      children[i],
    ],
  ];

  Widget _buildSuccessBadge(double width, double height) {
    return SvgPicture.asset(
      SvgAssets.successCheck,
      width: width,
      height: height,
    );
  }

  Widget _buildErrorBadge() {
    return Container(
      width: AppSize.s62,
      height: AppSize.s63,
      decoration: BoxDecoration(
        color: ColorManager.error,
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.close, color: ColorManager.white, size: AppSize.s40),
    );
  }

  Widget _buildTitle() {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: getBoldStyle(
        fontSize: FontSize.s16,
        color: ColorManager.navInactive,
        lineHeight: LineHeight.h22_75,
      ),
    );
  }

  Widget _buildBody(String body) {
    return Text(
      body,
      textAlign: TextAlign.center,
      style: getBoldStyle(
        fontSize: FontSize.s16,
        color: ColorManager.navInactive,
        lineHeight: LineHeight.h22_75,
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
          // Figma button is exactly 174 x 40.6 (11.6 vertical padding + 17.4
          // line). The default padded tap target inflates the height to 48, so
          // shrink-wrap it and drop the min size to honour the design box.
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          // No horizontal padding in Figma: the button is a fixed 174 box with
          // only vertical padding, so the label keeps the full width and stays
          // on one line ("تحديث الملف الشخصي").
          padding: const EdgeInsets.symmetric(vertical: AppSize.s11_6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.radiusDialogAction),
          ),
          shadowColor: ColorManager.black.withValues(alpha: AppOpacity.muted),
          elevation: AppSize.s8,
          textStyle: getBoldStyle(
            fontSize: FontSize.s14,
            color: ColorManager.white,
            lineHeight: LineHeight.h17,
          ),
        ),
        // Figma keeps every action label on a single line inside the fixed
        // 174 box (e.g. "تحديث الملف الشخصي"); force it rather than wrap.
        child: Text(
          label ?? AppStrings.continueAction.tr(),
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.visible,
        ),
      ),
    );
  }
}
