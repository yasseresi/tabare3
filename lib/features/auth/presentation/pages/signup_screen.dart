import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/presentation/widgets/adaptive_pickers.dart';
import '../../../../core/presentation/widgets/app_dialog.dart';
import '../../../../core/presentation/widgets/app_gradient_background.dart';
import '../../../../core/presentation/widgets/app_text_field.dart';
import '../../../../core/presentation/widgets/loading_overlay.dart';
import '../../../../core/presentation/widgets/searchable_wilaya_field.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/widget_keys.dart';
import '../../../../core/utils/constants_manager.dart';
import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/error_messages.dart';
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
  String? _genderValue;

  /// The username the backend last reported as taken. Kept so the form field
  /// itself carries the error; it clears as soon as a different one is typed.
  String? _takenUsername;

  /// True while the step-1 "Next" tap is waiting on the username availability
  /// check. Spins the button and swallows repeat taps until the result lands.
  bool _checkingUsername = false;

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
    if (_checkingUsername) return;
    if (!_formKey.currentState!.validate()) return;
    if (_currentStep == 1) {
      // Only leave step 1 once the backend confirms the username is free, so
      // the collision is reported here on "Next" rather than on field blur.
      setState(() => _checkingUsername = true);
      context.read<AuthBloc>().add(
        UsernameCheckRequested(_usernameController.text.trim()),
      );
    } else if (_currentStep < 3) {
      setState(() => _currentStep++);
    } else {
      if (!_agreeToTerms) return;
      _dispatchSignup();
    }
  }

  Future<void> _pickDate() async {
    final picked = await showAdaptiveDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2000),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dobController.text =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  /// Field-level validation plus the backend's verdict on the username.
  String? _validateUsernameField(String? value) {
    final localError = validateUsername(value);
    if (localError != null) return localError;
    if (_takenUsername != null && value?.trim() == _takenUsername) {
      return ErrorMessages.getValidationMessage(ValidationKeys.usernameTaken);
    }
    return null;
  }

  void _dispatchSignup() {
    if (!_formKey.currentState!.validate()) return;
    final params = SignupParams(
      username: _usernameController.text.trim(),
      fullName: _fullNameController.text.trim(),
      password: _passwordController.text,
      phone: _phoneController.text.trim(),
      dateOfBirth: _selectedDate ?? DateTime(2000),
      gender: _genderValue ?? AppConstants.genderMale,
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
              child: AppGradientBackground(
                child: SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppPadding.p30,
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
                          // Figma root `gap: 12` between the logo and the
                          // content area.
                          const SizedBox(height: AppSize.s12),
                          Text(
                            AppStrings.signup.tr(),
                            style: getBoldStyle(
                              fontSize: FontSize.s30,
                              color: ColorManager.black,
                              lineHeight: LineHeight.h36,
                            ),
                          ),
                          // `Heading 1:margin` pb 4 + content-area gap 20.
                          const SizedBox(height: AppSize.s24),
                          Text(
                            _getStepTitle(),
                            style: getRegularStyle(
                              fontSize: FontSize.s14,
                              color: ColorManager.welcomeText,
                              lineHeight: LineHeight.h20,
                            ),
                          ),
                          // `Margin` pb 10 + content-area gap 20.
                          const SizedBox(height: AppSize.s30),
                          _buildStepIndicator(),
                          const SizedBox(height: AppSize.s20),
                          _buildCurrentStepView(),
                          const SizedBox(height: AppSize.s20),
                          _buildPrimaryButton(),
                          if (_currentStep == 1) ...[
                            const SizedBox(height: AppSize.s20),
                            _buildFooterLink(),
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

  /// The stepper always reads 1·2·3 left to right, even inside the RTL page.
  Widget _buildStepIndicator() {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCircle(1),
          _buildLine(),
          _buildCircle(2),
          _buildLine(),
          _buildCircle(3),
        ],
      ),
    );
  }

  Widget _buildCircle(int step) {
    final isCurrent = _currentStep == step;
    final numeral = '$step';
    return Container(
      width: AppSize.s37_4,
      height: AppSize.s37_4,
      decoration: BoxDecoration(
        color: isCurrent ? ColorManager.primary : ColorManager.white,
        shape: BoxShape.circle,
        border: isCurrent
            ? null
            : Border.all(color: ColorManager.dividerGrey, width: AppSize.s1),
      ),
      child: Center(
        child: step == 1
            ? Text(
                numeral,
                style: getMediumStyle(
                  fontSize: FontSize.s17_9,
                  color: isCurrent
                      ? ColorManager.white
                      : ColorManager.stepperInactive,
                ),
              )
            : Text(
                numeral,
                style: getLightStyle(
                  fontSize: FontSize.s17_9,
                  color: isCurrent
                      ? ColorManager.white
                      : ColorManager.stepperInactive,
                ),
              ),
      ),
    );
  }

  Widget _buildLine() {
    return Container(
      width: AppSize.s44_9,
      height: AppSize.s1,
      color: ColorManager.dividerGrey,
    );
  }

  /// Full-width red pill shared by all three steps.
  Widget _buildPrimaryButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: (_checkingUsername || (_currentStep == 3 && !_agreeToTerms))
            ? null
            : _nextStep,
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorManager.primary,
          foregroundColor: ColorManager.white,
          minimumSize: Size.zero,
          padding: const EdgeInsets.symmetric(vertical: AppPadding.p16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.radiusField),
          ),
          elevation: AppSize.s8,
          shadowColor: ColorManager.black.withValues(alpha: AppOpacity.muted),
          textStyle: getSemiBoldStyle(
            fontSize: FontSize.s16,
            color: ColorManager.white,
            lineHeight: LineHeight.h24,
          ),
        ),
        child: _checkingUsername
            ? SizedBox(
                width: AppSize.s20,
                height: AppSize.s20,
                child: CircularProgressIndicator(
                  strokeWidth: AppSize.s2,
                  valueColor: AlwaysStoppedAnimation<Color>(ColorManager.white),
                ),
              )
            : Text(
                _currentStep == 3
                    ? AppStrings.signup.tr()
                    : AppStrings.next.tr(),
              ),
      ),
    );
  }

  Widget _buildFooterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${AppStrings.hasAccount.tr()} ',
          style: getRegularStyle(
            fontSize: FontSize.s12,
            color: ColorManager.welcomeText,
            lineHeight: LineHeight.h16,
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginFormScreen()),
          ),
          child: Text(
            AppStrings.login.tr(),
            style: getBoldStyle(
              fontSize: FontSize.s12,
              color: ColorManager.black,
              lineHeight: LineHeight.h16,
            ),
          ),
        ),
      ],
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
    // Signup inputs sit on the gradient, so they are white pills rather than
    // the grey `surface` fill the global theme uses on the login screen.
    final theme = Theme.of(context);
    return Theme(
      data: theme.copyWith(
        inputDecorationTheme: theme.inputDecorationTheme.copyWith(
          fillColor: ColorManager.white,
          contentPadding: const EdgeInsetsDirectional.fromSTEB(
            AppSize.s0,
            AppPadding.p11,
            AppPadding.p16,
            AppPadding.p11,
          ),
          border: _fieldBorder(),
          enabledBorder: _fieldBorder(),
          focusedBorder: _fieldBorder(
            side: BorderSide(color: ColorManager.primary, width: AppSize.s1),
          ),
          errorBorder: _fieldBorder(
            side: BorderSide(color: ColorManager.error, width: AppSize.s1),
          ),
          focusedErrorBorder: _fieldBorder(
            side: BorderSide(color: ColorManager.error, width: AppSize.s1),
          ),
          hintStyle: getRegularStyle(
            fontSize: FontSize.s16,
            color: ColorManager.lightGrey,
          ),
        ),
      ),
      child: switch (_currentStep) {
        1 => _buildStep1(),
        2 => _buildStep2(),
        3 => _buildStep3(),
        _ => const SizedBox.shrink(),
      },
    );
  }

  OutlineInputBorder _fieldBorder({BorderSide? side}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSize.radiusField),
      borderSide: side ?? BorderSide.none,
    );
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
          validator: _validateUsernameField,
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
          validator: validateStrongPassword,
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
            DropdownMenuItem(
              value: AppConstants.genderMale,
              child: Text(AppStrings.male.tr()),
            ),
            DropdownMenuItem(
              value: AppConstants.genderFemale,
              child: Text(AppStrings.female.tr()),
            ),
          ],
          onChanged: (v) => setState(() => _genderValue = v),
          // The dropdown stores gender codes, so only the presence check from
          // [validateGender] applies; its label branch never sees a raw value.
          validator: (v) => v == null ? validateGender(null) : null,
        ),
        const SizedBox(height: AppSize.s15),
        AppTextField(
          hintText: AppStrings.nationalId.tr(),
          prefixSvg: SvgAssets.idSerialNumber,
          controller: _nationalIdController,
          validator: validateNationalIdOptional,
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
        SizedBox(
          height: AppSize.s123,
          child: AppTextField(
            hintText: AppStrings.chronicDiseases.tr(),
            prefixSvg: SvgAssets.illnesses,
            controller: _chronicDiseasesController,
            isMultiline: true,
          ),
        ),
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppPadding.p20),
          decoration: BoxDecoration(
            color: ColorManager.white,
            borderRadius: BorderRadius.circular(AppSize.radiusXXLarge),
          ),
          child: Text(
            AppStrings.termsBody.tr(),
            style: getRegularStyle(
              fontSize: FontSize.s16,
              color: ColorManager.black,
            ),
            textAlign: TextAlign.start,
          ),
        ),
        const SizedBox(height: AppSize.s20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                AppStrings.acceptTerms.tr(),
                textAlign: TextAlign.start,
                style: getRegularStyle(
                  fontSize: FontSize.s12,
                  color: ColorManager.welcomeText,
                  lineHeight: LineHeight.h16,
                ),
              ),
            ),
            const SizedBox(width: AppSize.s8),
            _TermsToggle(
              key: WidgetKeys.signupTermsToggle,
              value: _agreeToTerms,
              onChanged: (v) => setState(() => _agreeToTerms = v),
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
    } else if (state is UsernameAvailable) {
      // The step-1 "Next" check cleared: drop the spinner and advance. Ignore
      // it in any other context (it can only fire from that tap).
      if (_checkingUsername) {
        setState(() {
          _checkingUsername = false;
          _currentStep = 2;
        });
      }
    } else if (state is UsernameTaken) {
      // Fires from the step-1 "Next" check or the final submit; either way walk
      // the user back to the field that has to change and paint the error on it.
      setState(() {
        _checkingUsername = false;
        _takenUsername = state.username;
        _currentStep = 1;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _formKey.currentState?.validate();
      });
    } else if (state is AuthError) {
      showDialog(
        context: context,
        barrierDismissible: true,
        barrierColor: ColorManager.dialogScrim,
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

/// Figma `Toggle Switch` on signup step 3: a 40x20 pill track with a 20x20
/// knob outlined in the track colour. Built for this screen only — the login
/// remember-me toggle was removed for good when sessions became persistent.
class _TermsToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _TermsToggle({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        width: AppSize.s40,
        height: AppSize.s20,
        decoration: BoxDecoration(
          color: value ? ColorManager.secondary : ColorManager.toggleTrack,
          borderRadius: BorderRadius.circular(AppSize.radiusCircle),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: AppDuration.toggle),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: AppSize.s20,
            height: AppSize.s20,
            decoration: BoxDecoration(
              color: ColorManager.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: value
                    ? ColorManager.toggleKnobBorder
                    : ColorManager.toggleTrack,
                width: AppSize.s2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
