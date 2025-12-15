import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/widgets/action_pill.dart';
import '../controllers/start_workout_controller.dart';
import '../services/exercise_selection_service.dart';

class ExerciseSelectionView extends BaseView<StartWorkoutController> {
  const ExerciseSelectionView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      title: Text('Add Exercise', style: theme.textTheme.titleMedium),
      centerTitle: true,
      leading: Padding(
        padding: EdgeInsetsGeometry.all(10),
        child: ActionPill(onTap: Get.back),
      ),
    );
  }

  @override
  Widget body(BuildContext context) {
    final theme = Theme.of(context);
    final ExerciseSelectionService service =
        controller.exerciseSelectionService;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12.0),
      child: CustomScrollView(
        slivers: [
          _searchBar(),
          space,
          _filters(theme),
          _sectionTitle('Recent Exercises'),
          Obx(() => _exerciseList(service.recentExercises)),
          _sectionTitle('All Exercises'),
          Obx(() => _exerciseList(service.allExercises)),
          _bottomButton(),
        ],
      ),
    );
  }

  // Spaces

  SliverToBoxAdapter get space  => SliverToBoxAdapter(child: 12.height);

  //  Search
  SliverToBoxAdapter _searchBar() {
    return SliverToBoxAdapter(
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(22),
        ),
        child: const TextField(
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search exercises',
            hintStyle: TextStyle(color: Colors.grey),
            prefixIcon: Icon(Icons.search, color: Colors.grey),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  //  Filters
  SliverToBoxAdapter _filters(ThemeData theme) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsetsGeometry.all(6),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Row(
          children: [
            Expanded(child: _chip('All Equipment', theme)),
            const SizedBox(width: 8),
            Expanded(child: _chip('All Muscles', theme)),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(child: Text(label, style: theme.textTheme.titleSmall)),
    );
  }

  //  Section title
  SliverToBoxAdapter _sectionTitle(String text) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // Exercise list
  SliverList _exerciseList(List<Exercise> exercises) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        return ExerciseTile(exercise: exercises[index]);
      }, childCount: exercises.length),
    );
  }

  SliverFillRemaining _bottomButton() {
    final ExerciseSelectionService service =
        controller.exerciseSelectionService;

    return SliverFillRemaining(
      hasScrollBody: false,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Obx(
            () => SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: service.selectedCount == 0 ? null : () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
                child: Text(
                  'Added ${service.selectedCount} Workout',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ExerciseTile extends StatelessWidget {
  final Exercise exercise;

  const ExerciseTile({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }
}
