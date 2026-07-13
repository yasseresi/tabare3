import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'features/splash/presentation/pages/splash_screen.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF8B1D1D);
    const secondaryColor = Color(0xFF4CAF50);
    const scaffoldBackgroundColor = Colors.white;
    const surfaceColor = Color(0xFFF5F5F5);
    const dividerColor = Color(0xFFEEEEEE);
    const textGrey = Color(0xFF9E9E9E);

    return MaterialApp(
      title: 'Tabare3',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: primaryColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          primary: primaryColor,
          secondary: secondaryColor,
          surface: scaffoldBackgroundColor,
          onSurface: Colors.black,
          error: const Color(0xFFE53935),
        ),
        scaffoldBackgroundColor: scaffoldBackgroundColor,
        textTheme: GoogleFonts.cairoTextTheme(
          ThemeData.light().textTheme,
        ).copyWith(
          displayLarge: GoogleFonts.cairo(
            fontWeight: FontWeight.bold,
            color: primaryColor,
            fontSize: 40,
          ),
          displayMedium: GoogleFonts.cairo(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 32,
          ),
          displaySmall: GoogleFonts.cairo(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 24,
          ),
          titleLarge: GoogleFonts.cairo(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 20,
          ),
          titleMedium: GoogleFonts.cairo(
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontSize: 16,
          ),
          bodyLarge: GoogleFonts.cairo(
            color: Colors.black,
            fontSize: 16,
          ),
          bodyMedium: GoogleFonts.cairo(
            color: textGrey,
            fontSize: 14,
          ),
          labelLarge: GoogleFonts.cairo(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: surfaceColor,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: primaryColor, width: 1),
          ),
          hintStyle: GoogleFonts.cairo(color: textGrey, fontSize: 14),
          prefixIconColor: textGrey,
          suffixIconColor: textGrey,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0,
            textStyle: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.black,
            minimumSize: const Size(double.infinity, 55),
            side: const BorderSide(color: dividerColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            textStyle: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.all(Colors.white),
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return secondaryColor;
            return Colors.grey[300];
          }),
        ),
        iconTheme: const IconThemeData(
          color: textGrey,
          size: 24,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
