import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/pages/welcome_screen.dart';
import '../../../donor_home/presentation/pages/donor_home_screen.dart';
import '../../../requester_home/presentation/pages/requester_home_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>()..add(SessionCheckRequested()),
      child: BlocListener<AuthBloc, AuthState>(
        listener: _authListener,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 180,
                  height: 180,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.favorite,
                    color: Theme.of(context).primaryColor,
                    size: 100,
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      minHeight: 6,
                      backgroundColor: const Color(0xFFE0E0E0),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
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

  void _authListener(BuildContext context, AuthState state) {
    if (state is Authenticated) {
      _navigateToHome(context, state.user.isDonor);
    } else if (state is Unauthenticated || state is AuthError) {
      _navigateToWelcome(context);
    }
  }

  void _navigateToHome(BuildContext context, bool isDonor) {
    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) =>
                isDonor ? const DonorHomeScreen() : const RequesterHomeScreen(),
          ),
          (route) => false,
        );
      }
    });
  }

  void _navigateToWelcome(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const WelcomeScreen()),
          (route) => false,
        );
      }
    });
  }
}
