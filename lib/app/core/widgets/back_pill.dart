import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/core/theme/services/theme_service.dart';

class BackPill extends StatelessWidget {
  const BackPill({super.key, required this.onTap, this.height = 32, this.width = 32});

  final VoidCallback onTap;
  final double height;
  final double width;

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
          color: theme.colorScheme.onPrimaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child:  Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 16,
          color: theme.iconTheme.color
        ),
      ),
    );
  }
}