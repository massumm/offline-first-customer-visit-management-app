import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';

import 'package:icon/app/core/theme/app_text_theme.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/modules/full_body_tracker/utils/theme_helpers.dart';
import '../../../../generated/assets.dart';
import '../controllers/workout_history_controller.dart';

class ChartsView extends StatelessWidget {
  const ChartsView({super.key});



  @override
  Widget build(BuildContext context) {
    return GetBuilder<WorkoutHistoryController>(
      builder: (controller) => charts(controller),
    );
  }

  Widget charts(WorkoutHistoryController controller) {
    return SingleChildScrollView(
      child: Column(
        children: [
          chartsDurationDropDown(controller),
          progressChart(controller),
          16.height,
          _buildChart(controller.weeklyTotalVolumeChartData),
          16.height,
          _buildChart(controller.maxWeightProcessChartData),
          16.height,
          _buildChart(controller.estimatedOneRepMaxChartData),
        ],
      ),
    );
  }

  Row chartsDurationDropDown(WorkoutHistoryController controller) {
    return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              width: 100,
              child: Obx(() => DropdownButton<String>(
                  hint: Text('Weekly', style: AppTextTheme.bodyMediumRegular.copyWith(color: ThemeHelpers.primaryTextColor)),
                  value: controller.selectedWeek.value,
                  isExpanded: true,
                  underline: SizedBox(),
                  items: [
                    DropdownMenuItem(value: 'Weekly', child: Text('Weekly', style: AppTextTheme.bodyMediumRegular.copyWith(color: ThemeHelpers.primaryTextColor))),
                    DropdownMenuItem(value: 'Daily', child: Text('Daily', style: AppTextTheme.bodyMediumRegular.copyWith(color: ThemeHelpers.primaryTextColor))),
                    DropdownMenuItem(value: 'Monthly', child: Text('Monthly', style: AppTextTheme.bodyMediumRegular.copyWith(color: ThemeHelpers.primaryTextColor))),
                    DropdownMenuItem(value: 'Yearly', child: Text('Yearly', style: AppTextTheme.bodyMediumRegular.copyWith(color: ThemeHelpers.primaryTextColor))),
                  ],
                  onChanged: (value) {
                    // Handle dropdown change
                    controller.selectedWeek.value = value!;
                  },
                icon: SvgPicture.asset(Assets.activityTrackerDropdownIcon, width: 24, height: 24, colorFilter: ColorFilter.mode(ThemeHelpers.primaryTextColor, BlendMode.srcIn),),
                ),
              ),
            ),
          ],
        );
  }

  Container progressChart(WorkoutHistoryController controller) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ThemeHelpers.bgColorRed,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Progress', style: AppTextTheme.bodyLargeSemiBold.copyWith(color: Colors.white)),
          //14 px, semi bold, white
          16.height,
          Table(
            columnWidths: {
              0: FlexColumnWidth(),
              1: FlexColumnWidth(),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.intrinsicHeight,
            children: [
              TableRow(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric( vertical: 4.0),
                    child: Text('Volume Increase', style: AppTextTheme.bodyMediumRegular.copyWith(color: Colors.white)), // 12 px, regular white
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric( vertical: 4.0),
                    child: Text('Strength Gain', style: AppTextTheme.bodyMediumRegular.copyWith(color: Colors.white)), // 12px regular white
                  ),
                ],
              ),
              TableRow(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric( vertical: 2.0),
                    child: Text("${controller.volumeIncreaseValue.toString()}%", style: AppTextTheme.titleMediumSemiBold.copyWith(color: Colors.white)), //18 px semi bold white
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric( vertical: 4.0),
                    child: Text("${controller.strengthGainValue.toString()}%", style: AppTextTheme.titleMediumSemiBold.copyWith(color: Colors.white)),
                  ), // 18px semi bold white

                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container _buildChart(ChartData chartData) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(chartData.title, style: AppTextTheme.bodyLargeMedium),
          16.height,
          SizedBox(
            height: 170,
            child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: chartData.maxValue,
              barTouchData: BarTouchData(enabled: false),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final days = chartData.data.map((data) => data.days.shortName).toList();
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(days[value.toInt()]),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: chartData.interval,
                    reservedSize: 40,
                  ),
                ),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: chartData.interval,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.grey.shade300,
                    strokeWidth: 1,
                    dashArray: [5, 5],
                  );
                },
              ),
              extraLinesData: ExtraLinesData(
                horizontalLines: [
                  HorizontalLine(
                    y: 0,
                    color: Colors.grey.shade300,
                    strokeWidth: 1,
                    dashArray: [5, 5],
                  ),
                  HorizontalLine(
                    y: chartData.maxValue,
                    color: Colors.grey.shade300,
                    strokeWidth: 1,
                    dashArray: [5, 5],
                  ),
                ],
              ),
              borderData: FlBorderData(show: false),
              barGroups: chartData.data.asMap().entries.map((entry) {
                final index = entry.key;
                final darkValue = entry.value;
                final data = chartData.maxValue - darkValue.value;
                return makeGroupData(index, darkValue.value, data);
              }).toList(),
            ),
          ),
          ),
        ],
      ),
    );
  }
  }

BarChartGroupData makeGroupData(int x, double darkValue, double lightValue) {
  return BarChartGroupData(
    x: x,
    barRods: [
      BarChartRodData(
        toY: darkValue + lightValue,
        rodStackItems: [
          BarChartRodStackItem(0, darkValue, null, gradient: AppColors.chartGradient, borderSide: BorderSide(
    color: Colors.white,
    width: 2,
          ),), // Dark red
          BarChartRodStackItem(darkValue, darkValue + lightValue, AppColors.colorSecondary), // Light pink
        ],
        width: 16,
        borderRadius: BorderRadius.circular(8),
      ),
    ],
  );
}
