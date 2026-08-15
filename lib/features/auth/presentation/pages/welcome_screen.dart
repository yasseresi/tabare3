import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

import '../../../../core/presentation/widgets/app_gradient_background.dart';
import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/font_manager.dart';
import '../../../../core/utils/route_manager.dart';
import '../../../../core/utils/string_manager.dart';
import '../../../../core/utils/styles_manager.dart';
import '../../../../core/utils/values_manager.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppGradientBackground(
        child: SafeArea(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppPadding.p10),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      ImageAssets.demo,
                      width: AppSize.s260,
                      height: AppSize.s260,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.bloodtype_outlined,
                        color: ColorManager.primary,
                        size: AppSize.s160,
                      ),
                    ),
                    const SizedBox(height: AppSize.s12),
                    Text(
                      AppStrings.welcomeTo.tr(),
                      textAlign: TextAlign.center,
                      style: getMediumStyle(
                        fontSize: FontSize.s32,
                        color: ColorManager.welcomeText,
                      ),
                    ),
                    const SizedBox(height: AppSize.s5),
                    Image.asset(
                      ImageAssets.icon6,
                      width: AppSize.s76,
                      height: AppSize.s76,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.bloodtype_outlined,
                        color: ColorManager.primary,
                        size: AppSize.s76,
                      ),
                    ),
                    const SizedBox(height: AppSize.s12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorManager.primary,
                        foregroundColor: ColorManager.white,
                        elevation: AppSize.s0,
                        minimumSize: const Size(AppSize.s120, AppSize.s50),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppPadding.p50,
                          vertical: AppPadding.p18,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppSize.radiusButton,
                          ),
                        ),
                        textStyle: getMediumStyle(
                          fontSize: FontSize.s19,
                          color: ColorManager.white,
                          lineHeight: FontSize.s19,
                        ),
                      ),

                      onPressed: () {
                        Navigator.pushNamed(context, Routes.loginFormRoute);
                      },
                      child: Text(AppStrings.login.tr()),
                    ),
                    const SizedBox(height: AppSize.s12),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: ColorManager.white,
                        foregroundColor: ColorManager.signupText,
                        minimumSize: const Size(AppSize.s220, AppSize.s56),
                        side: BorderSide(
                          color: ColorManager.surface,
                          width: AppSize.s2,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppPadding.p52,
                          vertical: AppPadding.p20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppSize.radiusCircle,
                          ),
                        ),
                        textStyle: getSemiBoldStyle(
                          fontSize: FontSize.s19,
                          color: ColorManager.signupText,
                          lineHeight: FontSize.s19,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, Routes.signupRoute);
                      },
                      child: Text(AppStrings.signup.tr()),
                    ),
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
