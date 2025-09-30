import 'package:flutter/material.dart';

import '../decorations/app_elevated_button_decoration.dart';
import '../values/app_colors.dart';

class IconDarkTheme {
  static ThemeData androidDarkTheme =  ThemeData(
    fontFamily: 'Poppins',
    primarySwatch: AppColors.colorPrimarySwatch,
    primaryColor: AppColors.colorPrimary,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121214),
    cardColor: const Color(0xFF1A1B1E),
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.colorPrimary,
      brightness: Brightness.dark,
      primary: AppColors.colorPrimary,
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
}
