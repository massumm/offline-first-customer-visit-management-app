import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:icon/app/core/widgets/input_widgets/date_input_field.dart';
import 'package:icon/app/core/values/app_colors.dart';

import 'widgets/animated_onboarding_stepper.dart';

import 'widgets/height_picker.dart';
import 'widgets/weight_picker.dart';

class TraineeOnboardingThroughPageView extends StatefulWidget {
  const TraineeOnboardingThroughPageView({super.key});

  @override
  State<TraineeOnboardingThroughPageView> createState() =>
      _TraineeOnboardingThroughPageViewState();
}

class _TraineeOnboardingThroughPageViewState
    extends State<TraineeOnboardingThroughPageView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Answers
  String _sex = 'Male';
  DateTime? _dob;
  double? _height;
  double? _weight;
  String? _fitnessGoal;
  String? _lifestyle;
  int _trainingDays = 1;
  String? _sessionLength;
  String? _eatingHabits;
  String? _stressLevel;
  String? _sleepQuality;

  void _nextPage() {
    if (_currentPage < 10) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const int onboardingSteps = 11;
    return Scaffold(
      appBar: AppBar(
        leading: _currentPage > 0
            ? IconButton(
                icon: Transform.rotate(
                  angle: 3.14,
                  child: SvgPicture.asset('assets/svg/arrow-right.svg'),
                ),
                onPressed: _prevPage,
              )
            : Opacity(
                opacity: 0.0,
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: null,
                ),
              ),
        title: AnimatedOnboardingStepper(
          totalSteps: onboardingSteps,
          currentStep: _currentPage,
          stepProgress: 0.0,
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (index) => setState(() => _currentPage = index),
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
    Widget? actionButton;
    if (_currentPage < 10) {
      actionButton = SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _nextPage,
          child: Text('Next', style: TextStyle(fontSize: 16)),
        ),
      );
    }
    if (_currentPage == 10) {
      actionButton = SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            /* Submit logic */
          },
          child: Text('Finish'),
        ),
      );
    }

    return actionButton;
  }

  Widget _buildSmallChoiceButton({
    required String title,
    required Function onPressed,
    required bool isSelected,
  }) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? AppColors.colorPrimary : Colors.transparent,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: FilledButton(
        onPressed: () {
          onPressed();
        },
        style: FilledButton.styleFrom(
          backgroundColor: Color(0xFF151515),
          foregroundColor: isSelected ? AppColors.colorPrimary : Colors.white,
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? AppColors.colorPrimary : Colors.white,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
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
              spacing: 8,
              children: [
                ...['Male', 'Female', 'Others'].map(
                  (sex) => _buildWideChoiceButton(
                    title: sex,
                    isSelected: _sex == sex,
                    onPressed: () => setState(() => _sex = sex),
                  ),
                ),
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
          Text('What is your date of birth?', style: TextStyle(fontSize: 24)),
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
                    setState(() => _dob = dt);
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
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.bottomCenter,
            child: HeightPicker(
              minHeightCm: 120,
              maxHeightCm: 250,
              initialHeightCm: 170,
              onChanged: (double value, HeightUnit unit) {
                setState(() => _height = value);
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
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.bottomCenter,
            child: WeightPicker(
              minWeightKg: 30,
              maxWeightKg: 200,
              initialWeightKg: 70,
              onChanged: (double value, WeightUnit unit) {
                setState(() {
                  _weight = value;
                });
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
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ...options.map(
                    (goal) => _buildSmallChoiceButton(
                      title: goal,
                      isSelected: _fitnessGoal == goal,
                      onPressed: (val) => setState(() => _fitnessGoal = val),
                    ),
                  ),
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
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,

                children: [
                  ...options.map(
                    (lifestyle) => _buildSmallChoiceButton(
                      title: lifestyle,
                      isSelected: _lifestyle == lifestyle,
                      onPressed: () => setState(() => _lifestyle = lifestyle),
                    ),
                  ),
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
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 100,
                    child: ListWheelScrollView.useDelegate(
                      itemExtent: 40,
                      onSelectedItemChanged: (i) =>
                          setState(() => _trainingDays = 1 + i),
                      controller: FixedExtentScrollController(
                        initialItem: _trainingDays - 1,
                      ),
                      childDelegate: ListWheelChildBuilderDelegate(
                        builder: (context, i) =>
                            i < 7 ? Text('${1 + i}') : null,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text('Selected: $_trainingDays days'),
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
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 8,
                children: [
                  ...options.map(
                    (length) => _buildWideChoiceButton(
                      title: length,
                      isSelected: _sessionLength == length,
                      onPressed: () => setState(() => _sessionLength = length),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Workout intensity tag (higher volume = lower intensity)',
                    style: TextStyle(fontSize: 12),
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
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 8,
                children: [
                  ...options.map(
                    (habit) => _buildWideChoiceButton(
                      title: habit,
                      isSelected: _eatingHabits == habit,
                      onPressed: () => setState(() => _eatingHabits = habit),
                    ),
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
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 8,
                children: [
                  ...options.map(
                    (level) => _buildWideChoiceButton(
                      title: level,
                      isSelected: _stressLevel == level,
                      onPressed: () => setState(() => _stressLevel = level),
                    ),
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
          Text('How is your current sleep?', style: TextStyle(fontSize: 24)),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 8,
                children: [
                  ...options.map(
                    (sleep) => _buildWideChoiceButton(
                      title: sleep,
                      isSelected: _sleepQuality == sleep,
                      onPressed: () => setState(() => _sleepQuality = sleep),
                    ),
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
