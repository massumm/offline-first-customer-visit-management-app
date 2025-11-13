import 'package:flutter/material.dart';

import '../values/app_colors.dart';

Size get buttonFixedSize => const Size(double.maxFinite, 42);
final BorderRadius borderRadius = BorderRadius.circular(12);

TextStyle get btnTextStyle {
  return const TextStyle(
    fontSize: 14,
    height: 24 / 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}

ElevatedButtonThemeData get appElevatedButtonTheme {
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
