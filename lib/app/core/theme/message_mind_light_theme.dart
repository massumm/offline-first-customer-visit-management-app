import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../decorations/app_elevated_button_decoration.dart';
import '../values/app_colors.dart';

class IconLightTheme {
  static ThemeData androidLightTheme = ThemeData(
    fontFamily: 'Poppins',
    primarySwatch: AppColors.colorPrimarySwatch,
    primaryColor: AppColors.colorPrimary,
    brightness: Brightness.light,
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
    textTheme: const CupertinoTextThemeData(
      primaryColor: Colors.black,
    ),
  );


  // Bridge: Cupertino theme based on Material theme
  static CupertinoThemeData materialBasedCupertinoTheme =
  MaterialBasedCupertinoThemeData(materialTheme: androidLightTheme);
}

