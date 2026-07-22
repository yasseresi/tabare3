import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/widget_keys.dart';
import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/constants_manager.dart';
import '../../../../core/utils/route_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../../../../injection_container.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>()..add(SessionCheckRequested()),
      child: BlocListener<AuthBloc, AuthState>(
        listener: _authListener,
        child: Scaffold(
          backgroundColor: ColorManager.scaffoldBg,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  ImageAssets.logo,
                  width: AppSize.s111,
                  height: AppSize.s111,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.favorite,
                    color: ColorManager.primary,
                    size: AppSize.s100,
                  ),
                ),
                const SizedBox(height: AppSize.s40),
                Container(
                  key: WidgetKeys.splashProgressBar,
                  width: AppSize.s80,
                  height: AppSize.s6,
                  decoration: BoxDecoration(
                    color: ColorManager.progressTrack,
                    borderRadius: BorderRadius.circular(AppSize.s3),
                  ),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(seconds: AppConstants.splashDelay),
                    curve: Curves.easeInOut,
                    builder: (context, value, _) => Align(
                      alignment: Alignment.centerRight,
                      child: FractionallySizedBox(
                        widthFactor: value,
                        child: Container(
                          height: AppSize.s6,
                          decoration: BoxDecoration(
                            color: ColorManager.progressFill,
                            borderRadius: BorderRadius.circular(AppSize.s3),
                          ),
                        ),
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
    Future.delayed(const Duration(seconds: AppConstants.splashDelay), () {
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          isDonor ? Routes.donorHomeRoute : Routes.requesterHomeRoute,
          (route) => false,
        );
      }
    });
  }

  void _navigateToWelcome(BuildContext context) {
    Future.delayed(
      const Duration(seconds: AppConstants.splashDelayUnauthenticated),
      () {
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.welcomeRoute,
            (route) => false,
          );
        }
      },
    );
  }
}
