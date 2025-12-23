import 'package:icon/app/modules/workout/models/workout_create_response_model.dart';

abstract class WorkoutRepository {
  Future<WorkoutCreateResponseModel> createWorkout(Map<String, dynamic> body);
}
