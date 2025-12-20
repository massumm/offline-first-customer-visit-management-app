import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/core/widgets/super_widgets/super_icon.dart';
import 'package:icon/app/core/widgets/super_widgets/super_icon_source.dart';
import 'package:icon/app/modules/start_workout/controllers/start_workout_controller.dart';
import 'package:icon/generated/assets.dart';

import '../../../activity_tracker/views/widgets/activity_rep_keyboard_widget.dart';
import 'bottom_sheet/rest_timer_bottom_sheet.dart';
import 'bottom_sheet/show_set_type_bottom_sheet.dart';

class WorkoutSetCard extends GetView<StartWorkoutController> {
  const WorkoutSetCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16).copyWith(bottom: 0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title Row
          Row(
            children: [
              const Icon(Icons.fitness_center, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Dumbbell Squat',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          /// Muscle Chips
          Row(
            children: const [
              _MuscleChip(label: 'Quads'),
              SizedBox(width: 6),
              _MuscleChip(label: 'Glutes'),
            ],
          ),

          6.height,

          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Get.bottomSheet(
                  RestTimerBottomSheet(selectedMinute: 0, selectedSecond: 0),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,

                  children: const [
                    Icon(
                      Icons.timer,
                      color: AppColors.activityPrimaryColor,
                      size: 18,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Rest Timer',
                      style: TextStyle(
                        color: AppColors.activityPrimaryColor,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          6.height,

          /// Table Header
          Row(
            children: const [
              _HeaderCell('SET', flex: 1),
              _HeaderCell('PREVIOUS', flex: 3),
              _HeaderCell('KG', flex: 2),
              _HeaderCell('REPS', flex: 2),
              _HeaderCell('', flex: 1, showIcon: true),
            ],
          ),

          const SizedBox(height: 8),

          Obx(() {
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.workoutSetService.workoutSets.length,
              itemBuilder: (context, index) {
                final set = controller.workoutSetService.workoutSets[index];

                return Dismissible(
                  key: ObjectKey(set),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    controller.workoutSetService.removeSet(index);
                  },
                  background: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 16.0),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                    ),
                  ),
                  child: _SetRow(
                    set: set.setType,
                    previous: set.previous,
                    kgController: set.kgController,
                    repsController: set.repsController,
                    highlightText: '5.00',
                    completed: set.isComplete,
                    highlight: true,
                    onSetTapped: (newSetType) {
                      controller.workoutSetService.updateSetType(
                        index,
                        newSetType,
                      );
                    },
                    onCompleteTap: (isCompleted) {
                      controller.workoutSetService.toggleCompletion(
                        index,
                        isCompleted,
                      );
                    },
                  ),
                );
              },
            );
          }),

          /// Add Set
          Center(
            child: TextButton(
              onPressed: () {
                controller.workoutSetService.addSet();
              },
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                textStyle: TextStyle(
                  color: theme.colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                ),
              ),
              child: Text('ADD SET'),
            ),
          ),
        ],
      ),
    );
  }
}

class _MuscleChip extends StatelessWidget {
  final String label;

  const _MuscleChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;
  final int flex;
  final bool showIcon;

  const _HeaderCell(this.text, {required this.flex, this.showIcon = false});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Center(
        child: showIcon
            ? SuperIcon(
                source: SuperIconSource.svgAsset(Assets.iconsCheckmarkCircle),
                size: 14,
              )
            : Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
      ),
    );
  }
}

class _SetRow extends StatelessWidget {
  final String set;
  final String previous;
  final TextEditingController kgController;
  final TextEditingController repsController;
  final String highlightText;
  final bool completed;
  final bool highlight;
  final ValueChanged<SetType> onSetTapped;
  final ValueChanged<bool> onCompleteTap;

  const _SetRow({
    required this.set,
    required this.previous,
    required this.kgController,
    required this.repsController,
    required this.highlightText,
    required this.completed,
    required this.onSetTapped,
    required this.onCompleteTap,
    this.highlight = true,
  });

  Color _getSetColor() {
    final sets = SetType.values.where((t) => t != SetType.remove).toList();

    for (var s in sets) {
      if (s.shortLabel == set) {
        return s.color;
      }
    }

    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () async {
                  final SetType? newSetType = await showSetTypeBottomSheet(
                    context,
                  );
                  if (newSetType != null) {
                    onSetTapped(newSetType);
                  }
                },
                child: Center(
                  child: Text(
                    set,
                    style: TextStyle(
                      color: _getSetColor(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              previous,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          Expanded(
            flex: 2,
            child: _InputBox(controller: kgController, enabled: true),
          ),
          6.width,
          Expanded(
            flex: 2,
            child: RepsInputField(
              repsController: repsController,
              highlightText: highlightText,
              highlight: highlight,
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () => onCompleteTap(!completed),
            borderRadius: BorderRadius.circular(6),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: completed
                      ? theme.colorScheme.secondary
                      : theme.colorScheme.outline,
                ),
              ),
              child: Visibility(
                visible: completed,
                replacement: SuperIcon(
                  size: 16,
                  source: SuperIconSource.svgAsset(Assets.iconsCheckmarkCircle),
                ),
                child: SuperIcon(
                  size: 16,
                  source: SuperIconSource.svgAsset(
                    Assets.iconsCheckmarkCircleSelected,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InputBox extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;

  const _InputBox({required this.controller, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 34,
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: theme.scaffoldBackgroundColor,
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: AppColors.activityPrimaryColor,
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class RepsInputField extends StatelessWidget {
  final TextEditingController repsController;
  final String highlightText;
  final bool highlight;

  const RepsInputField({
    super.key,
    required this.repsController,
    required this.highlightText,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      controller: repsController,
      keyboardType: TextInputType.none,
      onTap: () {
        Get.bottomSheet(
          ActivityRepKeyboard(
            controller: repsController,
            onDone: () {
              Get.back();
            },
            onRPE: () {
              Get.back();
            },
            initialValue: double.tryParse(highlightText),
          ),
        );
      },
      textAlign: TextAlign.center,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: theme.scaffoldBackgroundColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        suffix: Text(
          highlightText,
          style: TextStyle(
            color: highlight ? Colors.orange : Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppColors.activityPrimaryColor,
            width: 1,
          ),
        ),
      ),
    );
  }
}
