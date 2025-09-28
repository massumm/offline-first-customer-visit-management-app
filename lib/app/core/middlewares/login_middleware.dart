import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/routes/route_middleware.dart';

import '../../data/local/preference/preference_service.dart';
import '../../routes/app_pages.dart';
import '../values/app_keys.dart';

class LoginMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final bool isLoggedIn =
        StorageService.to.getString(StorageKeys.STORAGE_USER_KEY).isNotEmpty;
    if (isLoggedIn == false) {
      return null;
    } else {
      return const RouteSettings(name: Routes.HOME);
    }
  }
}