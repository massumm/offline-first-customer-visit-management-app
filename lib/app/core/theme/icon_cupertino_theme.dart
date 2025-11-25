import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../values/app_colors.dart';

class IconCupertinoTheme {

  static CupertinoThemeData darkTheme = CupertinoThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.colorPrimary,
    scaffoldBackgroundColor: AppColors.darkBgColor,
    barBackgroundColor: AppColors.darkShapeColor,
    textTheme: const CupertinoTextThemeData(
      primaryColor: CupertinoColors.white,
      textStyle: TextStyle(
        color: CupertinoColors.white,
        fontFamily: '.SF Pro Text',
      ),
      navTitleTextStyle: TextStyle(
        color: CupertinoColors.white,
        fontWeight: FontWeight.w600,
        fontFamily: '.SF Pro Display',
      ),
    ),
  );


  static CupertinoThemeData lightTheme = CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.colorPrimary,
    scaffoldBackgroundColor: AppColors.lightBgColor,
    barBackgroundColor: AppColors.lightShapeColor,
    textTheme: const CupertinoTextThemeData(
      primaryColor: CupertinoColors.black,
      textStyle: TextStyle(
        color: CupertinoColors.black,
        fontFamily: '.SF Pro Text',
      ),
      navTitleTextStyle: TextStyle(
        color: CupertinoColors.black,
        fontWeight: FontWeight.w600,
        fontFamily: '.SF Pro Display',
      ),
    ),
    applyThemeToAll: true,
  );


  static CupertinoThemeData fromColorScheme(ColorScheme scheme) {
    final isDark = scheme.brightness == Brightness.dark;

    return CupertinoThemeData(
      brightness: scheme.brightness,
      primaryColor: scheme.primary,
      scaffoldBackgroundColor:
      isDark ? AppColors.darkBgColor : AppColors.lightBgColor,
      barBackgroundColor:
      isDark ? AppColors.darkShapeColor : AppColors.lightShapeColor,
      textTheme: CupertinoTextThemeData(
        primaryColor: isDark ? CupertinoColors.white : CupertinoColors.black,
        textStyle: TextStyle(
          color: isDark ? CupertinoColors.white : CupertinoColors.black,
          fontFamily: '.SF Pro Text',
        ),
        navTitleTextStyle: TextStyle(
          color: isDark ? CupertinoColors.white : CupertinoColors.black,
          fontWeight: FontWeight.w600,
          fontFamily: '.SF Pro Display',
        ),
      ),
      applyThemeToAll: true,
    );
  }

  static CupertinoThemeData fromMaterial(ThemeData material) {
    final colorScheme = material.colorScheme;
    final isDark = material.brightness == Brightness.dark;

    return CupertinoThemeData(
      brightness: material.brightness,
      primaryColor: colorScheme.primary,

      // Match Material surfaces
      scaffoldBackgroundColor:
      isDark ? AppColors.darkBgColor : AppColors.lightBgColor,
      barBackgroundColor:
      isDark ? AppColors.darkShapeColor : AppColors.lightShapeColor,

      textTheme: CupertinoTextThemeData(
        primaryColor: isDark ? CupertinoColors.white : CupertinoColors.black,
        textStyle: TextStyle(
          color: isDark ? CupertinoColors.white : CupertinoColors.black,
          fontFamily: '.SF Pro Text',
        ),
        navTitleTextStyle: TextStyle(
          color: isDark ? CupertinoColors.white : CupertinoColors.black,
          fontWeight: FontWeight.w600,
          fontFamily: '.SF Pro Display',
        ),
      ),
      applyThemeToAll: true,
    );
  }
  
  static CupertinoThemeData adaptive(Brightness brightness) {
    return brightness == Brightness.dark ? darkTheme : lightTheme;
  }
}
