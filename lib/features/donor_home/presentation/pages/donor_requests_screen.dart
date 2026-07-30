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

class DonorRequestsScreen extends StatelessWidget {
  const DonorRequestsScreen({super.key});

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
              return _ErrorState(message: state.failure.message);
            }
            final loaded = state as DonorFeedLoaded;
            return RefreshIndicator(
              onRefresh: () async {
                context.read<DonorFeedBloc>().add(const DonorFeedRequested());
              },
              child: ListView(
                padding: const EdgeInsets.all(AppPadding.p20),
                children: [
                  _SectionTitle(title: AppStrings.allRequests.tr()),
                  const SizedBox(height: AppSize.s16),
                  if (loaded.feed.compatibleRequests.isEmpty)
                    const _EmptyRequests()
                  else
                    ...loaded.feed.compatibleRequests.map(
                      (request) => Padding(
                        padding: const EdgeInsets.only(bottom: AppPadding.p16),
                        child: _RequestCard(
                          request: request,
                          disabled: loaded.isMutating,
                        ),
                      ),
                    ),
                  const SizedBox(height: AppSize.s16),
                  _SectionTitle(title: AppStrings.availableCampaigns.tr()),
                  const SizedBox(height: AppSize.s16),
                  if (loaded.feed.availableCampaigns.isEmpty)
                    _EmptyMessage(message: AppStrings.noAvailableCampaigns.tr())
                  else
                    ...loaded.feed.availableCampaigns.map(
                      (campaign) => Padding(
                        padding: const EdgeInsets.only(bottom: AppPadding.p16),
                        child: _CampaignCard(campaign: campaign),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final DonorBloodRequestEntity request;
  final bool disabled;

  const _RequestCard({required this.request, required this.disabled});

  @override
  Widget build(BuildContext context) {
    final progress = request.unitsNeeded == AppSize.s0
        ? AppSize.s0
        : request.unitsFulfilled / request.unitsNeeded;
    return _SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  request.hospital.nameAr,
                  style: TextStyle(
                    color: ColorManager.textPrimary,
                    fontSize: AppSize.s17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _PriorityBadge(priority: request.priority),
            ],
          ),
          const SizedBox(height: AppSize.s16),
          _InfoRow(label: AppStrings.bloodType.tr(), value: request.bloodType),
          if (request.hospital.address != null)
            _InfoRow(
              label: AppStrings.location.tr(),
              value: request.hospital.address!,
            ),
          _InfoRow(
            label: AppStrings.requestDate.tr(),
            value: DateFormat(
              AppConstants.requestDateFormat,
            ).format(request.createdAt.toLocal()),
          ),
          if (request.neededBy != null)
            _InfoRow(
              label: AppStrings.deadline.tr(),
              value: DateFormat(
                AppConstants.requestDateFormat,
              ).format(request.neededBy!.toLocal()),
            ),
          const SizedBox(height: AppSize.s12),
          LinearProgressIndicator(
            value: progress.clamp(AppSize.s0, AppSize.s1),
            minHeight: AppSize.s8,
            borderRadius: BorderRadius.circular(AppSize.radiusSmall),
            color: ColorManager.primaryDark,
            backgroundColor: ColorManager.progressTrack,
          ),
          const SizedBox(height: AppSize.s8),
          Text(
            AppStrings.bagsRatio.tr(
              namedArgs: {
                LocalizationArgs.provided: request.unitsFulfilled.toString(),
                LocalizationArgs.total: request.unitsNeeded.toString(),
              },
            ),
            style: TextStyle(
              color: ColorManager.textMuted,
              fontSize: AppSize.s12,
            ),
          ),
          const SizedBox(height: AppSize.s16),
          ElevatedButton(
            onPressed: disabled
                ? null
                : () => _selectAppointment(context, request.id),
            child: Text(AppStrings.acceptRequest.tr()),
          ),
        ],
      ),
    );
  }

  Future<void> _selectAppointment(
    BuildContext context,
    String requestId,
  ) async {
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
    if (time == null || !context.mounted) return;
    context.read<DonorFeedBloc>().add(
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
}

class _CampaignCard extends StatelessWidget {
  final DonorCampaignEntity campaign;

  const _CampaignCard({required this.campaign});

  @override
  Widget build(BuildContext context) {
    return _SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            campaign.title,
            style: TextStyle(
              color: ColorManager.textPrimary,
              fontSize: AppSize.s17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSize.s12),
          _InfoRow(
            label: AppStrings.organizingEntity.tr(),
            value: campaign.organizerName,
          ),
          _InfoRow(label: AppStrings.place.tr(), value: campaign.venueName),
          _InfoRow(label: AppStrings.location.tr(), value: campaign.city),
          _InfoRow(
            label: AppStrings.campaignDate.tr(),
            value: DateFormat(
              AppConstants.requestDateFormat,
            ).format(campaign.startsAt.toLocal()),
          ),
          _InfoRow(
            label: AppStrings.startTime.tr(),
            value: DateFormat(
              AppConstants.requestTimeFormat,
            ).format(campaign.startsAt.toLocal()),
          ),
          _InfoRow(
            label: AppStrings.endTime.tr(),
            value: DateFormat(
              AppConstants.requestTimeFormat,
            ).format(campaign.endsAt.toLocal()),
          ),
        ],
      ),
    );
  }
}

class _SurfaceCard extends StatelessWidget {
  final Widget child;

  const _SurfaceCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppPadding.p20),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(AppSize.radiusXXLarge),
        border: Border.all(color: ColorManager.borderGrey),
      ),
      child: child,
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
            child: Text(
              label,
              style: TextStyle(
                color: ColorManager.textMuted,
                fontSize: AppSize.s14,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: ColorManager.textPrimary,
                fontSize: AppSize.s14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PriorityBadge extends StatelessWidget {
  final DonorRequestPriority priority;

  const _PriorityBadge({required this.priority});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (priority) {
      DonorRequestPriority.normal => (
        AppStrings.normal.tr(),
        ColorManager.success,
      ),
      DonorRequestPriority.semiUrgent => (
        AppStrings.semiUrgent.tr(),
        ColorManager.warning,
      ),
      DonorRequestPriority.urgent => (
        AppStrings.veryUrgent.tr(),
        ColorManager.error,
      ),
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
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: AppSize.s12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: ColorManager.textPrimary,
        fontSize: AppSize.s20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _EmptyRequests extends StatelessWidget {
  const _EmptyRequests();

  @override
  Widget build(BuildContext context) {
    return _EmptyMessage(message: AppStrings.noRequestsDescription.tr());
  }
}

class _EmptyMessage extends StatelessWidget {
  final String message;

  const _EmptyMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppPadding.p24),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(color: ColorManager.textMuted, fontSize: AppSize.s15),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;

  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: AppSize.s12),
          ElevatedButton(
            onPressed: () {
              context.read<DonorFeedBloc>().add(const DonorFeedRequested());
            },
            child: Text(AppStrings.retryAgain.tr()),
          ),
        ],
      ),
    );
  }
}
