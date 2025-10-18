// in lib/app/modules/profile_create_animation/views/profile_create_animation_view.dart

import 'package:flutter/material.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:lottie/lottie.dart';

import '../controllers/profile_create_animation_controller.dart';

class ProfileCreateAnimationView extends BaseView<ProfileCreateAnimationController> {
   ProfileCreateAnimationView({super.key});

  @override
  Widget body(BuildContext context) {
    return Container(
      // The gradient is part of the decoration, which is relatively efficient.
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [0.1, 0.9],
          colors: [AppColors.colorPrimary, Colors.black],
        ),
      ),
      child: Column(
        // Center the content vertically and horizontally.
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Use the composition future directly from the controller.
          FutureBuilder<LottieComposition>(
            future: controller.composition,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // The animation is ready, display it.
                return Lottie(composition: snapshot.data);
              } else if (snapshot.hasError) {
                // If Lottie fails to load, show a fallback.
                return const Icon(Icons.error, color: Colors.white, size: 80);
              }
              // While loading the animation itself, show a simple placeholder.
              return const SizedBox(height: 250); // Adjust size as needed
            },
          ),
          18.height,
          // Use const for static text.
          const Text(
            'Setting up your account...',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ],
      ),
    );
  }
}