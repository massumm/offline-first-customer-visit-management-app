// In login_middleware.dart (example)
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/data/local/preference/preference_service.dart';

import '../../routes/app_pages.dart';
import '../values/app_keys.dart'; // Correct path
// Or your route names

class LoginMiddleware extends GetMiddleware {
  @override
  int? get priority => 1; // Example priority

  @override
  RouteSettings? redirect(String? route) {
    final isLoggedIn = StorageService.to.getString(StorageKeys.STORAGE_USER_KEY).isNotEmpty;

    if (!isLoggedIn && route != Routes.SPLASH) {
      return RouteSettings(name: Routes.HOME);
    }
    return null;
  }
}