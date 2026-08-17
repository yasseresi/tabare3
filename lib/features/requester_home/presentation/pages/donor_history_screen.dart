import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/widget_keys.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import '../../../../core/presentation/widgets/app_empty_state.dart';
import '../../../../core/presentation/widgets/app_gradient_background.dart';
import '../../../../core/presentation/widgets/app_info_row.dart';
import '../../../../core/presentation/widgets/app_page.dart';
import '../../../../core/presentation/widgets/app_tag_pill.dart';
import '../../../../core/presentation/widgets/hero_banner.dart';
import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/constants_manager.dart';
import '../../../../core/utils/font_manager.dart';
import '../../../../core/utils/route_manager.dart';
import '../../../../core/utils/string_manager.dart';
import '../../../../core/utils/greeting.dart';
import '../../../../core/utils/styles_manager.dart';
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
  bool _donorsRequested = false;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocBuilder<RequestBloc, RequestState>(
        builder: (context, state) {
          // Fetch donors once the requests exist. Re-arms after a refresh
          // (which resets donorsLoaded) so the tab stays in sync.
          if (state.donorsLoaded) {
            _donorsRequested = false;
          } else if (!_donorsRequested && state.requests.isNotEmpty) {
            _donorsRequested = true;
            WidgetsBinding.instance.addPostFrameCallback(
              (_) => context.read<RequestBloc>().add(
                const RequestDonorsLoadRequested(),
              ),
            );
          }
          if (state.status == RequestViewStatus.initial ||
              state.status == RequestViewStatus.loading) {
            return const AppGradientBackground(
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (state.status == RequestViewStatus.failure) {
            return AppGradientBackground(
              child: Center(
                child: Text(state.errorMessage ?? AppStrings.error.tr()),
              ),
            );
          }
          return AppPage(
            title: welcomeTitle(),
            subtitle: AppStrings.getWellSoon.tr(),
            notificationsKey: WidgetKeys.requesterNotificationsButton,
            onNotifications:
                widget.onNotifications ??
                () => Navigator.pushNamed(context, Routes.notificationsRoute),
            children: [
              HeroBanner(
                title: AppStrings.donors.tr(),
                message: AppStrings.donorsSectionDescription.tr(),
              ),
              const SizedBox(height: AppSize.s12),
              Text(
                AppStrings.donorsList.tr(),
                textAlign: TextAlign.center,
                style: getSemiBoldStyle(
                  fontSize: FontSize.s16,
                  color: ColorManager.sectionTitle,
                  lineHeight: LineHeight.h28,
                ),
              ),
              const SizedBox(height: AppSize.s12),
              _DonorHistoryTabs(
                showCompleted: _showCompleted,
                onChanged: (value) => setState(() => _showCompleted = value),
              ),
              const SizedBox(height: AppSize.s12),
              ..._buildDonorList(state),
            ],
          );
        },
      ),
    );
  }

  /// Donor cards for the active tab. Completed tab shows donors who finished
  /// the donation (appointment completed after QR validation); the accepted
  /// tab shows donors who accepted a request but have not yet donated.
  List<Widget> _buildDonorList(RequestState state) {
    // Only a pending fetch spins; with no requests there is nothing to load, so
    // fall through to the (empty) donor list rather than spinning forever.
    if (!state.donorsLoaded && state.requests.isNotEmpty) {
      return const [
        Padding(
          padding: EdgeInsets.only(top: AppPadding.p20),
          child: Center(child: CircularProgressIndicator()),
        ),
      ];
    }

    final pairs = <_DonorEntry>[];
    for (final request in state.requests) {
      for (final donor in state.donorsByRequestId[request.id] ?? const []) {
        final isCompleted =
            donor.status == DonationAppointmentStatus.completed;
        final isAccepted =
            donor.status == DonationAppointmentStatus.pending ||
            donor.status == DonationAppointmentStatus.confirmed;
        if (_showCompleted ? isCompleted : isAccepted) {
          pairs.add(_DonorEntry(request: request, donor: donor));
        }
      }
    }

    if (pairs.isEmpty) {
      return [
        AppEmptyState(
          title: _showCompleted
              ? AppStrings.noCompletedDonors.tr()
              : AppStrings.noAcceptedDonors.tr(),
          message: AppStrings.donorsEmptyDescription.tr(),
        ),
      ];
    }

    return pairs
        .map(
          (entry) => Padding(
            padding: const EdgeInsets.only(bottom: AppPadding.p12),
            child: _DonorHistoryCard(
              request: entry.request,
              donor: entry.donor,
              isCompleted: _showCompleted,
              onDetail: widget.onDetail,
            ),
          ),
        )
        .toList();
  }
}

/// A donor paired with the request they responded to, so the card can show
/// both the hospital and the donor.
class _DonorEntry {
  final BloodRequestEntity request;
  final RequestDonorEntity donor;

  const _DonorEntry({required this.request, required this.donor});
}

/// Figma `Frame 1000009037`: two 110x42 pills, `المقبولين` on the leading
/// (right) side and `المكتملين` beside it.
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _HistoryTab(
          label: AppStrings.acceptedTab.tr(),
          selected: !showCompleted,
          onTap: () => onChanged(false),
        ),
        const SizedBox(width: AppSize.s60),
        _HistoryTab(
          label: AppStrings.completedDonors.tr(),
          selected: showCompleted,
          onTap: () => onChanged(true),
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
    final radius = BorderRadius.circular(AppSize.radiusXLarge);
    return Material(
      color: selected ? ColorManager.cardValue : ColorManager.white,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          width: AppSize.s111,
          padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.p10,
            vertical: AppPadding.p15,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: getSemiBoldStyle(
              fontSize: FontSize.s12,
              color: selected ? ColorManager.white : ColorManager.tabInactive,
            ),
          ),
        ),
      ),
    );
  }
}

/// Figma donor card: the hospital row with its status pill, then the name,
/// donation date and location rows.
class _DonorHistoryCard extends StatelessWidget {
  final BloodRequestEntity request;
  final RequestDonorEntity donor;
  final bool isCompleted;
  final ValueChanged<BloodRequestEntity>? onDetail;

  const _DonorHistoryCard({
    required this.request,
    required this.donor,
    required this.isCompleted,
    this.onDetail,
  });

  @override
  Widget build(BuildContext context) {
    // Completed donors carry the actual donation time; accepted ones only have
    // the scheduled appointment.
    final date = donor.completedAt ?? donor.scheduledAt;
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
      child: AppCard.list(
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(
                  ImageAssets.donationAvatar,
                  width: AppSize.s50,
                  height: AppSize.s50,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: AppSize.s12),
                Expanded(
                  child: Text(
                    request.hospital?.nameAr ?? AppStrings.notAvailable.tr(),
                    style: getBoldStyle(
                      fontSize: FontSize.s16,
                      color: ColorManager.cardTitle,
                    ),
                  ),
                ),
                const SizedBox(width: AppSize.s12),
                AppTagPill(
                  label: isCompleted
                      ? AppStrings.donationSuccessful.tr()
                      : AppStrings.accepted.tr(),
                  dotColor: isCompleted
                      ? ColorManager.success
                      : ColorManager.urgencyCritical,
                  labelColor: ColorManager.textMuted,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppPadding.p10,
                    vertical: AppPadding.p6,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSize.s18),
            AppInfoRow(
              label: AppStrings.fullName.tr(),
              value: donor.fullName,
              labelColor: ColorManager.textMuted,
            ),
            const SizedBox(height: AppSize.s18),
            AppInfoRow(
              label: AppStrings.bloodType.tr(),
              value: donor.bloodType,
              labelColor: ColorManager.textMuted,
            ),
            const SizedBox(height: AppSize.s18),
            AppInfoRow(
              label: AppStrings.donationDate.tr(),
              value: DateFormat(
                AppConstants.requestDateFormat,
              ).format(date.toLocal()),
              labelColor: ColorManager.textMuted,
            ),
            const SizedBox(height: AppSize.s18),
            AppInfoRow(
              label: AppStrings.location.tr(),
              value: request.hospital?.address ?? AppStrings.notAvailable.tr(),
              labelColor: ColorManager.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}
