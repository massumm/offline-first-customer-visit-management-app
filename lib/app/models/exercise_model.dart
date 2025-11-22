import 'package:icon/app/core/enums/body_areas.dart';
import 'package:icon/app/modules/weekly_routine/utils/enums/equipment_type_enum.dart';

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
  final EquipmentTypeEnum? equipmentType;

  ExerciseModel({
    required this.name,
    required this.lightAsset,
    required this.darkAsset,
    required this.sets,
    this.reps,
    this.bodyAreaList,
    this.routinesCount,
    this.equipmentType,
  });

  ExerciseModel copyWith({
    String? name,
    String? lightAsset,
    String? darkAsset,
    int? sets,
    String? reps,
    List<BodyAreas>? bodyArea,
    int? routinesCount,
    EquipmentTypeEnum? equipmentType,
  }) {
    return ExerciseModel(
      name: name ?? this.name,
      lightAsset: lightAsset ?? this.lightAsset,
      darkAsset: darkAsset ?? this.darkAsset,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      bodyAreaList: bodyArea ?? bodyAreaList,
      routinesCount: routinesCount ?? this.routinesCount,
      equipmentType: equipmentType ?? this.equipmentType,
    );
  }
}
