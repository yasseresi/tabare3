import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/font_manager.dart';
import '../../../../core/utils/string_manager.dart';
import '../../../../core/utils/styles_manager.dart';
import '../../../../core/utils/values_manager.dart';
import 'login_form_screen.dart';
import 'signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    ImageAssets.demo,
                    width: AppSize.s250,
                    height: AppSize.s250,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.bloodtype_outlined,
                      color: ColorManager.primary,
                      size: AppSize.s160,
                    ),
                  ),
                  const SizedBox(height: AppSize.s10),
                  Text(
                    AppStrings.welcomeTo.tr(),
                    style: getMediumStyle(
                      fontSize: FontSize.s32,
                      color: const Color(0xff5A5A5A),
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
                  const SizedBox(height: AppSize.s48),
                  SizedBox(
                    width: 215,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorManager.primary,
                        foregroundColor: ColorManager.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppPadding.p20,
                          vertical: AppPadding.p18,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSize.s20),
                        ),
                        textStyle: getMediumStyle(
                          fontSize: FontSize.s18,
                          color: ColorManager.white,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginFormScreen(),
                          ),
                        );
                      },
                      child: Text(AppStrings.login.tr()),
                    ),
                  ),
                  const SizedBox(height: AppSize.s20),
                  SizedBox(
                    width: 224,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: ColorManager.white,
                        foregroundColor: ColorManager.primaryDark,
                        side: BorderSide(
                          color: ColorManager.surface,
                          width: AppSize.s2,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppPadding.p20,
                          vertical: AppPadding.p20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppSize.radiusCircle,
                          ),
                        ),
                        textStyle: getSemiBoldStyle(
                          fontSize: FontSize.s18,
                          color: ColorManager.primaryDark,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ),
                        );
                      },
                      child: Text(AppStrings.signup.tr()),
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
}
