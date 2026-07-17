import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/presentation/widgets/app_dialog.dart';
import '../../../../core/presentation/widgets/app_text_field.dart';
import '../../../../core/presentation/widgets/loading_overlay.dart';
import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/font_manager.dart';
import '../../../../core/utils/styles_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../../../../core/validators/validators.dart';
import '../../../../injection_container.dart';
import '../bloc/auth_bloc.dart';
import 'role_selection_screen.dart';
import 'signup_screen.dart';

class LoginFormScreen extends StatefulWidget {
  const LoginFormScreen({super.key});

  @override
  State<LoginFormScreen> createState() => _LoginFormScreenState();
}

class _LoginFormScreenState extends State<LoginFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

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
            message: 'جاري تسجيل الدخول',
            child: Scaffold(
              backgroundColor: ColorManager.white,
              body: Directionality(
                textDirection: TextDirection.rtl,
                child: SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppPadding.p20,
                      vertical: AppPadding.p60,
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
                            width: 170,
                            height: 169,
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.assignment_ind_outlined,
                              color: ColorManager.primary,
                              size: 120,
                            ),
                          ),
                          const SizedBox(height: AppSize.s15),
                          Text(
                            'تسجيل الدخول',
                            style: getBoldStyle(
                              fontSize: FontSize.s30,
                              color: ColorManager.black,
                            ),
                          ),
                          const SizedBox(height: AppSize.s30),
                          AppTextField(
                            hintText: 'اسم المستخدم',
                            prefixIcon: Icons.person_outline,
                            controller: _usernameController,
                            keyboardType: TextInputType.text,
                            validator: validateUsername,
                          ),
                          const SizedBox(height: AppSize.s16),
                          AppTextField(
                            hintText: '............',
                            prefixIcon: Icons.lock_outline,
                            isPassword: true,
                            controller: _passwordController,
                            validator: validatePassword,
                          ),
                          const SizedBox(height: AppSize.s24),
                          Row(
                            children: [
                              Text(
                                'تذكرني في المرة القادمة',
                                style: getRegularStyle(
                                  fontSize: FontSize.s12,
                                  color: ColorManager.textMuted,
                                ),
                              ),
                              const Spacer(),
                              Transform.scale(
                                scale: 0.8,
                                child: Switch(
                                  value: _rememberMe,
                                  onChanged: (v) =>
                                      setState(() => _rememberMe = v),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSize.s30),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorManager.primary,
                                foregroundColor: ColorManager.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppPadding.p20,
                                  vertical: AppPadding.p18,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(AppSize.s20),
                                ),
                                textStyle: getMediumStyle(
                                  fontSize: FontSize.s18,
                                  color: ColorManager.white,
                                ),
                              ),
                              onPressed: () =>
                                  _dispatchLogin(context.read<AuthBloc>()),
                              child: const Text('تسجيل الدخول'),
                            ),
                          ),
                          const SizedBox(height: AppSize.s5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'ليس لديك حساب؟ ',
                                style: getRegularStyle(
                                  fontSize: FontSize.s12,
                                  color: ColorManager.textMuted,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const SignUpScreen(),
                                  ),
                                ),
                                child: Text(
                                  'إنشاء حساب',
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
          title: 'لقد سجلت الدخول بنجاح إلى تطبيق',
          actionLabel: 'الصفحة الرئيسية',
          onAction: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => const RoleSelectionScreen(),
              ),
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
          title: 'خطأ في تسجيل الدخول',
          message: state.failure.message,
          actionLabel: 'إعادة المحاولة',
          onAction: () => Navigator.pop(context),
        ),
      );
    }
  }
}
