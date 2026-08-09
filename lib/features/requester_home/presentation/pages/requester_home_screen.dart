import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/widget_keys.dart';
import '../../../../core/presentation/widgets/app_bottom_nav.dart';
import '../../../../core/presentation/widgets/app_button.dart';
import '../../../../core/presentation/widgets/app_gradient_background.dart';
import '../../../../core/presentation/widgets/app_page.dart';
import '../../../../core/presentation/widgets/app_section_header.dart';
import '../../../../core/presentation/widgets/app_tag_pill.dart';
import '../../../../core/presentation/widgets/hadith_stats_card.dart';
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
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../../profile/presentation/pages/requester_profile_screen.dart';
import '../../../profile/presentation/pages/about_app_screen.dart';
import '../../../notifications/presentation/bloc/notifications_bloc.dart';
import '../../../notifications/presentation/pages/notifications_center_page.dart';
import '../../domain/entities/blood_request_entity.dart';
import '../bloc/request_bloc.dart';
import '../bloc/request_detail_bloc.dart';
import '../widgets/requester_request_card.dart';
import 'create_request_screen.dart';
import 'donor_history_screen.dart';
import 'edit_request_screen.dart';
import 'request_detail_screen.dart';
import 'requester_qr_screen.dart';
import 'requests_screen.dart';

enum _RequesterTab {
  home,
  requests,
  create,
  donors,
  profile,
  notifications,
  about,
  edit,
  detail,
  qr,
}

class RequesterHomeScreen extends StatefulWidget {
  const RequesterHomeScreen({super.key});

  @override
  State<RequesterHomeScreen> createState() => _RequesterHomeScreenState();
}

class _RequesterHomeScreenState extends State<RequesterHomeScreen> {
  _RequesterTab _selectedTab = _RequesterTab.home;
  BloodRequestEntity? _editingRequest;
  BloodRequestEntity? _detailRequest;

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
          body: _buildBody(),
          bottomNavigationBar: _RequesterNavigation(
            selectedTab: _selectedTab,
            onSelected: (tab) => setState(() => _selectedTab = tab),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return switch (_selectedTab) {
      _RequesterTab.home => _RequesterOverview(
        onCreate: () => setState(() => _selectedTab = _RequesterTab.create),
        onNotifications: () =>
            setState(() => _selectedTab = _RequesterTab.notifications),
        onViewAll: () => setState(() => _selectedTab = _RequesterTab.requests),
        onEdit: (request) {
          setState(() {
            _editingRequest = request;
            _selectedTab = _RequesterTab.edit;
          });
        },
        onDetail: _openDetail,
      ),
      _RequesterTab.requests => RequestsScreen(
        onNotifications: () =>
            setState(() => _selectedTab = _RequesterTab.notifications),
        onEdit: (request) {
          setState(() {
            _editingRequest = request;
            _selectedTab = _RequesterTab.edit;
          });
        },
        onDetail: _openDetail,
      ),
      _RequesterTab.create => CreateRequestScreen(
        onSuccess: () {
          setState(() => _selectedTab = _RequesterTab.requests);
        },
        onNotifications: () =>
            setState(() => _selectedTab = _RequesterTab.notifications),
        onProfile: () => setState(() => _selectedTab = _RequesterTab.profile),
      ),
      _RequesterTab.donors => DonorHistoryScreen(
        onNotifications: () =>
            setState(() => _selectedTab = _RequesterTab.notifications),
        onDetail: _openDetail,
      ),
      _RequesterTab.profile => BlocProvider(
        create: (_) => sl<ProfileBloc>()..add(const LoadProfile()),
        child: RequesterProfileScreen(
          onAbout: () => setState(() => _selectedTab = _RequesterTab.about),
          onNotifications: () =>
              setState(() => _selectedTab = _RequesterTab.notifications),
          onQrCode: () => setState(() => _selectedTab = _RequesterTab.qr),
        ),
      ),
      _RequesterTab.qr => BlocProvider(
        create: (_) => sl<RequestDetailBloc>(),
        child: Builder(
          builder: (context) => RequesterQrScreen(
            request: _activeRequest(context),
            onNotifications: () =>
                setState(() => _selectedTab = _RequesterTab.notifications),
          ),
        ),
      ),
      _RequesterTab.notifications => BlocProvider(
        create: (_) => sl<NotificationsBloc>(),
        child: const NotificationsCenterPage(),
      ),
      _RequesterTab.about => AboutAppScreen(
        onBack: () => setState(() => _selectedTab = _RequesterTab.profile),
      ),
      _RequesterTab.edit =>
        _editingRequest == null
            ? RequestsScreen(
                onNotifications: () =>
                    setState(() => _selectedTab = _RequesterTab.notifications),
                onDetail: _openDetail,
              )
            : EditRequestScreen(
                request: _editingRequest!,
                onComplete: () {
                  setState(() {
                    _editingRequest = null;
                    _selectedTab = _RequesterTab.requests;
                  });
                },
                onNotifications: () {
                  setState(() => _selectedTab = _RequesterTab.notifications);
                },
              ),
      _RequesterTab.detail =>
        _detailRequest == null
            ? RequestsScreen(
                onNotifications: () =>
                    setState(() => _selectedTab = _RequesterTab.notifications),
                onDetail: _openDetail,
              )
            : BlocProvider(
                create: (_) => sl<RequestDetailBloc>(),
                child: RequestDetailScreen(
                  request: _detailRequest!,
                  onNotifications: () => setState(
                    () => _selectedTab = _RequesterTab.notifications,
                  ),
                ),
              ),
    };
  }

  /// The request a recipient QR should be issued against — their single open
  /// request, since the schema allows only one at a time.
  BloodRequestEntity? _activeRequest(BuildContext context) {
    final requests = context.read<RequestBloc>().state.requests;
    for (final request in requests) {
      if (request.isActive) return request;
    }
    return null;
  }

  void _openDetail(BloodRequestEntity request) {
    setState(() {
      _detailRequest = request;
      _selectedTab = _RequesterTab.detail;
    });
  }
}

class _RequesterOverview extends StatelessWidget {
  final VoidCallback onCreate;
  final VoidCallback onNotifications;
  final VoidCallback onViewAll;
  final ValueChanged<BloodRequestEntity> onEdit;
  final ValueChanged<BloodRequestEntity> onDetail;

  const _RequesterOverview({
    required this.onCreate,
    required this.onNotifications,
    required this.onViewAll,
    required this.onEdit,
    required this.onDetail,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestBloc, RequestState>(
      builder: (context, state) {
        if (state.status == RequestViewStatus.initial ||
            state.status == RequestViewStatus.loading) {
          return const AppGradientBackground(
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (state.status == RequestViewStatus.failure) {
          return AppGradientBackground(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.errorMessage ?? AppStrings.error.tr()),
                  const SizedBox(height: AppSize.s12),
                  ElevatedButton(
                    onPressed: () {
                      context.read<RequestBloc>().add(
                        const RequestsLoadRequested(),
                      );
                    },
                    child: Text(AppStrings.retryAgain.tr()),
                  ),
                ],
              ),
            ),
          );
        }
        final requests = state.requests;
        return AppPage(
          title: welcomeTitle(),
          subtitle: AppStrings.getWellSoon.tr(),
          onNotifications: onNotifications,
          onRefresh: () async {
            context.read<RequestBloc>().add(const RequestsLoadRequested());
          },
          children: [
            _RequestStatsCard(requests: requests),
            const SizedBox(height: AppSize.s12),
            if (requests.isEmpty)
              Center(
                child: SizedBox(
                  width: AppSize.s174,
                  child: AppButton.primary(
                    label: AppStrings.createRequest.tr(),
                    onPressed: onCreate,
                  ),
                ),
              )
            else ...[
              AppSectionHeader(
                title: AppStrings.myRequests.tr(),
                actionLabel: AppStrings.viewAll.tr(),
                onAction: onViewAll,
              ),
              const SizedBox(height: AppSize.s10),
              ...requests
                  .take(AppConstants.paginationLimit)
                  .map(
                    (request) => Padding(
                      padding: const EdgeInsets.only(bottom: AppPadding.p15),
                      child: RequesterRequestCard(
                        request: request,
                        ownerName: currentUserFullName(),
                        onEdit: () => onEdit(request),
                      ),
                    ),
                  ),
            ],
          ],
        );
      },
    );
  }
}

class _RequestStatsCard extends StatelessWidget {
  final List<BloodRequestEntity> requests;

  const _RequestStatsCard({required this.requests});

  @override
  Widget build(BuildContext context) {
    final active = requests
        .where((request) => request.status == BloodRequestStatus.open)
        .length;
    final completed = requests
        .where((request) => request.status == BloodRequestStatus.fulfilled)
        .length;
    final hasRequests = requests.isNotEmpty;
    final statusColor = hasRequests
        ? ColorManager.success
        : ColorManager.urgencyCritical;
    return HadithStatsCard(
      statusPill: AppTagPill(
        label: hasRequests
            ? AppStrings.requestActive.tr()
            : AppStrings.noRequestsYou.tr(),
        dotColor: statusColor,
        background: statusColor.withValues(alpha: AppOpacity.tint),
      ),
      hadithBody: AppStrings.hadithBelieverAffair.tr(),
      stats: [
        HadithStat(
          label: AppStrings.requestsCount.tr(),
          value: requests.length.toString(),
        ),
        HadithStat(
          label: AppStrings.respondingDonors.tr(),
          value: active.toString(),
        ),
        HadithStat(
          label: AppStrings.completedRequests.tr(),
          value: completed.toString(),
        ),
      ],
    );
  }
}

class _RequesterNavigation extends StatelessWidget {
  final _RequesterTab selectedTab;
  final ValueChanged<_RequesterTab> onSelected;

  const _RequesterNavigation({
    required this.selectedTab,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AppBottomNav(
      items: [
        AppBottomNavItem(
          itemKey: WidgetKeys.requesterNavigationHome,
          asset: SvgAssets.navHome,
          selected: selectedTab == _RequesterTab.home,
          onTap: () => onSelected(_RequesterTab.home),
        ),
        AppBottomNavItem(
          itemKey: WidgetKeys.requesterNavigationRequests,
          asset: SvgAssets.navRequests,
          selected:
              selectedTab == _RequesterTab.requests ||
              selectedTab == _RequesterTab.edit ||
              selectedTab == _RequesterTab.detail,
          onTap: () => onSelected(_RequesterTab.requests),
        ),
        AppBottomNavItem(
          itemKey: WidgetKeys.requesterNavigationCreate,
          asset: SvgAssets.navAdd,
          selected: selectedTab == _RequesterTab.create,
          onTap: () => onSelected(_RequesterTab.create),
        ),
        AppBottomNavItem(
          asset: SvgAssets.navHistory,
          selected: selectedTab == _RequesterTab.donors,
          onTap: () => onSelected(_RequesterTab.donors),
        ),
        AppBottomNavItem(
          itemKey: WidgetKeys.requesterNavigationProfile,
          asset: SvgAssets.navPerson,
          selected:
              selectedTab == _RequesterTab.profile ||
              selectedTab == _RequesterTab.about ||
              selectedTab == _RequesterTab.qr,
          onTap: () => onSelected(_RequesterTab.profile),
        ),
      ],
    );
  }
}
