import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/widgets/super_image.dart';
import 'package:icon/app/modules/workout/controllers/workout_controller.dart';

import '../../../core/extensions/app_extansions.dart';
import '../../../core/widgets/action_button.dart';

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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Logged At\n${controller.loggedAt.value.toString().split('.').first}',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 16),
            Card(
              color: Color(0xFF1B1B1B),
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
                        _InfoBlock('Duration', controller.onWorkoutDuration),
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
    return Obx(
      () => GestureDetector(
        onTap: controller.saveWorkoutService.pickPhoto,
        child: Container(
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white30),
            borderRadius: BorderRadius.circular(10),
          ),
          child: controller.saveWorkoutService.photoPath.value.isNotEmpty
              ? SuperImage(controller.saveWorkoutService.photoPath.value)
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cloud_upload, color: Colors.white38, size: 34),
                    Text(
                      'Upload from gallery',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
