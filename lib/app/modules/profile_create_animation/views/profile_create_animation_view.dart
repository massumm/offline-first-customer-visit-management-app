import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:lottie/lottie.dart';

import '../../../../generated/assets.dart';
import '../controllers/profile_create_animation_controller.dart';

class ProfileCreateAnimationView
    extends GetView<ProfileCreateAnimationController> {
  const ProfileCreateAnimationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [0.1, 0.9],

            colors: [AppColors.colorPrimary, Colors.black],

          )
        ),
        child: Column(
          children: [
            (Get.height*0.2).height,
            Center(child: Lottie.asset(Assets.jsonsProfileLoading)),
            18.height,
            Text(
              'Setting up your account...',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
