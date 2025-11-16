import 'package:flutter/material.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/theme/app_text_theme.dart';
import 'package:icon/app/core/values/app_colors.dart';

class WeekCard extends StatelessWidget {
  final String weekName;
  final bool isSelected;
  final VoidCallback onTap;

  const WeekCard({
    super.key,
    required this.weekName,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final nameParts = weekName.split(' ');
    final firstPart = nameParts.isNotEmpty ? nameParts[0] : '';
    final secondPart = nameParts.length > 1 ? nameParts[1] : '';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.colorPrimary : AppColors.lightBorderGrayColor,
          ),
        ),
        child: Column(
          children: [
            Text(
              firstPart,
              style: AppTextTheme.bodyMediumRegular,
            ),
            4.height,
            Text(
              secondPart,
              style: AppTextTheme.bodyMediumSemiBold.copyWith(
                color: AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
