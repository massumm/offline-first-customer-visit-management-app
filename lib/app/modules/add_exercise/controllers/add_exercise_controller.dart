import 'package:get/get.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';

import '../../../base/base_controller.dart';
import '../models/equipment_model.dart';
import '../models/equipments_response_model.dart';
import '../models/exercises_response_model.dart';
import '../models/muscle_group_model.dart';
import '../models/muscle_group_response_model.dart';
import '../repository/add_exercise_repository.dart';

class AddExerciseController extends BaseController {
  final AddExerciseRepository _addExerciseRepository = Get.find(
    tag: (AddExerciseRepository).toString(),
  );

  final RxBool isLoading = true.obs;

  /// Muscle Group State Information's
  final RxBool isMuscleSelected = false.obs;
  final Rx<MuscleGroupModel> selectedMuscle = MuscleGroupModel(
    name: "All Muscles",
  ).obs;
  final RxList<MuscleGroupModel> musclesItems = <MuscleGroupModel>[
    MuscleGroupModel(name: "All Muscles"),
  ].obs;

  /// Equipment State Information's
  final RxBool isEquipmentSelected = false.obs;
  final Rx<EquipmentModel> selectedEquipment = EquipmentModel(
    name: "All Equipments",
  ).obs;
  final RxList<EquipmentModel> equipmentItems = <EquipmentModel>[
    EquipmentModel(name: "All Equipments"),
  ].obs;

  /// Exercises State Information's
  final RxList<Exercise> recentExercises = <Exercise>[].obs;
  final RxList<Exercise> filteredRecentExercises = <Exercise>[].obs;
  final RxList<Exercise> allExercises = <Exercise>[].obs;
  final RxList<Exercise> filteredAllExercises = <Exercise>[].obs;
  final RxList<Exercise> selectedExercise = <Exercise>[].obs;

  bool isExerciseSelected(Exercise exercise) =>
      selectedExercise.contains(exercise);

  void filterExercises() {
    final bool isAllMuscles = selectedMuscle.value.name == "All Muscles";
    final bool isAllEquipments =
        selectedEquipment.value.name == "All Equipments";

    if (isAllMuscles && isAllEquipments) {
      // Show all exercises when both filters are "All"
      isMuscleSelected.value = false;
      isEquipmentSelected.value = false;
      filteredAllExercises.clear();
      filteredRecentExercises.clear();
    } else {
      // Determine which filters are active
      isMuscleSelected.value = !isAllMuscles;
      isEquipmentSelected.value = !isAllEquipments;

      // Filter all exercises
      filteredAllExercises.clear();
      filteredAllExercises.addAll(
        allExercises.where((Exercise exercise) {
          bool matchesMuscle = isAllMuscles;
          if (!matchesMuscle && exercise.muscleGroup != null) {
            matchesMuscle = exercise.muscleGroup!.any(
              (mg) => mg.id == selectedMuscle.value.id,
            );
          }

          bool matchesEquipment = isAllEquipments;
          if (!matchesEquipment && exercise.equipment != null) {
            matchesEquipment = exercise.equipment!.any(
              (eq) => eq.id == selectedEquipment.value.id,
            );
          }

          return matchesMuscle && matchesEquipment;
        }).toList(),
      );

      // Filter recent exercises
      filteredRecentExercises.clear();
      filteredRecentExercises.addAll(
        recentExercises.where((Exercise exercise) {
          bool matchesMuscle = isAllMuscles;
          if (!matchesMuscle && exercise.muscleGroup != null) {
            matchesMuscle = exercise.muscleGroup!.any(
              (mg) => mg.id == selectedMuscle.value.id,
            );
          }

          bool matchesEquipment = isAllEquipments;
          if (!matchesEquipment && exercise.equipment != null) {
            matchesEquipment = exercise.equipment!.any(
              (eq) => eq.id == selectedEquipment.value.id,
            );
          }

          return matchesMuscle && matchesEquipment;
        }).toList(),
      );
    }
  }

  void toggleExercise(Exercise exercise) {
    if (!selectedExercise.contains(exercise)) {
      selectedExercise.add(exercise);
    } else {
      selectedExercise.remove(exercise);
    }
  }

  @override
  void onInit() {
    super.onInit();

    /// Add Muscle Group
    _addExerciseRepository.getMusclesGroups().then((
      MuscleGroupResponseModel data,
    ) {
      musclesItems.addAll(data.results!);
    });

    /// Add Equipment
    _addExerciseRepository.getEquipments().then((EquipmentResponseModel data) {
      equipmentItems.addAll(data.results!);
    });

    /// All Exercises and Recent Exercises
    _addExerciseRepository.getExercises().then((ExercisesResponseModel data) {
      recentExercises.value = data.recent!;
      allExercises.value = data.results!;
      isLoading.value = false;
    });
  }

  void onAddTap() {
    Get.back(result: selectedExercise);
  }
}
