import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/widget_keys.dart';
import '../../../../core/presentation/widgets/app_empty_state.dart';
import '../../../../core/presentation/widgets/app_gradient_background.dart';
import '../../../../core/presentation/widgets/app_page.dart';
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

class DonorRecordScreen extends StatelessWidget {
  final VoidCallback? onNotifications;

  const DonorRecordScreen({super.key, this.onNotifications});

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
          final records = (state as DonorFeedLoaded).records;
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
                title: AppStrings.donationRecord.tr(),
                message: AppStrings.donationRecordDescription.tr(),
              ),
              const SizedBox(height: AppSize.s12),
              if (records.isEmpty)
                AppEmptyState(
                  title: AppStrings.noDonationRecords.tr(),
                  message: AppStrings.donationRecordDescription.tr(),
                )
              else ...[
                AppSectionHeader(
                  title: AppStrings.donationRecord.tr(),
                  centered: true,
                ),
                const SizedBox(height: AppSize.s10),
                ...records.map(
                  (record) => Padding(
                    padding: const EdgeInsets.only(bottom: AppPadding.p15),
                    child: _DonationRecordCard(record: record),
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

class _DonationRecordCard extends StatelessWidget {
  final DonationRecordEntity record;

  const _DonationRecordCard({required this.record});

  @override
  Widget build(BuildContext context) {
    final request = record.bloodRequest;
    final campaign = record.campaign;
    final title =
        request?.hospital?.nameAr ??
        campaign?.title ??
        AppStrings.bloodDonation.tr();
    final patient =
        request?.recipientName ??
        campaign?.title ??
        AppStrings.notAvailable.tr();
    final location =
        request?.hospital?.address ??
        campaign?.city ??
        AppStrings.notAvailable.tr();
    return RequestCard(
      avatar: ImageAssets.donationAvatar,
      title: title,
      tags: [
        AppTagPill(
          label: AppStrings.donationCompleted.tr(),
          dotColor: ColorManager.success,
          labelColor: ColorManager.textMuted,
          dotTrailing: true,
        ),
      ],
      details: [
        RequestCardDetail(
          label: AppStrings.patient.tr(),
          value: patient,
          labelColor: ColorManager.textMuted,
        ),
        RequestCardDetail(
          label: AppStrings.donationDate.tr(),
          value: DateFormat(
            AppConstants.requestDateFormat,
          ).format(record.donatedAt.toLocal()),
          labelColor: ColorManager.textMuted,
        ),
        RequestCardDetail(
          label: AppStrings.location.tr(),
          value: location,
          labelColor: ColorManager.textMuted,
        ),
      ],
    );
  }
}
