import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/widget_keys.dart';
import '../../../../core/presentation/widgets/app_dialog.dart';
import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/constants_manager.dart';
import '../../../../core/utils/font_manager.dart';
import '../../../../core/utils/route_manager.dart';
import '../../../../core/utils/string_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../../../../injection_container.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../notifications/presentation/bloc/notifications_bloc.dart';
import '../../../notifications/presentation/pages/notifications_center_page.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../../profile/presentation/pages/profile_screen.dart';
import '../../../profile/presentation/pages/about_app_screen.dart';
import '../../domain/entities/donor_feed_entity.dart';
import '../bloc/donor_feed_bloc.dart';
import '../bloc/donor_card_bloc.dart';
import 'donor_appointments_screen.dart';
import 'donor_card_info_screen.dart';
import 'donor_card_screen.dart';
import 'donor_record_screen.dart';
import 'donor_requests_screen.dart';
import 'donor_qr_scanner_screen.dart';

enum _DonorTab {
  home,
  requests,
  appointments,
  record,
  profile,
  card,
  cardInfo,
  notifications,
  about,
}

class DonorHomeScreen extends StatefulWidget {
  const DonorHomeScreen({super.key});

  @override
  State<DonorHomeScreen> createState() => _DonorHomeScreenState();
}

class _DonorHomeScreenState extends State<DonorHomeScreen> {
  _DonorTab _selectedTab = _DonorTab.home;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) => current is Unauthenticated,
      listener: (context, state) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.welcomeRoute,
          (route) => false,
        );
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: BlocListener<DonorFeedBloc, DonorFeedState>(
            listenWhen: (previous, current) =>
                current is DonorFeedLoaded && current.lastMutation != null,
            listener: (context, state) {
              final mutation = (state as DonorFeedLoaded).lastMutation;
              if (mutation == DonorFeedMutation.requestAccepted) {
                _showRequestAcceptedDialog(context);
                return;
              }
              final message = switch (mutation) {
                DonorFeedMutation.appointmentCancelled =>
                  AppStrings.appointmentCancelled.tr(),
                DonorFeedMutation.donationRecorded =>
                  AppStrings.donationRecorded.tr(),
                DonorFeedMutation.availabilityChanged =>
                  AppStrings.availabilityUpdated.tr(),
                DonorFeedMutation.requestAccepted =>
                  AppStrings.requestAccepted.tr(),
                null => AppStrings.doneStatus.tr(),
              };
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(message)));
            },
            child: _buildBody(),
          ),
          bottomNavigationBar: _BottomNavigation(
            selectedTab: _selectedTab,
            onSelected: (tab) => setState(() => _selectedTab = tab),
            onRedeem: () => _showRedeemDialog(context),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return switch (_selectedTab) {
      _DonorTab.home => _DonorOverview(onNotifications: _openNotifications),
      _DonorTab.requests => DonorRequestsScreen(
        onNotifications: _openNotifications,
      ),
      _DonorTab.appointments => DonorAppointmentsScreen(
        onNotifications: _openNotifications,
      ),
      _DonorTab.record => DonorRecordScreen(
        onNotifications: _openNotifications,
      ),
      _DonorTab.profile => BlocProvider(
        create: (_) => sl<ProfileBloc>()..add(const LoadProfile()),
        child: ProfileScreen(
          onAbout: () => setState(() => _selectedTab = _DonorTab.about),
          onDonorCard: () => setState(() => _selectedTab = _DonorTab.card),
          onNotifications: _openNotifications,
        ),
      ),
      _DonorTab.card => BlocProvider(
        create: (_) => sl<DonorCardBloc>()..add(const DonorCardRequested()),
        child: DonorCardScreen(
          onInfo: () => setState(() => _selectedTab = _DonorTab.cardInfo),
        ),
      ),
      _DonorTab.cardInfo => BlocProvider(
        create: (_) => sl<DonorCardBloc>()..add(const DonorCardRequested()),
        child: const DonorCardInfoScreen(),
      ),
      _DonorTab.notifications => BlocProvider(
        create: (_) => sl<NotificationsBloc>(),
        child: const NotificationsCenterPage(),
      ),
      _DonorTab.about => AboutAppScreen(
        onBack: () => setState(() => _selectedTab = _DonorTab.profile),
      ),
    };
  }

  void _openNotifications() {
    setState(() => _selectedTab = _DonorTab.notifications);
  }

  void _showRequestAcceptedDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AppDialog.success(
        title: AppStrings.requestAccepted.tr(),
        message: AppStrings.acceptRequestThanks.tr(),
        actionLabel: AppStrings.confirm.tr(),
        onAction: () => Navigator.pop(dialogContext),
      ),
    );
  }

  Future<void> _showRedeemDialog(BuildContext context) async {
    final controller = TextEditingController();
    final selection = await showDialog<_QrRedemption>(
      context: context,
      builder: (dialogContext) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text(AppStrings.redeemQr.tr()),
          content: TextField(
            controller: controller,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              hintText: AppStrings.requestQrToken.tr(),
              prefixIcon: IconButton(
                onPressed: () async {
                  DonorScannerDestination? destination;
                  final token = await Navigator.push<String>(
                    dialogContext,
                    MaterialPageRoute(
                      builder: (_) => DonorQrScannerScreen(
                        onNavigate: (value) => destination = value,
                      ),
                    ),
                  );
                  final selectedDestination = destination;
                  if (selectedDestination != null) {
                    if (dialogContext.mounted) Navigator.pop(dialogContext);
                    if (context.mounted) {
                      _navigateFromScanner(selectedDestination);
                    }
                    return;
                  }
                  if (token != null) controller.text = token;
                },
                icon: const Icon(Icons.qr_code_scanner),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(AppStrings.cancel.tr()),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  _QrRedemption(
                    token: controller.text,
                    source: DonationSource.request,
                  ),
                );
              },
              child: Text(AppStrings.requestQrToken.tr()),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  _QrRedemption(
                    token: controller.text,
                    source: DonationSource.campaign,
                  ),
                );
              },
              child: Text(AppStrings.campaignQrToken.tr()),
            ),
          ],
        ),
      ),
    );
    controller.dispose();
    if (selection == null || !context.mounted) return;
    final token = selection.token.trim();
    if (token.isEmpty) return;
    final bloc = context.read<DonorFeedBloc>();
    switch (selection.source) {
      case DonationSource.request:
        bloc.add(DonorRequestQrRedeemed(token));
        break;
      case DonationSource.campaign:
        bloc.add(DonorCampaignQrRedeemed(token));
        break;
    }
  }

  void _navigateFromScanner(DonorScannerDestination destination) {
    final tab = switch (destination) {
      DonorScannerDestination.home => _DonorTab.home,
      DonorScannerDestination.requests => _DonorTab.requests,
      DonorScannerDestination.appointments => _DonorTab.appointments,
      DonorScannerDestination.record => _DonorTab.record,
      DonorScannerDestination.profile => _DonorTab.profile,
      DonorScannerDestination.notifications => _DonorTab.notifications,
    };
    setState(() => _selectedTab = tab);
  }
}

class _DonorOverview extends StatelessWidget {
  final VoidCallback? onNotifications;

  const _DonorOverview({this.onNotifications});

  @override
  Widget build(BuildContext context) {
    return Container(
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
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.failure.message),
                    const SizedBox(height: AppSize.s12),
                    ElevatedButton(
                      onPressed: () {
                        context.read<DonorFeedBloc>().add(
                          const DonorFeedRequested(),
                        );
                      },
                      child: Text(AppStrings.retryAgain.tr()),
                    ),
                  ],
                ),
              );
            }
            final feed = (state as DonorFeedLoaded).feed;
            return RefreshIndicator(
              onRefresh: () async {
                context.read<DonorFeedBloc>().add(const DonorFeedRequested());
              },
              child: LayoutBuilder(
                builder: (context, _) => Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: AppSize.s402),
                    child: ListView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppPadding.p10,
                        vertical: AppPadding.p32,
                      ),
                      children: [
                        _OverviewHeader(
                          bloodType: feed.availability.bloodType,
                          onNotifications: onNotifications,
                        ),
                        const SizedBox(height: AppSize.s20),
                        _AvailabilityCard(
                          feed: feed,
                          disabled: state.isMutating,
                        ),
                        const SizedBox(height: AppSize.s24),
                        Text(
                          AppStrings.latestNearbyRequests.tr(),
                          style: const TextStyle(
                            fontSize: AppSize.s20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppSize.s12),
                        if (feed.compatibleRequests.isEmpty)
                          Text(
                            AppStrings.noRequestsDescription.tr(),
                            textAlign: TextAlign.center,
                          )
                        else
                          ...feed.compatibleRequests
                              .take(AppConstants.paginationLimit)
                              .map(
                                (request) => Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: AppPadding.p12,
                                  ),
                                  child: _NearbyRequestCard(request: request),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _OverviewHeader extends StatelessWidget {
  final String bloodType;
  final VoidCallback? onNotifications;

  const _OverviewHeader({required this.bloodType, this.onNotifications});

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
          padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.p8,
            vertical: AppPadding.p8,
          ),
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

class _AvailabilityCard extends StatelessWidget {
  final DonorFeedEntity feed;
  final bool disabled;

  const _AvailabilityCard({required this.feed, required this.disabled});

  @override
  Widget build(BuildContext context) {
    final availability = feed.availability;
    final eligible = availability.isEligibleAt(DateTime.now());
    final lastDonation = availability.lastDonationDate == null
        ? AppStrings.notAvailable.tr()
        : DateFormat(
            AppConstants.requestDateFormat,
          ).format(availability.lastDonationDate!.toLocal());
    final appointment = feed.activeAppointment;
    final nextAppointment = appointment == null
        ? AppStrings.notAvailable.tr()
        : DateFormat(
            AppConstants.requestDateFormat,
          ).format(appointment.scheduledAt.toLocal());
    return Container(
      padding: const EdgeInsets.all(AppPadding.p20),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(AppSize.radiusXXLarge),
        border: Border.all(color: ColorManager.borderGrey),
        boxShadow: [
          BoxShadow(
            color: ColorManager.black.withValues(alpha: AppOpacity.subtle),
            blurRadius: AppSize.s26,
            offset: const Offset(AppSize.s0, AppSize.s8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: _EligibilityStatus(
                        eligible: eligible,
                        onTap: disabled
                            ? null
                            : () {
                                context.read<DonorFeedBloc>().add(
                                  DonorAvailabilityChanged(
                                    !availability.isAvailableForDonation,
                                  ),
                                );
                              },
                      ),
                    ),
                    const SizedBox(height: AppSize.s10),
                    Text(
                      AppStrings.hadithIntro.tr(),
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: AppSize.s24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      AppStrings.hadithRelief.tr(),
                      maxLines: AppConstants.profileHadithMaxLines,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: ColorManager.textMuted,
                        fontSize: FontSize.s12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSize.s10),
              Image.asset(
                ImageAssets.demo1,
                width: AppSize.s130,
                height: AppSize.s130,
                fit: BoxFit.contain,
              ),
            ],
          ),
          const SizedBox(height: AppSize.s16),
          _OverviewInfo(
            label: AppStrings.bloodType.tr(),
            value: availability.bloodType,
          ),
          _OverviewInfo(
            label: AppStrings.totalDonations.tr(),
            value: availability.totalDonationsCount.toString(),
          ),
          _OverviewInfo(
            label: AppStrings.requestsNearYou.tr(),
            value: feed.compatibleRequests.length.toString(),
          ),
          _OverviewInfo(
            label: AppStrings.lastDonation.tr(),
            value: lastDonation,
          ),
          _OverviewInfo(
            label: AppStrings.nextDonationAppointment.tr(),
            value: nextAppointment,
          ),
        ],
      ),
    );
  }
}

class _EligibilityStatus extends StatelessWidget {
  final bool eligible;
  final VoidCallback? onTap;

  const _EligibilityStatus({required this.eligible, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = eligible ? ColorManager.success : ColorManager.error;
    return Semantics(
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.p12,
            vertical: AppPadding.p6,
          ),
          decoration: BoxDecoration(
            color: color.withValues(alpha: AppOpacity.muted),
            borderRadius: BorderRadius.circular(AppSize.radiusCircle),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                eligible
                    ? AppStrings.eligibleNow.tr()
                    : AppStrings.notEligibleNow.tr(),
                style: TextStyle(color: color, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: AppSize.s8),
              Container(
                width: AppSize.s8,
                height: AppSize.s8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OverviewInfo extends StatelessWidget {
  final String label;
  final String value;

  const _OverviewInfo({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppPadding.p4),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: TextStyle(color: ColorManager.textMuted)),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _NearbyRequestCard extends StatelessWidget {
  final DonorBloodRequestEntity request;

  const _NearbyRequestCard({required this.request});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppPadding.p16),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(AppSize.radiusXLarge),
        border: Border.all(color: ColorManager.borderGrey),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request.hospital.nameAr,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  request.hospital.address ?? AppStrings.location.tr(),
                  style: TextStyle(color: ColorManager.textMuted),
                ),
              ],
            ),
          ),
          Text(
            request.bloodType,
            style: TextStyle(
              color: ColorManager.primaryDark,
              fontSize: AppSize.s17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNavigation extends StatelessWidget {
  final _DonorTab selectedTab;
  final ValueChanged<_DonorTab> onSelected;
  final VoidCallback onRedeem;

  const _BottomNavigation({
    required this.selectedTab,
    required this.onSelected,
    required this.onRedeem,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSize.s80,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavigationItem(
              navKey: WidgetKeys.donorNavigationHome,
              asset: SvgAssets.icon1,
              selected: selectedTab == _DonorTab.home,
              onTap: () => onSelected(_DonorTab.home),
            ),
            _NavigationItem(
              asset: SvgAssets.icon2,
              selected: selectedTab == _DonorTab.requests,
              onTap: () => onSelected(_DonorTab.requests),
            ),
            IconButton(
              key: WidgetKeys.donorNavigationAppointments,
              tooltip: AppStrings.appointments.tr(),
              onPressed: () => onSelected(_DonorTab.appointments),
              onLongPress: onRedeem,
              style: IconButton.styleFrom(
                backgroundColor: ColorManager.transparent,
              ),
              icon: Icon(
                Icons.calendar_month_rounded,
                size: AppSize.s35,
                color: selectedTab == _DonorTab.appointments
                    ? ColorManager.primary
                    : ColorManager.mediumGrey,
              ),
            ),
            _NavigationItem(
              asset: SvgAssets.icon4,
              selected: selectedTab == _DonorTab.record,
              onTap: () => onSelected(_DonorTab.record),
            ),
            _NavigationItem(
              navKey: WidgetKeys.donorNavigationProfile,
              asset: SvgAssets.icon5,
              selected:
                  selectedTab == _DonorTab.profile ||
                  selectedTab == _DonorTab.about ||
                  selectedTab == _DonorTab.card ||
                  selectedTab == _DonorTab.cardInfo,
              onTap: () => onSelected(_DonorTab.profile),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavigationItem extends StatelessWidget {
  final Key? navKey;
  final String asset;
  final bool selected;
  final VoidCallback onTap;

  const _NavigationItem({
    this.navKey,
    required this.asset,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: navKey,
      onPressed: onTap,
      style: IconButton.styleFrom(backgroundColor: ColorManager.transparent),
      icon: SvgPicture.asset(
        asset,
        width: AppSize.s35,
        height: AppSize.s35,
        colorFilter: ColorFilter.mode(
          selected ? ColorManager.primary : ColorManager.mediumGrey,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}

class _QrRedemption {
  final String token;
  final DonationSource source;

  const _QrRedemption({required this.token, required this.source});
}
