import 'package:flutter/material.dart';

import '../../constants/widget_keys.dart';
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
