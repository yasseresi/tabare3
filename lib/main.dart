import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'backend/active_backend.dart';
import 'core/utils/language_manager.dart';
import 'core/utils/route_manager.dart';
import 'core/utils/theme_manager.dart';
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
        return Container(
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
        );
      },
    );
  }
}
