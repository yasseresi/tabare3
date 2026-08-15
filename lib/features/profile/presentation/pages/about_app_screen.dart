import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

import '../../../../core/presentation/widgets/app_gradient_background.dart';
import '../../../../core/presentation/widgets/app_header.dart';
import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/constants_manager.dart';
import '../../../../core/utils/font_manager.dart';
import '../../../../core/utils/string_manager.dart';
import '../../../../core/utils/greeting.dart';
import '../../../../core/utils/styles_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../widgets/profile_widgets.dart';

/// Figma `معلومات التطبيق` (node 135:547): logo + version, a pill title badge,
/// the about paragraphs card and the developer-contact card.
class AboutAppScreen extends StatelessWidget {
  final VoidCallback? onBack;

  const AboutAppScreen({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorManager.transparent,
        body: AppGradientBackground(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: AppSize.s402),
              child: ListView(
                padding: const EdgeInsets.only(bottom: AppPadding.p100),
                children: [
                  if (onBack == null)
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: BackButton(color: ColorManager.textPrimary),
                    ),
                  AppHeader(
                    title: welcomeTitle(),
                    subtitle: AppStrings.donationLifeChance.tr(),
                  ),
                  // Figma floats the header and starts the content at y=150;
                  // the inline header measures 128.
                  const SizedBox(height: AppSize.s22),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppPadding.p10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildLogoSection(),
                        const SizedBox(height: AppSize.s20),
                        Center(child: _buildTitleBadge()),
                        const SizedBox(height: AppSize.s12),
                        _buildDescriptionCard(),
                        const SizedBox(height: AppSize.s12),
                        _buildDeveloperSection(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Column(
      children: [
        Image.asset(
          ImageAssets.logo,
          width: AppSize.s76,
          height: AppSize.s76,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Icon(
            Icons.water_drop,
            size: AppSize.s76,
            color: ColorManager.primaryDark,
          ),
        ),
        Text(
          AppStrings.versionNumber.tr(
            namedArgs: {'version': AppConstants.appVersion},
          ),
          style: getRegularStyle(
            fontSize: FontSize.s14,
            color: ColorManager.textSecondary,
            lineHeight: LineHeight.h20,
          ),
        ),
      ],
    );
  }

  Widget _buildTitleBadge() {
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
      child: Text(
        AppStrings.appInfo.tr(),
        style: getSemiBoldStyle(
          fontSize: FontSize.s14,
          color: ColorManager.black,
          lineHeight: LineHeight.h20,
        ),
      ),
    );
  }

  Widget _buildDescriptionCard() {
    final paragraphs = [
      AppStrings.aboutAppParagraph1.tr(),
      AppStrings.aboutAppParagraph2.tr(),
      AppStrings.aboutAppParagraph3.tr(),
    ];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppPadding.p30),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(AppSize.radiusAboutCard),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < paragraphs.length; i++) ...[
            if (i > 0) const SizedBox(height: AppSize.s15),
            Text(
              paragraphs[i],
              textAlign: TextAlign.center,
              style: getSemiBoldStyle(
                fontSize: FontSize.s14,
                color: ColorManager.black,
                lineHeight: LineHeight.h20,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDeveloperSection() {
    return ProfileSection(
      children: [
        ProfileRow(
          label: AppStrings.developerContact.tr(),
          value: AppStrings.developerContactDescription.tr(),
          icon: SvgAssets.profileDeveloper,
          stackValue: true,
          centerStackedValue: true,
        ),
        ProfileRow(
          label: AppStrings.phoneNumberLabel.tr(),
          value: AppConstants.developerPhone,
          icon: SvgAssets.profilePhone,
        ),
        ProfileRow(
          label: AppStrings.email.tr(),
          value: AppConstants.developerEmail,
          icon: SvgAssets.profileEmail,
        ),
      ],
    );
  }
}
