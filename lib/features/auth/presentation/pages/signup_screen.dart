import 'package:flutter/material.dart';
import 'role_selection_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  int _currentStep = 1;
  bool _agreeToTerms = false;
  bool _obscurePassword = true;

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
      });
    } else {
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xFF4CAF50),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 25),
                Text(
                  'لقد تم إنشاء حساب بنجاح',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 10),
                Image.asset(
                  'assets/images/icon6.png',
                  height: 70,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.bloodtype_outlined, size: 70, color: Color(0xFF8B1D1D)),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const RoleSelectionScreen()),
                      (route) => false,
                    );
                  },
                  child: const Text('الصفحة الرئيسية'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Image.asset(
                  'assets/images/icon6.png',
                  height: 70,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.bloodtype_outlined, size: 70, color: Color(0xFF8B1D1D)),
                ),
                const SizedBox(height: 10),
                Text(
                  'إنشاء حساب',
                  style: theme.textTheme.titleLarge?.copyWith(fontSize: 28),
                ),
                const SizedBox(height: 5),
                Text(
                  _getStepTitle(),
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 30),
                _buildStepIndicator(),
                const SizedBox(height: 30),
                _buildCurrentStepView(),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _nextStep,
                  child: Text(_currentStep == 3 ? 'إنشاء حساب' : 'التالي'),
                ),
                if (_currentStep == 1) ...[
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'لديك حساب بالفعل؟ ',
                        style: theme.textTheme.bodyMedium,
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text(
                          'تسجيل الدخول',
                          style: TextStyle(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
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
        _buildLine(1),
        _buildCircle(2),
        _buildLine(2),
        _buildCircle(3),
      ],
    );
  }

  Widget _buildCircle(int step) {
    bool isCurrent = _currentStep == step;
    return Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        color: isCurrent ? const Color(0xFF8B1D1D) : const Color(0xFFEEEEEE),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '$step',
          style: TextStyle(
            color: isCurrent ? Colors.white : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildLine(int afterStep) {
    return Container(
      width: 40,
      height: 2,
      color: const Color(0xFFEEEEEE),
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
        _buildTextField('اسم المستخدم', Icons.person_outline),
        const SizedBox(height: 15),
        _buildTextField('رقم الجوال', Icons.phone_outlined),
        const SizedBox(height: 15),
        _buildTextField('البريد الإلكتروني', Icons.email_outlined),
        const SizedBox(height: 15),
        _buildTextField('..........', Icons.lock_outline, isPassword: true),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      children: [
        _buildTextField('تاريخ الميلاد', Icons.calendar_today_outlined),
        const SizedBox(height: 15),
        _buildTextField('الجنس', Icons.person_outline),
        const SizedBox(height: 15),
        _buildTextField('رقم بطاقة التعريف الوطني', Icons.badge_outlined),
        const SizedBox(height: 15),
        _buildTextField('فصيلة الدم', Icons.opacity),
        const SizedBox(height: 15),
        _buildTextField('الوزن', Icons.monitor_weight_outlined),
        const SizedBox(height: 15),
        _buildTextField('الولاية', Icons.location_city_outlined),
        const SizedBox(height: 15),
        _buildTextField('الأمراض المزمنة', Icons.coronavirus_outlined, isMultiline: true),
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'باستخدامك لهذا التطبيق، فإنك توافق على تقديم معلومات صحيحة، واستخدام المنصة لأغراض التبرع بالدم وطلبه فقط. تلتزم المنصة بحماية بياناتك الشخصية وعدم مشاركتها إلا عند الضرورة. تحتفظ إدارة التطبيق بحق تعديل الخدمات أو تعليق الحسابات المخالفة للشروط. بإنشاء حساب، فإنك توافق على هذه الشروط والأحكام.',
            style: TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
            textAlign: TextAlign.justify,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Transform.scale(
              scale: 0.8,
              child: Switch(
                value: _agreeToTerms,
                onChanged: (value) {
                  setState(() {
                    _agreeToTerms = value;
                  });
                },
              ),
            ),
            const Text(
              'أوافق على الشروط والأحكام',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField(String hint, IconData icon, {bool isPassword = false, bool isMultiline = false}) {
    return TextField(
      maxLines: isMultiline ? 4 : 1,
      obscureText: isPassword ? _obscurePassword : false,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: isPassword ? Icon(icon) : null,
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              )
            : Icon(icon),
      ),
    );
  }
}
