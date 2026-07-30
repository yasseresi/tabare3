import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/constants_manager.dart';
import '../../../../core/utils/route_manager.dart';
import '../../../../core/utils/string_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../../../../injection_container.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../../profile/presentation/pages/requester_profile_screen.dart';
import '../../domain/entities/blood_request_entity.dart';
import '../bloc/request_bloc.dart';
import 'create_request_screen.dart';
import 'donor_history_screen.dart';
import 'requests_screen.dart';

enum _RequesterTab { home, requests, create, donors, profile }

class RequesterHomeScreen extends StatefulWidget {
  const RequesterHomeScreen({super.key});

  @override
  State<RequesterHomeScreen> createState() => _RequesterHomeScreenState();
}

class _RequesterHomeScreenState extends State<RequesterHomeScreen> {
  _RequesterTab _selectedTab = _RequesterTab.home;

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
      _RequesterTab.home => const _RequesterOverview(),
      _RequesterTab.requests => const RequestsScreen(),
      _RequesterTab.create => CreateRequestScreen(
        onSuccess: () {
          setState(() => _selectedTab = _RequesterTab.requests);
        },
      ),
      _RequesterTab.donors => const DonorHistoryScreen(),
      _RequesterTab.profile => BlocProvider(
        create: (_) => sl<ProfileBloc>()..add(const LoadProfile()),
        child: const RequesterProfileScreen(),
      ),
    };
  }
}

class _RequesterOverview extends StatelessWidget {
  const _RequesterOverview();

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
            child: ListView(
              padding: const EdgeInsets.all(AppPadding.p20),
              children: [
                const _OverviewHeader(),
                const SizedBox(height: AppSize.s20),
                _RequestStatsCard(requests: state.requests),
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
                      Navigator.pushNamed(context, Routes.createRequestRoute);
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
                          child: _OverviewRequestCard(request: request),
                        ),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _OverviewHeader extends StatelessWidget {
  const _OverviewHeader();

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
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, Routes.notificationsRoute);
          },
          icon: const Icon(Icons.notifications_none_rounded),
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
        color: ColorManager.surfaceWarm,
        borderRadius: BorderRadius.circular(AppSize.radiusXXLarge),
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatItem(
              value: requests.length.toString(),
              label: AppStrings.requestsCount.tr(),
            ),
          ),
          Expanded(
            child: _StatItem(
              value: active.toString(),
              label: AppStrings.activeRequests.tr(),
            ),
          ),
          Expanded(
            child: _StatItem(
              value: completed.toString(),
              label: AppStrings.completedRequests.tr(),
            ),
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
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: AppSize.s17,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: ColorManager.textMuted,
            fontSize: AppSize.s12,
          ),
        ),
      ],
    );
  }
}

class _OverviewRequestCard extends StatelessWidget {
  final BloodRequestEntity request;

  const _OverviewRequestCard({required this.request});

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
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      Routes.editRequestRoute,
                      arguments: request,
                    );
                  },
                  child: Text(AppStrings.editRequest.tr()),
                ),
              ),
              const SizedBox(width: AppSize.s8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      Routes.requestDetailRoute,
                      arguments: request,
                    );
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
    return SizedBox(
      height: AppSize.s80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavigationItem(
            asset: SvgAssets.icon1,
            selected: selectedTab == _RequesterTab.home,
            onTap: () => onSelected(_RequesterTab.home),
          ),
          _NavigationItem(
            asset: SvgAssets.icon2,
            selected: selectedTab == _RequesterTab.requests,
            onTap: () => onSelected(_RequesterTab.requests),
          ),
          IconButton.filled(
            onPressed: () => onSelected(_RequesterTab.create),
            icon: const Icon(Icons.add),
          ),
          _NavigationItem(
            asset: SvgAssets.icon4,
            selected: selectedTab == _RequesterTab.donors,
            onTap: () => onSelected(_RequesterTab.donors),
          ),
          _NavigationItem(
            asset: SvgAssets.icon5,
            selected: selectedTab == _RequesterTab.profile,
            onTap: () => onSelected(_RequesterTab.profile),
          ),
        ],
      ),
    );
  }
}

class _NavigationItem extends StatelessWidget {
  final String asset;
  final bool selected;
  final VoidCallback onTap;

  const _NavigationItem({
    required this.asset,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      style: IconButton.styleFrom(
        backgroundColor: selected
            ? ColorManager.primaryDark
            : ColorManager.scaffoldBg,
      ),
      icon: SvgPicture.asset(
        asset,
        width: AppSize.s26,
        height: AppSize.s26,
        colorFilter: ColorFilter.mode(
          selected ? ColorManager.white : ColorManager.mediumGrey,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
