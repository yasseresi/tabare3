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
import '../../domain/entities/donor_feed_entity.dart';
import '../bloc/donor_feed_bloc.dart';

class DonorRecordScreen extends StatelessWidget {
  final VoidCallback? onNotifications;

  const DonorRecordScreen({super.key, this.onNotifications});

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
              final records = (state as DonorFeedLoaded).records;
              if (records.isEmpty) {
                return Center(
                  child: Text(
                    AppStrings.noDonationRecords.tr(),
                    textAlign: TextAlign.center,
                  ),
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
                    itemCount: records.length + AppSize.s2.toInt(),
                    separatorBuilder: (_, index) => SizedBox(
                      height: index == AppSize.s0.toInt()
                          ? AppSize.s20
                          : AppSize.s16,
                    ),
                    itemBuilder: (context, index) {
                      if (index == AppSize.s0.toInt()) {
                        return _DonationRecordHeader(
                          onNotifications: onNotifications,
                        );
                      }
                      if (index == AppSize.s1.toInt()) {
                        return Text(
                          AppStrings.donationRecord.tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: ColorManager.nearBlack,
                            fontSize: AppSize.s16,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      }
                      return _DonationRecordCard(
                        record: records[index - AppSize.s2.toInt()],
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

class _DonationRecordHeader extends StatelessWidget {
  final VoidCallback? onNotifications;

  const _DonationRecordHeader({this.onNotifications});

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
                    AppStrings.donationLifeChance.tr(),
                    style: TextStyle(color: ColorManager.textMuted),
                  ),
                ],
              ),
            ),
            IconButton(
              key: WidgetKeys.donorNotificationsButton,
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
                      AppStrings.donationRecord.tr(),
                      style: TextStyle(
                        color: ColorManager.white,
                        fontSize: AppSize.s24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSize.s4),
                    Text(
                      AppStrings.donationRecordDescription.tr(),
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
      ],
    );
  }
}

class _DonationRecordCard extends StatelessWidget {
  final DonationRecordEntity record;

  const _DonationRecordCard({required this.record});

  @override
  Widget build(BuildContext context) {
    final title =
        record.bloodRequest?.hospital.nameAr ??
        record.campaign?.title ??
        AppStrings.bloodDonation.tr();
    final patient =
        record.bloodRequest?.recipientName ??
        record.campaign?.title ??
        AppStrings.notAvailable.tr();
    final location =
        record.bloodRequest?.hospital.address ??
        record.campaign?.city ??
        AppStrings.notAvailable.tr();
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
                ImageAssets.icon9,
                width: AppSize.s50,
                height: AppSize.s50,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: AppSize.s12),
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: ColorManager.textPrimary,
                    fontSize: AppSize.s16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _CompletedBadge(),
            ],
          ),
          const SizedBox(height: AppSize.s16),
          _InfoRow(label: AppStrings.patient.tr(), value: patient),
          _InfoRow(
            label: AppStrings.donationDate.tr(),
            value: DateFormat(
              AppConstants.requestDateFormat,
            ).format(record.donatedAt.toLocal()),
          ),
          _InfoRow(label: AppStrings.location.tr(), value: location),
        ],
      ),
    );
  }
}

class _CompletedBadge extends StatelessWidget {
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
          Text(
            value,
            style: TextStyle(
              color: ColorManager.primaryDark,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
