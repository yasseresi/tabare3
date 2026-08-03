import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/constants_manager.dart';
import '../bloc/donor_feed_bloc.dart';

/// Asks the donor for an appointment slot and dispatches [DonorRequestAccepted].
///
/// Shared by the donor home feed and the requests tab so both offer the same
/// date-then-time flow.
Future<void> acceptDonorRequest(BuildContext context, String requestId) async {
  final bloc = context.read<DonorFeedBloc>();
  final now = DateTime.now();
  final firstDate = now.add(
    const Duration(days: AppConstants.requestCalendarStartOffsetDays),
  );
  final date = await showDatePicker(
    context: context,
    initialDate: firstDate,
    firstDate: firstDate,
    lastDate: now.add(
      const Duration(days: AppConstants.requestCalendarRangeDays),
    ),
  );
  if (date == null || !context.mounted) return;
  final time = await showTimePicker(
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
