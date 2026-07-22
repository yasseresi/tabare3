import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/presentation/widgets/app_dialog.dart';
import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/font_manager.dart';
import '../../../../core/utils/string_manager.dart';
import '../../../../core/utils/styles_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../../../../injection_container.dart';
import '../bloc/auth_bloc.dart';
import '../../../donor_home/presentation/pages/donor_home_screen.dart';
import '../../../requester_home/presentation/pages/requester_home_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is RoleUpdated) {
            final isDonor = state.user.isDonor;
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => isDonor
                    ? const DonorHomeScreen()
                    : const RequesterHomeScreen(),
              ),
              (route) => false,
            );
          } else if (state is AuthError) {
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (_) => AppDialog.error(
                title: AppStrings.roleUpdateError.tr(),
                message: state.failure.message,
                actionLabel: AppStrings.retryAgain.tr(),
                onAction: () => Navigator.pop(context),
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppPadding.p20,
                    vertical: AppPadding.p20,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppPadding.p24,
                      horizontal: AppPadding.p20,
                    ),
                    decoration: BoxDecoration(
                      color: ColorManager.surface,
                      borderRadius: BorderRadius.circular(AppSize.s40),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            ImageAssets.icon6,
                            height: AppSize.s80,
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.bloodtype_outlined,
                              size: AppSize.s80,
                              color: ColorManager.primary,
                            ),
                          ),
                          const SizedBox(height: AppSize.s20),
                      Text(
                        AppStrings.hadithIntro.tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: FontConstants.fontFamily,
                          fontSize: FontSize.s18,
                          fontWeight: FontWeightManager.bold,
                          color: ColorManager.textSecondary,
                        ),
                      ),
                          const SizedBox(height: AppSize.s10),
                          Text(
                            '«${AppStrings.hadithRelief.tr()}»',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: FontConstants.fontFamily,
                              fontSize: FontSize.s14,
                              fontWeight: FontWeightManager.semiBold,
                              color: ColorManager.textSecondary,
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: AppSize.s24),
                      Text(
                        AppStrings.areYou.tr(),
                        style: TextStyle(
                          fontFamily: FontConstants.fontFamily,
                          fontSize: FontSize.s20,
                          fontWeight: FontWeightManager.bold,
                          color: ColorManager.textPrimary,
                        ),
                      ),
                          const SizedBox(height: AppSize.s24),
                          SizedBox(
                            width: 220,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: () => _showConfirmationDialog(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorManager.white,
                                foregroundColor: ColorManager.primary,
                                elevation: AppSize.s2,
                                shadowColor: Colors.black26,
                              ),
                              child: Text(AppStrings.iNeedBlood.tr()),
                            ),
                          ),
                          const SizedBox(height: AppSize.s15),
                          SizedBox(
                            width: 220,
                            height: 55,
                            child: TextButton(
                              onPressed: () =>
                                  _selectRole(context, isDonor: true),
                              style: TextButton.styleFrom(
                                foregroundColor: ColorManager.textSecondary,
                              ),
                              child: Text(
                                AppStrings.iAmDonor.tr(),
                                style: const TextStyle(
                                  fontFamily: FontConstants.fontFamily,
                                  fontSize: FontSize.s18,
                                  fontWeight: FontWeightManager.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Dialog(
            child: Padding(
              padding: const EdgeInsets.all(AppPadding.p24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.warning_rounded,
                    color: Colors.red,
                    size: AppSize.s80,
                  ),
                  const SizedBox(height: AppSize.s20),
                  Text(
                    AppStrings.confirmRoleUpdate.tr(),
                    textAlign: TextAlign.center,
                    style: getBoldStyle(
                      fontSize: FontSize.s20,
                      color: ColorManager.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSize.s15),
                  Text(
                    AppStrings.roleSwitchWarning.tr(),
                    textAlign: TextAlign.center,
                    style: getBoldStyle(
                      fontSize: FontSize.s16,
                      color: ColorManager.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSize.s30),
                  SizedBox(
                    width: 220,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        _selectRole(context, isDonor: false, isRecipient: true);
                      },
                      child: Text(AppStrings.confirm.tr()),
                    ),
                  ),
                  const SizedBox(height: AppSize.s10),
                  SizedBox(
                    width: 220,
                    height: 50,
                    child: TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: Text(
                        AppStrings.cancel.tr(),
                        style: getSemiBoldStyle(
                          fontSize: FontSize.s16,
                          color: ColorManager.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _selectRole(
    BuildContext context, {
    required bool isDonor,
    bool isRecipient = false,
  }) {
    context.read<AuthBloc>().add(
      UpdateRoleRequested(isDonor: isDonor, isRecipient: isRecipient),
    );
  }
}
