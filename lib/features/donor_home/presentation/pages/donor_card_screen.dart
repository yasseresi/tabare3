import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/constants_manager.dart';
import '../../../../core/utils/font_manager.dart';
import '../../../../core/utils/route_manager.dart';
import '../../../../core/utils/string_manager.dart';
import '../../../../core/utils/styles_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../../domain/entities/donor_card_entity.dart';
import '../bloc/donor_card_bloc.dart';
import '../widgets/donor_card_theme.dart';

class DonorCardScreen extends StatelessWidget {
  final VoidCallback? onInfo;

  const DonorCardScreen({super.key, this.onInfo});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: DonorCardBackground(
        child: Material(
          type: MaterialType.transparency,
          child: SafeArea(
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
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSize.s402),
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.p10,
            vertical: AppPadding.p20,
          ),
          children: [
            const Center(child: _DonorCardBadgeButton()),
            const SizedBox(height: AppSize.s15),
            Center(
              child: Image.asset(
                ImageAssets.donorMascot,
                width: AppSize.s150,
                height: AppSize.s164,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: AppSize.s15),
            Wrap(
              spacing: AppSize.s10,
              runSpacing: AppSize.s10,
              alignment: WrapAlignment.center,
              children: [
                for (final level in card.levels)
                  DonorLevelChip(
                    label: level.nameAr,
                    active: level == current,
                  ),
              ],
            ),
            const SizedBox(height: AppSize.s15),
            _LevelProgressCard(card: card),
            const SizedBox(height: AppSize.s15),
            Text(
              AppStrings.earnedBadges.tr(),
              textAlign: TextAlign.center,
              style: getSemiBoldStyle(
                fontSize: FontSize.s16,
                color: ColorManager.white,
                lineHeight: LineHeight.h28,
              ),
            ),
            const SizedBox(height: AppSize.s15),
            if (card.badges.isEmpty)
              Text(
                AppStrings.notAvailable.tr(),
                textAlign: TextAlign.center,
                style: getMediumStyle(
                  fontSize: FontSize.s14,
                  color: ColorManager.lightGrey,
                ),
              )
            else
              Wrap(
                spacing: AppSize.s20,
                runSpacing: AppSize.s20,
                alignment: WrapAlignment.center,
                children: [
                  for (final badge in card.badges) _BadgeTile(badge: badge),
                ],
              ),
            const SizedBox(height: AppSize.s15),
            Center(
              child: DonorCardButton(
                label: AppStrings.whatIsDonorCard.tr(),
                onPressed: () {
                  if (onInfo != null) {
                    onInfo!();
                    return;
                  }
                  Navigator.pushNamed(context, Routes.donorCardInfoRoute);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// White `بطاقة المتبرع` chip with the gift-card glyph, sitting above the
/// mascot.
class _DonorCardBadgeButton extends StatelessWidget {
  const _DonorCardBadgeButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.p17,
        vertical: AppPadding.p7,
      ),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(AppSize.radiusCircle),
        border: Border.all(color: ColorManager.donorCardChipBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppStrings.donorCard.tr(),
            style: getSemiBoldStyle(
              fontSize: FontSize.s14,
              color: ColorManager.black,
              lineHeight: LineHeight.h20,
            ),
          ),
          const SizedBox(width: AppSize.s8),
          SvgPicture.asset(
            SvgAssets.giftCard,
            width: AppSize.s20,
            height: AppSize.s20,
          ),
        ],
      ),
    );
  }
}

class _LevelProgressCard extends StatelessWidget {
  final DonorCardEntity card;

  const _LevelProgressCard({required this.card});

  @override
  Widget build(BuildContext context) {
    final current = card.currentLevel;
    final next = card.nextLevel;
    final remaining = next == null ? 0 : next.minPoints - card.totalPoints;
    return DonorCardPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  current?.nameAr ?? AppStrings.notAvailable.tr(),
                  style: getSemiBoldStyle(
                    fontSize: FontSize.s24,
                    color: ColorManager.white,
                    lineHeight: LineHeight.h28,
                  ),
                ),
              ),
              const SizedBox(width: AppSize.s10),
              DonorPointsChip(
                label: AppStrings.pointsCount.tr(
                  namedArgs: {
                    LocalizationArgs.count: card.totalPoints.toString(),
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSize.s20),
          Text(
            AppStrings.levelProgressDescription.tr(),
            style: getMediumStyle(
              fontSize: FontSize.s12,
              color: ColorManager.white,
            ),
          ),
          const SizedBox(height: AppSize.s16),
          DonorLevelProgressBar(value: card.levelProgress),
          const SizedBox(height: AppSize.s16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.pointsCount.tr(
                  namedArgs: {
                    LocalizationArgs.count: (current?.minPoints ?? 0).toString(),
                  },
                ),
                style: _boundaryStyle,
              ),
              Flexible(
                child: Text(
                  next == null
                      ? AppStrings.deserveReward.tr()
                      : AppStrings.pointsForNextLevel.tr(
                          namedArgs: {
                            LocalizationArgs.count: remaining.toString(),
                          },
                        ),
                  textAlign: TextAlign.center,
                  style: getMediumStyle(
                    fontSize: FontSize.s14,
                    color: ColorManager.donorCardAccent,
                    lineHeight: LineHeight.h14,
                  ),
                ),
              ),
              Text(
                AppStrings.pointsCount.tr(
                  namedArgs: {
                    LocalizationArgs.count: (next?.minPoints ?? card.totalPoints)
                        .toString(),
                  },
                ),
                style: _boundaryStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }

  TextStyle get _boundaryStyle => getMediumStyle(
    fontSize: FontSize.s14,
    color: ColorManager.white,
    lineHeight: LineHeight.h14,
  );
}

class _BadgeTile extends StatelessWidget {
  final DonorBadgeEntity badge;

  const _BadgeTile({required this.badge});

  @override
  Widget build(BuildContext context) {
    return DonorCardPanel(
      width: AppSize.s181,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (badge.threshold != null)
            DonorPointsChip(
              label: AppStrings.pointsCount.tr(
                namedArgs: {
                  LocalizationArgs.count: badge.threshold!.toString(),
                },
              ),
            ),
          const SizedBox(height: AppSize.s10),
          Image.asset(
            ImageAssets.badgeTrophy,
            width: AppSize.s80,
            height: AppSize.s80,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: AppSize.s10),
          Text(
            badge.nameAr,
            textAlign: TextAlign.center,
            style: getSemiBoldStyle(
              fontSize: FontSize.s20,
              color: ColorManager.white,
              lineHeight: LineHeight.h28,
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
