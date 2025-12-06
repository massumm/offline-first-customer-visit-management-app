import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:icon/app/core/values/app_colors.dart';

class AssetIconContainer extends StatelessWidget {
  final String iconPath;
  final double width;
  final double height;
  final BoxShape shape;
  final EdgeInsets padding;

  const AssetIconContainer({
    super.key,
    required this.iconPath,
    this.width = 28,
    this.height = 28,
    this.shape = BoxShape.circle,
    this.padding = const EdgeInsets.all(8),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Get.isDarkMode
            ? AppColors.darkBgColor
            : AppColors.iconBgColorLight,
        shape: shape,
        borderRadius: shape == BoxShape.rectangle
            ? BorderRadius.circular(12)
            : null,
      ),
      child: SvgPicture.asset(iconPath, width: width, height: height),
    );
  }
}
