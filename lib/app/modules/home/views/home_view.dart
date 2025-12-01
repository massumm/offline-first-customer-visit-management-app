import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/theme/app_text_theme.dart';
import 'package:icon/app/core/theme/icon_light_theme.dart';
import 'package:icon/app/core/widgets/super_image.dart';
import 'package:icon/app/data/local/preference/store/user_store.dart';
import 'package:icon/app/routes/app_pages.dart';

import '../../../../generated/assets.dart';
import '../../../core/values/app_colors.dart';
import '../controllers/home_controller.dart';
import '../widgets/actions_card.dart';
import '../widgets/community_card.dart';
import '../widgets/goals_card.dart';
import '../widgets/header.dart';
import '../widgets/progress_ring.dart';
import '../widgets/trainer_info_card.dart';
import 'widgets/community_spotlight_card.dart';
import 'widgets/fitness_deshboard_widgets/fitness_deshboard.dart';
import 'widgets/health_deshboard_widgets/health_deshboard_widget.dart';
import 'widgets/lavel_card.dart';

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
                    FitnessDashboard(),
                    16.height,
                    HealthDashboard(),
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
  Widget? bottomNavigationBar(BuildContext context) => Container(
    color: AppColors.lightBgColor,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
      child: IconicNavBar(
        currentIndex: controller.selectedNavIndex.value,
        onTap: (index) {
          controller.selectedNavIndex.value = index;
        },
      ),
    ),
  );
}

class IconicNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const IconicNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _navItem(icon: Icons.home_outlined, label: "Home", index: 0),
          _navItem(
            icon: Icons.show_chart_outlined,
            label: "Analytic",
            index: 1,
          ),

          /// CENTER BUTTON
          GestureDetector(
            onTap: () => onTap(2),
            child: Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: SuperImage(Assets.svgIcon),
              ),
            ),
          ),

          _navItem(icon: Icons.group_outlined, label: "Community", index: 3),

          /// PROFILE IMAGE
          GestureDetector(
            onTap: () => onTap(4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundImage: AssetImage(
                    Assets.imagesMishIcon
                  )
                ),
                const SizedBox(height: 4),
                const Text(
                  "Profile",
                  style: TextStyle(fontSize: 11, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isActive = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 22, color: isActive ? Colors.red : Colors.white70),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isActive ? Colors.red : Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
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
