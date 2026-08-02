import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/widget_keys.dart';
import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/constants_manager.dart';
import '../../../../core/utils/route_manager.dart';
import '../../../../core/utils/string_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../../domain/entities/donor_feed_entity.dart';
import '../bloc/donor_feed_bloc.dart';

class DonorAppointmentsScreen extends StatelessWidget {
  final VoidCallback? onNotifications;

  const DonorAppointmentsScreen({super.key, this.onNotifications});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: BoxDecoration(
          color: ColorManager.white,
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              ColorManager.welcomeGradientStart,
              ColorManager.welcomeGradientEnd,
            ],
          ),
        ),
        child: SafeArea(
          child: BlocBuilder<DonorFeedBloc, DonorFeedState>(
            builder: (context, state) {
              if (state is DonorFeedInitial || state is DonorFeedLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is DonorFeedError) {
                return Center(child: Text(state.failure.message));
              }
              final loaded = state as DonorFeedLoaded;
              if (loaded.feed.appointments.isEmpty) {
                return _EmptyAppointments(
                  onRefresh: () {
                    context.read<DonorFeedBloc>().add(
                      const DonorFeedRequested(),
                    );
                  },
                );
              }
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: AppSize.s402),
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppPadding.p10,
                      vertical: AppPadding.p32,
                    ),
                    itemCount:
                        loaded.feed.appointments.length + AppSize.s2.toInt(),
                    separatorBuilder: (_, index) => SizedBox(
                      height: index == AppSize.s0.toInt()
                          ? AppSize.s20
                          : AppSize.s16,
                    ),
                    itemBuilder: (context, index) {
                      if (index == AppSize.s0.toInt()) {
                        return _AppointmentsHeader(
                          onNotifications: onNotifications,
                        );
                      }
                      if (index == AppSize.s1.toInt()) {
                        return Text(
                          AppStrings.upcomingAppointments.tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: ColorManager.nearBlack,
                            fontSize: AppSize.s16,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      }
                      return _AppointmentCard(
                        appointment: loaded
                            .feed
                            .appointments[index - AppSize.s2.toInt()],
                        disabled: loaded.isMutating,
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _AppointmentsHeader extends StatelessWidget {
  final VoidCallback? onNotifications;

  const _AppointmentsHeader({this.onNotifications});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _AppointmentsTopBar(onNotifications: onNotifications),
        const SizedBox(height: AppSize.s20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppPadding.p20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [ColorManager.error, ColorManager.primaryDark],
            ),
            borderRadius: BorderRadius.circular(AppSize.radiusXXLarge),
            border: Border.all(color: ColorManager.borderGrey),
          ),
          child: Row(
            children: [
              Image.asset(
                ImageAssets.icon7,
                width: AppSize.s130,
                height: AppSize.s104,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: AppSize.s12),
              const Expanded(child: _AppointmentsBannerCopy()),
            ],
          ),
        ),
      ],
    );
  }
}

class _AppointmentsTopBar extends StatelessWidget {
  final VoidCallback? onNotifications;

  const _AppointmentsTopBar({this.onNotifications});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.welcomeUser.tr(),
                style: const TextStyle(
                  fontSize: AppSize.s20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                AppStrings.donationLifeChance.tr(),
                style: TextStyle(color: ColorManager.textMuted),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(AppPadding.p8),
          decoration: BoxDecoration(
            color: ColorManager.surfaceAlt,
            borderRadius: BorderRadius.circular(AppSize.radiusXLarge),
          ),
          child: IconButton(
            key: WidgetKeys.donorNotificationsButton,
            onPressed:
                onNotifications ??
                () => Navigator.pushNamed(context, Routes.notificationsRoute),
            icon: const Icon(Icons.notifications_none_rounded),
          ),
        ),
      ],
    );
  }
}

class _AppointmentsBannerCopy extends StatelessWidget {
  const _AppointmentsBannerCopy();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          AppStrings.myAppointments.tr(),
          style: TextStyle(
            color: ColorManager.white,
            fontSize: AppSize.s24,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSize.s4),
        Text(
          AppStrings.appointmentsDescription.tr(),
          textAlign: TextAlign.right,
          style: TextStyle(
            color: ColorManager.white,
            fontSize: AppSize.s12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
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
        request?.hospital.nameAr ??
        campaign?.title ??
        AppStrings.appointments.tr();
    final canCancel =
        appointment.status == DonationAppointmentStatus.pending ||
        appointment.status == DonationAppointmentStatus.confirmed;
    return Container(
      padding: const EdgeInsets.all(AppPadding.p20),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(AppSize.radiusXXLarge),
        border: Border.all(color: ColorManager.borderGrey),
        boxShadow: [
          BoxShadow(
            color: ColorManager.black.withValues(alpha: AppOpacity.subtle),
            blurRadius: AppSize.s14,
            offset: const Offset(AppSize.s0, AppSize.s8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Image.asset(
                ImageAssets.icon8,
                width: AppSize.s50,
                height: AppSize.s50,
              ),
              const SizedBox(width: AppSize.s16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: ColorManager.textPrimary,
                    fontSize: AppSize.s17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _StatusBadge(status: appointment.status),
            ],
          ),
          const SizedBox(height: AppSize.s16),
          if (request != null)
            _InfoRow(
              label: AppStrings.bloodType.tr(),
              value: request.bloodType,
            ),
          _InfoRow(
            label: AppStrings.scheduledAt.tr(),
            value:
                '${DateFormat(AppConstants.requestDateFormat).format(appointment.scheduledAt.toLocal())} '
                '${DateFormat(AppConstants.requestTimeFormat).format(appointment.scheduledAt.toLocal())}',
          ),
          if (canCancel) ...[
            const SizedBox(height: AppSize.s16),
            ElevatedButton(
              key: WidgetKeys.appointmentCancelButton,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.darkGrey,
                foregroundColor: ColorManager.white,
              ),
              onPressed: disabled
                  ? null
                  : () => _showCancellationDialog(context, appointment.id),
              child: Text(AppStrings.cancelRequest.tr()),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _showCancellationDialog(
    BuildContext context,
    String appointmentId,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => Directionality(
        textDirection: TextDirection.rtl,
        child: Dialog(
          backgroundColor: ColorManager.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: AppPadding.p20,
            vertical: AppPadding.p40,
          ),
          child: Container(
            width: AppSize.s320,
            padding: const EdgeInsets.all(AppPadding.p40),
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
                  AppStrings.confirmCancelRequest.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ColorManager.darkGrey,
                    fontSize: AppSize.s16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSize.s10),
                Text(
                  AppStrings.cancelRequestNotice.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ColorManager.darkGrey,
                    fontSize: AppSize.s16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSize.s10),
                SizedBox(
                  width: AppSize.s174,
                  child: ElevatedButton(
                    key: WidgetKeys.appointmentCancelConfirmButton,
                    onPressed: () => Navigator.pop(dialogContext, true),
                    child: Text(AppStrings.confirm.tr()),
                  ),
                ),
                const SizedBox(height: AppSize.s10),
                SizedBox(
                  width: AppSize.s174,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.darkGrey,
                      foregroundColor: ColorManager.white,
                    ),
                    onPressed: () => Navigator.pop(dialogContext, false),
                    child: Text(AppStrings.cancel.tr()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (confirmed != true || !context.mounted) return;
    context.read<DonorFeedBloc>().add(
      DonorAppointmentCancelled(
        appointmentId: appointmentId,
        reason: AppStrings.cancelRequestNotice.tr(),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final DonationAppointmentStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final label = switch (status) {
      DonationAppointmentStatus.pending => AppStrings.pending.tr(),
      DonationAppointmentStatus.confirmed => AppStrings.accepted.tr(),
      DonationAppointmentStatus.completed => AppStrings.doneStatus.tr(),
      DonationAppointmentStatus.cancelled => AppStrings.cancelled.tr(),
    };
    final color = switch (status) {
      DonationAppointmentStatus.completed => ColorManager.success,
      DonationAppointmentStatus.cancelled => ColorManager.error,
      DonationAppointmentStatus.pending => ColorManager.warning,
      DonationAppointmentStatus.confirmed => ColorManager.primaryDark,
    };
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.p10,
        vertical: AppPadding.p4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: AppOpacity.muted),
        borderRadius: BorderRadius.circular(AppSize.radiusLarge),
      ),
      child: Text(label, style: TextStyle(color: color)),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppPadding.p4),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: TextStyle(color: ColorManager.textMuted)),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: ColorManager.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyAppointments extends StatelessWidget {
  final VoidCallback onRefresh;

  const _EmptyAppointments({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.event_available,
              color: ColorManager.lightGrey,
              size: AppSize.s80,
            ),
            const SizedBox(height: AppSize.s20),
            Text(
              AppStrings.noUpcomingAppointments.tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: AppSize.s20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSize.s12),
            Text(
              AppStrings.noAppointmentsDescription.tr(),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSize.s16),
            TextButton(
              onPressed: onRefresh,
              child: Text(AppStrings.retryAgain.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
