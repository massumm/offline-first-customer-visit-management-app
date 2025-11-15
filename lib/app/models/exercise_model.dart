import 'package:icon/app/core/enums/body_areas.dart';

class ExerciseModel {
  final String name;
  final String lightAsset;
  final String darkAsset;
  
  // Execution fields
  final int sets;
  final String? reps;
  
  // Planning fields
  final List<BodyAreas>? bodyAreaList;
  final int? routinesCount;
  final bool? isGymEquipmentNeeded;

  ExerciseModel({
    required this.name,
    required this.lightAsset,
    required this.darkAsset,
    required this.sets,
    this.reps,
    this.bodyAreaList,
    this.routinesCount,
    this.isGymEquipmentNeeded,
  });

  ExerciseModel copyWith({
    String? name,
    String? lightAsset,
    String? darkAsset,
    int? sets,
    String? reps,
    List<BodyAreas>? bodyArea,
    int? routinesCount,
    bool? isGymEquipmentNeeded,
  }) {
    return ExerciseModel(
      name: name ?? this.name,
      lightAsset: lightAsset ?? this.lightAsset,
      darkAsset: darkAsset ?? this.darkAsset,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      bodyAreaList: bodyArea ?? this.bodyAreaList,
      routinesCount: routinesCount ?? this.routinesCount,
      isGymEquipmentNeeded: isGymEquipmentNeeded ?? this.isGymEquipmentNeeded,
    );
  }
}
