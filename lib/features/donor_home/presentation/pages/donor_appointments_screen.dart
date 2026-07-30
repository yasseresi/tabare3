import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/constants_manager.dart';
import '../../../../core/utils/string_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../../domain/entities/donor_feed_entity.dart';
import '../bloc/donor_feed_bloc.dart';

class DonorAppointmentsScreen extends StatelessWidget {
  const DonorAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
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
                  context.read<DonorFeedBloc>().add(const DonorFeedRequested());
                },
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(AppPadding.p20),
              itemCount: loaded.feed.appointments.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSize.s16),
              itemBuilder: (context, index) {
                return _AppointmentCard(
                  appointment: loaded.feed.appointments[index],
                  disabled: loaded.isMutating,
                );
              },
            );
          },
        ),
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
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
            OutlinedButton(
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
    final controller = TextEditingController();
    final reason = await showDialog<String>(
      context: context,
      builder: (dialogContext) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text(AppStrings.cancellationReason.tr()),
          content: TextField(
            controller: controller,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              hintText: AppStrings.cancellationReason.tr(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(AppStrings.cancel.tr()),
            ),
            ElevatedButton(
              onPressed: () {
                final value = controller.text.trim();
                if (value.isNotEmpty) Navigator.pop(dialogContext, value);
              },
              child: Text(AppStrings.confirm.tr()),
            ),
          ],
        ),
      ),
    );
    controller.dispose();
    if (reason == null || !context.mounted) return;
    context.read<DonorFeedBloc>().add(
      DonorAppointmentCancelled(appointmentId: appointmentId, reason: reason),
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
