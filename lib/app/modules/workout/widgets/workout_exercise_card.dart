import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/core/widgets/super_widgets/super_icon.dart';
import 'package:icon/app/core/widgets/super_widgets/super_icon_source.dart';
import 'package:icon/generated/assets.dart';

import '../../activity_tracker/models/workout_response_model.dart';
import '../../activity_tracker/views/widgets/activity_rep_keyboard_widget.dart';
import '../controllers/workout_controller.dart';
import 'bottom_sheet/show_set_type_bottom_sheet.dart';
import 'show_delete_confirmation_dialog.dart';
import 'timer_progress_bar.dart';

class WorkoutExerciseCard extends GetView<WorkoutController> {
  const WorkoutExerciseCard({super.key, required this.exercise});

  final ExerciseElement exercise;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bool supportWeight = exercise.exercise?.supportsWeight ?? false;
    final bool supportReps = exercise.exercise?.supportsReps ?? false;
    final bool supportDistance = exercise.exercise?.supportsDistance ?? false;
    final bool supportTime = exercise.exercise?.supportsTime ?? false;

    final isResting = (exercise.restTimeSeconds ?? 0) > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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

          // Rest Timer
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => controller.onRestTimerTap(exercise),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.timer,
                      color: AppColors.activityPrimaryColor,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    RichText(
                      text: TextSpan(
                        text: 'Rest Timer',
                        style: TextStyle(
                          color: AppColors.activityPrimaryColor,
                          fontSize: 13,
                        ),
                        children: [
                          if (isResting)
                            TextSpan(
                              text: ' (${exercise.restTimeSeconds ?? 0})',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                        ],
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
            children: [
              Expanded(flex: 1, child: _HeaderCell('SET')),
              Expanded(flex: 3, child: _HeaderCell('PREVIOUS')),
              if (supportWeight) Expanded(flex: 2, child: _HeaderCell('KG')),
              if (supportReps) Expanded(flex: 2, child: _HeaderCell('REPS')),
              if (supportDistance) Expanded(flex: 2, child: _HeaderCell('KM')),
              if (supportTime) Expanded(flex: 2, child: _HeaderCell('TIME')),
              Expanded(flex: 1, child: _HeaderCell('', showIcon: true)),
            ],
          ),
          const SizedBox(height: 8),

          // Main List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: exercise.sets?.length ?? 0,
            itemBuilder: (context, index) {
              final Set? set = exercise.sets?[index];

              if (set == null) return SizedBox.shrink();

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Dismissible(
                    key: ObjectKey(set),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (direction) {
                      final kgText = set.weightKg.isNotEmpty
                          ? set.weightKg
                          : '0';
                      final repsText = set.reps ?? '0';
                      final details = '$kgText kg x $repsText reps';

                      return showDeleteConfirmationDialog(
                        context: context,
                        title: 'Delete Set ${set.setType} ($details)?',
                        message:
                            'Are you sure you want to remove this set? This action cannot be undone.',
                        onDelete: () =>
                            controller.workoutService.removeSet(index),
                      );
                    },
                    background: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.activityPrimaryColor,
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
                      set: set.setType ?? '',
                      previous: set.previous,
                      kg: set.weightKg ?? '',
                      reps: (set.reps ?? 0).toString(),
                      highlightText: '5.00',
                      completed: set.isCompleted ?? false,
                      highlight: true,
                      supportWeight: supportWeight,
                      supportReps: supportReps,
                      supportDistance: supportDistance,
                      supportTime: supportTime,
                      distance: '',
                      time: '',
                      onDistanceChange: (value) {},
                      onTimeChange: (value) {},
                      onSetTapped: (newSetType) {
                        controller.workoutService.updateSetType(
                          index,
                          newSetType,
                        );
                      },
                      onCompleteTap: (isCompleted) {
                        controller.workoutService.toggleCompletion(
                          index,
                          isCompleted,
                        );
                      },
                      onKgChanged: (value) {
                        controller.workoutService.updateKg(index, value);
                      },
                      onRepsChanged: (value) {
                        controller.workoutService.updateReps(index, value);
                      },
                    ),
                  ),
                  // Timer Progress Bar
                  Obx(() {
                    final enableTimer =
                        // controller.restTimerService.totalRestTimeInSec.value > 0
                        (exercise.restTimeSeconds ?? 0) > 0 &&
                        (set.isCompleted ?? false);
                    return Visibility(
                      visible: enableTimer,
                      child: TimedProgressBar(
                        seconds: exercise.restTimeSeconds ?? 0,
                        // controller
                        //     .restTimerService
                        //     .totalRestTimeInSec
                        //     .value,
                      ),
                    );
                  }),
                ],
              );
            },
          ),

          /// Add Set
          Center(
            child: TextButton(
              onPressed: () {
                controller.workoutService.addSet();
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
  final bool showIcon;

  const _HeaderCell(this.text, {this.showIcon = false});

  @override
  Widget build(BuildContext context) {
    return Center(
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
    );
  }
}

class _SetRow extends StatelessWidget {
  final String set;
  final String previous;
  final String kg;
  final String distance;
  final String reps;
  final String time;
  final String highlightText;
  final bool supportWeight;
  final bool supportReps;
  final bool supportDistance;
  final bool supportTime;
  final bool completed;
  final bool highlight;
  final ValueChanged<SetType> onSetTapped;
  final ValueChanged<bool> onCompleteTap;
  final ValueChanged<String> onKgChanged;
  final ValueChanged<String> onRepsChanged;
  final ValueChanged<String> onDistanceChange;
  final ValueChanged<String> onTimeChange;

  const _SetRow({
    required this.set,
    required this.previous,
    required this.kg,
    required this.reps,
    required this.highlightText,
    required this.completed,
    required this.onSetTapped,
    required this.onCompleteTap,
    required this.onKgChanged,
    required this.onRepsChanged,
    this.highlight = true,
    required this.supportWeight,
    required this.supportReps,
    required this.supportDistance,
    required this.supportTime,
    required this.distance,
    required this.time,
    required this.onDistanceChange,
    required this.onTimeChange,
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
          // Weight Input Field
          if (supportWeight) ...[
            Expanded(
              flex: 2,
              child: _KgInputField(initialValue: kg, onChanged: onKgChanged),
            ),
            const SizedBox(width: 6),
          ],

          if (supportDistance) ...[
            Expanded(
              flex: 2,
              child: _KgInputField(
                initialValue: distance,
                onChanged: onDistanceChange,
              ),
            ),
          ],

          if (supportTime) ...[
            Expanded(
              child: _KgInputField(initialValue: time, onChanged: onTimeChange),
            ),
          ],

          if (supportReps) ...[
            Expanded(
              flex: 2,
              child: _RepsInputField(
                initialValue: reps,
                onChanged: onRepsChanged,
              ),
            ),
          ],

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

class _KgInputField extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String> onChanged;

  const _KgInputField({required this.initialValue, required this.onChanged});

  @override
  State<_KgInputField> createState() => _KgInputFieldState();
}

class _KgInputFieldState extends State<_KgInputField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.initialValue);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant _KgInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != _controller.text) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 34,
      child: TextFormField(
        controller: _controller,
        enabled: true,
        keyboardType: TextInputType.number,
        onChanged: widget.onChanged,
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

class _RepsInputField extends StatefulWidget {
  const _RepsInputField({required this.initialValue, required this.onChanged});

  final String initialValue;
  final ValueChanged<String> onChanged;

  @override
  State<_RepsInputField> createState() => _RepsInputFieldState();
}

class _RepsInputFieldState extends State<_RepsInputField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.initialValue);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant _RepsInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != _controller.text) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      controller: _controller,
      keyboardType: TextInputType.none,
      onTap: () {
        Get.bottomSheet(
          ActivityRepKeyboard(
            controller: _controller,
            onDone: () {
              Get.back();
            },
            onRPE: () {
              Get.back();
            },
            initialValue: double.tryParse(widget.initialValue),
          ),
        );
      },
      textAlign: TextAlign.center,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: theme.scaffoldBackgroundColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        suffix: Text(
          widget.initialValue,
          style: TextStyle(
            color: Colors.orange,
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
