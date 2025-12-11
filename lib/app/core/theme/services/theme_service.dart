import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/data/local/preference/preference_service.dart';

class ThemeService extends GetxService {
  final _storageService = Get.find<StorageService>();
  final _themeKey = 'theme_mode';

  final _themeMode = ThemeMode.system.obs;

  ThemeMode get themeMode => _themeMode.value;

  bool get isDarkMode {
    if (_themeMode.value == ThemeMode.system) {
      return Get.isPlatformDarkMode;
    } else {
      return _themeMode.value == ThemeMode.dark;
    }
  }

  Future<ThemeService> init() async {
    _themeMode.value = ThemeMode.dark;
    await _saveThemeToStorage(ThemeMode.dark);
    return this;
  }

  void changeThemeMode(ThemeMode newThemeMode) {
    if (_themeMode.value == newThemeMode) return;

    _themeMode.value = newThemeMode;
    _saveThemeToStorage(newThemeMode);
  }

  void switchTheme() {
    changeThemeMode(isDarkMode ? ThemeMode.light : ThemeMode.dark);
  }

  ThemeMode _getThemeModeFromString(String? themeString) {
    switch (themeString) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> _saveThemeToStorage(ThemeMode themeMode) async {
    await _storageService.setString(_themeKey, themeMode.name);
  }
}
