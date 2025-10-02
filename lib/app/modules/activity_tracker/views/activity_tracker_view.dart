import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/core/widgets/back_pill.dart';

import '../controllers/activity_tracker_controller.dart';

class ActivityTrackerView extends BaseView<ActivityTrackerController> {
  ActivityTrackerView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) => AppBar(
    leading: BackPill(onTap: () => Navigator.maybePop(context)),
    title: Text(
      'ActivityTrackerView',
      style: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w600,
        height: 1.50,
      ),
    ),
    centerTitle: true,
  );

  @override
  Widget body(BuildContext context) {
    return Container(
      color: AppColors.screenBgColor,
      width: Get.width,
      height: Get.height,
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                controller.increment();
              },
              child: const Text('My Workout'),
            ),
            6.height,
            _buildHeader(),
            6.height,
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Activity',
              style: TextStyle(
                color: Colors.white /* D-T1 */,
                fontSize: 18,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                height: 1.50,
              ),
            ),
            SizedBox(
              width: 153,
              height: 19.82,
              child: Text(
                'Last synced 2 minutes ago',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFFB6B6B6) /* D-T2 */,
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                ),
              ),
            ),
          ],
        ),
        6.height,
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: ShapeDecoration(
              color: const Color(0xFF1F1F1F) /* D-shape */,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: [
                Container(
                  width: double.infinity,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 98,
                    children: [
                      Container(width: 24, height: 24, child: Stack()),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: ShapeDecoration(
                          color: const Color(0xFF0D0D0D) /* D-bg */,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                              strokeAlign: BorderSide.strokeAlignOutside,
                              color: const Color(0xFFE9522B) /* Color-Primery */,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'This Week',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: const Color(0xFFE9522B) /* Color-Primery */,
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                height: 1.67,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 12,
                    children: [
                      SizedBox(
                        width: 162,
                        child: Text(
                          'Running',
                          style: TextStyle(
                            color: Colors.white /* D-T1 */,
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            height: 1.50,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        spacing: 2,
                        children: [
                          Text(
                            '3.2',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white /* D-T1 */,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              height: 1.50,
                            ),
                          ),
                          Text(
                            'km',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white /* D-T1 */,
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w300,
                              height: 1.50,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ]),
      ],
    );
  }
}
