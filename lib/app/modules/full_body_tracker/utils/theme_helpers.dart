import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/core/values/app_colors.dart';

class ThemeHelpers {
  static Color get primaryCardColor =>
      Get.isDarkMode ? AppColors.darkBgColorSecondary : Colors.white;
      
  static Color get secondaryCardColor =>
      Get.isDarkMode ? AppColors.darkBgColor : AppColors.lightBgColorSecondary;
      
  static Color get primaryTextColor =>
      Get.isDarkMode ? Colors.white : AppColors.black;
      
  static Color get secondaryTextColor =>
      Get.isDarkMode ? Colors.white : AppColors.black;

      
  static Color get tagBackgroundColor =>
      Get.isDarkMode ? AppColors.darkBgColor : AppColors.colorSecondary;
      
  static String getExerciseIconPath(String lightAsset, String darkAsset) {
    return Get.isDarkMode ? darkAsset : lightAsset;
  }
}
