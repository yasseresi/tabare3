import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/string_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../bloc/donor_card_bloc.dart';

class DonorCardInfoScreen extends StatelessWidget {
  const DonorCardInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorManager.donorCardBackground,
        appBar: AppBar(
          backgroundColor: ColorManager.donorCardBackground,
          foregroundColor: ColorManager.white,
          title: Text(AppStrings.donorCardInfo.tr()),
        ),
        body: ListView(
          padding: const EdgeInsets.all(AppPadding.p20),
          children: [
            _Section(
              title: AppStrings.whatIsDonorCard.tr(),
              child: Text(
                AppStrings.donorCardExplanation.tr(),
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: ColorManager.lightGrey,
                  height: AppSize.s1_5,
                ),
              ),
            ),
            const SizedBox(height: AppSize.s24),
            _Section(
              title: AppStrings.howToEarnPoints.tr(),
              child: Wrap(
                spacing: AppSize.s8,
                runSpacing: AppSize.s8,
                children:
                    [
                          AppStrings.bloodDonation,
                          AppStrings.appointmentCommitment,
                          AppStrings.cancellationLabel,
                          AppStrings.urgentDonation,
                          AppStrings.threeMonthsInactive,
                        ]
                        .map(
                          (key) => Chip(
                            label: Text(key.tr()),
                            backgroundColor: ColorManager.white,
                          ),
                        )
                        .toList(),
              ),
            ),
            const SizedBox(height: AppSize.s24),
            _Section(
              title: AppStrings.levels.tr(),
              child: BlocBuilder<DonorCardBloc, DonorCardState>(
                builder: (context, state) {
                  if (state is DonorCardInitial || state is DonorCardLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is DonorCardError) {
                    return Text(
                      state.failure.message,
                      style: TextStyle(color: ColorManager.white),
                    );
                  }
                  final levels = (state as DonorCardLoaded).card.levels;
                  return Column(
                    children: levels
                        .map(
                          (level) => Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppPadding.p8,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.circle,
                                  color: ColorManager.donorCardAccent,
                                  size: AppSize.s8,
                                ),
                                const SizedBox(width: AppSize.s10),
                                Expanded(
                                  child: Text(
                                    level.nameAr,
                                    style: TextStyle(
                                      color: ColorManager.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  level.minPoints.toString(),
                                  style: TextStyle(
                                    color: ColorManager.donorCardAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;

  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppPadding.p20),
      decoration: BoxDecoration(
        color: ColorManager.white.withValues(alpha: AppOpacity.subtle),
        borderRadius: BorderRadius.circular(AppSize.radiusXLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: TextStyle(
              color: ColorManager.donorCardAccent,
              fontSize: AppSize.s18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSize.s12),
          child,
        ],
      ),
    );
  }
}
