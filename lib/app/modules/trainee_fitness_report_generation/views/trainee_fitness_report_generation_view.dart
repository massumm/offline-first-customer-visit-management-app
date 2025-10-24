import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/widgets/input_widgets/input_widgets.dart';

import '../../../core/widgets/back_pill.dart';
import '../controllers/trainee_fitness_report_generation_controller.dart';

class TraineeFitnessReportGenerationView
    extends BaseView<TraineeFitnessReportGenerationController> {
  TraineeFitnessReportGenerationView({super.key});

  @override
  Widget body(BuildContext context) {
    return Stack(
      children: [
        // Background SVG
        // TODO: Handle BG effect. Not working.
        // Positioned(
        //   top: -113,
        //   left: -109,
        //   child: Opacity(
        //     opacity:
        //         0.3, // Adjust opacity value (0.0 = transparent, 1.0 = opaque)
        //     child: SvgPicture.asset(
        //       Assets.svgBgGradientColor,
        //       fit: BoxFit.cover,
        //       width: 655.32,
        //       height: 503.33,
        //       // alignment: Alignment.topCenter,
        //     ),
        //   ),
        // ),
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
                    TextSpan(text: 'please ', style: Get.textTheme.titleLarge),
                    TextSpan(
                      text: 'enter your',
                      style: Get.textTheme.titleLarge?.copyWith(
                        color: Get.theme.colorScheme.primary,
                      ),
                    ),
                    TextSpan(text: ' email.', style: Get.textTheme.titleLarge),
                  ],
                ),
              ),
              8.height,
              // Sub title
              Text(
                "This email address will be used to create you account and send you the report.",
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const Spacer(),
              // Text('Email', style: Get.textTheme.labelLarge),
              // 10.height,
              Obx(() {
                return AdaptiveSuperTextField(
                  controller: controller.emailCtr,
                  hintText: "abc@example.com",
                  labelText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  errorText: controller.emailError.value,
                  onTapOutside: (_) => FocusScope.of(context).unfocus(),
                  onChanged: (value) {
                    controller.onEmailChanged(value);
                  },
                );
              }),
              10.height,
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.isValidEmail.isTrue
                        ? controller.onSubmitButtonPressed
                        : null,
                    child: const Text('Submit'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
