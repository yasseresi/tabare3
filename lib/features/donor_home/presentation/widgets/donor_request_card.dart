import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

import '../../../../core/presentation/widgets/app_pill_button.dart';
import '../../../../core/presentation/widgets/request_card.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/constants_manager.dart';
import '../../../../core/utils/string_manager.dart';
import '../../domain/entities/donor_feed_entity.dart';

/// Localised label for a request urgency, matching the Figma chips.
String donorPriorityLabel(DonorRequestPriority priority) => switch (priority) {
  DonorRequestPriority.normal => AppStrings.normalPriority.tr(),
  DonorRequestPriority.semiUrgent => AppStrings.urgent.tr(),
  DonorRequestPriority.urgent => AppStrings.veryUrgent.tr(),
};

/// Status-dot colour for a request urgency.
Color donorPriorityColor(DonorRequestPriority priority) => switch (priority) {
  DonorRequestPriority.normal => ColorManager.urgencyNormal,
  DonorRequestPriority.semiUrgent => ColorManager.urgencyUrgent,
  DonorRequestPriority.urgent => ColorManager.urgencyCritical,
};

/// Request card as it appears on the donor home feed and requests tab.
class DonorRequestCard extends StatelessWidget {
  final DonorBloodRequestEntity request;
  final VoidCallback? onAccept;

  const DonorRequestCard({
    super.key,
    required this.request,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat(AppConstants.requestDateFormat);
    final deadline = request.neededBy ?? request.expiresAt;
    return RequestCard(
      title: request.patientName ?? request.hospital.nameAr,
      urgencyLabel: donorPriorityLabel(request.priority),
      urgencyColor: donorPriorityColor(request.priority),
      details: [
        RequestCardDetail(
          label: AppStrings.bloodType.tr(),
          value: request.bloodType,
          valueColor: ColorManager.primary,
        ),
        RequestCardDetail(
          label: AppStrings.requestDate.tr(),
          value: dateFormat.format(request.createdAt.toLocal()),
        ),
        if (deadline != null)
          RequestCardDetail(
            label: AppStrings.lastDeadline.tr(),
            value: dateFormat.format(deadline.toLocal()),
          ),
        RequestCardDetail(
          label: request.hospital.nameAr,
          value: request.hospital.address ?? AppStrings.location.tr(),
        ),
        RequestCardDetail(
          label: AppStrings.unitsProgress.tr(
            args: [
              request.unitsFulfilled.toString(),
              request.unitsNeeded.toString(),
            ],
          ),
          value: '${request.unitsFulfilled}/${request.unitsNeeded}',
        ),
      ],
      progress: request.unitsNeeded == 0
          ? 0
          : request.unitsFulfilled / request.unitsNeeded,
      footer: AppPillButton(
        label: AppStrings.acceptRequest.tr(),
        onPressed: onAccept,
      ),
    );
  }
}
