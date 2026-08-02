import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/constants_manager.dart';
import '../../../../core/utils/font_manager.dart';
import '../../../../core/utils/string_manager.dart';
import '../../../../core/utils/styles_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../widgets/profile_widgets.dart';

class AboutAppScreen extends StatelessWidget {
  final VoidCallback? onBack;

  const AboutAppScreen({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorManager.transparent,
        body: Container(
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
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: AppSize.s402),
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppPadding.p10,
                    vertical: AppPadding.p32,
                  ),
                  children: [
                    if (onBack == null)
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: BackButton(color: ColorManager.textPrimary),
                      ),
                    const _AboutHeader(),
                    const SizedBox(height: AppSize.s20),
                    _buildLogoSection(),
                    const SizedBox(height: AppSize.s20),
                    Center(child: _buildTitleBadge()),
                    const SizedBox(height: AppSize.s12),
                    _buildDescriptionCard(),
                    const SizedBox(height: AppSize.s12),
                    _buildDeveloperSection(),
                    const SizedBox(height: AppSize.s100),
                  ],
                ),
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
          errorBuilder: (_, __, ___) => Icon(
            Icons.water_drop,
            size: AppSize.s76,
            color: ColorManager.primaryDark,
          ),
        ),
        const SizedBox(height: AppSize.s4),
        Text(
          AppStrings.versionNumber.tr(
            namedArgs: {'version': AppConstants.appVersion},
          ),
          style: getRegularStyle(
            fontSize: FontSize.s14,
            color: ColorManager.textSecondary,
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
        border: Border.all(color: ColorManager.borderGrey),
      ),
      child: Text(
        AppStrings.appInfo.tr(),
        style: getSemiBoldStyle(
          fontSize: FontSize.s14,
          color: ColorManager.textPrimary,
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
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.p30,
        vertical: AppPadding.p30,
      ),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(AppSize.s46),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < paragraphs.length; i++) ...[
            if (i > 0) const SizedBox(height: AppSize.s10),
            Text(
              paragraphs[i],
              textAlign: TextAlign.center,
              style: getSemiBoldStyle(
                fontSize: FontSize.s14,
                color: ColorManager.textPrimary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDeveloperSection() {
    return Container(
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(AppSize.s24),
        boxShadow: [
          BoxShadow(
            color: ColorManager.black.withValues(alpha: AppOpacity.subtle),
            blurRadius: AppSize.s20,
            offset: const Offset(0, AppSize.s4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ProfileRow(
            label: AppStrings.developerContact.tr(),
            value: AppStrings.developerContactDescription.tr(),
            iconData: Icons.code,
          ),
          Divider(
            height: AppSize.s1,
            color: ColorManager.dividerGrey,
            indent: AppPadding.p20,
            endIndent: AppPadding.p20,
          ),
          ProfileRow(
            label: AppStrings.phoneNumberLabel.tr(),
            value: AppConstants.developerPhone,
            iconData: Icons.phone_outlined,
          ),
          Divider(
            height: AppSize.s1,
            color: ColorManager.dividerGrey,
            indent: AppPadding.p20,
            endIndent: AppPadding.p20,
          ),
          ProfileRow(
            label: AppStrings.email.tr(),
            value: AppConstants.developerEmail,
            iconData: Icons.email_outlined,
          ),
        ],
      ),
    );
  }
}

class _AboutHeader extends StatelessWidget {
  const _AboutHeader();

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
                  fontSize: AppSize.s18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                AppStrings.donationLifeChance.tr(),
                style: TextStyle(
                  color: ColorManager.textMuted,
                  fontSize: AppSize.s14,
                  fontWeight: FontWeight.w600,
                ),
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
          child: const Icon(
            Icons.notifications_none_rounded,
            size: AppSize.s24,
          ),
        ),
      ],
    );
  }
}
