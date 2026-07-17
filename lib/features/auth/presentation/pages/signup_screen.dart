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
  String _genderValue = 'ذكر';

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
      gender: _genderValue == 'ذكر' ? 'male' : 'female',
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
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: _authListener,
        builder: (context, state) {
          return LoadingOverlay(
            visible: state is AuthLoading,
            message: 'جاري إنشاء الحساب',
            child: Scaffold(
              backgroundColor: ColorManager.white,
              body: Directionality(
                textDirection: TextDirection.rtl,
                child: SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppPadding.p20,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: AppSize.s20),
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
                            'إنشاء حساب',
                            style: getBoldStyle(
                              fontSize: FontSize.s24,
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
                              _currentStep == 3 ? 'إنشاء حساب' : 'التالي',
                            ),
                          ),
                          if (_currentStep == 1) ...[
                            const SizedBox(height: AppSize.s20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'لديك حساب بالفعل؟ ',
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
                                    'تسجيل الدخول',
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
          );
        },
      ),
    );
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case 1:
        return 'معلومات الحساب';
      case 2:
        return 'المعلومات الشخصية';
      case 3:
        return 'الشروط والأحكام';
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
        color: isCurrent ? ColorManager.primary : ColorManager.surface,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '$step',
          style: getBoldStyle(
            fontSize: FontSize.s16,
            color: isCurrent ? ColorManager.white : ColorManager.textLight,
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
          hintText: 'الاسم الكامل',
          prefixIcon: Icons.person_outline,
          controller: _fullNameController,
          validator: validateFullName,
        ),
        const SizedBox(height: AppSize.s15),
        AppTextField(
          hintText: 'اسم المستخدم',
          prefixIcon: Icons.alternate_email,
          controller: _usernameController,
          validator: validateUsername,
        ),
        const SizedBox(height: AppSize.s15),
        AppTextField(
          hintText: 'رقم الجوال',
          prefixIcon: Icons.phone_outlined,
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          validator: validatePhone,
        ),
        const SizedBox(height: AppSize.s15),
        AppTextField(
          hintText: 'كلمة المرور',
          prefixIcon: Icons.lock_outline,
          isPassword: true,
          controller: _passwordController,
          validator: validatePassword,
        ),
        const SizedBox(height: AppSize.s15),
        AppTextField(
          hintText: 'تأكيد كلمة المرور',
          prefixIcon: Icons.lock_outline,
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
              hintText: 'تاريخ الميلاد',
              prefixIcon: Icons.calendar_today_outlined,
              controller: _dobController,
              validator: (v) => validateDate(v),
            ),
          ),
        ),
        const SizedBox(height: AppSize.s15),
        DropdownButtonFormField<String>(
          initialValue: _genderValue,
          decoration: const InputDecoration(
            hintText: 'الجنس',
            prefixIcon: Icon(Icons.person_outline),
          ),
          items: const [
            DropdownMenuItem(value: 'ذكر', child: Text('ذكر')),
            DropdownMenuItem(value: 'أنثى', child: Text('أنثى')),
          ],
          onChanged: (v) => setState(() => _genderValue = v ?? 'ذكر'),
        ),
        const SizedBox(height: AppSize.s15),
        AppTextField(
          hintText: 'رقم بطاقة التعريف الوطني',
          prefixIcon: Icons.badge_outlined,
          controller: _nationalIdController,
        ),
        const SizedBox(height: AppSize.s15),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            hintText: 'فصيلة الدم',
            prefixIcon: Icon(Icons.opacity),
          ),
          items: const ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
              .map((type) => DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  ))
              .toList(),
          onChanged: (v) => _bloodTypeController.text = v ?? '',
          validator: (v) => (_bloodTypeController.text.isEmpty)
              ? validateRequired(null, '')
              : null,
        ),
        const SizedBox(height: AppSize.s15),
        AppTextField(
          hintText: 'الوزن',
          prefixIcon: Icons.monitor_weight_outlined,
          controller: _weightController,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: AppSize.s15),
        AppTextField(
          hintText: 'الولاية',
          prefixIcon: Icons.location_city_outlined,
          controller: _cityController,
          validator: validateCity,
        ),
        const SizedBox(height: AppSize.s15),
        AppTextField(
          hintText: 'الأمراض المزمنة',
          prefixIcon: Icons.coronavirus_outlined,
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
            'باستخدامك لهذا التطبيق، فإنك توافق على تقديم معلومات صحيحة، واستخدام المنصة لأغراض التبرع بالدم وطلبه فقط. تلتزم المنصة بحماية بياناتك الشخصية وعدم مشاركتها إلا عند الضرورة. تحتفظ إدارة التطبيق بحق تعديل الخدمات أو تعليق الحسابات المخالفة للشروط. بإنشاء حساب، فإنك توافق على هذه الشروط والأحكام.',
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
              'أوافق على الشروط والأحكام',
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
        builder: (_) => AppDialog.success(
          title: 'لقد تم إنشاء حساب بنجاح',
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
          title: 'خطأ في إنشاء الحساب',
          message: state.failure.message,
          actionLabel: 'إعادة المحاولة',
          onAction: () => Navigator.pop(context),
        ),
      );
    }
  }
}
