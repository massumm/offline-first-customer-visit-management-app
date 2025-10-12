import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/data/local/preference/preference_service.dart';

class ThemeService extends GetxService {
  final _storage = Get.find<StorageService>();
  final _themeModeKey = 'theme_mode';

  // Reactive variable to hold the theme mode
  late final Rx<ThemeMode> _themeMode;

  // Public getter to access the current theme mode
  ThemeMode get themeMode => _themeMode.value;

  // Public getter to easily check if dark mode is enabled
  bool get isDarkMode {
    if (_themeMode.value == ThemeMode.system) {
      // Use platform brightness if theme is set to system
      return Get.mediaQuery.platformBrightness == Brightness.dark;
    }
    return _themeMode.value == ThemeMode.dark;
  }

  // Initialize the service by loading the theme from storage
  Future<ThemeService> init() async {
    _themeMode = _loadThemeFromStorage().obs;
    return this;
  }

  // Load theme from local storage
  ThemeMode _loadThemeFromStorage() {
    final themeString = _storage.getString(_themeModeKey);
    switch (themeString) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.system; // Default to system theme
    }
  }

  // Save theme to local storage
  Future<void> _saveThemeToStorage(ThemeMode themeMode) async {
    await _storage.setString(_themeModeKey, themeMode.name);
  }

  // Switch between light and dark themes
  void switchTheme() {
    final newThemeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    _themeMode.value = newThemeMode;
    _saveThemeToStorage(newThemeMode);
  }
}