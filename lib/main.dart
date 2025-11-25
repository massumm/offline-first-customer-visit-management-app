import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';

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
import 'firebase_options.dart';

// final String token = UserStore.to.token;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await _setupFirebase();

  await _initCrashlytics();

  await Get.putAsync<StorageService>(() => StorageService().init());
  await Get.putAsync<ThemeService>(() => ThemeService().init());

  _setupEnvironment();
  _setupErrorHandling();

  final themeService = Get.find<ThemeService>();
  final isIOS = GetPlatform.isIOS; // from get package

  runApp(
    isIOS
        ? GetX<ThemeService>(
            init: themeService,
            builder: (ts) {
              // respect ThemeMode on iOS too
              final platformDark =
                  WidgetsBinding
                      .instance
                      .platformDispatcher
                      .platformBrightness ==
                  Brightness.dark;
              final useDark =
                  ts.themeMode == ThemeMode.dark ||
                  (ts.themeMode == ThemeMode.system && platformDark);

              final cupertinoTheme = useDark
                  ? IconCupertinoTheme.darkTheme
                  : IconCupertinoTheme.lightTheme;

              final materialTheme = useDark
                  ? IconDarkTheme.androidDarkTheme
                  : IconLightTheme.androidLightTheme;

              return GetCupertinoApp(
                title: BuildConfig.instance.config.appName,
                debugShowCheckedModeBanner: false,
                initialRoute: AppPages.INITIAL,
                initialBinding: InitialBindings(),
                getPages: AppPages.routes,
                theme: cupertinoTheme,
                builder: (context, child) {
                  return Theme(
                    data: materialTheme,
                    child: Localizations(
                      locale: const Locale('en'),
                      delegates: const [
                        DefaultWidgetsLocalizations.delegate,
                        DefaultMaterialLocalizations.delegate,
                        DefaultCupertinoLocalizations.delegate,
                      ],
                      child: child ?? const SizedBox.shrink(),
                    ),
                  );
                },

              );
            },
          )
        : GetX<ThemeService>(
            init: themeService,
            builder: (ts) {
              'Loaded theme: ${ts.themeMode.name}'.log();
              return GetMaterialApp(
                title: BuildConfig.instance.config.appName,
                debugShowCheckedModeBanner: false,
                initialRoute: AppPages.INITIAL,
                initialBinding: InitialBindings(),
                getPages: AppPages.routes,
                theme: IconLightTheme.androidLightTheme,
                darkTheme: IconDarkTheme.androidDarkTheme,
                themeMode: ts.themeMode,
                // Wrap with Cupertino Theme so any Cupertino widgets on Android match brand
                builder: (context, child) => CupertinoTheme(
                  // cupertino-in-material
                  data: IconCupertinoTheme.fromMaterial(Theme.of(context)),
                  child: child ?? const SizedBox.shrink(),
                ),
              );
            },
          ),
  );
}

Future<void> _setupFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

Future<void> _initCrashlytics() async {
  if (kReleaseMode) {
    // init firebase crashlytics
    FlutterError.onError = (FlutterErrorDetails details) async {
      FirebaseCrashlytics.instance.recordFlutterFatalError(details);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      if (kReleaseMode) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      }
      return true;
    };
  }
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
