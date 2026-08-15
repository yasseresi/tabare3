import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

import '../../constants/widget_keys.dart';
import '../../utils/color_manager.dart';
import '../../utils/string_manager.dart';
import 'app_dialog.dart';

/// Logout confirmation. The design reuses the shared warning card verbatim, so
/// this only binds the copy, the stable keys and the dismiss-then-callback
/// ordering the profile screen relies on.
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

  void _dismiss(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog.warning(
      title: title,
      message: message,
      actionLabel: confirmLabel,
      actionKey: WidgetKeys.logoutDialogConfirmButton,
      onAction: () {
        _dismiss(context);
        onConfirm?.call();
      },
      secondaryLabel: cancelLabel,
      secondaryKey: WidgetKeys.logoutDialogCancelButton,
      onSecondaryAction: () {
        _dismiss(context);
        onCancel?.call();
      },
    );
  }
}

/// Result card shown once the session has actually ended. Both home shells
/// listen for `Unauthenticated`, so the copy and the exit route live here
/// rather than being duplicated in each of them.
Future<void> showLogoutSuccessDialog(
  BuildContext context, {
  required VoidCallback onDismissed,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierColor: ColorManager.dialogScrim,
    builder: (dialogContext) => Directionality(
      textDirection: TextDirection.rtl,
      child: AppDialog.success(
        title: AppStrings.logoutSuccess.tr(),
        message: AppStrings.logoutSuccessMessage.tr(),
        actionLabel: AppStrings.homePage.tr(),
        actionKey: WidgetKeys.logoutSuccessButton,
        onAction: () {
          Navigator.pop(dialogContext);
          onDismissed();
        },
      ),
    ),
  );
}
