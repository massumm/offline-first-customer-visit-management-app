import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../decorations/app_elevated_button_decoration.dart';
import '../values/app_colors.dart';

class IconDarkTheme {
  /// Defines the text styling for the dark theme, following Material 3 typography guidelines.
  /// This ensures a consistent look and feel for all text elements in the app.
  static final TextTheme _darkTextTheme = TextTheme(
    displayLarge: GoogleFonts.inter(
      fontSize: 56,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    ),
    displayMedium: GoogleFonts.inter(
      fontSize: 36,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    ),
    displaySmall: GoogleFonts.inter(
      fontSize: 32,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    ),

    headlineLarge: GoogleFonts.inter(
      fontSize: 28,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    ),
    headlineMedium: GoogleFonts.inter(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      color: AppColors.darkTextSecondaryColor,
      height: 1.3,
    ),
    headlineSmall: GoogleFonts.inter(
      fontSize: 22,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    ),

    titleLarge: GoogleFonts.inter(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: AppColors.darkTextPrimaryColor,
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      color: AppColors.darkTextPrimaryColor,
    ),
    titleSmall: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      height: 1.50,
      color: AppColors.darkTextPrimaryColor,
    ),

    bodyLarge: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      color: Colors.white.withValues(alpha: 0.9),
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      color: Colors.white.withValues(alpha: 0.9),
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: 10,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      color: Colors.white.withValues(alpha: 0.9),
    ),

    labelLarge: GoogleFonts.inter(
      fontSize: 9,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: Colors.white,
    ),
    labelMedium: GoogleFonts.inter(
      fontSize: 8,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      color: Colors.white,
    ),
    labelSmall: GoogleFonts.inter(
      fontSize: 8,
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
    iconTheme: IconThemeData(color: AppColors.darkTextPrimaryColor, size: 24),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: AppColors.darkTextPrimaryColor,
        iconSize: 24,
      ),
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.darkStockColor,
      thickness: 1,
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
      color: AppColors.darkShapeColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),

    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.darkShapeColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),

    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColors.darkShapeColor,
    ),

    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.colorPrimary,
      brightness: Brightness.dark,

      // --- Core Brand Colors ---
      primary: AppColors.colorPrimary,
      onPrimaryContainer: AppColors.darkShapeColor,
      secondary: AppColors.activityPrimaryColor,
      secondaryContainer: AppColors.activitySecondaryColor,
      onSecondaryContainer: AppColors.darkTextPrimaryColor,

      error: AppColors.warningColor,

      surface: AppColors.darkShapeColor,

      onPrimary: Colors.white,

      onError: AppColors.warningColor,
      onSurface: Colors.white,
      onSurfaceVariant: Colors.white,
      surfaceContainerHighest: AppColors.darkShapeColor,

      outline: AppColors.darkStockColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkShapeColor,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),

      iconColor: Colors.white.withValues(alpha: 0.6),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.darkStockColor, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.darkStockColor, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.colorPrimary, width: 0.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.warningColor, width: 0.5),
      ),
    ),
    elevatedButtonTheme: appElevatedButtonThemeDark,
    // textButtonTheme: TextButtonThemeData(
    //   style: TextButton.styleFrom(
    //     backgroundColor: Colors.grey[800],
    //     foregroundColor: Colors.white,
    //     elevation: 2,
    //     shadowColor: Colors.black,
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(14),
    //     ),
    //     textStyle: const TextStyle(
    //       fontWeight: FontWeight.w600,
    //     ),
    //   ),
    // ),
  );
}
