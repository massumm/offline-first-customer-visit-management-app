import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/theme/app_text_theme.dart';

import '../../../../generated/assets.dart';
import '../../../core/values/app_colors.dart';
import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';
import '../widgets/actions_card.dart';
import '../widgets/goals_card.dart';
import '../widgets/header.dart';
import 'widgets/daily_progress_indicator.dart';
import 'widgets/nav_bar/icon_nav_bar.dart';

class HomeView extends BaseView<HomeController> {
  const HomeView({super.key});

  @override
  Widget body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: const Header()),
          hSpace,
          // SliverToBoxAdapter(child: _UserHeader()),
          // hSpace,
          SliverToBoxAdapter(child: DailyProgressIndicators()),
          hSpace,
          SliverToBoxAdapter(child: trackerProgressIndicator()),
          hSpace,
          SliverToBoxAdapter(child: GoalsCard(onPressed: () {})),
        ],
      ),
    );
  }

  SliverToBoxAdapter get hSpace => SliverToBoxAdapter(child: 16.height);

  SingleChildScrollView trackerProgressIndicator() {
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
            onTap: () {
              Get.toNamed(Routes.NUTRITION_TRACKER);
            },
          ),
          16.width,
          ActionsCard(
            title: controller.actionCards[2].title,
            color: controller.actionCards[2].color,
            percent: controller.actionCards[2].percent,
            gradient: controller.actionCards[2].gradient,
            onTap: controller.onActivityCardTap,

          ),
        ],
      ),
    );
  }

  @override
  PreferredSizeWidget? appBar(BuildContext context) => null;

  @override
  Widget? bottomNavigationBar(BuildContext context) => Obx(() {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
        child: IconicNavWrapper(
          currentIndex: controller.selectedNavIndex.value,
          onTap: (index) {
            controller.handleNavigation(index);
          },
        ),
      ),
    );
  });
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
