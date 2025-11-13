import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../generated/assets.dart';
import '../../../core/extensions/app_extansions.dart';
import '../../../core/theme/app_text_theme.dart';
import '../../../core/values/app_colors.dart';

class TrainerInfoCard extends StatelessWidget {
  final VoidCallback onPressed;

  const TrainerInfoCard({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      width: Get.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.ligthBorderGrayColor, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Image.asset(Assets.homeCoach, fit: BoxFit.cover, width: 90),
              8.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _proWidget(),
                    4.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Coach Hana',
                          style: AppTextTheme.bodyLargeSemiBold,
                        ),
                        4.width,
                        Expanded(
                          child: Text(
                            '(Strength & Hypertrophy)',
                            style: AppTextTheme.bodySmallRegular.copyWith(
                              color: AppColors.colorPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    4.height,
                    Text(
                      "I tuned today's Push A for your shoulder soreness. Swap incline press for neutral dumbbell press?",
                      style: AppTextTheme.bodySmallRegular,
                    ),
                  ],
                ),
              ),
              // 8.width,
              InkWell(
                onTap: () {},
                child: Icon(Icons.close, color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _proWidget() {
    return Container(
      width: 38,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.colorPrimary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'Pro',
        style: AppTextTheme.bodyLargeMedium.copyWith(color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }
}
