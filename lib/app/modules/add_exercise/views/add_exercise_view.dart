import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';

import '../../../../generated/assets.dart';
import '../../../core/extensions/app_extansions.dart';
import '../../../core/widgets/action_button.dart';
import '../../../core/widgets/super_image.dart';
import '../../../core/widgets/super_widgets/super_icon.dart';
import '../../../core/widgets/super_widgets/super_icon_source.dart';
import '../controllers/add_exercise_controller.dart';
import '../models/muscle_group_model.dart';
import '../widgets/exercise_tile.dart';

class AddExerciseView extends BaseView<AddExerciseController> {
  const AddExerciseView({super.key});
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      title: Text('Add Exercise', style: theme.textTheme.titleMedium),
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ActionButton.compact(onTap: Get.back),
      ),
    );
  }

  @override
  Widget body(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12.0),
      child: CustomScrollView(
        slivers: [
          _searchBar(),
          SliverToBoxAdapter(child: 12.height),
          _filters(theme, context),
          _sectionTitle('Recent Exercises'),
          Obx(
            () => controller.isLoading.value
                ? SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  )
                : _exerciseListRecent(),
          ),
          _sectionTitle('All Exercises'),
          Obx(
            () => controller.isLoading.value
                ? SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  )
                : _exerciseListAll(),
          ),
          SliverToBoxAdapter(child: 12.height),
          _bottomButton(context),
        ],
      ),
    );
  }

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

  // //  Filters
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
              child: Obx(() {
                return ActionButton(
                  label: controller.selectedEquipment.value.name,
                  bgColor: theme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(6),
                  onTap: () {
                    equipmentBottomSheet(context, theme);
                  },
                );
              }),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Obx(() {
                return ActionButton(
                  label: controller.selectedMuscle.value.name,
                  bgColor: theme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(6),
                  onTap: () {
                    musclesBottomSheet(context, theme);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  //
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
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          'All Equipment',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
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
                      itemCount: controller.equipmentItems.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        return Obx(() {
                          final item = controller.equipmentItems[index];

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
                                controller.selectedEquipment.value = item;
                                controller.filterExercises();
                              },

                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: SuperImage(
                                  controller.equipmentItems[index].iconImage,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              title: Text(
                                controller.equipmentItems[index].name ?? "",
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              trailing:
                                  controller.selectedEquipment.value == item
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

  //
  Future<dynamic> musclesBottomSheet(BuildContext context, ThemeData theme) {
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
                        'All Muscles',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),

                  //  List of chips
                  Expanded(
                    child: ListView.separated(
                      controller: scrollController,
                      physics: const ClampingScrollPhysics(),
                      itemCount: controller.musclesItems.length,
                      separatorBuilder: (BuildContext _, int _) =>
                          const SizedBox(height: 8),
                      itemBuilder: (BuildContext context, int index) {
                        final MuscleGroupModel item =
                            controller.musclesItems[index];

                        return Obx(() {
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
                                controller.selectedMuscle.value = item;
                                controller.filterExercises();
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
                                  controller.musclesItems[index].iconImage,
                                  width: 40,
                                  height: 40,
                                ),
                              ),
                              title: Text(
                                item.name ?? "",
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              trailing: item == controller.selectedMuscle.value
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

  Widget _exerciseListRecent() {
    return Obx(() {
      final exercises =
          (controller.isMuscleSelected.value ||
              controller.isEquipmentSelected.value)
          ? controller.filteredRecentExercises
          : controller.recentExercises;
      return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return ExerciseTile(exercise: exercises[index]);
        }, childCount: exercises.length),
      );
    });
  }

  Widget _exerciseListAll() {
    return Obx(() {
      final exercises =
          (controller.isMuscleSelected.value ||
              controller.isEquipmentSelected.value)
          ? controller.filteredAllExercises
          : controller.allExercises;
      return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return ExerciseTile(exercise: exercises[index]);
        }, childCount: exercises.length),
      );
    });
  }

  //

  // //  Section title
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

  SliverFillRemaining _bottomButton(BuildContext context) {
    final theme = Theme.of(context);

    return SliverFillRemaining(
      hasScrollBody: false,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            // onPressed: service.selectedCount == 0 ? null : () {},
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.secondary,
            ),
            child: Obx(() {
              return Text(
                'Added ${controller.selectedExercise.length} Workout',

                style: const TextStyle(fontSize: 16),
              );
            }),
          ),
        ),

        // Obx(() =>),
      ),
    );
  }
}
