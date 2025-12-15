import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:icon/app/data/local/preference/preference_service.dart';

class ThemeService extends GetxService {
  late final StorageService _storageService;
  static const _themeModeKey = 'theme_mode';

  final themeMode = ThemeMode.system.obs;

  bool get isDarkMode {
    if (themeMode.value == ThemeMode.system) {
      return SchedulerBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark;
    } else {
      return themeMode.value == ThemeMode.dark;
    }
  }

  /// Initializes the service by loading the saved theme from storage.
  Future<ThemeService> init() async {
    _storageService = Get.find<StorageService>();

    final savedTheme = _storageService.getString(_themeModeKey) as String?;

    if (savedTheme != null) {
      // For now dark is default. but change this to system after first MVP
      themeMode.value = ThemeMode.values.firstWhere(
        (e) => e.name == savedTheme,
        orElse: () => ThemeMode.dark,
        // ThemeMode.system,
      );
    }

    return this;
  }

  void saveThemeMode(ThemeMode mode) {
    themeMode.value = mode;
    _storageService.setString(_themeModeKey, mode.name);
  }
}
