import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/constants_manager.dart';
import '../../../../core/utils/font_manager.dart';
import '../../../../core/utils/string_manager.dart';
import '../../../../core/utils/styles_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../../domain/entities/donor_card_entity.dart';
import '../bloc/donor_card_bloc.dart';
import '../widgets/donor_card_theme.dart';

class DonorCardInfoScreen extends StatelessWidget {
  const DonorCardInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: DonorCardBackground(
        child: Material(
          type: MaterialType.transparency,
          child: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: AppSize.s402),
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppPadding.p10,
                    vertical: AppPadding.p20,
                  ),
                  children: const [
                    Center(child: _DonorCardBadgeChip()),
                    SizedBox(height: AppSize.s15),
                    _Mascot(),
                    SizedBox(height: AppSize.s15),
                    _ExplanationCard(),
                    SizedBox(height: AppSize.s15),
                    _PointRulesCard(),
                    SizedBox(height: AppSize.s15),
                    _LevelsCard(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Mascot extends StatelessWidget {
  const _Mascot();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        ImageAssets.donorMascot,
        width: AppSize.s150,
        height: AppSize.s164,
        fit: BoxFit.contain,
      ),
    );
  }
}

class _DonorCardBadgeChip extends StatelessWidget {
  const _DonorCardBadgeChip();

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

class _ExplanationCard extends StatelessWidget {
  const _ExplanationCard();

  @override
  Widget build(BuildContext context) {
    return DonorCardPanel(
      child: Column(
        children: [
          Text(
            AppStrings.whatIsDonorCard.tr(),
            textAlign: TextAlign.center,
            style: getBoldStyle(
              fontSize: FontSize.s16,
              color: ColorManager.donorCardAccent,
              lineHeight: LineHeight.h20,
            ),
          ),
          const SizedBox(height: AppSize.s16),
          Text(
            AppStrings.donorCardExplanation.tr(),
            textAlign: TextAlign.center,
            style: getSemiBoldStyle(
              fontSize: FontSize.s14,
              color: ColorManager.white,
              lineHeight: LineHeight.h20,
            ),
          ),
        ],
      ),
    );
  }
}

class _PointRulesCard extends StatelessWidget {
  const _PointRulesCard();

  @override
  Widget build(BuildContext context) {
    return DonorCardPanel(
      child: Column(
        children: [
          Text(
            AppStrings.howToEarnPoints.tr(),
            textAlign: TextAlign.center,
            style: getBoldStyle(
              fontSize: FontSize.s16,
              color: ColorManager.donorCardAccent,
              lineHeight: LineHeight.h20,
            ),
          ),
          const SizedBox(height: AppSize.s16),
          Wrap(
            spacing: AppSize.s10,
            runSpacing: AppSize.s10,
            alignment: WrapAlignment.center,
            children: const [
              _PointRuleChip(
                amount: AppConstants.pointsCancellation,
                labelKey: AppStrings.cancellationLabel,
              ),
              _PointRuleChip(
                amount: AppConstants.pointsKeptAppointment,
                labelKey: AppStrings.appointmentCommitment,
              ),
              _PointRuleChip(
                amount: AppConstants.pointsNormalDonation,
                labelKey: AppStrings.bloodDonation,
              ),
              _PointRuleChip(
                amount: AppConstants.pointsInactiveThreeMonths,
                labelKey: AppStrings.threeMonthsInactive,
              ),
              _PointRuleChip(
                amount: AppConstants.pointsUrgentDonation,
                labelKey: AppStrings.urgentDonation,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// `+8 التبرع بالدم` chip: the signed amount is green when it earns points and
/// red when it costs them.
class _PointRuleChip extends StatelessWidget {
  final int amount;
  final String labelKey;

  const _PointRuleChip({required this.amount, required this.labelKey});

  @override
  Widget build(BuildContext context) {
    final earns = amount > 0;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.p12,
        vertical: AppPadding.p6,
      ),
      decoration: BoxDecoration(
        color: ColorManager.surfaceLight,
        borderRadius: BorderRadius.circular(AppSize.radiusCircle),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            earns ? '+$amount' : '$amount',
            textAlign: TextAlign.center,
            style: getRegularStyle(
              fontSize: FontSize.s12,
              color: earns
                  ? ColorManager.success
                  : ColorManager.urgencyCritical,
              lineHeight: LineHeight.h16,
            ),
          ),
          const SizedBox(width: AppSize.s5),
          Text(
            labelKey.tr(),
            textAlign: TextAlign.center,
            style: getRegularStyle(
              fontSize: FontSize.s12,
              color: ColorManager.donorCardChipLabel,
              lineHeight: LineHeight.h16,
            ),
          ),
        ],
      ),
    );
  }
}

class _LevelsCard extends StatelessWidget {
  const _LevelsCard();

  @override
  Widget build(BuildContext context) {
    return DonorCardPanel(
      child: BlocBuilder<DonorCardBloc, DonorCardState>(
        builder: (context, state) {
          Widget body;
          if (state is DonorCardInitial || state is DonorCardLoading) {
            body = Center(
              child: CircularProgressIndicator(
                color: ColorManager.donorCardAccent,
              ),
            );
          } else if (state is DonorCardError) {
            body = Text(
              state.failure.message,
              style: getMediumStyle(
                fontSize: FontSize.s14,
                color: ColorManager.white,
              ),
            );
          } else {
            final levels = (state as DonorCardLoaded).card.levels;
            body = Column(
              children: [
                for (var index = 0; index < levels.length; index++) ...[
                  if (index > 0) const SizedBox(height: AppSize.s16),
                  _LevelRow(
                    level: levels[index],
                    next: index + 1 < levels.length ? levels[index + 1] : null,
                  ),
                ],
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppStrings.levels.tr(),
                style: getBoldStyle(
                  fontSize: FontSize.s16,
                  color: ColorManager.white,
                  lineHeight: LineHeight.h24,
                ),
              ),
              const SizedBox(height: AppSize.s16),
              body,
            ],
          );
        },
      ),
    );
  }
}

/// `● قطرة امل ……… 0-10` row. The last level has no upper bound, so it renders
/// as `+120`.
class _LevelRow extends StatelessWidget {
  final DonorLevelEntity level;
  final DonorLevelEntity? next;

  const _LevelRow({required this.level, required this.next});

  @override
  Widget build(BuildContext context) {
    final range = next == null
        ? '+${level.minPoints}'
        : '${level.minPoints}-${next!.minPoints}';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: AppSize.s8,
                height: AppSize.s8,
                decoration: BoxDecoration(
                  color: ColorManager.donorCardLevelDot,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppSize.s10),
              Flexible(
                child: Text(
                  level.nameAr,
                  style: getMediumStyle(
                    fontSize: FontSize.s14,
                    color: ColorManager.white,
                    lineHeight: LineHeight.h14,
                  ),
                ),
              ),
            ],
          ),
        ),
        Text(
          range,
          style: getMediumStyle(
            fontSize: FontSize.s14,
            color: ColorManager.donorCardAccent,
            lineHeight: LineHeight.h14,
          ),
        ),
      ],
    );
  }
}
