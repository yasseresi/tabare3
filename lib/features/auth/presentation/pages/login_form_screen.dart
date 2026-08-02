import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/presentation/widgets/app_dialog.dart';
import '../../../../core/presentation/widgets/app_text_field.dart';
import '../../../../core/presentation/widgets/loading_overlay.dart';
import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/font_manager.dart';
import '../../../../core/utils/route_manager.dart';
import '../../../../core/utils/string_manager.dart';
import '../../../../core/utils/styles_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../../../../core/validators/validators.dart';
import '../../../../injection_container.dart';
import '../bloc/auth_bloc.dart';
import 'role_selection_screen.dart';

class LoginFormScreen extends StatefulWidget {
  const LoginFormScreen({super.key});

  @override
  State<LoginFormScreen> createState() => _LoginFormScreenState();
}

class _LoginFormScreenState extends State<LoginFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _dispatchLogin(AuthBloc bloc) {
    if (!_formKey.currentState!.validate()) return;
    bloc.add(
      LoginRequested(
        username: _usernameController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: _authListener,
        builder: (context, state) {
          return LoadingOverlay(
            visible: state is AuthLoading,
            message: AppStrings.loggingIn.tr(),
            child: Scaffold(
              body: Directionality(
                textDirection: TextDirection.rtl,
                child: SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppPadding.p32,
                      vertical: AppPadding.p100,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Image.asset(
                            ImageAssets.icon6,
                            width: AppSize.s76,
                            height: AppSize.s76,
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.bloodtype_outlined,
                              color: ColorManager.primary,
                              size: AppSize.s76,
                            ),
                          ),
                          const SizedBox(height: AppSize.s15),
                          Image.asset(
                            ImageAssets.demo1,
                            width: AppSize.s170,
                            height: AppSize.s169,
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.assignment_ind_outlined,
                              color: ColorManager.primary,
                              size: 120,
                            ),
                          ),
                          const SizedBox(height: AppSize.s15),
                          Text(
                            AppStrings.login.tr(),
                            style: TextStyle(
                              fontFamily: FontConstants.fontFamily,
                              fontSize: FontSize.s30,
                              fontWeight: FontWeightManager.bold,
                              color: ColorManager.black,
                            ),
                          ),
                          const SizedBox(height: AppSize.s30),
                          AppTextField(
                            hintText: AppStrings.username.tr(),
                            prefixSvg: SvgAssets.person,
                            controller: _usernameController,
                            keyboardType: TextInputType.text,
                            validator: validateUsername,
                          ),
                          const SizedBox(height: AppSize.s16),
                          AppTextField(
                            hintText: AppStrings.passwordMask.tr(),
                            prefixSvg: SvgAssets.password,
                            obscureSvg: SvgAssets.hidden,
                            isPassword: true,
                            controller: _passwordController,
                            validator: validatePassword,
                          ),
                          const SizedBox(height: AppSize.s30),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorManager.primary,
                              foregroundColor: ColorManager.white,
                              minimumSize: const Size(
                                AppSize.s220,
                                AppSize.s56,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppPadding.p50,
                                vertical: AppPadding.p18,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppSize.radiusButton,
                                ),
                              ),
                              textStyle: TextStyle(
                                fontFamily: FontConstants.fontFamily,
                                fontSize: FontSize.s19,
                                fontWeight: FontWeightManager.medium,
                                color: ColorManager.white,
                              ),
                            ),
                            onPressed: () =>
                                _dispatchLogin(context.read<AuthBloc>()),
                            child: Text(AppStrings.login.tr()),
                          ),
                          const SizedBox(height: AppSize.s5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${AppStrings.noAccount.tr()} ',
                                style: getRegularStyle(
                                  fontSize: FontSize.s12,
                                  color: ColorManager.textMuted,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  Routes.signupRoute,
                                ),
                                child: Text(
                                  AppStrings.signup.tr(),
                                  style: getBoldStyle(
                                    fontSize: FontSize.s12,
                                    color: ColorManager.primary,
                                  ),
                                ),
                              ),
                            ],
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

  void _authListener(BuildContext context, AuthState state) {
    if (state is Authenticated) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AppDialog.success(
          title: AppStrings.loginSuccess.tr(),
          actionLabel: AppStrings.homePage.tr(),
          onAction: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
              (route) => false,
            );
          },
        ),
      );
    } else if (state is AuthError) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => AppDialog.error(
          title: AppStrings.loginError.tr(),
          message: state.failure.message,
          actionLabel: AppStrings.retryAgain.tr(),
          onAction: () => Navigator.pop(context),
        ),
      );
    }
  }
}
