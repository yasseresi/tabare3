import 'package:flutter/material.dart';
import 'login_form_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Demo Image
                Image.asset(
                  'assets/images/demo.png',
                  height: 250,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.bloodtype_outlined,
                    color: theme.primaryColor,
                    size: 150,
                  ),
                ),
                const SizedBox(height: 40),
                // Welcome Text
                Text(
                  'مرحباً بك في',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                    fontSize: 24,
                  ),
                ),
                Image.asset(
                  'assets/images/icon6.png',
                  height: 80,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.bloodtype_outlined,
                    color: theme.primaryColor,
                    size: 80,
                  ),
                ),
                const SizedBox(height: 50),
                // Login Button
                SizedBox(
                  width: 220,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginFormScreen()),
                      );
                    },
                    child: const Text('تسجيل الدخول'),
                  ),
                ),
                const SizedBox(height: 20),
                // Create Account Button
                SizedBox(
                  width: 220,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUpScreen()),
                      );
                    },
                    child: Text(
                      'إنشاء حساب',
                      style: TextStyle(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
