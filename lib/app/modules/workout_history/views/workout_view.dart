import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/theme/app_text_theme.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/generated/assets.dart';

import '../controllers/workout_history_controller.dart';

class WorkoutView extends StatelessWidget {
  const WorkoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WorkoutHistoryController>(
      builder: (controller) => history(controller),
    );
  }

  Widget history(WorkoutHistoryController controller) => SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        16.height,
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Workouts', style: AppTextTheme.bodySmallRegular),
                    8.height,
                    Text(controller.totalWorkoutsCount.toString(), style: AppTextTheme.titleSmallSemiBold.copyWith(color: AppColors.colorPrimary))
                  ],
                ),
              ),
            ),
            16.width,
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Avg Volume', style: AppTextTheme.bodySmallRegular),
                    8.height,
                    Text('${controller.averageVolume.toStringAsFixed(0)} kg', style: AppTextTheme.titleSmallSemiBold.copyWith(color: AppColors.colorPrimary))
                  ],
                ),
              ),
            ),
            16.width,
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Peak Weight', style: AppTextTheme.bodySmallRegular),
                    8.height,
                    Text('${controller.peakWeightValue.toStringAsFixed(0)} kg', style: AppTextTheme.titleSmallSemiBold.copyWith(color: AppColors.colorPrimary))
                  ],
                ),
              ),
            ),
          ],
        ),
        16.height,
        Text('Workout History', style: AppTextTheme.titleMediumRegular),
        16.height,
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: controller.dumbbellSquats.length,
          itemBuilder: (context, index) {
            final workout = controller.dumbbellSquats[index];
            return Container(
              margin: EdgeInsets.only(bottom: 8),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 16, color: AppColors.lightTextSecondaryColor),
                          8.width,
                          Text(
                            '${_getMonthAbbreviation(workout.date.month)} ${workout.date.day}, ${workout.date.year}',
                            style: AppTextTheme.bodyLargeRegular.copyWith(color: AppColors.lightTextPrimaryColor)
                          ),
                        ],
                      ),
                      const Spacer(),
                      // based on progress show upward, downward or no progress
                      SvgPicture.asset(
                        workout.progressDirection == ProgressDirection.upward 
                          ? Assets.activityTrackerProgressUp
                          : workout.progressDirection == ProgressDirection.downward 
                            ? Assets.activityTrackerProgressDown
                            : Assets.activityTrackerProgressNone,
                        width: 16,
                        color: workout.progressDirection == ProgressDirection.upward 
                          ? AppColors.greenColor 
                          : workout.progressDirection == ProgressDirection.downward 
                            ? AppColors.bgColorRed
                            : AppColors.lightTextSecondaryColor,
                      ),
                      8.width,
                      Text(
                        '${workout.progressPercentage}%', 
                        style: AppTextTheme.bodyMediumRegular.copyWith(
                          color: workout.progressDirection == ProgressDirection.upward 
                            ? AppColors.greenColor 
                            : workout.progressDirection == ProgressDirection.downward 
                              ? AppColors.bgColorRed
                              : AppColors.lightTextSecondaryColor
                        )
                      )
                    ]
                  ),
                  16.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Sets', style: AppTextTheme.bodySmallRegular.copyWith(color: AppColors.lightTextSecondaryColor)),
                          8.height,
                          Text(workout.noOfSets.toString(), style: AppTextTheme.bodyLargeSemiBold.copyWith(color: AppColors.lightTextPrimaryColor))
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Volume (kg)', style: AppTextTheme.bodySmallRegular.copyWith(color: AppColors.lightTextSecondaryColor)),
                          8.height,
                          Text(workout.volumeKg.toString(), style: AppTextTheme.bodyLargeSemiBold.copyWith(color: AppColors.lightTextPrimaryColor))
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Max Weight', style: AppTextTheme.bodySmallRegular.copyWith(color: AppColors.lightTextSecondaryColor)),
                          8.height,
                          Text('${workout.maxWeightKg} kg', style: AppTextTheme.bodyLargeSemiBold.copyWith(color: AppColors.lightTextPrimaryColor))
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Duration', style: AppTextTheme.bodySmallRegular.copyWith(color: AppColors.lightTextSecondaryColor)),
                          8.height,
                          Text('${workout.duration.inMinutes} min', style: AppTextTheme.bodyLargeSemiBold.copyWith(color: AppColors.lightTextPrimaryColor))
                        ],
                      ),
                    ]
                  )
                ]
              ),
            );
          },
        )
      ],
    ),
  );

  String _getMonthAbbreviation(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}
