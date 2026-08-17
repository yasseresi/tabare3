import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/widget_keys.dart';
import '../../../../core/utils/string_manager.dart';
import '../../../../core/utils/values_manager.dart';

/// Shows the shared request-cancellation dialog and resolves to the trimmed
/// reason the user entered, or `null` if they dismissed it. Extracted so the
/// edit and list screens open the exact same flow.
Future<String?> showRequestCancellationDialog(BuildContext context) {
  return showDialog<String>(
    context: context,
    builder: (_) => const _RequestCancellationDialog(),
  );
}

class _RequestCancellationDialog extends StatefulWidget {
  const _RequestCancellationDialog();

  @override
  State<_RequestCancellationDialog> createState() =>
      _RequestCancellationDialogState();
}

class _RequestCancellationDialogState
    extends State<_RequestCancellationDialog> {
  final _reasonController = TextEditingController();
  String? _validationMessage;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppStrings.cancelRequest.tr()),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppStrings.confirmCancelRequest.tr(),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: AppSize.s16),
            TextField(
              key: WidgetKeys.requestCancelReasonField,
              controller: _reasonController,
              maxLines: AppSize.s3.toInt(),
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                labelText: AppStrings.cancellationReason.tr(),
                errorText: _validationMessage,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppStrings.cancel.tr()),
        ),
        ElevatedButton(
          key: WidgetKeys.requestCancelConfirmButton,
          onPressed: _confirm,
          child: Text(AppStrings.confirm.tr()),
        ),
      ],
    );
  }

  void _confirm() {
    final reason = _reasonController.text.trim();
    if (reason.isEmpty) {
      setState(
        () => _validationMessage = AppStrings.cancellationReasonRequired.tr(),
      );
      return;
    }
    Navigator.pop(context, reason);
  }
}
