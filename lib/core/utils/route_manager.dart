import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../injection_container.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/splash/presentation/pages/splash_screen.dart';
import '../../features/auth/presentation/pages/role_selection_screen.dart';
import '../../features/auth/presentation/pages/welcome_screen.dart';
import '../../features/auth/presentation/pages/login_form_screen.dart';
import '../../features/auth/presentation/pages/signup_screen.dart'
    show SignUpScreen;
import '../../features/requester_home/presentation/pages/requester_home_screen.dart';
import '../../features/requester_home/presentation/pages/create_request_screen.dart';
import '../../features/requester_home/presentation/pages/edit_request_screen.dart';
import '../../features/requester_home/presentation/pages/requests_screen.dart';
import '../../features/requester_home/presentation/pages/notifications_screen.dart';
import '../../features/requester_home/presentation/pages/donor_history_screen.dart';
import '../../features/donor_home/presentation/pages/donor_home_screen.dart';
import '../../features/donor_home/presentation/pages/donor_requests_screen.dart';
import '../../features/donor_home/presentation/pages/donor_appointments_screen.dart';
import '../../features/donor_home/presentation/pages/donor_card_screen.dart';
import '../../features/donor_home/presentation/pages/donor_card_info_screen.dart';
import '../../features/donor_home/presentation/pages/donor_record_screen.dart';
import '../../features/profile/presentation/pages/profile_screen.dart';
import '../../features/profile/presentation/pages/requester_profile_screen.dart';

class Routes {
  static const String splashRoute = '/';
  static const String roleSelectionRoute = '/role-selection';
  static const String welcomeRoute = '/welcome';
  static const String loginFormRoute = '/login-form';
  static const String signupRoute = '/signup';

  // Requester
  static const String requesterHomeRoute = '/requester-home';
  static const String createRequestRoute = '/create-request';
  static const String editRequestRoute = '/edit-request';
  static const String requestsRoute = '/requests';
  static const String notificationsRoute = '/notifications';
  static const String donorHistoryRoute = '/donor-history';
  static const String requesterProfileRoute = '/requester-profile';

  // Donor
  static const String donorHomeRoute = '/donor-home';
  static const String donorRequestsRoute = '/donor-requests';
  static const String donorAppointmentsRoute = '/donor-appointments';
  static const String donorCardRoute = '/donor-card';
  static const String donorCardInfoRoute = '/donor-card-info';
  static const String donorRecordRoute = '/donor-record';
  static const String profileRoute = '/profile';
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      // Auth
      case Routes.roleSelectionRoute:
        return MaterialPageRoute(builder: (_) => const RoleSelectionScreen());
      case Routes.welcomeRoute:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());
      case Routes.loginFormRoute:
        return MaterialPageRoute(builder: (_) => const LoginFormScreen());
      case Routes.signupRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<AuthBloc>(),
            child: const SignUpScreen(),
          ),
        );

      // Requester
      case Routes.requesterHomeRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<AuthBloc>(),
            child: const RequesterHomeScreen(),
          ),
        );
      case Routes.createRequestRoute:
        return MaterialPageRoute(builder: (_) => const CreateRequestScreen());
      case Routes.editRequestRoute:
        return MaterialPageRoute(builder: (_) => const EditRequestScreen());
      case Routes.requestsRoute:
        return MaterialPageRoute(builder: (_) => const RequestsScreen());
      case Routes.notificationsRoute:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());
      case Routes.donorHistoryRoute:
        return MaterialPageRoute(builder: (_) => const DonorHistoryScreen());
      case Routes.requesterProfileRoute:
        return MaterialPageRoute(
          builder: (_) => const RequesterProfileScreen(),
        );

      // Donor
      case Routes.donorHomeRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<AuthBloc>(),
            child: const DonorHomeScreen(),
          ),
        );
      case Routes.donorRequestsRoute:
        return MaterialPageRoute(builder: (_) => const DonorRequestsScreen());
      case Routes.donorAppointmentsRoute:
        return MaterialPageRoute(
          builder: (_) => const DonorAppointmentsScreen(),
        );
      case Routes.donorCardRoute:
        return MaterialPageRoute(builder: (_) => const DonorCardScreen());
      case Routes.donorCardInfoRoute:
        return MaterialPageRoute(builder: (_) => const DonorCardInfoScreen());
      case Routes.donorRecordRoute:
        return MaterialPageRoute(builder: (_) => const DonorRecordScreen());
      case Routes.profileRoute:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Not Found')),
            body: const Center(child: Text('Route not found')),
          ),
        );
    }
  }
}
