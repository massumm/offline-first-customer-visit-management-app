import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/core/binding/initial_binding.dart';

// Import all theme-related files
import 'app/core/theme/icon_cupertino_theme.dart';
import 'app/core/theme/icon_dark_theme.dart';
import 'app/core/theme/icon_light_theme.dart';
import 'app/core/theme/services/theme_service.dart';
import 'app/data/local/preference/preference_service.dart';
import 'app/flavors/build_config.dart';
import 'app/flavors/env_config.dart';
import 'app/flavors/environment.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Get.putAsync<StorageService>(() => StorageService().init());
  await Get.putAsync<ThemeService>(() => ThemeService().init());

  _setupEnvironment();
  _setupErrorHandling();

  final isIOS = defaultTargetPlatform == TargetPlatform.iOS;

  final themeService = Get.find<ThemeService>();

  runApp(
    isIOS
        ? GetX<ThemeService>(
      // Rebuilds only when theme values change.
      init: themeService,
      builder: (ts) => GetCupertinoApp(
        title: BuildConfig.instance.config.appName,
        debugShowCheckedModeBanner: false,
        initialRoute: AppPages.INITIAL,
        initialBinding: InitialBindings(),
        getPages: AppPages.routes,
        theme: ts.isDarkMode
            ? IconCupertinoTheme.darkTheme
            : IconCupertinoTheme.lightTheme,
      ),
    )
        : GetX<ThemeService>(
      init: themeService,
      builder: (ts) => GetMaterialApp(
        title: BuildConfig.instance.config.appName,
        debugShowCheckedModeBanner: false,
        initialRoute: AppPages.INITIAL,
        initialBinding: InitialBindings(),
        getPages: AppPages.routes,
        theme: IconLightTheme.androidLightTheme,
        darkTheme: IconDarkTheme.androidDarkTheme,
        themeMode: ts.themeMode,
      ),
    ),
  );
}


Future<void> _setupEnvironment() {
  final config = EnvConfig(
    appName: "Icon Train Smarter",
    productionUrl: "https://api.icontraining.app",
    devUrl: "http://localhost:8000",
    mediaProductionUrl: "",
    mediaDevUrl: "",
    socketProductionUrl: "",
    socketDevUrl: "",
    wsProductionUrl: "",
    wsDevUrl: "",
    shouldCollectCrashLog: true,
  );

  Environment environment = Environment.PRODUCTION;

  if (kReleaseMode) {
    environment = Environment.PRODUCTION;
  }

  BuildConfig.instantiate(envType: environment, envConfig: config);

  return Future.value();
}

// Updated to be theme-aware
Future<void> _setupErrorHandling() {
  ErrorWidget.builder = (FlutterErrorDetails details) {
    final bool inDebug = kDebugMode;
    final bool isIOS = defaultTargetPlatform == TargetPlatform.iOS;
    // Safely check the theme mode
    final bool isDarkMode = Get.isRegistered<ThemeService>()
        ? Get.find<ThemeService>().isDarkMode
        : true; // Default to dark if service isn't ready

    if (isIOS) {
      final theme = isDarkMode
          ? IconCupertinoTheme.darkTheme
          : IconCupertinoTheme.lightTheme;
      return CupertinoPageScaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.exclamationmark_circle,
                      color: theme.primaryColor,
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Something went wrong',
                      style: theme.textTheme.navTitleTextStyle.copyWith(
                        fontSize: 24,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      inDebug
                          ? details.exceptionAsString()
                          : 'An unexpected error occurred.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.textStyle.copyWith(
                        fontSize: 16,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    // Fallback to the Material error widget
    final theme = isDarkMode
        ? IconDarkTheme.androidDarkTheme
        : IconLightTheme.androidLightTheme;
    return Material(
      color: theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: theme.colorScheme.primary,
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Something went wrong',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    inDebug
                        ? details.exceptionAsString()
                        : 'An unexpected error occurred.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  };

  return Future.value();
}