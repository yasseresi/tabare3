import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'backend/active_backend.dart';
import 'core/utils/language_manager.dart';
import 'core/utils/route_manager.dart';
import 'core/utils/theme_manager.dart';
import 'features/notifications/presentation/bloc/notifications_bloc.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await activeBackend.initialize();
  await di.init(activeBackend);
  runApp(
    EasyLocalization(
      supportedLocales: const [arabicLocale, englishLocale],
      path: assetPathLocalisations,
      fallbackLocale: arabicLocale,
      startLocale: arabicLocale,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tabare3',
      debugShowCheckedModeBanner: false,
      theme: getAppTheme(),
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      onGenerateRoute: RouteGenerator.getRoute,
      initialRoute: Routes.splashRoute,
      builder: (context, child) {
        // App-wide notifications bloc lives above the navigator so the unread
        // bell badge is available on every route. It is created lazily and only
        // opens its stream once an authenticated screen fires
        // NotificationsRequested, so it never touches the null current user.
        return BlocProvider<NotificationsBloc>(
          create: (_) => di.sl<NotificationsBloc>(),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  const Color(0xFFFDB6B0).withValues(alpha: 3),
                  const Color(0xFFDFE0FE).withValues(alpha: 1.5),
                ],
              ),
            ),
            child: child,
          ),
        );
      },
    );
  }
}
