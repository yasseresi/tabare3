import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/widget_keys.dart';
import '../../utils/assets_manager.dart';
import '../../utils/color_manager.dart';
import '../../utils/font_manager.dart';
import '../../utils/styles_manager.dart';
import '../../utils/values_manager.dart';

class LogoutDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const LogoutDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.cancelLabel,
    this.onConfirm,
    this.onCancel,
  });

  Future<void> _dismiss(BuildContext context) async {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

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
          children: [
            SvgPicture.asset(
              SvgAssets.warning,
              width: AppSize.s60,
              height: AppSize.s60,
            ),
            const SizedBox(height: AppSize.s10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: getBoldStyle(
                fontSize: FontSize.s16,
                color: ColorManager.welcomeText,
              ),
            ),
            const SizedBox(height: AppSize.s10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: getBoldStyle(
                fontSize: FontSize.s16,
                color: ColorManager.welcomeText,
              ),
            ),
            const SizedBox(height: AppSize.s20),
            _ActionButton(
              key: WidgetKeys.logoutDialogConfirmButton,
              label: confirmLabel,
              backgroundColor: ColorManager.primary,
              onPressed: () async {
                await _dismiss(context);
                onConfirm?.call();
              },
            ),
            const SizedBox(height: AppSize.s10),
            _ActionButton(
              key: WidgetKeys.logoutDialogCancelButton,
              label: cancelLabel,
              backgroundColor: ColorManager.welcomeText,
              onPressed: () async {
                await _dismiss(context);
                onCancel?.call();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final VoidCallback? onPressed;

  const _ActionButton({
    super.key,
    required this.label,
    required this.backgroundColor,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSize.s174,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: ColorManager.white,
          padding: const EdgeInsets.symmetric(vertical: 11.6),
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
        child: Text(label),
      ),
    );
  }
}
