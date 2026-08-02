import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/presentation/widgets/app_dialog.dart';
import '../../../../core/presentation/widgets/app_text_field.dart';
import '../../../../core/presentation/widgets/loading_overlay.dart';
import '../../../../core/presentation/widgets/searchable_wilaya_field.dart';
import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/font_manager.dart';
import '../../../../core/utils/string_manager.dart';
import '../../../../core/utils/styles_manager.dart';
import '../../../../core/validators/validators.dart';
import '../../domain/repositories/auth_repository.dart';
import '../bloc/auth_bloc.dart';
import 'login_form_screen.dart';
import 'role_selection_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 1;
  bool _agreeToTerms = false;
  DateTime? _selectedDate;
  String _genderValue = 'male';

  final _usernameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _dobController = TextEditingController();
  final _nationalIdController = TextEditingController();
  final _bloodTypeController = TextEditingController();
  final _weightController = TextEditingController();
  final _cityController = TextEditingController();
  final _chronicDiseasesController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    _dobController.dispose();
    _nationalIdController.dispose();
    _bloodTypeController.dispose();
    _weightController.dispose();
    _cityController.dispose();
    _chronicDiseasesController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (!_formKey.currentState!.validate()) return;
    if (_currentStep < 3) {
      setState(() => _currentStep++);
    } else {
      if (!_agreeToTerms) return;
      _dispatchSignup();
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2000),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
      locale: const Locale('ar'),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dobController.text =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  void _dispatchSignup() {
    if (!_formKey.currentState!.validate()) return;
    final params = SignupParams(
      username: _usernameController.text.trim(),
      fullName: _fullNameController.text.trim(),
      password: _passwordController.text,
      phone: _phoneController.text.trim(),
      dateOfBirth: _selectedDate ?? DateTime(2000),
      gender: _genderValue,
      bloodType: _bloodTypeController.text.trim(),
      city: _cityController.text.trim(),
      nationalId: _nationalIdController.text.trim().isEmpty
          ? null
          : _nationalIdController.text.trim(),
      weight: double.tryParse(_weightController.text.trim()),
      chronicDiseases: _chronicDiseasesController.text.trim().isEmpty
          ? null
          : _chronicDiseasesController.text.trim(),
    );
    context.read<AuthBloc>().add(SignupRequested(params));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: _authListener,
      builder: (context, state) {
        return LoadingOverlay(
          visible: state is AuthLoading,
          message: AppStrings.signingUp.tr(),
          child: Scaffold(
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
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
                          const SizedBox(height: AppSize.s10),
                          Text(
                            AppStrings.signup.tr(),
                            style: getBoldStyle(
                              fontSize: FontSize.s30,
                              color: ColorManager.textPrimary,
                            ),
                          ),
                          const SizedBox(height: AppSize.s5),
                          Text(
                            _getStepTitle(),
                            style: getRegularStyle(
                              fontSize: FontSize.s14,
                              color: ColorManager.textSecondary,
                            ),
                          ),
                          const SizedBox(height: AppSize.s20),
                          _buildStepIndicator(),
                          const SizedBox(height: AppSize.s20),
                          _buildCurrentStepView(),
                          const SizedBox(height: AppSize.s20),
                          ElevatedButton(
                            onPressed: (_currentStep == 3 && !_agreeToTerms)
                                ? null
                                : _nextStep,
                            child: Text(
                              _currentStep == 3
                                  ? AppStrings.signup.tr()
                                  : AppStrings.next.tr(),
                            ),
                          ),
                          if (_currentStep == 1) ...[
                            const SizedBox(height: AppSize.s20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${AppStrings.hasAccount.tr()} ',
                                  style: getRegularStyle(
                                    fontSize: FontSize.s12,
                                    color: ColorManager.textMuted,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const LoginFormScreen(),
                                    ),
                                  ),
                                  child: Text(
                                    AppStrings.login.tr(),
                                    style: getBoldStyle(
                                      fontSize: FontSize.s12,
                                      color: ColorManager.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          const SizedBox(height: AppSize.s20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case 1:
        return AppStrings.accountInfo.tr();
      case 2:
        return AppStrings.personalInfo.tr();
      case 3:
        return AppStrings.termsAndConditions.tr();
      default:
        return '';
    }
  }

  Widget _buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildCircle(1),
        _buildLine(),
        _buildCircle(2),
        _buildLine(),
        _buildCircle(3),
      ],
    );
  }

  Widget _buildCircle(int step) {
    final isCurrent = _currentStep == step;
    return Container(
      width: AppSize.s35,
      height: AppSize.s35,
      decoration: BoxDecoration(
        color: isCurrent ? ColorManager.primary : ColorManager.dividerGrey,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '$step',
          style: TextStyle(
            fontFamily: FontConstants.fontFamily,
            color: isCurrent ? ColorManager.white : ColorManager.textMuted,
            fontWeight: FontWeightManager.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildLine() {
    return Container(
      width: AppSize.s40,
      height: AppSize.s2,
      color: ColorManager.dividerGrey,
    );
  }

  Widget _buildSvgPrefixIcon(String assetPath) {
    return Padding(
      padding: const EdgeInsets.all(AppPadding.p14),
      child: SvgPicture.asset(
        assetPath,
        width: AppSize.s20,
        height: AppSize.s20,
      ),
    );
  }

  Widget _buildCurrentStepView() {
    switch (_currentStep) {
      case 1:
        return _buildStep1();
      case 2:
        return _buildStep2();
      case 3:
        return _buildStep3();
      default:
        return Container();
    }
  }

  Widget _buildStep1() {
    return Column(
      children: [
        AppTextField(
          hintText: AppStrings.fullName.tr(),
          prefixSvg: SvgAssets.person,
          controller: _fullNameController,
          validator: validateFullName,
        ),
        const SizedBox(height: AppSize.s15),
        AppTextField(
          hintText: AppStrings.username.tr(),
          prefixSvg: SvgAssets.person,
          controller: _usernameController,
          validator: validateUsername,
        ),
        const SizedBox(height: AppSize.s15),
        AppTextField(
          hintText: AppStrings.phoneNumber.tr(),
          prefixSvg: SvgAssets.call,
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          validator: validatePhone,
        ),
        const SizedBox(height: AppSize.s15),
        AppTextField(
          hintText: AppStrings.password.tr(),
          prefixSvg: SvgAssets.password,
          obscureSvg: SvgAssets.hidden,
          isPassword: true,
          controller: _passwordController,
          validator: validatePassword,
        ),
        const SizedBox(height: AppSize.s15),
        AppTextField(
          hintText: AppStrings.passwordConfirm.tr(),
          prefixSvg: SvgAssets.password,
          obscureSvg: SvgAssets.hidden,
          isPassword: true,
          controller: _passwordConfirmController,
          validator: (v) =>
              validatePasswordConfirmation(v, _passwordController.text),
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      children: [
        GestureDetector(
          onTap: _pickDate,
          child: AbsorbPointer(
            child: AppTextField(
              hintText: AppStrings.dateOfBirth.tr(),
              prefixSvg: SvgAssets.calendarDate,
              controller: _dobController,
              validator: (v) => validateDate(v),
            ),
          ),
        ),
        const SizedBox(height: AppSize.s15),
        DropdownButtonFormField<String>(
          initialValue: _genderValue,
          decoration: InputDecoration(
            hintText: AppStrings.gender.tr(),
            prefixIcon: _buildSvgPrefixIcon(SvgAssets.person),
          ),
          items: [
            DropdownMenuItem(value: 'male', child: Text(AppStrings.male.tr())),
            DropdownMenuItem(
              value: 'female',
              child: Text(AppStrings.female.tr()),
            ),
          ],
          onChanged: (v) => setState(() => _genderValue = v ?? 'male'),
        ),
        const SizedBox(height: AppSize.s15),
        AppTextField(
          hintText: AppStrings.nationalId.tr(),
          prefixSvg: SvgAssets.idSerialNumber,
          controller: _nationalIdController,
        ),
        const SizedBox(height: AppSize.s15),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            hintText: AppStrings.bloodType.tr(),
            prefixIcon: _buildSvgPrefixIcon(SvgAssets.bloodType),
          ),
          items: const ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
              .map((type) => DropdownMenuItem(value: type, child: Text(type)))
              .toList(),
          onChanged: (v) => _bloodTypeController.text = v ?? '',
          validator: (v) => (_bloodTypeController.text.isEmpty)
              ? validateRequired(null, '')
              : null,
        ),
        const SizedBox(height: AppSize.s15),
        AppTextField(
          hintText: AppStrings.weight.tr(),
          prefixSvg: SvgAssets.weight,
          controller: _weightController,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: AppSize.s15),
        SearchableWilayaField(
          controller: _cityController,
          validator: validateCity,
        ),
        const SizedBox(height: AppSize.s15),
        AppTextField(
          hintText: AppStrings.chronicDiseases.tr(),
          prefixSvg: SvgAssets.illnesses,
          controller: _chronicDiseasesController,
          isMultiline: true,
        ),
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppPadding.p20),
          decoration: BoxDecoration(
            color: ColorManager.surface,
            borderRadius: BorderRadius.circular(AppSize.s20),
          ),
          child: Text(
            AppStrings.termsBody.tr(),
            style: getRegularStyle(
              fontSize: FontSize.s16,
              color: ColorManager.textPrimary,
            ),
            textAlign: TextAlign.justify,
          ),
        ),
        const SizedBox(height: AppSize.s20),
        Row(
          children: [
            Transform.scale(
              scale: 0.8,
              child: Switch(
                value: _agreeToTerms,
                onChanged: (v) => setState(() => _agreeToTerms = v),
              ),
            ),
            Text(
              AppStrings.acceptTerms.tr(),
              style: getRegularStyle(
                fontSize: FontSize.s14,
                color: ColorManager.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _authListener(BuildContext context, AuthState state) {
    if (state is Authenticated) {
      showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: ColorManager.dialogScrim,
        builder: (_) => AppDialog.success(
          title: AppStrings.signupSuccess.tr(),
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
          title: AppStrings.signupError.tr(),
          message: state.failure.message,
          actionLabel: AppStrings.retryAgain.tr(),
          onAction: () => Navigator.pop(context),
        ),
      );
    }
  }
}
