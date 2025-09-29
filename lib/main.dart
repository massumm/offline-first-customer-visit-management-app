import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/core/binding/initial_binding.dart';
import 'app/core/theme/message_mind_dark_theme.dart';
import 'app/routes/app_pages.dart';

void main() {
  runApp(
    GetMaterialApp(
      title: "Icon",
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      initialBinding: InitialBindings(),
      getPages: AppPages.routes,
      theme: IconDarkTheme.androidDarkTheme,
      darkTheme: IconDarkTheme.androidDarkTheme,
    ),
  );
}
