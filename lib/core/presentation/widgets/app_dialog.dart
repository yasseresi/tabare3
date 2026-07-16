import 'package:flutter/material.dart';
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.s40),
      ),
      child: Container(
        width: AppSize.s320,
        padding: const EdgeInsets.all(AppPadding.p40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _buildChildren(),
        ),
      ),
    );
  }

  List<Widget> _buildChildren() {
    switch (type) {
      case AppDialogType.success:
        return [
          Icon(
            Icons.check_circle,
            color: ColorManager.secondary,
            size: AppSize.s60,
          ),
          const SizedBox(height: AppSize.s10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: getBoldStyle(
              fontSize: FontSize.s16,
              color: const Color(0xff5A5A5A),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: AppSize.s10),
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
      case AppDialogType.error:
        return [
          Icon(
            Icons.error_outline,
            color: ColorManager.error,
            size: AppSize.s60,
          ),
          const SizedBox(height: AppSize.s10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: getBoldStyle(
              fontSize: FontSize.s16,
              color: const Color(0xff5A5A5A),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: AppSize.s10),
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

  Widget _buildActionButton() {
    return SizedBox(
      width: 174,
      child: ElevatedButton(
        onPressed: onAction,
        child: Text(actionLabel ?? 'متابعة'),
      ),
    );
  }
}
