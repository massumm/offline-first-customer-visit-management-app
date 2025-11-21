import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/theme/app_text_theme.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/core/widgets/action_pill.dart';
import 'package:icon/app/modules/workout_history/views/workout_view.dart';
import 'package:icon/app/modules/workout_history/views/charts_view.dart';
import 'package:icon/app/modules/workout_history/views/records_view.dart';
import 'package:icon/generated/assets.dart';

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
            padding: EdgeInsets.zero,
          margin: EdgeInsets.zero,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TabBar(
            onTap: (index) => controller.selectedTabIndex.value = index,
            dividerColor: Colors.transparent ,
            indicator: BoxDecoration(
              border: Border.all(color: AppColors.bgColorRed),
              borderRadius: BorderRadius.circular(8),
            ),
            labelStyle: AppTextTheme.bodyLargeSemiBold,
            unselectedLabelStyle: AppTextTheme.bodyLargeRegular,
            labelColor: AppColors.bgColorRed,
            indicatorPadding: EdgeInsets.symmetric(horizontal: -16, vertical: 2),
            unselectedLabelColor: AppColors.lightTextPrimaryColor,
            tabs: [
              Tab(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: controller.selectedTabIndex.value == 0 ? Colors.white : Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'History',
                  ),
                ),
              ),
              Tab(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  decoration: BoxDecoration(
                    color: controller.selectedTabIndex.value == 1 ? Colors.white : Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Charts',
                  ),
                ),
              ),
              Tab(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  decoration: BoxDecoration(
                    color: controller.selectedTabIndex.value == 2 ? Colors.white : Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Records',
                  ),
                ),
              ),
            ],

          ),
        ),

        // TabBarView
        Expanded(
          child: TabBarView(
            children: [
              WorkoutView(),
              ChartsView(),
              RecordsView(),
            ],
          ),),
          ],
        );
        }),
      ),
    );
  }

  

}
