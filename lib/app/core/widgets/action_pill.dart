import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:icon/app/core/values/app_colors.dart';

class ActionPill extends StatelessWidget {
  const ActionPill({
    super.key,
    required this.onTap,
    this.icon = Icons.arrow_back_ios_new_rounded,
    this.height = 32,
    this.width = 32,
    this.iconSize = 16,
    this.darBgColor,
  });

  final VoidCallback onTap;
  final IconData icon;
  final double height;
  final double width;
  final double iconSize;
  final Color? darBgColor;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Get.isDarkMode
              ? darBgColor ?? theme.colorScheme.onPrimaryContainer
              : theme.colorScheme.onPrimaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: iconSize, color: theme.iconTheme.color),
      ),
    );
  }
}
