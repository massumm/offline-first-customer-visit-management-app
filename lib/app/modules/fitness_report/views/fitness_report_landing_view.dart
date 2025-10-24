import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/widgets/back_pill.dart';
import 'package:icon/generated/assets.dart';

import '../controllers/fitness_report_controller.dart';

class FitnessReportLandingView extends BaseView<FitnessReportController> {
  FitnessReportLandingView({super.key});

  @override
  Widget body(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          // Background SVG
          Positioned(
            top: -113,
            left: -109,
            child: Opacity(
              opacity:
                  0.3, // Adjust opacity value (0.0 = transparent, 1.0 = opaque)
              child: SvgPicture.asset(
                Assets.svgBgGradientColor,
                fit: BoxFit.cover,
                width: 655.32,
                height: 503.33,
                // alignment: Alignment.topCenter,
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BackPill(onTap: Get.back),
                30.height,
                RichText(
                  text: TextSpan(
                    style: Get.textTheme.bodyMedium?.copyWith(height: 2.0),
                    children: [
                      TextSpan(
                        text: 'To receive your\n',
                        style: Get.textTheme.titleLarge?.copyWith(),
                      ),
                      TextSpan(
                        text: 'personalized Icon ',
                        style: Get.textTheme.titleLarge?.copyWith(
                          color: Get.theme.colorScheme.primary,
                        ),
                      ),
                      TextSpan(
                        text: 'Report,\n',
                        style: Get.textTheme.titleLarge,
                      ),
                      TextSpan(
                        text: 'please ',
                        style: Get.textTheme.titleLarge,
                      ),
                      TextSpan(
                        text: 'enter your',
                        style: Get.textTheme.titleLarge?.copyWith(
                          color: Get.theme.colorScheme.primary,
                        ),
                      ),
                      TextSpan(
                        text: ' email.',
                        style: Get.textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text('Email', style: Get.textTheme.labelLarge),
                10.height,
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
                10.height,
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
        ],
      ),
    );
  }
}
