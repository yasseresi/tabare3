import 'package:flutter/material.dart';

import '../../utils/assets_manager.dart';
import '../../utils/color_manager.dart';
import '../../utils/font_manager.dart';
import '../../utils/styles_manager.dart';
import '../../utils/values_manager.dart';

enum AppDialogType { success, error, loading }

class AppDialog extends StatelessWidget {
  final AppDialogType type;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const AppDialog.success({
    super.key,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
  }) : type = AppDialogType.success;

  const AppDialog.error({
    super.key,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
  }) : type = AppDialogType.error;

  const AppDialog.loading({super.key, required this.title})
    : message = null,
      actionLabel = null,
      onAction = null,
      type = AppDialogType.loading;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        width: AppSize.s320,
        padding: const EdgeInsets.all(AppSize.s40),
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
          _buildSuccessIcon(),
          const SizedBox(height: AppSize.s10),
          _buildText(),
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
          ] else ...[
            const SizedBox(height: AppSize.s10),
            _buildLogo(),
            const SizedBox(height: AppSize.s20),
          ],
          if (message != null) const SizedBox(height: AppSize.s10),
          _buildActionButton(),
        ];
      case AppDialogType.error:
        return [
          _buildErrorIcon(),
          const SizedBox(height: AppSize.s10),
          _buildText(),
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
          _buildActionButton(),
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

  Widget _buildSuccessIcon() {
    return Container(
      width: 62,
      height: 63,
      decoration: const BoxDecoration(
        color: Color(0xFF4CAF50),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.check, color: Colors.white, size: 40),
    );
  }

  Widget _buildErrorIcon() {
    return Container(
      width: 62,
      height: 63,
      decoration: const BoxDecoration(
        color: Color(0xFFC0392B),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.close, color: Colors.white, size: 40),
    );
  }

  Widget _buildText() {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: getBoldStyle(
        fontSize: FontSize.s16,
        color: const Color(0xFF5A5A5A),
      ),
    );
  }

  Widget _buildLogo() {
    return Image.asset(
      ImageAssets.icon6,
      width: AppSize.s76,
      height: AppSize.s76,
      errorBuilder: (_, __, ___) => Icon(
        Icons.bloodtype_outlined,
        color: ColorManager.primary,
        size: AppSize.s76,
      ),
    );
  }

  Widget _buildActionButton() {
    return SizedBox(
      width: 174,
      child: ElevatedButton(
        onPressed: onAction,
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorManager.primary,
          foregroundColor: ColorManager.white,
          padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.p20,
            vertical: 11.6,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17.4),
          ),
          shadowColor: Colors.black.withValues(alpha: 0.1),
          elevation: AppSize.s8,
          textStyle: getBoldStyle(
            fontSize: FontSize.s14,
            color: ColorManager.white,
          ),
        ),
        child: Text(actionLabel ?? 'متابعة'),
      ),
    );
  }
}
