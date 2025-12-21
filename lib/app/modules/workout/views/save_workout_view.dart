import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/core/widgets/super_image.dart';
import 'package:icon/app/core/widgets/super_widgets/super_icon.dart';
import 'package:icon/app/core/widgets/super_widgets/super_icon_source.dart';
import 'package:icon/app/modules/workout/controllers/workout_controller.dart';
import 'package:intl/intl.dart';

import '../../../../generated/assets.dart';
import '../../../core/extensions/app_extansions.dart';
import '../../../core/widgets/action_button.dart';
import '../../../core/widgets/dashed_border_container.dart';

class SaveWorkoutView extends BaseView<WorkoutController> {
  const SaveWorkoutView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) => AppBar(
    title: Text('Save Workout'),
    leading: Padding(
      padding: EdgeInsetsGeometry.all(6),
      child: ActionButton.compact(onTap: Get.back),
    ),
    centerTitle: true,
  );

  @override
  Widget body(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Logged At', style: theme.textTheme.bodyLarge),
                  Text(
                    DateFormat.yMMMd().add_jm().format(
                      controller.loggedAt.value,
                    ),
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  Card(
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              _InfoBlock(
                                'Total Volume',
                                '${controller.totalVolume} kg',
                              ),
                              _InfoBlock(
                                'Duration',
                                controller.totalWorkoutDurations,
                              ),
                              _InfoBlock('Set', '${controller.totalSets}'),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _PhotoPickerSection(controller: controller),
                          const SizedBox(height: 16),
                          TextField(
                            style: TextStyle(color: Colors.white),
                            maxLines: 2,
                            decoration: InputDecoration(
                              hintText: 'How did you feel? Any observations?',
                              hintStyle: TextStyle(color: Colors.white38),
                              labelText: 'Notes (optional)',
                              labelStyle: TextStyle(color: Colors.white60),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white30),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.redAccent),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onChanged: (v) =>
                                controller.saveWorkoutService.notes.value = v,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    controller.saveWorkoutService.error.value,
                    style: TextStyle(color: Colors.red),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.redAccent),
                            foregroundColor: Colors.redAccent,
                          ),
                          onPressed: () => Get.back(),
                          child: Text('Cancel'),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: controller.saveWorkoutService.loading.value
                              ? null
                              : controller.saveWorkoutService.saveWorkout,
                          child: controller.saveWorkoutService.loading.value
                              ? CircularProgressIndicator()
                              : Text('Save Workout'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBlock extends StatelessWidget {
  final String label;
  final String value;

  const _InfoBlock(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 6.0),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(7.0),
        ),
        child: Column(
          children: [
            Text(label, style: TextStyle(color: Colors.white70, fontSize: 13)),
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class _PhotoPickerSection extends StatelessWidget {
  final WorkoutController controller;

  const _PhotoPickerSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Obx(
          () => GestureDetector(
        onTap: controller.saveWorkoutService.pickPhoto,
        child: DashedBorderContainer(
          dashLength: 8,
          dashGap: 4,
          strokeWidth: 2,
          borderRadius: 10,
          borderColor: theme.colorScheme.outline,
          padding: EdgeInsets.zero,
          child: Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SuperIcon(
                  source: SuperIconSource.svgAsset(Assets.iconsCloudUpload),
                  size: 34,
                ),
                SizedBox(height: 8),
                Text(
                  'Upload from gallery',
                  style: theme.textTheme.titleSmall!.copyWith(
                    color: AppColors.activityPrimaryColor,
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
