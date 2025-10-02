import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:lottie/lottie.dart';

import '../../../../generated/assets.dart';
import '../controllers/profile_create_animation_controller.dart';

class ProfileCreateAnimationView
    extends StatefulWidget {
  const ProfileCreateAnimationView({super.key});

  @override
  State<ProfileCreateAnimationView> createState() =>
      _ProfileCreateAnimationViewState();
}

class _ProfileCreateAnimationViewState
    extends State<ProfileCreateAnimationView> {
  // --- OPTIMIZATION 1: Cache the Lottie animation ---
  // We decode the animation from the asset string once.
  late final Future<LottieComposition> _composition;

  @override
  void initState() {
    super.initState();
    // Get the controller and start the API calls immediately.
    Get.find<ProfileCreateAnimationController>().startProfileCreation();
    // Start decoding the Lottie file.
    _composition = AssetLottie(Assets.jsonsProfileLoading).load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
            // --- OPTIMIZATION 2: Use a FutureBuilder for the cached animation ---
            // This builds the Lottie widget only when the composition is ready.
            FutureBuilder<LottieComposition>(
              future: _composition,
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
            // --- OPTIMIZATION 3: Use const for static text ---
            const Text(
              'Setting up your account...',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
