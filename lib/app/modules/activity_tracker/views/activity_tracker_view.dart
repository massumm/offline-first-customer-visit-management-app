import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('ActivityTrackerView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ActivityTrackerView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
