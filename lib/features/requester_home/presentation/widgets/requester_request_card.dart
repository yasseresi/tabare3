import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/presentation/widgets/app_pill_button.dart';
import '../../../../core/presentation/widgets/app_tag_pill.dart';
import '../../../../core/presentation/widgets/request_card.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/constants_manager.dart';
import '../../../../core/utils/string_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../../domain/entities/blood_request_entity.dart';

/// Localised label for a request urgency.
String requesterPriorityLabel(RequestPriority priority) => switch (priority) {
  RequestPriority.normal => AppStrings.normalPriority.tr(),
  RequestPriority.semiUrgent => AppStrings.urgent.tr(),
  RequestPriority.urgent => AppStrings.veryUrgent.tr(),
};

/// Status-dot colour for a request urgency.
Color requesterPriorityColor(RequestPriority priority) => switch (priority) {
  RequestPriority.normal => ColorManager.urgencyNormal,
  RequestPriority.semiUrgent => ColorManager.urgencyUrgent,
  RequestPriority.urgent => ColorManager.urgencyCritical,
};

/// Localised label + colour for a request lifecycle status.
({String label, Color color}) requesterStatus(BloodRequestStatus status) =>
    switch (status) {
      BloodRequestStatus.open => (
        label: AppStrings.statusActivated.tr(),
        color: ColorManager.success,
      ),
      BloodRequestStatus.fulfilled => (
        label: AppStrings.statusCompleted.tr(),
        color: ColorManager.success,
      ),
      BloodRequestStatus.cancelled => (
        label: AppStrings.statusCancelled.tr(),
        color: ColorManager.urgencyCritical,
      ),
      BloodRequestStatus.expired => (
        label: AppStrings.statusExpired.tr(),
        color: ColorManager.navInactive,
      ),
    };

/// Request card as it appears on the recipient's home and request list, with a
/// status pill, an urgency pill and an edit action.
class RequesterRequestCard extends StatelessWidget {
  final BloodRequestEntity request;
  final String ownerName;
  final VoidCallback? onEdit;
  final VoidCallback? onViewDonors;
  final Key? editKey;
  final Key? viewDonorsKey;

  const RequesterRequestCard({
    super.key,
    required this.request,
    required this.ownerName,
    this.onEdit,
    this.onViewDonors,
    this.editKey,
    this.viewDonorsKey,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat(AppConstants.requestDateFormat);
    final status = requesterStatus(request.status);
    final deadline = request.neededBy ?? request.expiresAt;
    final patientName = request.patient?.fullName ?? ownerName;
    return RequestCard(
      title: patientName,
      tags: [
        AppTagPill(
          label: requesterPriorityLabel(request.priority),
          dotColor: requesterPriorityColor(request.priority),
          labelColor: ColorManager.navInactive,
        ),
        AppTagPill(
          label: status.label,
          dotColor: status.color,
          background: status.color.withValues(alpha: AppOpacity.tint),
        ),
      ],
      banner: request.isForSomeoneElse
          ? AppTagPill(
              label: AppStrings.forSomeoneElse.tr(),
              dotColor: ColorManager.urgencyUrgent,
              background: ColorManager.urgencyUrgent.withValues(
                alpha: AppOpacity.tint,
              ),
            )
          : null,
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
      footer: onViewDonors == null
          ? AppPillButton(
              label: AppStrings.editRequest.tr(),
              onPressed: onEdit,
              buttonKey: editKey,
            )
          : Row(
              children: [
                Expanded(
                  child: AppPillButton(
                    label: AppStrings.availableDonors.tr(),
                    onPressed: onViewDonors,
                    background: ColorManager.primary,
                    buttonKey: viewDonorsKey,
                  ),
                ),
                const SizedBox(width: AppSize.s16),
                Expanded(
                  child: AppPillButton(
                    label: AppStrings.editRequest.tr(),
                    onPressed: onEdit,
                    buttonKey: editKey,
                  ),
                ),
              ],
            ),
    );
  }
}
