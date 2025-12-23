import 'package:flutter/material.dart';

import '../values/app_colors.dart';

Size get buttonFixedSize => const Size(double.maxFinite, 52);
final BorderRadius borderRadius = BorderRadius.circular(12);

TextStyle get btnTextStyle {
  return const TextStyle(
    fontSize: 14,
    height: 24 / 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}

ElevatedButtonThemeData get appElevatedButtonThemeLight {
  return ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.colorPrimary,
      foregroundColor: Colors.white,
      fixedSize: buttonFixedSize,
      textStyle: btnTextStyle,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      elevation: 0,
    ),
  );
}

ElevatedButtonThemeData get appElevatedButtonThemeDark {
  return ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.colorPrimary,
      foregroundColor: Colors.white,
      fixedSize: buttonFixedSize,
      textStyle: btnTextStyle,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
        side: BorderSide(color: AppColors.darkStockColor, width: 1),
      ),
      elevation: 0,
    ),
  );
}
