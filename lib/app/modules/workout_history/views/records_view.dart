import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/theme/app_text_theme.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:intl/intl.dart';

import '../controllers/workout_history_controller.dart';

class RecordsView extends StatelessWidget {
  const RecordsView({super.key});

  String _formatValue(double value) {
    if (value >= 1000) {
      return (value / 1000).toString()+ 'k';
    }
    return value.toStringAsPrecision(2);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WorkoutHistoryController>(
      builder: (controller) => records(controller),
    );
  }

  Widget records(WorkoutHistoryController controller) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          16.height,

          personalRecordsWidget(controller),
          16.height,
          currentMaxWeightWidget(controller),
          16.height,
          statisticsDataWidget(controller),
        ],
      ),
    );
  }

  Column personalRecordsWidget(WorkoutHistoryController controller) {
    return Column(
  crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Personal Records',
          style: AppTextTheme.titleSmallMedium.copyWith(color: Colors.black),
        ), // 16px, Medium, Black
        16.height,
        ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: controller.personalRecords.length,
              itemBuilder: (context, index) {
                final record = controller.personalRecords[index];
                return Column(
                  children: [

                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                record.title, //14px, medium, black
                                style: AppTextTheme.bodyLargeMedium.copyWith(color: Colors.black),
                              ),
                              SizedBox(height: 4),
                              Text(
                                DateFormat('MMM d, y').format(record.date), //10px, regular, format -> Nov 7, 2025
                                style: AppTextTheme.bodySmallRegular.copyWith(color: Colors.grey[500]),
                              ),

                            ],
                          ),
                          Text(
                            '${record.value} ${record.unit.unit}', //16px, medium, black
                            style: AppTextTheme.titleSmallMedium.copyWith(color: AppColors.black),
                          ),
                        ],
                      ),
                    ),
                    if (index < controller.personalRecords.length - 1)
                      16.height,
                  ],
                );
              },
            ),
      ],
    );
  }

  Container currentMaxWeightWidget(WorkoutHistoryController controller) {
    final currentMax = controller.currentMaxWeight.value;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Max: $currentMax kg', //14px, semi bold, black
            style: AppTextTheme.titleSmallSemiBold.copyWith(color: Colors.black),
          ),
          16.height,
          _buildProgressRow(100, currentMax.toDouble()),
          16.height,
          _buildProgressRow(120, currentMax.toDouble()),
          16.height,
          _buildProgressRow(150, currentMax.toDouble()),
        ],
      ),
    );
  }

  Widget _buildProgressRow(double targetWeight, double currentWeight) {
    double percentage = (currentWeight / targetWeight * 100).clamp(0, 100);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Weight label
            Text(
              '${targetWeight.toInt()} kg', //12px, regular
              style: AppTextTheme.bodyMediumRegular.copyWith(color: Colors.grey.shade700),
            ),
            Text(
              '${percentage.toInt()}%', //12px, regular
              style: AppTextTheme.bodyMediumRegular.copyWith(color: Colors.grey.shade700),
              textAlign: TextAlign.right,
            ),
          ],
        ),
        4.height,
        Row(
          children: [
            Expanded(
              child: Stack(
                children: [
                  // Background bar (light pink)
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: Color(0xFFFFE5E5),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  // Foreground bar (gradient red)
                  FractionallySizedBox(
                    widthFactor: percentage / 100,
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        gradient: AppColors.lineChartGradient,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Container statisticsDataWidget(WorkoutHistoryController controller  ) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Statistics', //14px, semi bold, black
            style: AppTextTheme.bodyLargeSemiBold.copyWith(color: Colors.black),
          ),
          16.height,
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.8,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: controller.statisticsDataList.length,
            itemBuilder: (context, index) {
              final statisticsData = controller.statisticsDataList[index];
              return Container(
                padding: EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      statisticsData.title, //10px regular
                      style: AppTextTheme.bodySmallRegular,
                    ),
                    8.height,
                    Text(
                      _formatValue(statisticsData.value), //16px semi bold
                      style: AppTextTheme.titleSmallSemiBold.copyWith(
                        color: Colors.black,
                      ),
                    ),
                    8.height,
                    Text(
                      statisticsData.duration.duration, // 10px regular, textColorRed
                      style: AppTextTheme.bodySmallMedium.copyWith(color: AppColors.textColorRed),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}



