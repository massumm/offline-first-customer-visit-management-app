import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../decorations/app_elevated_button_decoration.dart';
import '../values/app_colors.dart';

class IconDarkTheme {
  /// Defines the text styling for the dark theme, following Material 3 typography guidelines.
  /// This ensures a consistent look and feel for all text elements in the app.
  static final TextTheme _darkTextTheme = TextTheme(
    displayLarge: GoogleFonts.inter(
      fontSize: 57,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    ),
    displayMedium: GoogleFonts.inter(
      fontSize: 45,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    ),
    displaySmall: GoogleFonts.inter(
      fontSize: 36,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    ),

    headlineLarge: GoogleFonts.inter(
      fontSize: 32,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    ),
    headlineMedium: GoogleFonts.inter(
      fontSize: 28,
      fontWeight: FontWeight.w400,
      color: AppColors.darkTextSecondaryColor,
      height: 1.3
    ),
    headlineSmall: GoogleFonts.inter(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    ),

    titleLarge: GoogleFonts.inter(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      color: Colors.white,
    ),
    titleSmall: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: Colors.white,
    ),

    bodyLarge: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      color: Colors.white.withValues(alpha: 0.9),
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      color: Colors.white.withValues(alpha: 0.9),
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      color: Colors.white.withValues(alpha: 0.9),
    ),

    labelLarge: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: Colors.white,
    ),
    labelMedium: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      color: Colors.white,
    ),
    labelSmall: GoogleFonts.inter(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      color: Colors.white,
    ),
  );

  static ThemeData androidDarkTheme = ThemeData(
    textTheme: _darkTextTheme,
    primarySwatch: AppColors.colorPrimarySwatch,
    primaryColor: AppColors.colorPrimary,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBgColor,
    cardColor: AppColors.cardBgColor,
    useMaterial3: true,
    iconTheme: IconThemeData(
      color: AppColors.darkTextPrimaryColor,
      size: 24

    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: AppColors.darkTextPrimaryColor,
        iconSize: 24,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBgColor,
      elevation: 0,
      foregroundColor: Colors.white,
    ),

    tabBarTheme: TabBarThemeData(
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(width: 2.0, color: AppColors.colorPrimary),
      ),
      labelColor: AppColors.colorPrimary,
      unselectedLabelColor: Colors.white.withValues(alpha: 0.7),
    ),

    cardTheme: CardThemeData(
      elevation: 2,
      color: AppColors.cardBgColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),

    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.cardBgColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),

    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.colorPrimary,
      brightness: Brightness.dark,

      // --- Core Brand Colors ---
      primary: AppColors.colorPrimary,
      onPrimaryContainer: AppColors.darkShapeColor,
      // Assuming AppColors has a secondary color defined
      // secondary: AppColors.colorSecondary,
      error: AppColors.warningColor,

      // --- Surface and Background Colors ---
      // Aligns with scaffoldBackgroundColor
      // Aligns with cardColor and dialogTheme.backgroundColor
      surface: AppColors.darkShapeColor,

      // --- "On" Colors (for text and icons) ---
      // Defines the color of content placed on top of the key colors above.
      // Setting these explicitly ensures high contrast.
      onPrimary: Colors.white,
      // onSecondary: Colors.black,
      onError: AppColors.warningColor,
      onSurface: Colors.white,
      onSurfaceVariant: Colors.white,
      surfaceContainerHighest: AppColors.darkShapeColor,

      // --- Other Colors ---
      // Aligns with the border color used in InputDecorationTheme
      outline: AppColors.darkStockColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkShapeColor,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
      // Lighter hint text
      // Ensure icon colors are also light
      iconColor: Colors.white.withValues(alpha: 0.6),
      // Your border definitions are good, but you might want to adjust the
      // enabledBorder color to be less prominent in a dark theme.
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: AppColors.darkStockColor, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: AppColors.darkStockColor, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: AppColors.colorPrimary, width: 0.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: AppColors.warningColor, width: 0.5),
      ),

    ),
    elevatedButtonTheme: appElevatedButtonTheme,
  );
}
