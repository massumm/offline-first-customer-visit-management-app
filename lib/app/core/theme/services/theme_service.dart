import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/data/local/preference/preference_service.dart';

class ThemeService extends GetxService {
  final _storageService = Get.find<StorageService>();
  final _themeKey = 'theme_mode';

  // An observable for the current theme mode.
  // It's initialized with a default and updated from storage in init().
  final _themeMode = ThemeMode.system.obs;

  /// Returns the current [ThemeMode].
  ThemeMode get themeMode => _themeMode.value;

  /// Returns true if the current effective theme is dark.
  /// This getter is now safe to call at any time, even before the app is built.
  bool get isDarkMode {
    if (_themeMode.value == ThemeMode.system) {
      // Use Get.isPlatformDarkMode, which safely checks the platform's
      // brightness without needing a BuildContext.
      return Get.isPlatformDarkMode;
    } else {
      // Otherwise, respect the user's explicit choice.
      return _themeMode.value == ThemeMode.dark;
    }
  }

  /// Initializes the service by loading the saved theme from storage.
  Future<ThemeService> init() async {
    //final savedTheme = _storageService.getString(_themeKey);
    //_themeMode.value = _getThemeModeFromString(savedTheme);
    //return this;

    _themeMode.value = ThemeMode.dark;
    await _saveThemeToStorage(ThemeMode.dark);
    return this;
  }

  /// Changes the application's theme and persists the choice.
  /// This provides more flexibility than a simple toggle.
  void changeThemeMode(ThemeMode newThemeMode) {
    if (_themeMode.value == newThemeMode) return;

    _themeMode.value = newThemeMode;
    _saveThemeToStorage(newThemeMode);
  }

  /// A convenience method to toggle between light and dark modes.
  /// This will take the user out of `ThemeMode.system`.
  void switchTheme() {
    changeThemeMode(isDarkMode ? ThemeMode.light : ThemeMode.dark);
  }

  /// A helper to convert the stored string back to a [ThemeMode] enum.
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

  /// A helper to save the [ThemeMode] to storage as a string.
  Future<void> _saveThemeToStorage(ThemeMode themeMode) async {
    await _storageService.setString(_themeKey, themeMode.name);
  }
}
