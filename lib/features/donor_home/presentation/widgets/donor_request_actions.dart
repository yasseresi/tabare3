import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/widget_keys.dart';
import '../../../../core/presentation/widgets/adaptive_pickers.dart';
import '../../../../core/presentation/widgets/app_dialog.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/constants_manager.dart';
import '../../../../core/utils/string_manager.dart';
import '../bloc/donor_feed_bloc.dart';

/// Confirms the intent, asks the donor for an appointment slot and dispatches
/// [DonorRequestAccepted].
///
/// Shared by the donor home feed and the requests tab so both offer the same
/// confirm-then-date-then-time flow.
Future<void> acceptDonorRequest(BuildContext context, String requestId) async {
  final bloc = context.read<DonorFeedBloc>();
  final confirmed = await showDialog<bool>(
    context: context,
    barrierColor: ColorManager.dialogScrim,
    builder: (dialogContext) => Directionality(
      textDirection: TextDirection.rtl,
      child: AppDialog.warning(
        title: AppStrings.confirmAcceptRequest.tr(),
        message: AppStrings.acceptRequestNotice.tr(),
        actionLabel: AppStrings.confirm.tr(),
        actionKey: WidgetKeys.acceptRequestConfirmButton,
        onAction: () => Navigator.pop(dialogContext, true),
        secondaryLabel: AppStrings.cancel.tr(),
        onSecondaryAction: () => Navigator.pop(dialogContext, false),
      ),
    ),
  );
  if (confirmed != true || !context.mounted) return;
  final now = DateTime.now();
  final firstDate = now.add(
    const Duration(days: AppConstants.requestCalendarStartOffsetDays),
  );
  final date = await showAdaptiveDatePicker(
    context: context,
    initialDate: firstDate,
    firstDate: firstDate,
    lastDate: now.add(
      const Duration(days: AppConstants.requestCalendarRangeDays),
    ),
  );
  if (date == null || !context.mounted) return;
  final time = await showAdaptiveTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(firstDate),
  );
  if (time == null) return;
  bloc.add(
    DonorRequestAccepted(
      requestId: requestId,
      scheduledAt: DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      ),
    ),
  );
}
