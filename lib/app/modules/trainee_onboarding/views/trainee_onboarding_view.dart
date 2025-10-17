import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:icon/app/base/base_view.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/trainee_onboarding_controller.dart';
import '../models/onboarding_qa_model.dart';
import 'widgets/message_bubble.dart';
import 'widgets/type_bubble.dart';

class TraineeOnboardingView extends BaseView<TraineeOnboardingController> {
  TraineeOnboardingView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      title: const Text('Onboarding Assistant'),
      centerTitle: true,
      actions: [
        Obx(
          () => controller.canGoBack
              ? IconButton(
                  icon: const Icon(Icons.undo),
                  onPressed: controller.goBack,
                  tooltip: 'Go Back',
                )
              : const SizedBox.shrink(),
        ),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: controller.start,
          tooltip: 'Restart',
        ),
      ],
    );
  }

  @override
  Widget body(BuildContext context) {
    return Column(
      children: [
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

                  // --- START: MODIFIED LOGIC ---
                  // Determine alignment
                  final alignment = m.from == Sender.user
                      ? Alignment.centerRight
                      : Alignment.centerLeft;

                  // Conditionally build the bubble based on message content
                  Widget bubble;
                  if (m.imagePath != null && m.imagePath!.isNotEmpty) {
                    // If there's an image, use the new image bubble
                    bubble = _ImageMessageBubble(
                        imagePath: m.imagePath!, from: m.from);
                  } else {
                    // Otherwise, use the existing text bubble
                    bubble = MessageBubble(text: m.text, from: m.from);
                  }

                  return Align(
                    alignment: alignment,
                    child: bubble,
                  );
                });
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
          // END: Modify this condition
          return const SizedBox.shrink();
          }

          return Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: q.options
                  .map(
                    (o) => ActionChip(
                  label: Text(o),
                  onPressed: () => controller.choose(o),
                ),
              )
                  .toList(),
            ),
          );
        }),

        // Input
        SafeArea(
          top: false,
          child: Obx(() {
            // When a group is finished, show Continue/Skip buttons.
            if (controller.showGroupContinuationButtons) {
              return _buildContinuationButtons();
            }

            if (controller.isCurrentImage) {
              // NEW: Show the image picker button
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

            // START: Add new conditions for height and weight pickers
            if (controller.isCurrentHeight) {
              return _HeightPicker(controller: controller);
            }

            if (controller.isCurrentWeight) {
              return _WeightPicker(controller: controller);
            }
            // END: Add new conditions

            // Default input field for text/number questions.
            return _buildTextInput();
          }),
        ),
        const SizedBox(height: 8),
      ],
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
    return ElevatedButton(
      onPressed: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now().subtract(
            const Duration(days: 365 * 20),
          ), // Sensible default
          firstDate: DateTime(1920),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null) {
          controller.selectDate(pickedDate);
        }
      },
      child: Text(controller.currentQuestion?.hint ?? "Select Date"),
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
          label: const Text("Send"),
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

// Add these new widgets at the end of the file

/// A widget for selecting height with options for cm or ft/in.
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
  final List<int> _cmValues = List.generate(101, (index) => 120 + index); // 120-220 cm
  final List<int> _feetValues = List.generate(4, (index) => 4 + index); // 4-7 ft
  final List<int> _inchValues = List.generate(12, (index) => index); // 0-11 in

  @override
  Widget build(BuildContext context) {
    final canSkip = widget.controller.currentQuestion?.canSkip ?? false;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          CupertinoSlidingSegmentedControl<int>(
            groupValue: _selectedUnit,
            children: const {
              0: Text('cm'),
              1: Text('ft / in'),
            },
            onValueChanged: (value) => setState(() => _selectedUnit = value ?? 0),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 150,
            child: _selectedUnit == 0
                ? _buildCmPicker()
                : _buildFtInPicker(),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              if (canSkip) ...[
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => widget.controller.selectHeight(), // Skip
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
                      widget.controller.selectHeight(feet: _selectedFeet, inches: _selectedInches);
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
      scrollController: FixedExtentScrollController(initialItem: _cmValues.indexOf(_selectedCm)),
      onSelectedItemChanged: (index) => setState(() => _selectedCm = _cmValues[index]),
      children: _cmValues.map((cm) => Center(child: Text('$cm cm'))).toList(),
    );
  }

  Widget _buildFtInPicker() {
    return Row(
      children: [
        Expanded(
          child: CupertinoPicker(
            itemExtent: 32,
            scrollController: FixedExtentScrollController(initialItem: _feetValues.indexOf(_selectedFeet)),
            onSelectedItemChanged: (index) => setState(() => _selectedFeet = _feetValues[index]),
            children: _feetValues.map((ft) => Center(child: Text("$ft'"))).toList(),
          ),
        ),
        Expanded(
          child: CupertinoPicker(
            itemExtent: 32,
            scrollController: FixedExtentScrollController(initialItem: _inchValues.indexOf(_selectedInches)),
            onSelectedItemChanged: (index) => setState(() => _selectedInches = _inchValues[index]),
            children: _inchValues.map((inch) => Center(child: Text('$inch"'))).toList(),
          ),
        ),
      ],
    );
  }
}

/// A widget for selecting weight with options for kg or lbs.
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
  final List<double> _kgValues = List.generate(1101, (i) => 40.0 + i * 0.1); // 40.0-150.0 kg
  final List<double> _lbsValues = List.generate(2401, (i) => 90.0 + i * 0.1); // 90.0-330.0 lbs

  @override
  Widget build(BuildContext context) {
    final canSkip = widget.controller.currentQuestion?.canSkip ?? false;
    final currentValues = _selectedUnit == 0 ? _kgValues : _lbsValues;
    final initialValue = _selectedUnit == 0 ? _selectedKg : _selectedLbs;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          CupertinoSlidingSegmentedControl<int>(
            groupValue: _selectedUnit,
            children: const {
              0: Text('kg'),
              1: Text('lbs'),
            },
            onValueChanged: (value) => setState(() => _selectedUnit = value ?? 0),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 150,
            child: CupertinoPicker(
              itemExtent: 32,
              scrollController: FixedExtentScrollController(
                initialItem: currentValues.indexOf(
                  currentValues.firstWhere((v) => (v - initialValue).abs() < 0.01, orElse: () => currentValues.first),
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
              children: currentValues.map((w) => Center(child: Text(w.toStringAsFixed(1)))).toList(),
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
                      widget.controller.selectWeight(weight: _selectedKg, unit: 'kg');
                    } else {
                      widget.controller.selectWeight(weight: _selectedLbs, unit: 'lbs');
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


/// A widget that displays an "Upload Photo" button and handles the image
/// selection process by showing a dialog for Camera or Gallery.
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

  /// Shows a dialog to let the user choose between taking a new photo
  /// or selecting one from their gallery.
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

  /// Uses the image_picker package to select an image and passes the
  /// result back to the controller.
  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    // Pick an image.
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      // If an image was selected, call the controller's handler method.
      controller.selectImage(image);
    }
  }
}


///displays an image from a local file path.
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
        // Constrain the width to 70% of the screen
        maxWidth: MediaQuery.of(context).size.width * 0.7,
      ),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: isUser
            ? theme.colorScheme.primaryContainer
            : theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      // Clip the image to the rounded corners of the container
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.file(
          File(imagePath),
          fit: BoxFit.cover,
          // MODIFIED: Use frameBuilder for compatibility with older Flutter versions.
          // It provides a similar "while loading" capability.
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded) {
              return child; // If loaded instantly, just show the image.
            }
            // If the frame is not yet available, show a loading indicator.
            // Once the frame is ready, this builder is called again and `child` is shown.
            return frame == null
                ? const Padding(
              padding: EdgeInsets.all(48.0),
              child: Center(child: CircularProgressIndicator.adaptive()),
            )
                : child;
          },
          // Show an error icon if the image fails to load
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