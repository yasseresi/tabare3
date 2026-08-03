import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/widget_keys.dart';
import '../../../../core/presentation/widgets/app_bottom_nav.dart';
import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/constants_manager.dart';
import '../../../../core/utils/font_manager.dart';
import '../../../../core/utils/route_manager.dart';
import '../../../../core/utils/string_manager.dart';
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
import 'create_request_screen.dart';
import 'donor_history_screen.dart';
import 'edit_request_screen.dart';
import 'request_detail_screen.dart';
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
        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.welcomeRoute,
          (route) => false,
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
  final ValueChanged<BloodRequestEntity> onEdit;
  final ValueChanged<BloodRequestEntity> onDetail;

  const _RequesterOverview({
    required this.onCreate,
    required this.onNotifications,
    required this.onEdit,
    required this.onDetail,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<RequestBloc, RequestState>(
        builder: (context, state) {
          if (state.status == RequestViewStatus.initial ||
              state.status == RequestViewStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == RequestViewStatus.failure) {
            return Center(
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
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              context.read<RequestBloc>().add(const RequestsLoadRequested());
            },
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
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: AppSize.s402),
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppPadding.p10,
                      vertical: AppPadding.p32,
                    ),
                    children: [
                      _OverviewHeader(onNotifications: onNotifications),
                      const SizedBox(height: AppSize.s20),
                      _RequestStatsCard(requests: state.requests),
                      const SizedBox(height: AppSize.s24),
                      Center(
                        child: SizedBox(
                          width: AppSize.s174,
                          child: ElevatedButton(
                            onPressed: () {
                              onCreate();
                            },
                            child: Text(AppStrings.createRequest.tr()),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSize.s24),
                      Text(
                        AppStrings.myRequests.tr(),
                        style: const TextStyle(
                          fontSize: AppSize.s20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSize.s12),
                      if (state.requests.isEmpty)
                        _EmptyOverview(
                          onCreate: () {
                            onCreate();
                          },
                        )
                      else
                        ...state.requests
                            .take(AppConstants.paginationLimit)
                            .map(
                              (request) => Padding(
                                padding: const EdgeInsets.only(
                                  bottom: AppPadding.p12,
                                ),
                                child: _OverviewRequestCard(
                                  request: request,
                                  onEdit: onEdit,
                                  onDetail: onDetail,
                                ),
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
    );
  }
}

class _OverviewHeader extends StatelessWidget {
  final VoidCallback onNotifications;

  const _OverviewHeader({required this.onNotifications});

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
                AppStrings.getWellSoon.tr(),
                style: TextStyle(color: ColorManager.textMuted),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(AppPadding.p8),
          decoration: BoxDecoration(
            color: ColorManager.surfaceAlt,
            borderRadius: BorderRadius.circular(AppSize.radiusCircle),
          ),
          child: IconButton(
            onPressed: onNotifications,
            icon: const Icon(Icons.notifications_none_rounded),
          ),
        ),
      ],
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
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _RequestStatusTag(requests: requests),
                    const SizedBox(height: AppSize.s10),
                    Text(
                      AppStrings.hadithIntro.tr(),
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: FontSize.s24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      AppStrings.hadithBelieverAffair.tr(),
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
          _StatItem(
            value: requests.length.toString(),
            label: AppStrings.requestsCount.tr(),
          ),
          _StatItem(
            value: active.toString(),
            label: AppStrings.respondingDonors.tr(),
          ),
          _StatItem(
            value: completed.toString(),
            label: AppStrings.completedRequests.tr(),
          ),
        ],
      ),
    );
  }
}

class _RequestStatusTag extends StatelessWidget {
  final List<BloodRequestEntity> requests;

  const _RequestStatusTag({required this.requests});

  @override
  Widget build(BuildContext context) {
    final hasRequests = requests.isNotEmpty;
    final color = hasRequests ? ColorManager.success : ColorManager.error;
    return Container(
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
          Flexible(
            child: Text(
              hasRequests
                  ? AppStrings.activeRequests.tr()
                  : AppStrings.noRequestsDescription.tr(),
              maxLines: AppConstants.statusTagMaxLines,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: color, fontSize: FontSize.s12),
            ),
          ),
          const SizedBox(width: AppSize.s8),
          Container(
            width: AppSize.s8,
            height: AppSize.s8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppPadding.p2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: AppSize.s14),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppPadding.p8,
              vertical: AppPadding.p2,
            ),
            decoration: BoxDecoration(
              color: ColorManager.surfaceLight,
              borderRadius: BorderRadius.circular(AppSize.radiusCircle),
            ),
            child: Text(
              value,
              style: const TextStyle(
                fontSize: AppSize.s12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OverviewRequestCard extends StatelessWidget {
  final BloodRequestEntity request;
  final ValueChanged<BloodRequestEntity> onEdit;
  final ValueChanged<BloodRequestEntity> onDetail;

  const _OverviewRequestCard({
    required this.request,
    required this.onEdit,
    required this.onDetail,
  });

  @override
  Widget build(BuildContext context) {
    final progress = request.unitsNeeded == AppSize.s0
        ? AppSize.s0
        : request.unitsFulfilled / request.unitsNeeded;
    return Container(
      padding: const EdgeInsets.all(AppPadding.p16),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(AppSize.radiusXLarge),
        border: Border.all(color: ColorManager.borderGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  request.hospital.nameAr,
                  style: const TextStyle(
                    fontSize: AppSize.s17,
                    fontWeight: FontWeight.bold,
                  ),
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
          const SizedBox(height: AppSize.s12),
          LinearProgressIndicator(
            value: progress.clamp(AppSize.s0, AppSize.s1),
            minHeight: AppSize.s8,
            borderRadius: BorderRadius.circular(AppSize.radiusSmall),
            color: ColorManager.primaryDark,
            backgroundColor: ColorManager.progressTrack,
          ),
          const SizedBox(height: AppSize.s8),
          Text(
            AppStrings.bagsRatio.tr(
              namedArgs: {
                LocalizationArgs.provided: request.unitsFulfilled.toString(),
                LocalizationArgs.total: request.unitsNeeded.toString(),
              },
            ),
          ),
          const SizedBox(height: AppSize.s12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => onEdit(request),
                  child: Text(AppStrings.editRequest.tr()),
                ),
              ),
              const SizedBox(width: AppSize.s8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    onDetail(request);
                  },
                  child: Text(AppStrings.requestDetails.tr()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyOverview extends StatelessWidget {
  final VoidCallback onCreate;

  const _EmptyOverview({required this.onCreate});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          AppStrings.noRequestsDescription.tr(),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSize.s16),
        ElevatedButton(
          onPressed: onCreate,
          child: Text(AppStrings.createRequest.tr()),
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
              selectedTab == _RequesterTab.about,
          onTap: () => onSelected(_RequesterTab.profile),
        ),
      ],
    );
  }
}
