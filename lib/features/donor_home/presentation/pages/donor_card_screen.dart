import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/constants_manager.dart';
import '../../../../core/utils/route_manager.dart';
import '../../../../core/utils/string_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../../domain/entities/donor_card_entity.dart';
import '../bloc/donor_card_bloc.dart';

class DonorCardScreen extends StatelessWidget {
  final VoidCallback? onInfo;

  const DonorCardScreen({super.key, this.onInfo});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorManager.donorCardBackground,
        body: SafeArea(
          child: BlocBuilder<DonorCardBloc, DonorCardState>(
            builder: (context, state) {
              if (state is DonorCardInitial || state is DonorCardLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: ColorManager.donorCardAccent,
                  ),
                );
              }
              if (state is DonorCardError) {
                return _ErrorState(message: state.failure.message);
              }
              return _DonorCardContent(
                card: (state as DonorCardLoaded).card,
                onInfo: onInfo,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _DonorCardContent extends StatelessWidget {
  final DonorCardEntity card;
  final VoidCallback? onInfo;

  const _DonorCardContent({required this.card, this.onInfo});

  @override
  Widget build(BuildContext context) {
    final current = card.currentLevel;
    final next = card.nextLevel;
    return ListView(
      padding: const EdgeInsets.all(AppPadding.p20),
      children: [
        Text(
          AppStrings.donorCard.tr(),
          style: TextStyle(
            color: ColorManager.white,
            fontSize: AppSize.s24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSize.s20),
        Center(
          child: Image.asset(
            ImageAssets.avatar,
            height: AppSize.s160,
            errorBuilder: (context, error, stackTrace) => Icon(
              Icons.water_drop,
              size: AppSize.s120,
              color: ColorManager.donorCardAccent,
            ),
          ),
        ),
        const SizedBox(height: AppSize.s16),
        if (current != null)
          Text(
            current.nameAr,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ColorManager.white,
              fontSize: AppSize.s24,
              fontWeight: FontWeight.bold,
            ),
          ),
        const SizedBox(height: AppSize.s8),
        Text(
          AppStrings.pointsCount.tr(
            namedArgs: {LocalizationArgs.count: card.totalPoints.toString()},
          ),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: ColorManager.donorCardAccent,
            fontSize: AppSize.s17,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSize.s20),
        _ProgressCard(card: card, next: next),
        const SizedBox(height: AppSize.s24),
        Wrap(
          spacing: AppSize.s8,
          runSpacing: AppSize.s8,
          alignment: WrapAlignment.center,
          children: card.levels
              .map(
                (level) => _LevelChip(level: level, active: level == current),
              )
              .toList(),
        ),
        const SizedBox(height: AppSize.s24),
        _MetricCard(
          label: AppStrings.totalDonations.tr(),
          value: card.totalDonations.toString(),
        ),
        const SizedBox(height: AppSize.s24),
        Text(
          AppStrings.earnedBadges.tr(),
          style: TextStyle(
            color: ColorManager.white,
            fontSize: AppSize.s18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSize.s12),
        if (card.badges.isEmpty)
          Text(
            AppStrings.notAvailable.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(color: ColorManager.lightGrey),
          )
        else
          Wrap(
            spacing: AppSize.s12,
            runSpacing: AppSize.s12,
            children: card.badges
                .map((badge) => _BadgeCard(badge: badge))
                .toList(),
          ),
        const SizedBox(height: AppSize.s24),
        ElevatedButton(
          onPressed: () {
            if (onInfo != null) {
              onInfo!();
              return;
            }
            Navigator.pushNamed(context, Routes.donorCardInfoRoute);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorManager.donorCardAccent,
          ),
          child: Text(AppStrings.whatIsDonorCard.tr()),
        ),
      ],
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final DonorCardEntity card;
  final DonorLevelEntity? next;

  const _ProgressCard({required this.card, required this.next});

  @override
  Widget build(BuildContext context) {
    final remaining = next == null
        ? AppSize.s0.toInt()
        : next!.minPoints - card.totalPoints;
    return Container(
      padding: const EdgeInsets.all(AppPadding.p20),
      decoration: BoxDecoration(
        color: ColorManager.white.withValues(alpha: AppOpacity.subtle),
        borderRadius: BorderRadius.circular(AppSize.radiusXLarge),
        border: Border.all(
          color: ColorManager.donorCardAccent.withValues(
            alpha: AppOpacity.muted,
          ),
        ),
      ),
      child: Column(
        children: [
          LinearProgressIndicator(
            value: card.levelProgress,
            minHeight: AppSize.s12,
            borderRadius: BorderRadius.circular(AppSize.radiusSmall),
            color: ColorManager.donorCardAccent,
            backgroundColor: ColorManager.white.withValues(
              alpha: AppOpacity.muted,
            ),
          ),
          const SizedBox(height: AppSize.s12),
          Text(
            next == null
                ? AppStrings.deserveReward.tr()
                : AppStrings.pointsForNextLevel.tr(
                    namedArgs: {LocalizationArgs.count: remaining.toString()},
                  ),
            style: TextStyle(color: ColorManager.lightGrey),
          ),
        ],
      ),
    );
  }
}

class _LevelChip extends StatelessWidget {
  final DonorLevelEntity level;
  final bool active;

  const _LevelChip({required this.level, required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.p12,
        vertical: AppPadding.p8,
      ),
      decoration: BoxDecoration(
        color: active
            ? ColorManager.donorCardAccent.withValues(alpha: AppOpacity.muted)
            : ColorManager.white.withValues(alpha: AppOpacity.subtle),
        borderRadius: BorderRadius.circular(AppSize.radiusXLarge),
        border: Border.all(
          color: active
              ? ColorManager.donorCardAccent
              : ColorManager.scaffoldBg,
        ),
      ),
      child: Text(
        level.nameAr,
        style: TextStyle(
          color: active ? ColorManager.white : ColorManager.lightGrey,
          fontWeight: active ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;

  const _MetricCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppPadding.p16),
      decoration: BoxDecoration(
        color: ColorManager.white.withValues(alpha: AppOpacity.subtle),
        borderRadius: BorderRadius.circular(AppSize.radiusXLarge),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: TextStyle(color: ColorManager.lightGrey)),
          ),
          Text(
            value,
            style: TextStyle(
              color: ColorManager.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgeCard extends StatelessWidget {
  final DonorBadgeEntity badge;

  const _BadgeCard({required this.badge});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppPadding.p12),
      decoration: BoxDecoration(
        color: ColorManager.white.withValues(alpha: AppOpacity.subtle),
        borderRadius: BorderRadius.circular(AppSize.radiusXLarge),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            ImageAssets.reward,
            height: AppSize.s48,
            errorBuilder: (context, error, stackTrace) =>
                Icon(Icons.emoji_events, color: ColorManager.donorCardAccent),
          ),
          const SizedBox(height: AppSize.s8),
          Text(
            badge.nameAr,
            style: TextStyle(
              color: ColorManager.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
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
          Text(message, style: TextStyle(color: ColorManager.white)),
          const SizedBox(height: AppSize.s12),
          ElevatedButton(
            onPressed: () {
              context.read<DonorCardBloc>().add(const DonorCardRequested());
            },
            child: Text(AppStrings.retryAgain.tr()),
          ),
        ],
      ),
    );
  }
}
