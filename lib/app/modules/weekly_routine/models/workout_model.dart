import 'package:get/get.dart';
import 'package:icon/app/core/enums/week_days.dart';
import 'package:icon/app/models/exercise_model.dart';

class RoutineModel {
  final WeekDays day;
  final RxList<ExerciseModel> workOuts;
  final bool isRestDay;

  RoutineModel({
    required this.day,
    required this.workOuts,
    this.isRestDay = false,
  });

  RoutineModel copyWith({
    WeekDays? day,
    RxList<ExerciseModel>? workOuts,
    bool? isRestDay,
  }) {
    return RoutineModel(
      day: day ?? this.day,
      workOuts: workOuts ?? this.workOuts,
      isRestDay: isRestDay ?? this.isRestDay,
    );
  }
}
