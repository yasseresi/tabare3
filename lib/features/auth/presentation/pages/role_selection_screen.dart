import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/font_manager.dart';
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
                            'قال رسول الله ﷺ:',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.cairo(
                              fontSize: FontSize.s18,
                              fontWeight: FontWeightManager.bold,
                              color: ColorManager.textSecondary,
                            ),
                          ),
                          const SizedBox(height: AppSize.s10),
                          Text(
                            '«مَنْ نَفَّسَ عَنْ مُؤْمِنٍ كُرْبَةً مِنْ كُرَبِ الدُّنْيَا، نَفَّسَ اللهُ عَنْهُ كُرْبَةً مِنْ كُرَبِ يَوْمِ الْقِيَامَةِ»',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.cairo(
                              fontSize: FontSize.s14,
                              fontWeight: FontWeightManager.semiBold,
                              color: ColorManager.textSecondary,
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: AppSize.s24),
                          Text(
                            'هل انت',
                            style: getBoldStyle(
                              fontSize: FontSize.s20,
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
                              child: const Text('أحتاج دم'),
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
                              child: const Text(
                                'أنا متبرع',
                                style: TextStyle(
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
                    'تأكيد تحديث الحالة !',
                    textAlign: TextAlign.center,
                    style: getBoldStyle(
                      fontSize: FontSize.s20,
                      color: ColorManager.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSize.s15),
                  Text(
                    'عند تقديم طلب للحصول على الدم، سيتم إلغاء حالة "أنا متبرع" تلقائياً ولن تظهر ضمن قائمة المتبرعين النشطين، يمكنك إعادة تفعيلها لاحقاً بعد انتهاء طلبك.',
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
                      child: const Text('تأكيد'),
                    ),
                  ),
                  const SizedBox(height: AppSize.s10),
                  SizedBox(
                    width: 220,
                    height: 50,
                    child: TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: Text(
                        'إلغاء',
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
