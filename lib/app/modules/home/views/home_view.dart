import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/theme/app_text_theme.dart';
import 'package:icon/app/core/theme/icon_light_theme.dart';

import '../../../../generated/assets.dart';
import '../../../core/values/app_colors.dart';
import '../controllers/home_controller.dart';
import '../widgets/actions_card.dart';
import '../widgets/goals_card.dart';
import '../widgets/header.dart';
import '../widgets/progress_ring.dart';
import '../widgets/trainer_info_card.dart';
import 'widgets/community_spotlight_card.dart';
import 'widgets/fitness_deshboard_widgets/fitness_deshboard.dart';
import 'widgets/health_deshboard_widgets/health_deshboard_widget.dart';
import 'widgets/lavel_card.dart';
import 'widgets/metrix_grid_page.dart';
import 'widgets/nav_bar/icon_nav_bar.dart';

class HomeView extends BaseView<HomeController> {
  const HomeView({super.key});

  @override
  Widget body(BuildContext context) {
    return Theme(
      data: IconLightTheme.androidLightTheme,
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Header(),
                    16.height,
                    _UserHeader(),
                    16.height,
                    DailyProgressIndicators(),
                    16.height,
                    TrainerInfoCard(onPressed: () {}),
                    16.height,
                    healthProgressIndicator(),
                    16.height,
                    GoalsCard(onPressed: () {}),
                    16.height,
                    MetricsGridPage(),
                    // FitnessDashboard(),
                    // 16.height,
                    // HealthDashboard(),
                    16.height,
                    LevelCard(label: 'Level 1'),
                    16.height,
                    CommunitySpotlightCard(),
                    16.height,
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  SingleChildScrollView healthProgressIndicator() {
    final controller = Get.find<HomeController>();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ActionsCard(
            title: controller.actionCards[0].title,
            color: controller.actionCards[0].color,
            percent: controller.actionCards[0].percent,
            gradient: controller.actionCards[0].gradient,
          ),
          16.width,
          ActionsCard(
            title: controller.actionCards[1].title,
            color: controller.actionCards[1].color,
            percent: controller.actionCards[1].percent,
            gradient: controller.actionCards[1].gradient,
          ),
          16.width,
          ActionsCard(
            title: controller.actionCards[2].title,
            color: controller.actionCards[2].color,
            percent: controller.actionCards[2].percent,
            gradient: controller.actionCards[2].gradient,
          ),
        ],
      ),
    );
  }

  @override
  PreferredSizeWidget? appBar(BuildContext context) => null;

  @override
  Widget? bottomNavigationBar(BuildContext context) =>
      Obx(() {
        return Container(
          color: AppColors.lightBgColor,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
            child: IconicNavWrapper(
              currentIndex: controller.selectedNavIndex.value,
              onTap: (index) {
                controller.selectedNavIndex.value = index;
              },
            ),
          ),
        );
      });
}

class DailyProgressIndicators extends StatelessWidget {
  const DailyProgressIndicators({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return SizedBox(
      height: 112,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, i) => DayCard(item: controller.week[i]),
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemCount: controller.week.length,
      ),
    );
  }
}

class _UserHeader extends StatelessWidget {
  const _UserHeader();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final chipStyle = AppTextTheme.bodyMediumMedium;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightBorderGrayColor, width: 2),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Good morning,', style: AppTextTheme.titleSmallRegular),
                const SizedBox(height: 4),
                Text(
                  controller.username,
                  style: AppTextTheme.headlineSmallBold.copyWith(
                    color: AppColors.black,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
          _InfoChip(
            icon: Assets.svgMorningIcon,
            label: 'Day ${controller.currentDay}',
            style: chipStyle,
          ),
          const SizedBox(width: 8),
          _InfoChip(
            icon: Assets.svgLevel7,
            label: 'Level ${controller.currentLevel}',
            style: chipStyle,
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label, this.style});

  final String icon;
  final String label;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 37, height: 33, child: SvgPicture.asset(icon)),
          const SizedBox(width: 16),
          Text(label, style: style),
        ],
      ),
    );
  }
}

class DayCard extends StatelessWidget {
  const DayCard({super.key, required this.item});

  final DayItem item;

  @override
  Widget build(BuildContext context) {
    final isToday = item.isToday;

    return Container(
      width: 60,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isToday
            ? Border.all(color: const Color(0xFFE35D5D), width: 2)
            : Border.all(color: AppColors.lightBorderGrayColor, width: 2),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 40,
              width: 40,
              child: ProgressRing(
                value: item.progress,
                thickness: 4,
                trackColor: AppColors.lightBorderGrayColor,
                valueColor: AppColors.redProgressColor,
                valueGradient: AppColors.redGradient,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              item.label,
              style: isToday
                  ? AppTextTheme.bodyLargeBold
                  : AppTextTheme.bodyMediumRegular,
            ),
            const SizedBox(height: 2),
            Text(
              '${item.date}',
              style: isToday
                  ? AppTextTheme.bodyLargeSemiBold
                  : AppTextTheme.bodyMediumSemiBold,
            ),
          ],
        ),
      ),
    );
  }
}
