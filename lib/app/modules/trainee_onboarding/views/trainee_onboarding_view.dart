import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../generated/assets.dart';
import '../../../core/widgets/action_pill.dart';
import '../controllers/trainee_onboarding_controller.dart';
import '../models/onboarding_qa_model.dart';
import 'widgets/animated_onboarding_stepper.dart';
import 'widgets/message_bubble.dart';
import 'widgets/type_bubble.dart';

class TraineeOnboardingView extends BaseView<TraineeOnboardingController> {
  TraineeOnboardingView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    const double bottomWidgetHeight = 80.0;
    final double totalAppBarHeight = kToolbarHeight + bottomWidgetHeight;

    return PreferredSize(
      preferredSize: Size.fromHeight(totalAppBarHeight),
      child: Obx(() {
        // Adjust on Q. previous button
        final double dynamicLeadingWidth = controller.canGoBack ? 78.0 : 48.0;
        return AppBar(
          title: Row(
            children: [
              Stack(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage(Assets.imagesIconLogoPink),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2.0),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xff2FFF3C),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              6.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Mish Icon',
                      style: Theme.of(context).textTheme.titleMedium),
                  Text(
                    'Online',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
          leadingWidth: dynamicLeadingWidth,
          leading: Row(
            children: [
              const SizedBox(width: 8.0),
              SizedBox(
                width: 32.0,
                height: 32.0,
                child: ActionPill(onTap: Get.back),
              ),
              if (controller.canGoBack)
                Padding(
                  padding: const EdgeInsets.only(left: 6.0),
                  child: SizedBox(
                    width: 32.0,
                    height: 32.0,
                    child: ActionPill(
                      onTap: controller.goBack,
                      icon: Icons.undo,
                    ),
                  ),
                ),
            ],
          ),
          actions: [
            if (controller.currentQuestion?.canSkip ?? false) ...[
              TextButton(
                onPressed: () {
                  controller.send('');
                },
                child: const Text('Skip'),
              ),
            ],
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(bottomWidgetHeight),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  6.height,
                  Text(
                    'Personal',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  AnimatedOnboardingStepper(
                    totalSteps: controller.totalGroups.value,
                    currentStep: controller.currentGroupIndex.value,
                    stepProgress: controller.currentGroupProgress.value,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget body(BuildContext context) {
    return Column(
      children: [
        // Obx(
        //   () => OnboardingHeader(
        //     avatarAsset: Assets.imagesIconLogoPink,
        //     name: 'Mish Icon',
        //     statusText: 'Online',
        //     sectionTitle: controller.isFinished
        //         ? "You're all set!"
        //         : controller.getCurrentGroupName ?? "Just a moment...",
        //     totalSteps: controller.totalGroups.value,
        //     currentStep: controller.currentGroupIndex.value,
        //     stepProgress: controller.currentGroupProgress.value,
        //     controller: controller,
        //   ),
        // ),
        // Custom Stepper For visualizing group movement
        Expanded(
          child: Obx(() {
            final items = controller.messages;
            final typing = controller.isTyping.value;
            return ListView.builder(
              controller: controller.pageController,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: items.length + (typing ? 1 : 0),
              itemBuilder: (context, index) {
                final isTypingRow = typing && index == items.length;
                if (isTypingRow) return const TypingBubble();
                final m = items[index];

                // Determine alignment
                final alignment = m.from == Sender.user
                    ? Alignment.centerRight
                    : Alignment.centerLeft;

                // Conditionally build the bubble based on message content
                Widget bubble;
                if (m.imagePath != null && m.imagePath!.isNotEmpty) {
                  // If there's an image, use the new image bubble
                  bubble = _ImageMessageBubble(
                    imagePath: m.imagePath!,
                    from: m.from,
                  );
                } else {
                  // Otherwise, use the existing text bubble
                  bubble = MessageBubble(text: m.text, from: m.from);
                }

                return Align(alignment: alignment, child: bubble);
              },
            );
          }),
        ),

        /// Quick replies (only for choice-type question)
        Obx(() {
          final q = controller.currentQuestion;
          // Hide quick replies if the flow is finished, paused, or not a choice question.
          if (controller.isFinished ||
              controller.showGroupContinuationButtons ||
              q == null ||
              q.type != QAType.choice) {
            return const SizedBox.shrink();
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: q.options
                      .map(
                        (o) => ActionChip(
                          label: Text(o),
                          onPressed: () => controller.choose(o),
                        ),
                      )
                      .toList(),
                ),
              ),
              8.height,
            ],
          );
        }),

        // Input
        SafeArea(
          top: false,
          child: Obx(() {
            // Check for the final continuation state first.
            if (controller.isAwaitingFinalContinuation.isTrue) {
              return _buildFinalContinueButton(context);
            }

            // When a group is finished, show Continue/Skip buttons.
            if (controller.showGroupContinuationButtons) {
              return _buildContinuationButtons();
            }

            if (controller.isCurrentImage) {
              // Show the image picker button
              return _ImagePickerInput(controller: controller);
            }

            // When the current question is a date type, show a date picker button.
            if (controller.isCurrentDate) {
              return _buildDatePickerButton(context);
            }

            // When the current question is a time type, show a time picker button.
            if (controller.isCurrentTime) {
              return _buildTimePickerButton(context);
            }

            //  height and weight pickers
            if (controller.isCurrentHeight) {
              return _HeightPicker(controller: controller);
            }

            if (controller.isCurrentWeight) {
              return _WeightPicker(controller: controller);
            }

            // Hide the input field for Choice questions.
            if (controller.currentQuestion?.type == QAType.choice) {
              return SizedBox.shrink();
            }

            // Default input field for text/number questions.
            return _buildTextInput();
          }),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildFinalContinueButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Obx(
                () => Checkbox(
                  value: controller.hasAgreedToTerms.value,
                  onChanged: controller.toggleTermsAgreement,
                ),
              ),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                      const TextSpan(text: 'I have read and agree to the '),
                      TextSpan(
                        text: 'Terms and Conditions',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          decoration: TextDecoration.underline,
                          decorationColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                        ),
                        // TODO: Add a recognizer to open the terms page
                        // recognizer: TapGestureRecognizer()..onTap = () => Get.toNamed(Routes.TERMS),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Obx(
            () => FilledButton(
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              // The button is disabled if `hasAgreedToTerms` is false
              onPressed: controller.hasAgreedToTerms.value
                  ? controller.proceedToContinue
                  : null,
              child: const Text('Continue'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinuationButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: FilledButton(
              onPressed: controller.continueToNextGroup,
              child: const Text('Continue'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: OutlinedButton(
              onPressed: controller.skipToEnd,
              child: const Text('Skip to End'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePickerButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: ElevatedButton(
        onPressed: () async {
          final DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now().subtract(
              const Duration(days: 365 * 20),
            ),
            firstDate: DateTime(1920),
            lastDate: DateTime.now(),
          );
          if (pickedDate != null) {
            controller.selectDate(pickedDate);
          }
        },
        child: Text(controller.currentQuestion?.hint ?? "Select Date"),
      ),
    );
  }

  Widget _buildTimePickerButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (pickedTime != null) {
          controller.selectTime(pickedTime, context);
        }
      },
      child: Text(controller.currentQuestion?.hint ?? "Select Time"),
    );
  }

  Widget _buildTextInput() {
    return Row(
      children: [
        const SizedBox(width: 8),
        Expanded(
          child: IgnorePointer(
            ignoring: controller.isCurrentChoice,
            child: TextField(
              controller: controller.textController,
              onChanged: (t) => controller.inputText.value = t,
              onSubmitted: (t) {
                controller.send(t);
                controller.textController.clear();
              },
              decoration: InputDecoration(
                hintText: _hintFor(),
                border: const OutlineInputBorder(),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        FilledButton.icon(
          onPressed: () {
            controller.send(controller.textController.text);
            controller.textController.clear();
          },
          icon: const Icon(Icons.send),
          style: FilledButton.styleFrom(
            backgroundColor: controller.currentQuestion?.canSkip ?? false ?
                Colors.grey.shade500 : null,
          ),
          label: Obx(
            () => (controller.currentQuestion?.canSkip ?? false)
                ? const Text("Skip")
                : const Text("Send"),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  String _hintFor() {
    if (controller.isFinished) {
      return "Type anything to restart";
    }
    final q = controller.currentQuestion;
    if (q == null) {
      return "Say hi to start";
    }
    if (q.type == QAType.choice) {
      return "Choose an option above";
    }
    return q.hint ?? "Type your answer";
  }
}

class _HeightPicker extends StatefulWidget {
  const _HeightPicker({required this.controller});

  final TraineeOnboardingController controller;

  @override
  State<_HeightPicker> createState() => _HeightPickerState();
}

class _HeightPickerState extends State<_HeightPicker> {
  // 0 for cm, 1 for ft/in
  int _selectedUnit = 0;

  // State for pickers
  int _selectedCm = 170;
  int _selectedFeet = 5;
  int _selectedInches = 7;

  // Data for pickers
  final List<int> _cmValues = List.generate(
    101,
    (index) => 120 + index,
  ); // 120-220 cm
  final List<int> _feetValues = List.generate(
    4,
    (index) => 4 + index,
  ); // 4-7 ft
  final List<int> _inchValues = List.generate(12, (index) => index); // 0-11 in

  @override
  Widget build(BuildContext context) {
    final canSkip = widget.controller.currentQuestion?.canSkip ?? false;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          CupertinoSlidingSegmentedControl<int>(
            groupValue: _selectedUnit,
            children: const {0: Text('cm'), 1: Text('ft / in')},
            onValueChanged: (value) =>
                setState(() => _selectedUnit = value ?? 0),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 150,
            child: _selectedUnit == 0 ? _buildCmPicker() : _buildFtInPicker(),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              if (canSkip) ...[
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => widget.controller.selectHeight(),
                    child: const Text('Skip'),
                  ),
                ),
                const SizedBox(width: 16),
              ],
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    if (_selectedUnit == 0) {
                      widget.controller.selectHeight(cm: _selectedCm);
                    } else {
                      widget.controller.selectHeight(
                        feet: _selectedFeet,
                        inches: _selectedInches,
                      );
                    }
                  },
                  child: const Text('Confirm'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCmPicker() {
    return CupertinoPicker(
      itemExtent: 32,
      scrollController: FixedExtentScrollController(
        initialItem: _cmValues.indexOf(_selectedCm),
      ),
      onSelectedItemChanged: (index) =>
          setState(() => _selectedCm = _cmValues[index]),
      children: _cmValues.map((cm) => Center(child: Text('$cm cm'))).toList(),
    );
  }

  Widget _buildFtInPicker() {
    return Row(
      children: [
        Expanded(
          child: CupertinoPicker(
            itemExtent: 32,
            scrollController: FixedExtentScrollController(
              initialItem: _feetValues.indexOf(_selectedFeet),
            ),
            onSelectedItemChanged: (index) =>
                setState(() => _selectedFeet = _feetValues[index]),
            children: _feetValues
                .map((ft) => Center(child: Text("$ft'")))
                .toList(),
          ),
        ),
        Expanded(
          child: CupertinoPicker(
            itemExtent: 32,
            scrollController: FixedExtentScrollController(
              initialItem: _inchValues.indexOf(_selectedInches),
            ),
            onSelectedItemChanged: (index) =>
                setState(() => _selectedInches = _inchValues[index]),
            children: _inchValues
                .map((inch) => Center(child: Text('$inch"')))
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _WeightPicker extends StatefulWidget {
  const _WeightPicker({required this.controller});

  final TraineeOnboardingController controller;

  @override
  State<_WeightPicker> createState() => _WeightPickerState();
}

class _WeightPickerState extends State<_WeightPicker> {
  // 0 for kg, 1 for lbs
  int _selectedUnit = 0;

  // State for pickers
  double _selectedKg = 70.0;
  double _selectedLbs = 154.0;

  // Data for pickers
  final List<double> _kgValues = List.generate(
    1101,
    (i) => 40.0 + i * 0.1,
  ); // 40.0-150.0 kg
  final List<double> _lbsValues = List.generate(
    2401,
    (i) => 90.0 + i * 0.1,
  ); // 90.0-330.0 lbs

  @override
  Widget build(BuildContext context) {
    final canSkip = widget.controller.currentQuestion?.canSkip ?? false;
    final currentValues = _selectedUnit == 0 ? _kgValues : _lbsValues;
    final initialValue = _selectedUnit == 0 ? _selectedKg : _selectedLbs;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          CupertinoSlidingSegmentedControl<int>(
            groupValue: _selectedUnit,
            children: const {0: Text('kg'), 1: Text('lbs')},
            onValueChanged: (value) =>
                setState(() => _selectedUnit = value ?? 0),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 150,
            child: CupertinoPicker(
              itemExtent: 32,
              scrollController: FixedExtentScrollController(
                initialItem: currentValues.indexOf(
                  currentValues.firstWhere(
                    (v) => (v - initialValue).abs() < 0.01,
                    orElse: () => currentValues.first,
                  ),
                ),
              ),
              onSelectedItemChanged: (index) {
                setState(() {
                  if (_selectedUnit == 0) {
                    _selectedKg = currentValues[index];
                  } else {
                    _selectedLbs = currentValues[index];
                  }
                });
              },
              children: currentValues
                  .map((w) => Center(child: Text(w.toStringAsFixed(1))))
                  .toList(),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              if (canSkip) ...[
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => widget.controller.selectWeight(), // Skip
                    child: const Text('Skip'),
                  ),
                ),
                const SizedBox(width: 16),
              ],
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    if (_selectedUnit == 0) {
                      widget.controller.selectWeight(
                        weight: _selectedKg,
                        unit: 'kg',
                      );
                    } else {
                      widget.controller.selectWeight(
                        weight: _selectedLbs,
                        unit: 'lbs',
                      );
                    }
                  },
                  child: const Text('Confirm'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ImagePickerInput extends StatelessWidget {
  final TraineeOnboardingController controller;

  const _ImagePickerInput({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: ElevatedButton.icon(
        icon: const Icon(Icons.camera_alt),
        label: const Text("Upload Photo"),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
        ),
        onPressed: () => _showImageSourceDialog(context),
      ),
    );
  }

  void _showImageSourceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Select Image Source"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Take Photo"),
              onTap: () {
                Navigator.of(dialogContext).pop();
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Choose from Gallery"),
              onTap: () {
                Navigator.of(dialogContext).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    // Pick an image.
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      controller.selectImage(image);
    }
  }
}

class _ImageMessageBubble extends StatelessWidget {
  final String imagePath;
  final Sender from;

  const _ImageMessageBubble({required this.imagePath, required this.from});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUser = from == Sender.user;

    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.7,
      ),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: isUser
            ? theme.colorScheme.primaryContainer
            : theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),

      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.file(
          File(imagePath),
          fit: BoxFit.cover,

          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded) {
              return child;
            }
            return frame == null
                ? const Padding(
                    padding: EdgeInsets.all(48.0),
                    child: Center(child: CircularProgressIndicator.adaptive()),
                  )
                : child;
          },
          errorBuilder: (context, error, stackTrace) {
            return const Padding(
              padding: EdgeInsets.all(32.0),
              child: Icon(Icons.broken_image, color: Colors.red, size: 40),
            );
          },
        ),
      ),
    );
  }
}
