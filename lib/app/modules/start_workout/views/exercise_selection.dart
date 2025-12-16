import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/widgets/action_button.dart';
import 'package:icon/app/core/widgets/super_image.dart';
import 'package:icon/app/core/widgets/super_widgets/super_icon.dart';
import 'package:icon/app/core/widgets/super_widgets/super_icon_source.dart';
import 'package:icon/app/modules/start_workout/models/equipment_item.dart';
import '../../../../generated/assets.dart';
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
        padding: const EdgeInsets.all(6.0),
        child: ActionButton.compact(onTap: () {}),
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
          _filters(theme, context),
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

  SliverToBoxAdapter get space => SliverToBoxAdapter(child: 12.height);

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
  SliverToBoxAdapter _filters(ThemeData theme, BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsetsGeometry.all(6),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Row(
          children: [
            Expanded(
              child: ActionButton(
                label: 'All Equipment',
                bgColor: theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(6),
                onTap: () {
                  equipmentBottomSheet(context, theme);
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ActionButton(
                label: 'All Muscles',
                bgColor: theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(6),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> equipmentBottomSheet(BuildContext context, ThemeData theme) {
    return Get.bottomSheet(
      isScrollControlled: true,
      DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: Column(
                children: [
                  // Header with title and close button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'All Equipment',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),

                  // List of chips
                  Expanded(
                    child: ListView.separated(
                      controller: scrollController,
                      // Important for DraggableScrollableSheet
                      physics: const ClampingScrollPhysics(),
                      itemCount: controller
                          .exerciseSelectionService
                          .equipmentItems
                          .length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        return Obx(() {
                          final item = controller
                              .exerciseSelectionService
                              .equipmentItems[index];
                          final isSelected = item.isSelected;
                          return Card(
                            color: theme.scaffoldBackgroundColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              onTap: () {
                                controller.exerciseSelectionService
                                    .selectSingleEquipment(index);
                              },

                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              leading: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color:
                                      theme.colorScheme.surfaceContainerHighest,
                                  shape: BoxShape.circle,
                                ),
                                child: SuperImage(
                                  controller
                                      .exerciseSelectionService
                                      .equipmentItems[index]
                                      .image,
                                  width: 40,
                                  height: 40,
                                ),
                              ),
                              title: Text(
                                controller
                                    .exerciseSelectionService
                                    .equipmentItems[index]
                                    .label,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              trailing: isSelected
                                  ? SuperIcon(
                                      source: SuperIconSource.svgAsset(
                                        Assets.iconsCheckmarkSelected,
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          );
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _chip({
    required String title,
    String label = '',
    required ThemeData theme,
    required VoidCallback onTap,
    required bool isSelected,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              SuperImage('', radius: 100),
              const SizedBox(width: 8),
              Text(label, style: theme.textTheme.titleSmall),
              const Spacer(),
              const Icon(Icons.close, size: 16),
            ],
          ),
        ),
      ),
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
