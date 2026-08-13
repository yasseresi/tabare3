import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/widget_keys.dart';
import '../../../../core/presentation/widgets/app_bottom_nav.dart';
import '../../../../core/presentation/widgets/app_dialog.dart';
import '../../../../core/presentation/widgets/app_gradient_background.dart';
import '../../../../core/presentation/widgets/app_page.dart';
import '../../../../core/presentation/widgets/hadith_stats_card.dart';
import '../../../../core/presentation/widgets/app_section_header.dart';
import '../../../../core/presentation/widgets/app_tag_pill.dart';
import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/constants_manager.dart';
import '../../../../core/presentation/widgets/logout_dialog.dart';
import '../../../../core/utils/route_manager.dart';
import '../../../../core/utils/string_manager.dart';
import '../../../../core/utils/greeting.dart';
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
import '../widgets/donor_card_theme.dart';
import '../widgets/donor_request_actions.dart';
import '../widgets/donor_request_card.dart';
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
  void initState() {
    super.initState();
    // Open the app-wide notifications stream now that a user is signed in, so
    // the bell badge stays live across every screen for this session.
    context.read<NotificationsBloc>().add(const NotificationsRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) => current is Unauthenticated,
      listener: (context, state) {
        showLogoutSuccessDialog(
          context,
          onDismissed: () => Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.welcomeRoute,
            (route) => false,
          ),
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
              if (mutation == DonorFeedMutation.donationRecorded) {
                // A completed redemption lands the donor on their history.
                setState(() => _selectedTab = _DonorTab.record);
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
            onRedeem: () => _openScanner(context),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return switch (_selectedTab) {
      _DonorTab.home => _DonorOverview(
        onNotifications: _openNotifications,
        onViewAllRequests: () =>
            setState(() => _selectedTab = _DonorTab.requests),
      ),
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
          onQrCode: () => _openScanner(context),
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
      _DonorTab.notifications => BlocProvider.value(
        value: context.read<NotificationsBloc>(),
        child: const NotificationsCenterPage(isDonor: true),
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
      barrierColor: ColorManager.dialogScrim,
      builder: (dialogContext) => AppDialog.success(
        title: AppStrings.requestAccepted.tr(),
        message: AppStrings.acceptRequestThanks.tr(),
        actionLabel: AppStrings.confirm.tr(),
        onAction: () => Navigator.pop(dialogContext),
      ),
    );
  }

  /// Scan-first redemption: opens the camera directly, keeping the shared
  /// [DonorFeedBloc] available so the scanner can redeem and self-close. On
  /// success the feed listener lands the donor on their history tab.
  Future<void> _openScanner(BuildContext context) {
    final bloc = context.read<DonorFeedBloc>();
    return Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => BlocProvider<DonorFeedBloc>.value(
          value: bloc,
          child: DonorQrScannerScreen(onNavigate: _navigateFromScanner),
        ),
      ),
    );
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
  final VoidCallback? onViewAllRequests;

  const _DonorOverview({this.onNotifications, this.onViewAllRequests});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DonorFeedBloc, DonorFeedState>(
      builder: (context, state) {
        if (state is DonorFeedInitial || state is DonorFeedLoading) {
          return const AppGradientBackground(
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (state is DonorFeedError) {
          return AppGradientBackground(
            child: Center(
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
            ),
          );
        }
        final loaded = state as DonorFeedLoaded;
        final feed = loaded.feed;
        final notificationsState = context.watch<NotificationsBloc>().state;
        final unreadCount = notificationsState is NotificationsLoaded
            ? notificationsState.unreadCount
            : 0;
        return AppPage(
          title: welcomeTitle(),
          subtitle: AppStrings.donationLifeChance.tr(),
          unreadCount: unreadCount,
          notificationsKey: WidgetKeys.donorNotificationsButton,
          onNotifications:
              onNotifications ??
              () => Navigator.pushNamed(context, Routes.notificationsRoute),
          onRefresh: () async {
            context.read<DonorFeedBloc>().add(const DonorFeedRequested());
          },
          children: [
            _AvailabilityCard(feed: feed, disabled: loaded.isMutating),
            const SizedBox(height: AppSize.s12),
            AppSectionHeader(
              title: AppStrings.latestNearbyRequests.tr(),
              actionLabel: AppStrings.viewAll.tr(),
              onAction: onViewAllRequests,
            ),
            const SizedBox(height: AppSize.s10),
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
                      padding: const EdgeInsets.only(bottom: AppPadding.p15),
                      child: DonorRequestCard(
                        request: request,
                        onAccept: loaded.isMutating
                            ? null
                            : () => acceptDonorRequest(context, request.id),
                      ),
                    ),
                  ),
          ],
        );
      },
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
    final statusColor = eligible
        ? ColorManager.success
        : ColorManager.urgencyCritical;
    // Figma tints the two chips differently: a soft sage behind `مؤهل الآن`
    // and the urgency red at a heavier 9% behind `غير مؤهل الآن`.
    final statusBackground = eligible
        ? ColorManager.eligiblePillTint.withValues(alpha: AppOpacity.tint)
        : ColorManager.urgencyCritical.withValues(
            alpha: AppOpacity.notEligiblePill,
          );
    return HadithStatsCard(
      statusPill: Semantics(
        button: true,
        child: GestureDetector(
          onTap: disabled
              ? null
              : () {
                  context.read<DonorFeedBloc>().add(
                    DonorAvailabilityChanged(
                      !availability.isAvailableForDonation,
                    ),
                  );
                },
          child: AppTagPill(
            label: eligible
                ? AppStrings.eligibleNow.tr()
                : AppStrings.notEligibleNow.tr(),
            dotColor: statusColor,
            background: statusBackground,
            gap: AppSize.s10,
          ),
        ),
      ),
      hadithBody: AppStrings.hadithRelief.tr(),
      stats: [
        HadithStat(
          label: AppStrings.totalDonations.tr(),
          value: availability.totalDonationsCount.toString(),
        ),
        HadithStat(
          label: AppStrings.requestsNearYou.tr(),
          value: feed.compatibleRequests.length.toString(),
        ),
        HadithStat(label: AppStrings.lastDonation.tr(), value: lastDonation),
        if (appointment != null)
          HadithStat(
            label: AppStrings.nextDonationAppointment.tr(),
            value: nextAppointment,
          ),
      ],
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
    final onDonorCard =
        selectedTab == _DonorTab.card || selectedTab == _DonorTab.cardInfo;
    return AppBottomNav(
      backgroundBuilder: onDonorCard
          ? (child) => DonorCardBackground(child: child)
          : null,
      items: [
        AppBottomNavItem(
          itemKey: WidgetKeys.donorNavigationHome,
          asset: SvgAssets.navHome,
          selected: selectedTab == _DonorTab.home,
          onTap: () => onSelected(_DonorTab.home),
        ),
        AppBottomNavItem(
          asset: SvgAssets.navRequests,
          selected: selectedTab == _DonorTab.requests,
          onTap: () => onSelected(_DonorTab.requests),
        ),
        AppBottomNavItem(
          itemKey: WidgetKeys.donorNavigationAppointments,
          asset: SvgAssets.navCalendar,
          tooltip: AppStrings.appointments.tr(),
          selected: selectedTab == _DonorTab.appointments,
          onTap: () => onSelected(_DonorTab.appointments),
          onLongPress: onRedeem,
        ),
        AppBottomNavItem(
          asset: SvgAssets.navHistory,
          selected: selectedTab == _DonorTab.record,
          onTap: () => onSelected(_DonorTab.record),
        ),
        AppBottomNavItem(
          itemKey: WidgetKeys.donorNavigationProfile,
          asset: SvgAssets.navPerson,
          selected:
              selectedTab == _DonorTab.profile ||
              selectedTab == _DonorTab.about ||
              selectedTab == _DonorTab.card ||
              selectedTab == _DonorTab.cardInfo,
          onTap: () => onSelected(_DonorTab.profile),
        ),
      ],
    );
  }
}

