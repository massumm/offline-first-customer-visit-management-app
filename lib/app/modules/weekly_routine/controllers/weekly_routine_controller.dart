import 'package:get/get.dart';
import 'package:icon/app/base/base_controller.dart';
import 'package:icon/app/base/widgets/custom_toast.dart';
import 'package:icon/app/core/enums/week_days.dart';
import 'package:icon/app/models/exercise_model.dart';
import 'package:icon/app/modules/weekly_routine/data/exercise_data.dart';
import 'package:icon/app/modules/weekly_routine/models/week_model.dart';
import 'package:icon/app/modules/weekly_routine/models/workout_model.dart';

class WeeklyRoutineController extends BaseController {
  //TODO: Implement WeeklyRoutineController

  final routines = RxList<RoutineModel>([]);
  final availableExercises = RxList<ExerciseModel>([]);
  final weeks = RxList<WeekModel>([]);
  final deletingWorkouts = <String>{}.obs;

  final selectedDay = WeekDays.sunday.obs;
  final searchQuery = ''.obs;
  final selectedWeek = 0.obs;

  // For undo functionality
  WeekModel? _deletedWeek;
  int? _deletedIndex;

  List<RoutineModel> get currentWeekRoutines => 
    weeks.isNotEmpty ? weeks[selectedWeek.value].routines : [];

  List<ExerciseModel> get filteredExercises {
    if (searchQuery.value.isEmpty) {
      return availableExercises;
    }
    return availableExercises.where((exercise) => 
      exercise.name.toLowerCase().contains(searchQuery.value.toLowerCase())
    ).toList();
  }

  @override
  void onInit() {
    super.onInit();

    _initializeRoutines();
    _populateAvailableExercises();
    _initializeWeeks();
  }

  void _initializeRoutines() {
    final sunday = _createRoutine(WeekDays.sunday, ExerciseData.getSundayExercises(), isRestDay: false);
    final monday = _createRoutine(WeekDays.monday, ExerciseData.getMondayExercises(), isRestDay: true);
    final tuesday = _createRoutine(WeekDays.tuesday, ExerciseData.getTuesdayExercises(), isRestDay: false);
    final wednesday = _createRoutine(WeekDays.wednesday, ExerciseData.getWednesdayExercises(), isRestDay: false);
    final thursday = _createRoutine(WeekDays.thursday, ExerciseData.getThursdayExercises(), isRestDay: false);
    final friday = _createRoutine(WeekDays.friday, ExerciseData.getFridayExercises(), isRestDay: false);
    final saturday = _createRoutine(WeekDays.saturday, ExerciseData.getSaturdayExercises(), isRestDay: false);

    routines.addAll([sunday, monday, tuesday, wednesday, thursday, friday, saturday]);
  }

  RoutineModel _createRoutine(WeekDays day, List<ExerciseModel> exercises, {bool isRestDay = false}) {
    return RoutineModel(
      day: day,
      workOuts: RxList<ExerciseModel>(List.from(exercises)),
      isRestDay: isRestDay,
    );
  }

  void _populateAvailableExercises() {
    // Add all exercises from routines
    for (final routine in routines) {
      for (final exercise in routine.workOuts) {
        if (!availableExercises.any((e) => e.name == exercise.name)) {
          availableExercises.add(exercise);
        }
      }
    }
    
    // Add additional exercises
    for (final exercise in ExerciseData.getAdditionalExercises()) {
      if (!availableExercises.any((e) => e.name == exercise.name)) {
        availableExercises.add(exercise);
      }
    }
  }

  void _initializeWeeks() {
    weeks.addAll([
      WeekModel(weekName: 'Week 1', routines: _createWeekRoutines()),
      WeekModel(weekName: 'Week 2', routines: _createWeekRoutines()),
      WeekModel(weekName: 'Week 3', routines: _createWeekRoutines()),
      WeekModel(weekName: 'Week 4', routines: _createWeekRoutines()),
      WeekModel(weekName: 'Week 5', routines: _createWeekRoutines()),
    ]);
  }

  List<RoutineModel> _createWeekRoutines() {
    return [
      _createRoutine(WeekDays.sunday, ExerciseData.getSundayExercises(), isRestDay: false),
      _createRoutine(WeekDays.monday, ExerciseData.getMondayExercises(), isRestDay: true),
      _createRoutine(WeekDays.tuesday, ExerciseData.getTuesdayExercises(), isRestDay: false),
      _createRoutine(WeekDays.wednesday, ExerciseData.getWednesdayExercises(), isRestDay: false),
      _createRoutine(WeekDays.thursday, ExerciseData.getThursdayExercises(), isRestDay: false),
      _createRoutine(WeekDays.friday, ExerciseData.getFridayExercises(), isRestDay: false),
      _createRoutine(WeekDays.saturday, ExerciseData.getSaturdayExercises(), isRestDay: false),
    ];
  }

  void addExerciseToRoutine(ExerciseModel exercise) {
    // Check which week is selected first
    if (selectedWeek.value < 0 || selectedWeek.value >= weeks.length) {
      CustomToast.showErrorToast('Invalid week selected');
      return;
    }

    final currentWeek = weeks[selectedWeek.value];
    final currentRoutine = currentWeek.routines.firstWhereOrNull(
      (routine) => routine.day == selectedDay.value,
    );

    if (currentRoutine == null) {
      CustomToast.showErrorToast('No routine found for selected day');
      return;
    }

    // Check if exercise already exists in the current routine
    final existingExercise = currentRoutine.workOuts.firstWhereOrNull(
      (existingExercise) => existingExercise.name == exercise.name,
    );

    if (existingExercise != null) {
      CustomToast.showWarningToast('Exercise already added to routine');
    } else {
      currentRoutine.workOuts.add(exercise);
      CustomToast.showSuccessToast('Exercise added to routine');
    }
  }

  bool isExerciseInRoutine(ExerciseModel exercise) {
    // Check which week is selected first
    if (selectedWeek.value < 0 || selectedWeek.value >= weeks.length) {
      return false;
    }

    final currentWeek = weeks[selectedWeek.value];
    final currentRoutine = currentWeek.routines.firstWhereOrNull(
      (routine) => routine.day == selectedDay.value,
    );

    if (currentRoutine == null) {
      return false;
    }

    return currentRoutine.workOuts.any(
      (existingExercise) => existingExercise.name == exercise.name,
    );
  }

  void deleteWorkout(ExerciseModel workout) {
    final currentWeek = weeks[selectedWeek.value];
    final currentRoutine = currentWeek.routines.firstWhereOrNull(
      (routine) => routine.day == selectedDay.value,
    );
    
    if (currentRoutine != null) {
      currentRoutine.workOuts.removeWhere((w) => w.name == workout.name);
      // Update the weeks list to trigger UI refresh
      weeks.refresh();
      CustomToast.showSuccessToast('Workout deleted successfully');
    }
  }

  WeekModel? deleteWeek(int index) {
    if (weeks.length <= 1) {
      CustomToast.showErrorToast('Cannot delete the last week');
      return null;
    }

    if (index < 0 || index >= weeks.length) {
      CustomToast.showErrorToast('Invalid week index');
      return null;
    }

    // Store for undo functionality
    _deletedWeek = weeks[index];
    _deletedIndex = index;

    weeks.removeAt(index);
    
    // Adjust selectedWeek index
    if (weeks.isEmpty) {
      // This shouldn't happen due to the length check above, but handle it
      selectedWeek.value = 0;
    } else if (selectedWeek.value == index) {
      // Deleted the currently selected week, select first week
      selectedWeek.value = 0;
    } else if (selectedWeek.value > index) {
      // Deleted a week before the selected one, decrement selectedWeek
      selectedWeek.value = selectedWeek.value - 1;
    } else if (selectedWeek.value >= weeks.length) {
      // Selected week is now out of bounds, select last week
      selectedWeek.value = weeks.length - 1;
    }

    return _deletedWeek;
  }

  void undoWeek() {
    if (_deletedWeek != null && _deletedIndex != null) {
      weeks.insert(_deletedIndex!, _deletedWeek!);
      
      // Select the restored week
      selectedWeek.value = _deletedIndex!;
      
      _deletedWeek = null;
      _deletedIndex = null;
    }
  }
}
