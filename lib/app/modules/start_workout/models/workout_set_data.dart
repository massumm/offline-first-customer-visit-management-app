import 'package:flutter/material.dart';

class WorkoutSetData {
  final String setType;
  final String previous;
  final TextEditingController kgController;
  final TextEditingController repsController;
  final bool isComplete;

  WorkoutSetData({
    required this.setType,
    required this.previous,
    required this.kgController,
    required this.repsController,
    required this.isComplete,
  });

  // Copy with method
  WorkoutSetData copyWith({
    String? setType,
    String? previous,
    TextEditingController? kgController,
    TextEditingController? repsController,
    bool? isComplete,
  }) => WorkoutSetData(
    setType: setType ?? this.setType,
    previous: previous ?? this.previous,
    kgController: kgController ?? this.kgController,
    repsController: repsController ?? this.repsController,
    isComplete: isComplete ?? this.isComplete,
  );
}
