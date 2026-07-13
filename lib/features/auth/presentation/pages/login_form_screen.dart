import 'package:flutter/material.dart';
import 'role_selection_screen.dart';
import 'signup_screen.dart';

class LoginFormScreen extends StatefulWidget {
  const LoginFormScreen({super.key});

  @override
  State<LoginFormScreen> createState() => _LoginFormScreenState();
}

class _LoginFormScreenState extends State<LoginFormScreen> {
  bool _rememberMe = false;
  bool _obscurePassword = true;

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
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 50),
                ),
                const SizedBox(height: 25),
                Text(
                  'لقد سجلت الدخول بنجاح إلى تطبيق',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 10),
                Image.asset(
                  'assets/images/icon6.png',
                  height: 60,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.bloodtype_outlined, size: 60, color: Color(0xFF8B1D1D)),
                ),
                const SizedBox(height: 30),
                  SizedBox(
                  width: 200,
                  child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const RoleSelectionScreen()),
                      (route) => false,
                    );
                  },
                  child: const Text('الصفحة الرئيسية'),
                ), 
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
                  height: 60,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.bloodtype_outlined, size: 60, color: Color(0xFF8B1D1D)),
                ),
                const SizedBox(height: 20),
                Image.asset(
                  'assets/images/demo1.png',
                  height: 180,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.assignment_ind_outlined,
                    color: theme.primaryColor,
                    size: 120,
                  ),
                ),
                const SizedBox(height: 30),
                Text('تسجيل الدخول', style: theme.textTheme.displaySmall),
                const SizedBox(height: 30),
                const TextField(
                  decoration: InputDecoration(
                    hintText: 'اسم المستخدم',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: '..........',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Text('تذكرني في المرة القادمة', style: theme.textTheme.bodyMedium),
                    const Spacer(),
                    Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: _rememberMe,
                        onChanged: (value) => setState(() => _rememberMe = value),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _showSuccessDialog,
                  child: const Text('تسجيل الدخول'),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('ليس لديك حساب؟ ', style: theme.textTheme.bodyMedium),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignUpScreen()),
                        );
                      },
                      child: Text(
                        'إنشاء حساب',
                        style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
