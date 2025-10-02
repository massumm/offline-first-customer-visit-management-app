import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/core/binding/initial_binding.dart';

import 'app/core/theme/icon_dark_theme.dart';
import 'app/data/local/preference/preference_service.dart';
import 'app/data/local/preference/store/user_store.dart';
import 'app/flavors/build_config.dart';
import 'app/flavors/env_config.dart';
import 'app/flavors/environment.dart';
import 'app/routes/app_pages.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Local Storage
 await Get.putAsync<StorageService>(() => StorageService().init());

  _setupEnvironment();
  _setupErrorHandling();

  runApp(
    GetMaterialApp(
      title: BuildConfig.instance.config.appName,
      debugShowCheckedModeBanner: false,
      initialRoute: UserStore.to.isLoggedIn ? Routes.HOME : AppPages.INITIAL,
      initialBinding: InitialBindings(),
      getPages: AppPages.routes,
      theme: IconDarkTheme.androidDarkTheme,
      darkTheme: IconDarkTheme.androidDarkTheme,
    ),
  );
}

Future<void> _setupEnvironment() {
  final config = EnvConfig(
    appName: "Icon",
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

Future<void> _setupErrorHandling() {
  ErrorWidget.builder = (FlutterErrorDetails details) {
    final bool inDebug = kDebugMode;

    return Material(
      color: Colors.black,
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.orangeAccent,
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Something went wrong',
                    style: TextStyle(
                      color: Colors.orangeAccent,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    inDebug
                        ? details.exceptionAsString()
                        : 'An unexpected error occurred. Please try again later.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  if (inDebug) ...[
                    const SizedBox(height: 12),
                    Text(
                      details.stack?.toString() ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
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
