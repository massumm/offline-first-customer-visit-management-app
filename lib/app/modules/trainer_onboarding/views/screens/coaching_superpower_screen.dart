import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/widgets/action_pill.dart';
import 'package:icon/app/core/widgets/custom_text_field.dart';
import 'package:icon/app/modules/trainer_onboarding/controllers/trainer_onboarding_controller.dart';
import 'package:icon/app/modules/trainer_onboarding/views/screens/client_best_connect_screen.dart';

import 'trainer_onboarding_full_name.dart';

class CoachingSuperpowerScreen extends GetView<TrainerOnboardingController> {
  const CoachingSuperpowerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 40),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ActionPill(onTap: () => Navigator.maybePop(context)),
              30.height,
              const ProgressBar(
                currentStep: 2,
                stepText: "Coaching Style & Persona",
              ),
              400.height,
              // Title
              Center(
                child: Text(
                  "What’s your coaching superpower?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white, // fixed
                  ),
                ),
              ),
              16.height,
              CustomTextField(
                controller: controller.descriptionController,
                maxLines: 5,
                label: "Description",
                hint: "",
              ),
              20.height,
              ElevatedButton(
                onPressed: () {
                  Get.to(() => ClientBestConnectScreen());
                },
                child: const Text('Next'),
              ),
              20.height,
            ],
          ),
        ),
      ),
    );
  }
}
