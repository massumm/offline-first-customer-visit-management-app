import 'package:flutter/material.dart';

import '../../routes/app_pages.dart';

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
      return const RouteSettings(name: Routes.MAIN);
    }
  }
}