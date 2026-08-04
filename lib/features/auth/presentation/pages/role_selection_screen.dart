import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/presentation/widgets/app_dialog.dart';
import '../../../../core/presentation/widgets/app_gradient_background.dart';
import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/font_manager.dart';
import '../../../../core/utils/route_manager.dart';
import '../../../../core/utils/string_manager.dart';
import '../../../../core/utils/styles_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../../../../injection_container.dart';
import '../bloc/auth_bloc.dart';

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
            Navigator.pushNamedAndRemoveUntil(
              context,
              isDonor ? Routes.donorHomeRoute : Routes.requesterHomeRoute,
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
              child: AppGradientBackground(
                child: LayoutBuilder(
                  builder: (context, constraints) => SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(AppPadding.p10),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: AppSize.s330,
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppPadding.p50,
                                horizontal: AppPadding.p20,
                              ),
                              decoration: BoxDecoration(
                                color: ColorManager.white,
                                borderRadius: BorderRadius.circular(
                                  AppSize.s46_6,
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    ImageAssets.icon6,
                                    height: AppSize.s120,
                                    width: AppSize.s120,
                                    errorBuilder: (_, __, ___) => Icon(
                                      Icons.bloodtype_outlined,
                                      size: AppSize.s80,
                                      color: ColorManager.primary,
                                    ),
                                  ),
                                  const SizedBox(height: AppPadding.p9_3),
                                  Text(
                                    AppStrings.hadithIntro.tr(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: FontConstants.fontFamily,
                                      fontSize: FontSize.s20,
                                      fontWeight: FontWeightManager.medium,
                                      color: ColorManager.grey,
                                    ),
                                  ),
                                  Text(
                                    AppStrings.hadithRelief.tr(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: FontConstants.fontFamily,
                                      fontSize: FontSize.s20,
                                      fontWeight: FontWeightManager.medium,
                                      color: ColorManager.grey,
                                      height: 1.6,
                                    ),
                                  ),
                                  const SizedBox(height: AppSize.s20),
                                  Text(
                                    AppStrings.areYou.tr(),
                                    textAlign: TextAlign.center,
                                    style: getBoldStyle(
                                      fontSize: FontSize.s32,
                                      color: ColorManager.black,
                                      lineHeight: LineHeight.h35,
                                    ),
                                  ),
                                  const SizedBox(height: AppPadding.p10),
                                  _RoleTabs(
                                    onNeedBlood: () =>
                                        _showConfirmationDialog(context),
                                    onDonor: () =>
                                        _selectRole(context, isDonor: true),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
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
      barrierColor: ColorManager.dialogScrim,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Dialog(
            backgroundColor: ColorManager.transparent,
            elevation: AppSize.s0,
            insetPadding: const EdgeInsets.symmetric(
              horizontal: AppPadding.p20,
            ),
            child: Container(
              width: AppSize.s320,
              padding: const EdgeInsets.all(AppSize.s40),
              decoration: BoxDecoration(
                color: ColorManager.white,
                borderRadius: BorderRadius.circular(AppSize.s40),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    SvgAssets.warning,
                    width: AppSize.s60,
                    height: AppSize.s60,
                  ),
                  const SizedBox(height: AppSize.s10),
                  Text(
                    AppStrings.confirmRoleUpdate.tr(),
                    textAlign: TextAlign.center,
                    style: getBoldStyle(
                      fontSize: FontSize.s16,
                      color: ColorManager.welcomeText,
                    ),
                  ),
                  const SizedBox(height: AppSize.s10),
                  Text(
                    AppStrings.roleSwitchWarning.tr(),
                    textAlign: TextAlign.center,
                    style: getBoldStyle(
                      fontSize: FontSize.s16,
                      color: ColorManager.welcomeText,
                    ),
                  ),
                  const SizedBox(height: AppSize.s10),
                  SizedBox(
                    width: AppSize.s174,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        _selectRole(context, isDonor: false, isRecipient: true);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSize.s11_6,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppSize.radiusDialogAction,
                          ),
                        ),
                      ),
                      child: Text(AppStrings.confirm.tr()),
                    ),
                  ),
                  const SizedBox(height: AppSize.s10),
                  SizedBox(
                    width: AppSize.s174,
                    child: TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      style: TextButton.styleFrom(
                        backgroundColor: ColorManager.welcomeText,
                        foregroundColor: ColorManager.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSize.s11_6,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppSize.radiusDialogAction,
                          ),
                        ),
                      ),
                      child: Text(
                        AppStrings.cancel.tr(),
                        style: getSemiBoldStyle(
                          fontSize: FontSize.s14,
                          color: ColorManager.white,
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

/// Figma `Tabs`: a white rounded container holding the two role buttons, with
/// the selected one raised on its own white card.
class _RoleTabs extends StatelessWidget {
  final VoidCallback onNeedBlood;
  final VoidCallback onDonor;

  const _RoleTabs({required this.onNeedBlood, required this.onDonor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppPadding.p10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppPadding.p4_8),
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.circular(AppSize.radiusTabs),
        ),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onNeedBlood,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.white,
                  foregroundColor: ColorManager.primary,
                  elevation: AppSize.s1,
                  shadowColor: ColorManager.black,
                  padding: const EdgeInsets.symmetric(
                    vertical: AppPadding.p9_6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSize.s9_6),
                  ),
                ),
                child: Text(
                  AppStrings.iNeedBlood.tr(),
                  style: getBoldStyle(
                    fontSize: FontSize.s19,
                    color: ColorManager.primary,
                    lineHeight: LineHeight.h24,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSize.s10),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: onDonor,
                style: TextButton.styleFrom(
                  foregroundColor: ColorManager.welcomeText,
                  padding: const EdgeInsets.symmetric(
                    vertical: AppPadding.p9_6,
                  ),
                ),
                child: Text(
                  AppStrings.iAmDonor.tr(),
                  style: getBoldStyle(
                    fontSize: FontSize.s19,
                    color: ColorManager.welcomeText,
                    lineHeight: LineHeight.h24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
