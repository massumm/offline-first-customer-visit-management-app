import 'package:flutter/material.dart';

import '../values/app_colors.dart';

class IconDarkTheme {
  static ThemeData androidDarkTheme = ThemeData(
    fontFamily: 'Poppins',
    primarySwatch: AppColors.colorPrimarySwatch,
    primaryColor: AppColors.colorPrimary,
    brightness: Brightness.dark,
  );
}
