import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';

class InfoCardWidget extends StatelessWidget {
  const InfoCardWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.isGradient = false,
    this.iconType = IconType.svg,
  });

  final String icon;
  final String title;
  final String description;
  final bool isGradient;
  final IconType iconType;

  @override
  Widget build(BuildContext context) {
    if (isGradient) {
      return Container(
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: [Color(0xFFE9522B), Color(0xFF007BF7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: _buildInnerCard(),
      );
    }
    return _buildInnerCard();
  }

  Widget _buildInnerCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Get.theme.cardTheme.color,
        borderRadius: BorderRadius.circular(isGradient ? 11 : 12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildIcon(),
              8.width,
              Text(
                title,
                style: Get.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          16.height,
          Text(
            description,
            style: Get.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    if (iconType == IconType.svg) {
      return SvgPicture.asset(
        icon,
        height: 40,
        width: 40,
      );
    }
    return Image.asset(
      icon,
      height: 40,
      width: 40,
    );
  }
}

enum IconType { svg, asset }
