import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

import '../../utils/assets_manager.dart';
import '../../utils/color_manager.dart';
import '../../utils/constants_manager.dart';
import '../../utils/font_manager.dart';
import '../../utils/string_manager.dart';
import '../../utils/styles_manager.dart';
import '../../utils/values_manager.dart';
import 'app_card.dart';
import 'app_tag_pill.dart';

/// A single `label ……… value-chip` line inside a [HadithStatsCard].
class HadithStat {
  final String label;
  final String value;

  const HadithStat({required this.label, required this.value});
}

/// The profile card shared by the donor and recipient home screens: a status
/// pill, the hadith heading and body, an illustration, and a stack of stat
/// rows with pill-shaped values.
class HadithStatsCard extends StatelessWidget {
  final Widget statusPill;
  final String hadithBody;
  final List<HadithStat> stats;

  const HadithStatsCard({
    super.key,
    required this.statusPill,
    required this.hadithBody,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: AppSize.s200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    statusPill,
                    const SizedBox(height: AppSize.s10),
                    Text(
                      AppStrings.hadithIntro.tr(),
                      style: getSemiBoldStyle(
                        fontSize: FontSize.s24,
                        color: ColorManager.cardHeading,
                        lineHeight: LineHeight.h28,
                      ),
                    ),
                    const SizedBox(height: AppSize.s10),
                    Padding(
                      padding: const EdgeInsets.only(top: AppPadding.p4),
                      child: Text(
                        hadithBody,
                        maxLines: AppConstants.profileHadithMaxLines,
                        overflow: TextOverflow.ellipsis,
                        style: getMediumStyle(
                          fontSize: FontSize.s12,
                          color: ColorManager.textMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Image.asset(
                ImageAssets.hadithIllustration,
                width: AppSize.s130,
                height: AppSize.s130,
                fit: BoxFit.contain,
              ),
            ],
          ),
          for (final stat in stats) ...[
            const SizedBox(height: AppSize.s8),
            _StatRow(label: stat.label, value: stat.value),
          ],
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;

  const _StatRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            label,
            style: getRegularStyle(
              fontSize: FontSize.s14,
              color: ColorManager.black,
              lineHeight: LineHeight.h20,
            ),
          ),
        ),
        AppTagPill.value(label: value),
      ],
    );
  }
}
