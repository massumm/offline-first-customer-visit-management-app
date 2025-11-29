import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/theme/app_text_theme.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/generated/assets.dart';

import 'soft_button.dart';

class HealthDashboardCard extends StatelessWidget {
  const HealthDashboardCard({super.key});

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.0,
            children: [
              MetricCard(
                title: 'Steps',
                icon: SvgPicture.asset(Assets.activityTrackerSteps),
                value: '8,547',
                unit: 'steps',
                maxValue: '10,000',
              ),
              MetricCard(
                title: 'Calories',
                icon: SvgPicture.asset(Assets.activityTrackerCaloriesBurned),
                value: '420',
                unit: 'kcal',
                maxValue: '500',
              ),
              MetricCard(
                title: 'Heart Rate',
                icon: SvgPicture.asset(Assets.activityTrackerHeartRate),
                value: '72',
                unit: 'bpm',
              ),
              MetricCard(
                title: 'Active Minutes',
                icon: SvgPicture.asset(Assets.activityTrackerActiveMinutes),
                value: '45',
                unit: 'min',
              ),
            ],
          ),

        ],
      ),
    );
  }

  static void _toast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }
}

class MetricCard extends StatelessWidget {
  final String title;
  final SvgPicture icon;
  final String value;
  final String? maxValue;
  final String unit;

  const MetricCard({
    super.key,
    required this.title,
    required this.icon,
    required this.value,
    this.maxValue,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _TitleRow(title: title, icon: icon),
          4.height,
          _BigStat(value: value, unit: unit, maxValue: maxValue),
        ],
      ),
    );
  }
}


/// ———————————————————— UI building blocks ————————————————————

class _CardShell extends StatelessWidget {
  final Widget child;

  const _CardShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: AppColors.pageBackground,
        borderRadius: BorderRadius.circular(18),
      ),
      child: child,
    );
  }
}

class _TitleRow extends StatelessWidget {
  final String title;
  final SvgPicture icon;

  const _TitleRow({
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextTheme.titleSmallSemiBold.copyWith(color: Colors.black),
          ),
        ),
        icon,
      ],
    );
  }
}

class _BigStat extends StatelessWidget {
  final String value;
  final String unit;
  final String? maxValue;

  const _BigStat({required this.value, required this.unit, this.maxValue});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          value,
          style: AppTextTheme.titleMediumBold.copyWith(color: Colors.black),
        ),
        4.width,
        if(maxValue != null)
          ...[
            Text("/$maxValue ", style: AppTextTheme.bodyMediumRegular.copyWith(color: AppColors.lightTextSecondaryColor)),
          ],
        Text(unit, style: AppTextTheme.bodyMediumRegular.copyWith(color: AppColors.lightTextSecondaryColor)),
      ],
    );
  }
}


class TinyProgressBar extends StatelessWidget {
  final double value; // 0..1
  final Color color;

  const TinyProgressBar({super.key, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    final bg = color.withValues(alpha: 0.15);
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final filled = (w * value.clamp(0, 1)).toDouble();

        return Container(
          height: 8,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: filled,
              height: 8,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF241814),
                    Color(0xFFE9522B),
                  ],
                ),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        );
      },
    );
  }

}


