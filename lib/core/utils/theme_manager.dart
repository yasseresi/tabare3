import 'package:flutter/material.dart';
import 'color_manager.dart';
import 'font_manager.dart';
import 'styles_manager.dart';
import 'values_manager.dart';

ThemeData getAppTheme() {
  return ThemeData(
    useMaterial3: true,
    primaryColor: ColorManager.primary,
    primaryColorDark: ColorManager.primaryDark,
    primaryColorLight: ColorManager.primaryLight,
    disabledColor: ColorManager.lightGrey,
    scaffoldBackgroundColor: ColorManager.scaffoldBg,
    colorScheme: ColorScheme.fromSeed(
      seedColor: ColorManager.primary,
      primary: ColorManager.primary,
      secondary: ColorManager.secondary,
      surface: ColorManager.scaffoldBg,
      onSurface: ColorManager.black,
      error: ColorManager.error,
    ),
    cardTheme: CardThemeData(
      color: ColorManager.white,
      elevation: AppSize.s4,
      shadowColor: ColorManager.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.radiusMedium),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: ColorManager.white,
      foregroundColor: ColorManager.black,
      centerTitle: true,
      elevation: 0,
      shadowColor: Colors.transparent,
      titleTextStyle: getSemiBoldStyle(
        fontSize: FontSize.s18,
        color: ColorManager.textPrimary,
      ),
      iconTheme: IconThemeData(color: ColorManager.black),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorManager.primary,
        foregroundColor: ColorManager.textOnPrimary,
        minimumSize: const Size(double.infinity, AppSize.s58),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.radiusXLarge),
        ),
        textStyle: getBoldStyle(
          fontSize: FontSize.s18,
          color: ColorManager.textOnPrimary,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: ColorManager.black,
        minimumSize: const Size(double.infinity, AppSize.s58),
        side: BorderSide(color: ColorManager.dividerGrey),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.radiusXLarge),
        ),
        textStyle: getBoldStyle(
          fontSize: FontSize.s18,
          color: ColorManager.black,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: ColorManager.primary,
        textStyle: getSemiBoldStyle(
          fontSize: FontSize.s14,
          color: ColorManager.primary,
        ),
      ),
    ),
    textTheme: TextTheme(
      displayLarge: getBoldStyle(
        color: ColorManager.primary,
        fontSize: FontSize.s40,
      ),
      displayMedium: getBoldStyle(
        color: ColorManager.textPrimary,
        fontSize: FontSize.s32,
      ),
      displaySmall: getBoldStyle(
        color: ColorManager.textPrimary,
        fontSize: FontSize.s24,
      ),
      titleLarge: getBoldStyle(
        color: ColorManager.textPrimary,
        fontSize: FontSize.s20,
      ),
      titleMedium: getSemiBoldStyle(
        color: ColorManager.textPrimary,
        fontSize: FontSize.s16,
      ),
      titleSmall: getMediumStyle(
        color: ColorManager.textSecondary,
        fontSize: FontSize.s14,
      ),
      bodyLarge: getRegularStyle(
        color: ColorManager.textPrimary,
        fontSize: FontSize.s16,
      ),
      bodyMedium: getRegularStyle(
        color: ColorManager.textSecondary,
        fontSize: FontSize.s14,
      ),
      bodySmall: getRegularStyle(
        color: ColorManager.textMuted,
        fontSize: FontSize.s12,
      ),
      labelLarge: getBoldStyle(
        color: ColorManager.textOnPrimary,
        fontSize: FontSize.s16,
      ),
      labelMedium: getMediumStyle(
        color: ColorManager.textSecondary,
        fontSize: FontSize.s12,
      ),
      labelSmall: getRegularStyle(
        color: ColorManager.textLight,
        fontSize: FontSize.s10,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ColorManager.surface,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppPadding.p20,
        vertical: AppPadding.p16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSize.radiusLarge),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSize.radiusLarge),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSize.radiusLarge),
        borderSide: BorderSide(color: ColorManager.primary, width: AppSize.s1),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSize.radiusLarge),
        borderSide: BorderSide(color: ColorManager.error, width: AppSize.s1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSize.radiusLarge),
        borderSide: BorderSide(color: ColorManager.error, width: AppSize.s1),
      ),
      hintStyle: getRegularStyle(
        color: ColorManager.textLight,
        fontSize: FontSize.s14,
      ),
      labelStyle: getMediumStyle(
        color: ColorManager.textMuted,
        fontSize: FontSize.s14,
      ),
      errorStyle: getRegularStyle(
        color: ColorManager.error,
        fontSize: FontSize.s12,
      ),
      prefixIconColor: ColorManager.textLight,
      suffixIconColor: ColorManager.textLight,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: ColorManager.white,
      surfaceTintColor: ColorManager.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.radiusXXLarge),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(ColorManager.white),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected))
          return ColorManager.secondary;
        return ColorManager.dividerGrey;
      }),
    ),
    iconTheme: IconThemeData(color: ColorManager.textMuted, size: AppSize.s24),
    dividerTheme: DividerThemeData(
      color: ColorManager.dividerGrey,
      thickness: AppSize.s1,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: ColorManager.white,
      selectedItemColor: ColorManager.primary,
      unselectedItemColor: ColorManager.textLight,
      type: BottomNavigationBarType.fixed,
      elevation: AppSize.s8,
    ),
  );
}
