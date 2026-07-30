import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/constants_manager.dart';
import '../../../../core/utils/string_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../../domain/entities/donor_feed_entity.dart';
import '../bloc/donor_feed_bloc.dart';

class DonorRecordScreen extends StatelessWidget {
  const DonorRecordScreen({super.key});

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
            final records = (state as DonorFeedLoaded).records;
            if (records.isEmpty) {
              return Center(
                child: Text(
                  AppStrings.noDonationRecords.tr(),
                  textAlign: TextAlign.center,
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(AppPadding.p20),
              itemCount: records.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSize.s16),
              itemBuilder: (context, index) {
                return _DonationRecordCard(record: records[index]);
              },
            );
          },
        ),
      ),
    );
  }
}

class _DonationRecordCard extends StatelessWidget {
  final DonationRecordEntity record;

  const _DonationRecordCard({required this.record});

  @override
  Widget build(BuildContext context) {
    final source = switch (record.source) {
      DonationSource.request => AppStrings.bloodDonation.tr(),
      DonationSource.campaign => AppStrings.campaignDonation.tr(),
    };
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
              Icon(
                Icons.check_circle,
                color: ColorManager.success,
                size: AppSize.s24,
              ),
              const SizedBox(width: AppSize.s8),
              Expanded(
                child: Text(
                  AppStrings.donationSuccessful.tr(),
                  style: TextStyle(
                    color: ColorManager.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSize.s16),
          _InfoRow(label: AppStrings.record.tr(), value: source),
          _InfoRow(
            label: AppStrings.donationDate.tr(),
            value: DateFormat(
              AppConstants.requestDateFormat,
            ).format(record.donatedAt.toLocal()),
          ),
          _InfoRow(
            label: AppStrings.donationUnits.tr(),
            value: record.units.toString(),
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
