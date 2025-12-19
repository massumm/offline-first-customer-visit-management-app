// lib/app/core/widgets/custom_app_bar.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/generated/assets.dart'; // Make sure this path is correct// A reusable AppBar widget for the application.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = true, // Default to true as it's a common case
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // 1. Conditionally show the back button
      leading: showBackButton
          ? IconButton(
        icon: Image.asset(
          Assets.imagesBackButton, // Using the image asset
          width: 40,
          height: 40,
        ),
        onPressed: () => Get.back(),
      )
          : null,
      title: Text(title),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: actions,
    );
  }

  // 2. Implement PreferredSizeWidget to give the AppBar a specific height
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
