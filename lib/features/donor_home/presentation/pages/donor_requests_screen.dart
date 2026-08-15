import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/widget_keys.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import '../../../../core/presentation/widgets/app_empty_state.dart';
import '../../../../core/presentation/widgets/app_gradient_background.dart';
import '../../../../core/presentation/widgets/app_info_row.dart';
import '../../../../core/presentation/widgets/app_page.dart';
import '../../../../core/presentation/widgets/app_search_field.dart';
import '../../../../core/presentation/widgets/app_section_header.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/constants_manager.dart';
import '../../../../core/utils/font_manager.dart';
import '../../../../core/utils/route_manager.dart';
import '../../../../core/utils/string_manager.dart';
import '../../../../core/utils/greeting.dart';
import '../../../../core/utils/styles_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../../domain/entities/donor_feed_entity.dart';
import '../bloc/donor_feed_bloc.dart';
import '../widgets/donor_request_actions.dart';
import '../widgets/donor_request_card.dart';

class DonorRequestsScreen extends StatefulWidget {
  final VoidCallback? onNotifications;

  const DonorRequestsScreen({super.key, this.onNotifications});

  @override
  State<DonorRequestsScreen> createState() => _DonorRequestsScreenState();
}

class _DonorRequestsScreenState extends State<DonorRequestsScreen> {
  String _query = '';

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
              child: _ErrorState(message: state.failure.message),
            );
          }
          final loaded = state as DonorFeedLoaded;
          final requests = _filter(loaded.feed.compatibleRequests);
          return AppPage(
            title: welcomeTitle(),
            subtitle: AppStrings.donationLifeChance.tr(),
            notificationsKey: WidgetKeys.donorNotificationsButton,
            onNotifications:
                widget.onNotifications ??
                () => Navigator.pushNamed(context, Routes.notificationsRoute),
            onRefresh: () async {
              context.read<DonorFeedBloc>().add(const DonorFeedRequested());
            },
            children: [
              AppSearchField(
                hintText: AppStrings.searchPatients.tr(),
                onChanged: (value) => setState(() => _query = value),
              ),
              const SizedBox(height: AppSize.s12),
              AppSectionHeader(title: AppStrings.allRequests.tr()),
              const SizedBox(height: AppSize.s12),
              if (requests.isEmpty)
                AppEmptyState(
                  title: AppStrings.noRequestsNow.tr(),
                  message: AppStrings.noRequestsDescription.tr(),
                  secondaryMessage: AppStrings.thanksForDonating.tr(),
                )
              else
                ...requests.map(
                  (request) => Padding(
                    padding: const EdgeInsets.only(bottom: AppPadding.p15),
                    child: DonorRequestCard(
                      request: request,
                      onAccept: loaded.isMutating
                          ? null
                          : () => acceptDonorRequest(context, request.id),
                    ),
                  ),
                ),
              const SizedBox(height: AppSize.s12),
              AppSectionHeader(title: AppStrings.availableCampaigns.tr()),
              const SizedBox(height: AppSize.s12),
              if (loaded.feed.availableCampaigns.isEmpty)
                _EmptyMessage(message: AppStrings.noAvailableCampaigns.tr())
              else
                ...loaded.feed.availableCampaigns.map(
                  (campaign) => Padding(
                    padding: const EdgeInsets.only(bottom: AppPadding.p15),
                    child: _CampaignCard(campaign: campaign),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  List<DonorBloodRequestEntity> _filter(
    List<DonorBloodRequestEntity> requests,
  ) {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return requests;
    return requests
        .where(
          (request) =>
              (request.patientName ?? '').toLowerCase().contains(query) ||
              request.hospital.nameAr.toLowerCase().contains(query) ||
              (request.hospital.nameFr ?? '').toLowerCase().contains(query),
        )
        .toList();
  }
}

class _CampaignCard extends StatelessWidget {
  final DonorCampaignEntity campaign;

  const _CampaignCard({required this.campaign});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat(AppConstants.requestDateFormat);
    final timeFormat = DateFormat(AppConstants.requestTimeFormat);
    return AppCard.list(
      child: Column(
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              campaign.title,
              style: getBoldStyle(
                fontSize: FontSize.s16,
                color: ColorManager.cardTitle,
                lineHeight: LineHeight.h19,
              ),
            ),
          ),
          const SizedBox(height: AppSize.s18),
          AppInfoRow(
            label: AppStrings.organizingEntity.tr(),
            value: campaign.organizerName,
          ),
          const SizedBox(height: AppSize.s18),
          AppInfoRow(
            label: AppStrings.place.tr(),
            value: campaign.venueName ?? AppStrings.notAvailable.tr(),
          ),
          const SizedBox(height: AppSize.s18),
          AppInfoRow(label: AppStrings.location.tr(), value: campaign.city),
          const SizedBox(height: AppSize.s18),
          AppInfoRow(
            label: AppStrings.campaignDate.tr(),
            value: dateFormat.format(campaign.startsAt.toLocal()),
          ),
          const SizedBox(height: AppSize.s18),
          AppInfoRow(
            label: AppStrings.startTime.tr(),
            value: timeFormat.format(campaign.startsAt.toLocal()),
          ),
          const SizedBox(height: AppSize.s18),
          AppInfoRow(
            label: AppStrings.endTime.tr(),
            value: timeFormat.format(campaign.endsAt.toLocal()),
          ),
        ],
      ),
    );
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
        style: getMediumStyle(
          fontSize: FontSize.s14,
          color: ColorManager.textMuted,
        ),
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
