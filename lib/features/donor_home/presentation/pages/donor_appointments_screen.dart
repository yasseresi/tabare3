import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/widget_keys.dart';
import '../../../../core/presentation/widgets/app_dialog.dart';
import '../../../../core/presentation/widgets/app_empty_state.dart';
import '../../../../core/presentation/widgets/app_gradient_background.dart';
import '../../../../core/presentation/widgets/app_page.dart';
import '../../../../core/presentation/widgets/app_pill_button.dart';
import '../../../../core/presentation/widgets/app_section_header.dart';
import '../../../../core/presentation/widgets/app_tag_pill.dart';
import '../../../../core/presentation/widgets/hero_banner.dart';
import '../../../../core/presentation/widgets/request_card.dart';
import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/constants_manager.dart';
import '../../../../core/utils/route_manager.dart';
import '../../../../core/utils/string_manager.dart';
import '../../../../core/utils/greeting.dart';
import '../../../../core/utils/values_manager.dart';
import '../../domain/entities/donor_feed_entity.dart';
import '../bloc/donor_feed_bloc.dart';
import '../widgets/donor_request_card.dart';

class DonorAppointmentsScreen extends StatelessWidget {
  final VoidCallback? onNotifications;

  const DonorAppointmentsScreen({super.key, this.onNotifications});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocBuilder<DonorFeedBloc, DonorFeedState>(
        builder: (context, state) {
          if (state is DonorFeedInitial || state is DonorFeedLoading) {
            return const AppGradientBackground(
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (state is DonorFeedError) {
            return AppGradientBackground(
              child: Center(child: Text(state.failure.message)),
            );
          }
          final loaded = state as DonorFeedLoaded;
          final appointments = loaded.feed.appointments;
          return AppPage(
            title: welcomeTitle(),
            subtitle: AppStrings.donationLifeChance.tr(),
            notificationsKey: WidgetKeys.donorNotificationsButton,
            onNotifications:
                onNotifications ??
                () => Navigator.pushNamed(context, Routes.notificationsRoute),
            onRefresh: () async {
              context.read<DonorFeedBloc>().add(const DonorFeedRequested());
            },
            children: [
              HeroBanner(
                title: AppStrings.myAppointments.tr(),
                message: AppStrings.appointmentsDescription.tr(),
              ),
              const SizedBox(height: AppSize.s12),
              // Figma keeps the section title above the empty state.
              AppSectionHeader(
                title: AppStrings.upcomingAppointments.tr(),
                centered: true,
              ),
              const SizedBox(height: AppSize.s10),
              if (appointments.isEmpty)
                AppEmptyState(
                  illustration: ImageAssets.appointmentAvatar,
                  title: AppStrings.noUpcomingAppointments.tr(),
                  message: AppStrings.noAppointmentsDescription.tr(),
                )
              else ...[
                ...appointments.map(
                  (appointment) => Padding(
                    padding: const EdgeInsets.only(bottom: AppPadding.p15),
                    child: _AppointmentCard(
                      appointment: appointment,
                      disabled: loaded.isMutating,
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final DonorAppointmentEntity appointment;
  final bool disabled;

  const _AppointmentCard({required this.appointment, required this.disabled});

  @override
  Widget build(BuildContext context) {
    final request = appointment.bloodRequest;
    final campaign = appointment.campaign;
    final title =
        request?.hospital?.nameAr ??
        campaign?.title ??
        AppStrings.appointments.tr();
    final canCancel =
        appointment.status == DonationAppointmentStatus.pending ||
        appointment.status == DonationAppointmentStatus.confirmed;
    final dateFormat = DateFormat(AppConstants.requestDateFormat);
    final timeFormat = DateFormat(AppConstants.requestTimeFormat);
    final scheduled = appointment.scheduledAt.toLocal();
    return RequestCard(
      avatar: ImageAssets.appointmentAvatar,
      title: title,
      // Figma shows a single urgency chip; the appointment status is conveyed
      // by the card living under `المواعيد القادمة`.
      tags: [
        if (request != null)
          AppTagPill(
            label: donorPriorityLabel(request.priority),
            dotColor: donorPriorityColor(request.priority),
            labelColor: ColorManager.textMuted,
            dotTrailing: true,
          )
        else
          _statusPill(appointment.status),
      ],
      // Figma also lists `المريض` and `تم توفير … أكياس` here, but the
      // appointment's request reference carries neither the patient name nor
      // the unit counts, so those rows stay out until the entity grows them.
      details: [
        if (request != null)
          RequestCardDetail(
            label: AppStrings.bloodType.tr(),
            value: request.bloodType,
            labelColor: ColorManager.textMuted,
            valueColor: ColorManager.primary,
          ),
        RequestCardDetail(
          label: AppStrings.scheduledAt.tr(),
          value:
              '${dateFormat.format(scheduled)} ${timeFormat.format(scheduled)}',
          labelColor: ColorManager.textMuted,
        ),
        if (request?.neededBy != null)
          RequestCardDetail(
            label: AppStrings.lastDeadline.tr(),
            value: dateFormat.format(request!.neededBy!.toLocal()),
            labelColor: ColorManager.textMuted,
          ),
      ],
      footer: canCancel
          ? AppPillButton(
              label: AppStrings.cancel.tr(),
              buttonKey: WidgetKeys.appointmentCancelButton,
              onPressed: disabled
                  ? null
                  : () => _confirmCancellation(context, appointment.id),
            )
          : null,
    );
  }

  Widget _statusPill(DonationAppointmentStatus status) {
    final (label, color) = switch (status) {
      DonationAppointmentStatus.pending => (
        AppStrings.pending.tr(),
        ColorManager.urgencyUrgent,
      ),
      DonationAppointmentStatus.confirmed => (
        AppStrings.accepted.tr(),
        ColorManager.success,
      ),
      DonationAppointmentStatus.completed => (
        AppStrings.doneStatus.tr(),
        ColorManager.success,
      ),
      DonationAppointmentStatus.cancelled => (
        AppStrings.cancelled.tr(),
        ColorManager.urgencyCritical,
      ),
    };
    return AppTagPill(label: label, dotColor: color);
  }

  Future<void> _confirmCancellation(
    BuildContext context,
    String appointmentId,
  ) async {
    final bloc = context.read<DonorFeedBloc>();
    final confirmed = await showDialog<bool>(
      context: context,
      barrierColor: ColorManager.dialogScrim,
      builder: (dialogContext) => Directionality(
        textDirection: TextDirection.rtl,
        child: AppDialog.warning(
          title: AppStrings.confirmCancelRequest.tr(),
          message: AppStrings.cancelRequestNotice.tr(),
          actionLabel: AppStrings.confirm.tr(),
          actionKey: WidgetKeys.appointmentCancelConfirmButton,
          onAction: () => Navigator.pop(dialogContext, true),
          secondaryLabel: AppStrings.cancel.tr(),
          onSecondaryAction: () => Navigator.pop(dialogContext, false),
        ),
      ),
    );
    if (confirmed != true) return;
    bloc.add(
      DonorAppointmentCancelled(
        appointmentId: appointmentId,
        reason: AppStrings.cancelRequestNotice.tr(),
      ),
    );
  }
}
