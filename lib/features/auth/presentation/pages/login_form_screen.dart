
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/widget_keys.dart';
import '../../../../core/presentation/widgets/app_dialog.dart';
import '../../../../core/presentation/widgets/app_gradient_background.dart';
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

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
              backgroundColor: ColorManager.transparent,
              body: Directionality(
                textDirection: TextDirection.rtl,
                child: AppGradientBackground(
                  child: SafeArea(
                    child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppPadding.p10,
                          vertical: AppPadding.p32,
                        ),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: AppSize.s402,
                          ),
                          child: Form(key: _formKey, child: _buildForm(context)),
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

  Widget _buildForm(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          ImageAssets.logo76,
          width: AppSize.s76,
          height: AppSize.s76,
          errorBuilder: (_, _, _) => Icon(
            Icons.bloodtype_outlined,
            color: ColorManager.primary,
            size: AppSize.s76,
          ),
        ),
        const SizedBox(height: AppSize.s12),
        Image.asset(
          ImageAssets.loginIllustration,
          width: AppSize.s170,
          height: AppSize.s169,
          errorBuilder: (_, _, _) => Icon(
            Icons.assignment_ind_outlined,
            color: ColorManager.primary,
            size: AppSize.s120,
          ),
        ),
        const SizedBox(height: AppSize.s12),
        Text(
          AppStrings.login.tr(),
          textAlign: TextAlign.center,
          style: getBoldStyle(
            fontSize: FontSize.s30,
            color: ColorManager.black,
          ),
        ),
        const SizedBox(height: AppSize.s12),
        Padding(
          key: WidgetKeys.loginContentArea,
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.p32),
          child: Column(
            children: [
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
              _LoginButton(
                onPressed: () => _dispatchLogin(context.read<AuthBloc>()),
              ),
              const SizedBox(height: AppSize.s5),
              const _SignupLink(),
            ],
          ),
        ),
      ],
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

class _LoginButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _LoginButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorManager.primary,
          foregroundColor: ColorManager.white,
          padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.p50,
            vertical: AppPadding.p18,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.radiusButton),
          ),
        ),
        child: Text(
          AppStrings.login.tr(),
          style: getMediumStyle(
            fontSize: FontSize.s19,
            color: ColorManager.white,
          ),
        ),
      ),
    );
  }
}

class _SignupLink extends StatelessWidget {
  const _SignupLink();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${AppStrings.noAccount.tr()} ',
          style: getRegularStyle(
            fontSize: FontSize.s12,
            color: ColorManager.textMuted,
            lineHeight: LineHeight.h16,
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, Routes.signupRoute),
          child: Text(
            AppStrings.signup.tr(),
            style: getBoldStyle(
              fontSize: FontSize.s12,
              color: ColorManager.primary,
              lineHeight: LineHeight.h16,
            ),
          ),
        ),
      ],
    );
  }
}
