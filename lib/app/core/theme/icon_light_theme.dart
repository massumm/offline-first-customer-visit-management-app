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
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      isDense: true,
      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
      fillColor: Colors.white,
      hintStyle: const TextStyle(color: AppColors.hintTextColor, fontSize: 14),
    ),
    elevatedButtonTheme: appElevatedButtonTheme,
  );

  // iOS (Cupertino) Theme
  static CupertinoThemeData iOSLightTheme = CupertinoThemeData(
    primaryColor: AppColors.colorPrimary,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    textTheme: const CupertinoTextThemeData(primaryColor: Colors.black),
  );

  // Bridge: Cupertino theme based on Material theme
  static CupertinoThemeData materialBasedCupertinoTheme =
      MaterialBasedCupertinoThemeData(materialTheme: androidLightTheme);
}
