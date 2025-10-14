import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../decorations/app_elevated_button_decoration.dart';
import '../values/app_colors.dart';

class IconLightTheme {
  /// Defines the text styling for the light theme, following Material 3 typography guidelines.
  /// This ensures a consistent look and feel for all text elements in the app.
  static final TextTheme _lightTextTheme = TextTheme(
    displayLarge: GoogleFonts.inter(
      fontSize: 57,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
    displayMedium: GoogleFonts.inter(
      fontSize: 45,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
    displaySmall: GoogleFonts.inter(
      fontSize: 36,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),

    headlineLarge: GoogleFonts.inter(
      fontSize: 32,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
    headlineMedium: GoogleFonts.inter(
      fontSize: 28,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
    headlineSmall: GoogleFonts.inter(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),

    titleLarge: GoogleFonts.inter(
      fontSize: 22,
      fontWeight: FontWeight.w500,
      color: AppColors.lightTextPrimaryColor,
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      color:AppColors.lightTextPrimaryColor,
    ),
    titleSmall: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: AppColors.lightTextPrimaryColor,
    ),

    bodyLarge: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      color: AppColors.lightTextSecondaryColor,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      color: AppColors.lightTextSecondaryColor,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      color: AppColors.lightTextSecondaryColor,
    ),

    labelLarge: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: AppColors.lightTextSecondaryColor,
    ),
    labelMedium: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      color: AppColors.lightTextSecondaryColor,
    ),
    labelSmall: GoogleFonts.inter(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      color: AppColors.lightTextSecondaryColor,
    ),
  );

  static ThemeData androidLightTheme = ThemeData(
    textTheme: _lightTextTheme,
    primarySwatch: AppColors.colorPrimarySwatch,
    primaryColor: AppColors.colorPrimary,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBgColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.colorPrimary,
      brightness: Brightness.light,
      primary: AppColors.colorPrimary,
      secondary: AppColors.greenColor,
      tertiary: AppColors.informationColor,
      error: AppColors.warningColor,
      surface:  AppColors.lightBgColor,
    ),
    appBarTheme:  AppBarTheme(
      backgroundColor: AppColors.lightBgColor,
      elevation: 0,
      foregroundColor: AppColors.lightBgColor,
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      color: const Color(0xFF1A1B1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: const Color(0xFF1A1B1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),

    tabBarTheme: TabBarThemeData(
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(width: 2.0, color: AppColors.colorPrimary),
      ),
      labelColor: AppColors.colorPrimary,
      unselectedLabelColor: Colors.white.withValues(alpha: 0.7),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      isDense: true,
      fillColor: Colors.white,
      // A subtle, slightly lighter fill
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      // Ensure icon colors are also light
      iconColor: Colors.black,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: AppColors.lightInputBorderColor, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: AppColors.lightInputBorderColor, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: AppColors.colorPrimary, width: 0.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: AppColors.warningColor, width: 0.5),
      ),
      hintStyle: const TextStyle(color: AppColors.lightHintTextColor, fontSize: 14),
    ),
    elevatedButtonTheme: appElevatedButtonTheme,
  );
}
