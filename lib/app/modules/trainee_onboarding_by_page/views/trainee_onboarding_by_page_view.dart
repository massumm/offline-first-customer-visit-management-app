import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:icon/app/core/values/app_colors.dart';

import 'package:icon/app/core/widgets/qanda_progress_bar.dart';

import 'package:icon/app/core/widgets/input_widgets/wheel_list_widget.dart';
import 'package:icon/app/core/widgets/input_widgets/date_input_field.dart';
import 'package:icon/app/core/widgets/input_widgets/height_picker.dart';
import 'package:icon/app/core/widgets/input_widgets/weight_picker.dart';

import '../controllers/trainee_onboarding_by_page_controller.dart';

class TraineeOnboardingByPageView
    extends GetView<TraineeOnboardingByPageController> {
  const TraineeOnboardingByPageView({super.key});

  // All state and navigation logic will be handled by the controller.

  @override
  Widget build(BuildContext context) {
    const int onboardingSteps = 12;
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          leading: controller.currentPage.value > 0
              ? IconButton(
                  icon: Transform.rotate(
                    angle: 3.14,
                    child: SvgPicture.asset('assets/svg/arrow-right.svg'),
                  ),
                  onPressed: controller.prevPage,
                )
              : Opacity(
                  opacity: 0.0,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: null,
                  ),
                ),
        ),
        body: CustomScrollView(
          physics: NeverScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: QandAProgressBar(
                  currentGroup: 1,
                  totalGroups: 1,
                  currentQuestion: controller.currentPage.value + 1,
                  totalQuestions: onboardingSteps,
                ),
              ),
            ),
            SliverFillRemaining(
              child: PageView(
                controller: controller.pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) => controller.currentPage.value = index,
                children: [
                  _buildSexPage(),
                  _buildDobPage(),
                  _buildHeightPage(),
                  _buildWeightPage(),
                  _buildFitnessGoalPage(),
                  _buildLifestylePage(),
                  _buildTrainingDaysPage(),
                  _buildSessionLengthPage(),
                  _buildEatingHabitsPage(),
                  _buildStressLevelPage(),
                  _buildSleepQualityPage(),
                  _buildEmailPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailPage() {
    return _buildNavigation(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What is your email address?',
            style: TextStyle(fontSize: 24),
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 24),
          TextField(
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) => controller.email.value = value,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigation({required Widget child}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400),
            child: child,
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(16.0),
          child: _buildActionButton(),
        ),
      ],
    );
  }

  Widget? _buildActionButton() {
    if (controller.currentPage.value < 10) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: controller.nextPage,
          child: Text('Next', style: TextStyle(fontSize: 16)),
        ),
      );
    }
    if (controller.currentPage.value == 10) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: controller.submitAnswers,
          child: Text('Finish'),
        ),
      );
    }
    return null;
  }

  Widget _buildWideChoiceButton({
    required String title,
    required Function onPressed,
    required bool isSelected,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: FilledButton(
        onPressed: () {
          onPressed();
        },
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF1F1F1F),
          foregroundColor: isSelected ? AppColors.colorPrimary : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: isSelected ? AppColors.colorPrimary : Colors.transparent,
              width: 2,
            ),
          ),
          minimumSize: Size.fromHeight(54),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 16,
                  color: isSelected ? AppColors.colorPrimary : Colors.white,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            SvgPicture.asset(
              'assets/svg/arrow-right.svg',
              colorFilter: ColorFilter.mode(
                isSelected ? AppColors.colorPrimary : Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSexPage() {
    return _buildNavigation(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'What is your sex?',
            style: TextStyle(fontSize: 24),
            textAlign: TextAlign.start,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ...['Male', 'Female', 'Others'].expand((sex) {
                  const options = ['Male', 'Female', 'Others'];
                  return [
                    _buildWideChoiceButton(
                      title: sex,
                      isSelected: controller.sex.value == sex,
                      onPressed: () => controller.sex.value = sex,
                    ),
                    if (sex != options.last) const SizedBox(height: 12),
                  ];
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDobPage() {
    return _buildNavigation(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'What is your date of birth?',
            style: TextStyle(fontSize: 24),
            textAlign: TextAlign.start,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DatePickerInputField(
              hint: 'dd/mm/yyyy',
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
              onSelectDate: (value) {
                final parts = value.split('/');
                if (parts.length == 3) {
                  final dd = int.tryParse(parts[0]);
                  final mm = int.tryParse(parts[1]);
                  final yyyy = int.tryParse(parts[2]);
                  if (dd != null && mm != null && yyyy != null) {
                    final dt = DateTime(yyyy, mm, dd);
                    controller.dob.value = dt;
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeightPage() {
    return _buildNavigation(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'What is your height?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.bottomCenter,
            child: HeightPicker(
              minHeightCm: 120,
              maxHeightCm: 250,
              initialHeightCm: 170,
              onChanged: (double value, unit) {
                controller.height.value = value;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightPage() {
    return _buildNavigation(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'What is your current weight?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.bottomCenter,
            child: WeightPicker(
              minWeightKg: 30,
              maxWeightKg: 200,
              initialWeightKg: 70,
              onChanged: (double value, unit) {
                controller.weight.value = value;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFitnessGoalPage() {
    final options = [
      'Lose fat',
      'Build muscle',
      'Get fitter',
      'Improve health',
      'Feel better in myself',
    ];
    return _buildNavigation(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What is your primary fitness goal?',
            style: TextStyle(fontSize: 24),
            textAlign: TextAlign.start,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...options.expand((goal) {
                    return [
                      _buildWideChoiceButton(
                        title: goal,
                        isSelected: controller.fitnessGoal.value == goal,
                        onPressed: () => controller.fitnessGoal.value = goal,
                      ),
                      if (goal != options.last) const SizedBox(height: 12),
                    ];
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLifestylePage() {
    final options = [
      'Very sedentary',
      'Lightly active',
      'Moderately active',
      'Very active',
      'Extremely active',
    ];
    return _buildNavigation(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How active is your daily lifestyle?',
            style: TextStyle(fontSize: 24),
            textAlign: TextAlign.start,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...options.expand((lifestyle) {
                    return [
                      _buildWideChoiceButton(
                        title: lifestyle,
                        isSelected: controller.lifestyle.value == lifestyle,
                        onPressed: () => controller.lifestyle.value = lifestyle,
                      ),
                      if (lifestyle != options.last) const SizedBox(height: 12),
                    ];
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrainingDaysPage() {
    return _buildNavigation(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How many days per week can you train?',
            style: TextStyle(fontSize: 24),
            textAlign: TextAlign.start,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  WheelListWidget(
                    items: List.generate(7, (i) => '${i + 1}'),
                    onNext: (val) {
                      controller.trainingDays.value = int.parse(val);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionLengthPage() {
    final options = ['15mins', '30mins', '45mins', '1hr', '1hr+'];
    return _buildNavigation(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How long do you want each session to be?',
            style: TextStyle(fontSize: 24),
            textAlign: TextAlign.start,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...options.expand(
                        (length) {
                      return [
                        _buildWideChoiceButton(
                          title: length,
                          isSelected: controller.sessionLength.value == length,
                          onPressed: () =>
                          controller.sessionLength.value = length,
                        ),
                        if (length != options.last) const SizedBox(height: 12),
                      ];
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEatingHabitsPage() {
    final options = ['Undereat', 'Balanced', 'Overeat', 'Mixed'];
    return _buildNavigation(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How would you describe your current eating habits?',
            style: TextStyle(fontSize: 24),
            textAlign: TextAlign.start,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...options.expand(
                        (habit) {
                      return [
                        _buildWideChoiceButton(
                          title: habit,
                          isSelected: controller.eatingHabits.value == habit,
                          onPressed: () => controller.eatingHabits.value = habit,
                        ),
                        if (habit != options.last) const SizedBox(height: 12),
                      ];
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStressLevelPage() {
    final options = ['Low', 'Mixed', 'High'];
    return _buildNavigation(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How would you describe your stress levels?',
            style: TextStyle(fontSize: 24),
            textAlign: TextAlign.start,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...options.expand(
                        (level) {
                      return [
                        _buildWideChoiceButton(
                          title: level,
                          isSelected: controller.stressLevel.value == level,
                          onPressed: () => controller.stressLevel.value = level,
                        ),
                        if (level != options.last) const SizedBox(height: 12),
                      ];
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSleepQualityPage() {
    final options = ['Poor', 'Okay', 'Good'];
    return _buildNavigation(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How is your current sleep?',
            style: TextStyle(fontSize: 24),
            textAlign: TextAlign.start,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...options.expand(
                        (sleep) {
                      return [
                        _buildWideChoiceButton(
                          title: sleep,
                          isSelected: controller.sleepQuality.value == sleep,
                          onPressed: () => controller.sleepQuality.value = sleep,
                        ),
                        if (sleep != options.last) const SizedBox(height: 12),
                      ];
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
