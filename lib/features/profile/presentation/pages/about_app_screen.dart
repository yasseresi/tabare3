import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/constants_manager.dart';
import '../../../../core/utils/font_manager.dart';
import '../../../../core/utils/string_manager.dart';
import '../../../../core/utils/styles_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../widgets/profile_field_editors.dart' show appTextDirection;
import '../widgets/profile_widgets.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: appTextDirection(context),
      child: Scaffold(
        backgroundColor: ColorManager.scaffoldBg,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: AppSize.s0,
          leading: BackButton(color: ColorManager.textPrimary),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: AppPadding.p32),
            child: Column(
              children: [
                const SizedBox(height: AppSize.s20),
                _buildLogoSection(),
                const SizedBox(height: AppSize.s20),
                _buildTitleBadge(),
                const SizedBox(height: AppSize.s12),
                _buildDescriptionCard(),
                const SizedBox(height: AppSize.s12),
                _buildDeveloperSection(),
                const SizedBox(height: AppSize.s40),
              ],
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppPadding.p30),
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.circular(AppSize.s46),
        ),
        child: Column(
          children: [
            for (var i = 0; i < paragraphs.length; i++) ...[
              if (i > 0) const SizedBox(height: AppSize.s15),
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
      ),
    );
  }

  Widget _buildDeveloperSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p10),
      child: Container(
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.circular(AppSize.s24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
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
      ),
    );
  }
}
