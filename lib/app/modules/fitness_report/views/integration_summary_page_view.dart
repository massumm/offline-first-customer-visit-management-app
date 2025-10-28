import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/core/widgets/loading_button.dart';
import 'package:icon/app/modules/fitness_report/controllers/fitness_report_controller.dart';
import 'package:icon/app/modules/fitness_report/widgets/fitness_report_appbar_widget.dart';
import 'package:icon/app/modules/fitness_report/widgets/info_card_widget.dart';
import 'package:icon/generated/assets.dart';

class IntegrationSummaryPageView extends BaseView<FitnessReportController> {
  IntegrationSummaryPageView({super.key});

  final List<Map<String, String>> deviceList = [
    {
      'icon': Assets.imagesApple,
      'title': 'Apple Watch',
      'connectionStatus': 'Connected',
      'iconColor': 'FFEFEFEF',
    },
    {
      'icon': Assets.imagesFitbit,
      'title': 'Fitbit',
      'connectionStatus': 'Not Connected',
      'iconColor': 'FFE9FEFF',
    },
    {
      'icon': Assets.imagesGoogle,
      'title': 'Google',
      'connectionStatus': 'Connected',
      'iconColor': 'FFE6FFEF',
    },
    {
      'icon': Assets.imagesGarmin,
      'title': 'Garmin',
      'connectionStatus': 'Not Connected',
      'iconColor': 'FFFEFEC',
    },
  ];

  @override
  Widget body(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FitnessReportAppbarWidget(
                controller: controller,
                title: 'Integration Summary',
              ),
              16.height,
              Container(
                // width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Get.isDarkMode
                      ? AppColors.darkWarningColorBG
                      : AppColors.lightWarningColorBG,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      Assets.integrationSummaryWarning,
                      width: 16,
                      height: 16,
                    ),
                    12.width,
                    Expanded(
                      child: Text(
                        'ICON can sync with your wearable devices and fitness apps to automatically track your steps, workouts, sleep, and other key metrics. The more you connect, the smarter your personal recommendations become',
                        textAlign: TextAlign.justify,
                        style: Get.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
              16.height,
              Text(
                'Connect your device',
                style: Get.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              16.height,
              ListView.builder(
                shrinkWrap: true,
                itemCount: deviceList.length,
                itemBuilder: (context, index) {
                  final device = deviceList[index];
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Get.theme.colorScheme.onPrimaryContainer,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: device['connectionStatus']! == 'Connected'
                            ? AppColors.positiveBorderColor
                            : Colors.transparent,
                        width: 1,
                      ),
                    ),
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Color(
                              int.parse(device['iconColor']!, radix: 16),
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Image.asset(
                            device['icon']!,
                            width: 28,
                            height: 28,
                          ),
                        ),
                        16.width,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              device['title']!,
                              style: Get.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            4.height,
                            Text(
                              device['connectionStatus']! == 'Connected'
                                  ? 'Connected'
                                  : 'Connect',
                              style: Get.textTheme.bodySmall?.copyWith(
                                color:
                                    device['connectionStatus']! == 'Connected'
                                    ? AppColors.positiveBorderColor
                                    : AppColors.colorPrimary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              24.height,
              InfoCardWidget(
                icon: Assets.imagesFitnessReportFace,
                title: 'Personalized Suggestion',
                description:
                    'Since you care about step tracking and activity consistency, connecting your wearable will automatically log your steps and workouts. ICON will use this data to adjust your goals and provide insights in real-time.',
                isGradient: true,
                iconType: IconType.asset,
              ),
              16.height,
              LoadingButton(
                onPressed: controller.gotToNextPage,
                label: 'View Your Report',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
