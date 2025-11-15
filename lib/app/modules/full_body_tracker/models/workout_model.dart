import 'package:get/get.dart';
import 'package:icon/app/models/exercise_model.dart';

class Workout {
  final String name;
  final String day;
  final String description;
  final List<ExerciseModel> exercises;
  final RxBool expanded;

  Workout({
    required this.name,
    required this.day,
    required this.description,
    required this.exercises,
    required this.expanded,
  });

  Workout copyWith({
    String? name,
    String? day,
    String? description,
    List<ExerciseModel>? exercises,
    RxBool? expanded,
  }) {
    return Workout(
      name: name ?? this.name,
      day: day ?? this.day,
      description: description ?? this.description,
      exercises: exercises ?? this.exercises,
      expanded: expanded ?? this.expanded,
    );
  }
}
