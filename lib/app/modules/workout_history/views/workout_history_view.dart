import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/theme/app_text_theme.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/core/widgets/action_pill.dart';

import '../controllers/workout_history_controller.dart';

class WorkoutHistoryView extends BaseView<WorkoutHistoryController> {
  WorkoutHistoryView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      leading: SizedBox(
        height: 32,
        width: 32,
        child: Center(
          child: ActionPill(onTap: () => Navigator.maybePop(context)),
        ),
      ),
      title: Text('Dumbbell Squat'),
      centerTitle: true,
    );
  }

  @override
  Widget body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: DefaultTabController(
        length: 3,
        child: Obx(() {
          return Column(
          children: [
          Container(
          color: Colors.white,

          child: TabBar(
            onTap: (index) => controller.selectedTabIndex.value = index,
            dividerColor: Colors.transparent ,
            indicator: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            indicatorPadding: EdgeInsets.symmetric(horizontal: -16, vertical: 4),
            tabs: [
              Tab(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: controller.selectedTabIndex.value == 0 ? Colors.white : Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('History'),
                ),
              ),
              Tab(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: controller.selectedTabIndex.value == 1 ? Colors.white : Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('Charts'),
                ),
              ),
              Tab(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: controller.selectedTabIndex.value == 2 ? Colors.white : Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('Records'),
                ),
              ),
            ],
            labelColor: AppColors.colorPrimary,
            unselectedLabelColor: Colors.black,
            // indicatorColor: Colors.red,
          ),
        ),

        // TabBarView
        Expanded(
          child: TabBarView(
            children: [
              history(),
              Center(child: Text('Charts Content')),
              Center(child: Text('Records Content')),
            ],
          ),),
          ],
        );
        }),
      ),
    );
  }

  Widget history() => SingleChildScrollView(
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
                      Icon(
                        workout.progressDirection == ProgressDirection.upward 
                          ? Icons.arrow_upward 
                          : workout.progressDirection == ProgressDirection.downward 
                            ? Icons.arrow_downward 
                            : Icons.remove,
                        size: 16, 
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
