import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/core/widgets/action_pill.dart';

class ReportMenuItemWidget extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const ReportMenuItemWidget({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: Get.theme.cardTheme.color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          ActionPill(
            onTap: onTap,
            icon: Icons.arrow_forward_ios,
          ),
        ],
      ),
    );
  }
}
