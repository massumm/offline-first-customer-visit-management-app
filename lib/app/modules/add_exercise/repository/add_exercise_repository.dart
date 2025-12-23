import '../models/equipments_response_model.dart';
import '../models/exercises_response_model.dart';
import '../models/muscle_group_response_model.dart';

abstract class AddExerciseRepository {
  Future<MuscleGroupResponseModel> getMusclesGroups();
  Future<EquipmentResponseModel> getEquipments();
  Future<ExercisesResponseModel> getExercises();
}
