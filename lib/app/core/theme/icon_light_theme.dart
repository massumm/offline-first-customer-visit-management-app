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
      color: Colors.black,
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      color: Colors.black,
    ),
    titleSmall: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: Colors.black,
    ),

    bodyLarge: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      color: Colors.black.withValues(alpha: 0.9),
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      color: Colors.black.withValues(alpha: 0.9),
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      color: Colors.black.withValues(alpha: 0.9),
    ),

    labelLarge: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: Colors.black,
    ),
    labelMedium: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      color: Colors.black,
    ),
    labelSmall: GoogleFonts.inter(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      color: Colors.black,
    ),
  );

  static ThemeData androidLightTheme = ThemeData(
    textTheme: _lightTextTheme,
    primarySwatch: AppColors.colorPrimarySwatch,
    primaryColor: AppColors.colorPrimary,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.colorPrimary,
      brightness: Brightness.light,
      // primary: AppColors.colorPrimary,
      // secondary: AppColors.colorSecondary,
      // error: AppColors.colorError,
      // surface: Colors.white,
      // background: Color(0xFFFDFDFD),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1A1B1E), // Or another dark surface color
      elevation: 0,
      foregroundColor: Colors.white, // Color for icons and title
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
      fillColor: Colors.white.withValues(alpha: 0.05),
      // A subtle, slightly lighter fill
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      // Ensure icon colors are also light
      iconColor: Colors.white.withValues(alpha: 0.6),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Color(0xFFDADEE7), width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Color(0xFFDADEE7), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: AppColors.colorPrimary, width: 0.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.red, width: 0.5),
      ),
      hintStyle: const TextStyle(color: AppColors.hintTextColor, fontSize: 14),
    ),
    elevatedButtonTheme: appElevatedButtonTheme,
  );
}
