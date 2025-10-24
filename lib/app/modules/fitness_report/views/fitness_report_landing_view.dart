import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/widgets/back_pill.dart';

import '../controllers/fitness_report_controller.dart';

class FitnessReportLandingView extends BaseView<FitnessReportController> {
  FitnessReportLandingView({super.key});

  @override
  Widget body(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: Get.size.height,
          width: Get.size.width,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BackPill(onTap: Get.back),
                const SizedBox(height: 40),
                Text('Fitness Report', style: Get.textTheme.titleLarge),
                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    style: Get.textTheme.bodyMedium,
                    children: [
                      const TextSpan(text: 'To receive your '),
                      TextSpan(
                        text: 'personalized Icon Report',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const TextSpan(text: ', please '),
                      TextSpan(
                        text: 'enter your',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Get.theme.colorScheme.primary,
                        ),
                      ),
                      const TextSpan(text: ' email.'),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  'Email',
                  style: Get.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Obx(
                  () => TextField(
                    onChanged: controller.updateEmail,
                    decoration: InputDecoration(
                      hintText: 'Enter your email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      errorText:
                          controller.email.isNotEmpty &&
                              !controller.isValidEmail
                          ? 'Please enter a valid email'
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.isValidEmail
                          ? controller.generateReport
                          : null,
                      child: const Text('Next'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
