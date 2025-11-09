import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../decorations/app_elevated_button_decoration.dart';
import '../values/app_colors.dart';

class IconLightTheme {
  /// Defines the text styling for the light theme, following Material 3 typography guidelines.
  /// This ensures a consistent look and feel for all text elements in the app.
  static final TextTheme _lightTextTheme = TextTheme(
    displayLarge: GoogleFonts.inter(
      fontSize: 56,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
    displayMedium: GoogleFonts.inter(
      fontSize: 36,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
    displaySmall: GoogleFonts.inter(
      fontSize: 32,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),

    headlineLarge: GoogleFonts.inter(
      fontSize: 28,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
    headlineMedium: GoogleFonts.inter(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      color: AppColors.lightTextSecondaryColor,
      height: 1.3,
    ),
    headlineSmall: GoogleFonts.inter(
      fontSize: 22,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),

    titleLarge: GoogleFonts.inter(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.lightTextPrimaryColor,
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
      color: AppColors.lightTextPrimaryColor,
    ),
    titleSmall: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      color: AppColors.lightTextPrimaryColor,
    ),

    bodyLarge: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      color: AppColors.lightTextSecondaryColor,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      color: AppColors.lightTextSecondaryColor,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: 10,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      color: AppColors.lightTextSecondaryColor,
    ),

    labelLarge: GoogleFonts.inter(
      fontSize: 9,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: AppColors.lightTextSecondaryColor,
    ),
    labelMedium: GoogleFonts.inter(
      fontSize: 8,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      color: AppColors.lightTextSecondaryColor,
    ),
    labelSmall: GoogleFonts.inter(
      fontSize: 8,
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
      onPrimaryContainer: AppColors.lightShapeColor,
      secondary: AppColors.greenColor,
      tertiary: AppColors.informationColor,
      error: AppColors.warningColor,
      surface: AppColors.lightBgColor,
      onSurface: AppColors.lightTextPrimaryColor,
      // Explicitly set for text/icons on surface
      surfaceContainerHighest: Colors.white,
    ),
    iconTheme: IconThemeData(color: AppColors.lightTextPrimaryColor, size: 24),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: AppColors.lightTextPrimaryColor,
        iconSize: 24,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.lightBgColor,
      elevation: 0,
      titleTextStyle: _lightTextTheme.titleMedium,
      iconTheme: IconThemeData(
        color: AppColors.lightTextPrimaryColor,
        size: 24,
      ),
      foregroundColor: AppColors.lightBgColor,
      surfaceTintColor: AppColors.lightBgColor,
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      color:AppColors.lightShapeColor,
      // Corrected: Use a light color for cards in light theme
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.lightShapeColor,
      // Corrected: Use a light color for dialogs in light theme
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColors.lightShapeColor,
    ),

    tabBarTheme: TabBarThemeData(
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(width: 2.0, color: AppColors.colorPrimary),
      ),
      labelColor: AppColors.colorPrimary,
      unselectedLabelColor:
          AppColors.lightTextSecondaryColor, // Corrected: Use a visible color
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.lightStockColor,
      thickness: 1,
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
        borderSide: BorderSide(
          color: AppColors.lightInputBorderColor,
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color: AppColors.lightInputBorderColor,
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: AppColors.colorPrimary, width: 0.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: AppColors.warningColor, width: 0.5),
      ),
      hintStyle: const TextStyle(
        color: AppColors.lightHintTextColor,
        fontSize: 14,
      ),
    ),
    elevatedButtonTheme: appElevatedButtonTheme,
  );
}
