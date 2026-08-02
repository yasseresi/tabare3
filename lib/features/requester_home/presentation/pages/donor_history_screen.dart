import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/widget_keys.dart';
import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/constants_manager.dart';
import '../../../../core/utils/route_manager.dart';
import '../../../../core/utils/string_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../../domain/entities/blood_request_entity.dart';
import '../bloc/request_bloc.dart';

class DonorHistoryScreen extends StatefulWidget {
  final VoidCallback? onNotifications;
  final ValueChanged<BloodRequestEntity>? onDetail;

  const DonorHistoryScreen({super.key, this.onNotifications, this.onDetail});

  @override
  State<DonorHistoryScreen> createState() => _DonorHistoryScreenState();
}

class _DonorHistoryScreenState extends State<DonorHistoryScreen> {
  bool _showCompleted = true;

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
          child: BlocBuilder<RequestBloc, RequestState>(
            builder: (context, state) {
              if (state.status == RequestViewStatus.initial ||
                  state.status == RequestViewStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.status == RequestViewStatus.failure) {
                return Center(
                  child: Text(state.errorMessage ?? AppStrings.error.tr()),
                );
              }
              if (state.requests.isEmpty) return const _EmptyDonorHistory();
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: AppSize.s402),
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppPadding.p10,
                      vertical: AppPadding.p32,
                    ),
                    itemCount: state.requests.length + AppSize.s2.toInt(),
                    separatorBuilder: (_, index) => SizedBox(
                      height: index == AppSize.s0.toInt()
                          ? AppSize.s20
                          : AppSize.s12,
                    ),
                    itemBuilder: (context, index) {
                      if (index == AppSize.s0.toInt()) {
                        return _DonorHistoryHeader(
                          onNotifications: widget.onNotifications,
                        );
                      }
                      if (index == AppSize.s1.toInt()) {
                        return _DonorHistoryTabs(
                          showCompleted: _showCompleted,
                          onChanged: (value) {
                            setState(() => _showCompleted = value);
                          },
                        );
                      }
                      return _DonorHistoryCard(
                        request: state.requests[index - AppSize.s2.toInt()],
                        onDetail: widget.onDetail,
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

class _DonorHistoryHeader extends StatelessWidget {
  final VoidCallback? onNotifications;

  const _DonorHistoryHeader({required this.onNotifications});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
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
                    AppStrings.getWellSoon.tr(),
                    style: TextStyle(color: ColorManager.textMuted),
                  ),
                ],
              ),
            ),
            IconButton(
              key: WidgetKeys.requesterNotificationsButton,
              onPressed:
                  onNotifications ??
                  () => Navigator.pushNamed(context, Routes.notificationsRoute),
              style: IconButton.styleFrom(
                padding: const EdgeInsets.all(AppPadding.p8),
                backgroundColor: ColorManager.surfaceAlt,
                minimumSize: const Size.square(AppSize.s40),
                maximumSize: const Size.square(AppSize.s40),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: const CircleBorder(),
              ),
              constraints: const BoxConstraints(),
              icon: const Icon(
                Icons.notifications_none_rounded,
                size: AppSize.s24,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSize.s46),
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      AppStrings.donors.tr(),
                      style: TextStyle(
                        color: ColorManager.white,
                        fontSize: AppSize.s24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSize.s4),
                    Text(
                      AppStrings.donorsSectionDescription.tr(),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: ColorManager.white,
                        fontSize: AppSize.s12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSize.s20),
        Text(
          AppStrings.donorsList.tr(),
          style: TextStyle(
            color: ColorManager.nearBlack,
            fontSize: AppSize.s16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _DonorHistoryTabs extends StatelessWidget {
  final bool showCompleted;
  final ValueChanged<bool> onChanged;

  const _DonorHistoryTabs({
    required this.showCompleted,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _HistoryTab(
          label: AppStrings.completedDonors.tr(),
          selected: showCompleted,
          onTap: () => onChanged(true),
        ),
        _HistoryTab(
          label: AppStrings.accepted.tr(),
          selected: !showCompleted,
          onTap: () => onChanged(false),
        ),
      ],
    );
  }
}

class _HistoryTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _HistoryTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSize.s111,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: selected ? ColorManager.primary : ColorManager.white,
          foregroundColor: selected
              ? ColorManager.white
              : ColorManager.textLight,
          padding: const EdgeInsets.symmetric(vertical: AppPadding.p14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.radiusXLarge),
          ),
        ),
        onPressed: onTap,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: AppSize.s12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _DonorHistoryCard extends StatelessWidget {
  final BloodRequestEntity request;
  final ValueChanged<BloodRequestEntity>? onDetail;

  const _DonorHistoryCard({required this.request, this.onDetail});

  @override
  Widget build(BuildContext context) {
    final date = request.neededBy ?? request.createdAt;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (onDetail != null) {
          onDetail!(request);
          return;
        }
        Navigator.pushNamed(
          context,
          Routes.requestDetailRoute,
          arguments: request,
        );
      },
      child: Container(
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
          children: [
            Row(
              children: [
                Image.asset(
                  ImageAssets.icon9,
                  width: AppSize.s50,
                  height: AppSize.s50,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: AppSize.s12),
                Expanded(
                  child: Text(
                    request.hospital.nameAr,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: ColorManager.nearBlack,
                      fontSize: AppSize.s16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const _CompletedStatus(),
              ],
            ),
            const SizedBox(height: AppSize.s16),
            _HistoryInfoRow(
              label: AppStrings.fullName.tr(),
              value: request.patient?.fullName ?? AppStrings.notAvailable.tr(),
            ),
            _HistoryInfoRow(
              label: AppStrings.donationDate.tr(),
              value: DateFormat(
                AppConstants.requestDateFormat,
              ).format(date.toLocal()),
            ),
            _HistoryInfoRow(
              label: AppStrings.location.tr(),
              value: request.hospital.address ?? AppStrings.notAvailable.tr(),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompletedStatus extends StatelessWidget {
  const _CompletedStatus();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.p10,
        vertical: AppPadding.p6,
      ),
      decoration: BoxDecoration(
        color: ColorManager.surfaceLight,
        borderRadius: BorderRadius.circular(AppSize.radiusCircle),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: AppSize.s8,
            height: AppSize.s8,
            decoration: BoxDecoration(
              color: ColorManager.success,
              borderRadius: BorderRadius.circular(AppSize.radiusCircle),
            ),
          ),
          const SizedBox(width: AppSize.s4),
          Text(
            AppStrings.donationSuccessful.tr(),
            style: TextStyle(
              color: ColorManager.textMuted,
              fontSize: AppSize.s12,
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _HistoryInfoRow({required this.label, required this.value});

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
                color: ColorManager.primaryDark,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyDonorHistory extends StatelessWidget {
  const _EmptyDonorHistory();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(AppStrings.noRequestsYet.tr(), textAlign: TextAlign.center),
    );
  }
}
