import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/base/widgets/custom_toast.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../generated/assets.dart';
import '../../../core/widgets/action_pill.dart';
import '../../../core/widgets/chat_room_shimmer.dart';
import '../../../core/widgets/search_location_dropdown.dart';
import '../controllers/trainee_onboarding_controller.dart';
import '../models/onboarding_qa_model.dart';
import '../models/trainee_onboarding_questions_model.dart';
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
                  Text(
                    'Mish Icon',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
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
                child: ActionPill(
                  onTap: () => _showExitConfirmationDialog(context),
                ),
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
                    controller.getCurrentGroupName ?? "Getting Started",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  AnimatedOnboardingStepper(
                    totalSteps: controller.stepperTotalSteps,
                    currentStep: controller.stepperCurrentStep,
                    stepProgress: controller.stepperStepProgress,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  void _showExitConfirmationDialog(BuildContext context) {
    // Check if the user has sent any messages.
    final hasAnswered = controller.messages.any((m) => m.from == Sender.user);

    if (hasAnswered) {
      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          icon: const Icon(Icons.warning_amber_rounded, size: 40),
          title: const Text('Leave Onboarding?'),
          content: const Text(
            'Your progress will be lost if you go back. Are you sure?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Stay'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Get.back();
              },
              child: const Text('Leave'),
            ),
          ],
        ),
      );
    } else {
      // If no answers have been provided, navigate back directly.
      Get.back();
    }
  }

  @override
  Widget body(BuildContext context) {
    return Column(
      children: [
        // ------------------ MESSAGES ----------
        Expanded(
          child: Obx(() {
            // ------------------- MESSAGE LOADING STATE --------
            if (controller.onboardingPhase.value ==
                OnboardingPhase.fetchingData) {
              return ChatRoomShimmer();
            }

            // ------------------- DATA STATE ------------------
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

                final alignment = m.from == Sender.user
                    ? Alignment.centerRight
                    : Alignment.centerLeft;

                Widget bubble;
                if (m.imagePath != null && m.imagePath!.isNotEmpty) {
                  // Use the new status-aware image bubble
                  bubble = _StatusImageBubble(
                    imagePath: m.imagePath!,
                    from: m.from,
                    status: m.status,
                  );
                } else {
                  // Use the new status-aware text bubble
                  bubble = _StatusMessageBubble(
                    text: m.text,
                    from: m.from,
                    status: m.status,
                  );
                }

                return Align(alignment: alignment, child: bubble);
              },
            );
          }),
        ),

        /// Quick replies (only for choice-type question)
        Obx(() {
          final q = controller.currentQuestion;
          if (controller.onboardingPhase.value !=
                  OnboardingPhase.askingQuestions ||
              controller.isFinished ||
              controller.showGroupContinuationButtons ||
              q == null ||
              q.type != QAType.multipleChoice) {
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

        // ----------------- Input Sections ----------
        AnimatedSize(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          alignment: Alignment.topCenter,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,

            // Make sure old and new are stacked during the swap
            layoutBuilder: (currentChild, previousChildren) => Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                ...previousChildren,
                if (currentChild != null) currentChild,
              ],
            ),

            transitionBuilder: (Widget child, Animation<double> animation) {
              final inCurved = CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              );
              final outCurved = CurvedAnimation(
                parent: ReverseAnimation(animation),
                curve: Curves.easeInCubic,
              );

              // New child: slide UP from bottom
              final slideIn = Tween<Offset>(
                begin: const Offset(0, 1), // from bottom
                end: Offset.zero,
              ).animate(inCurved);

              // Old child: slide DOWN off-screen
              final slideOut = Tween<Offset>(
                begin: Offset.zero,
                end: const Offset(0, 1), // to bottom
              ).animate(outCurved);

              // Choose which tween to use based on the animation direction
              final isIncoming = animation.status == AnimationStatus.forward;

              return ClipRect(
                child: SlideTransition(
                  position: isIncoming ? slideIn : slideOut,
                  child: child,
                ),
              );
            },

            child: SafeArea(
              key: ValueKey(
                '${controller.onboardingPhase.value}-${controller.currentQuestion?.id}',
              ),
              top: false,
              child:
              Obx(() {
                switch (controller.onboardingPhase.value) {
                  case OnboardingPhase.awaitingEmail:
                    return _buildTextInput(context);

                  case OnboardingPhase.awaitingInitialTerms:
                    return _buildInitialTermsInput(context);

                  case OnboardingPhase.fetchingData:
                    return const SizedBox.shrink();

                  case OnboardingPhase.askingQuestions:
                    if (controller.showGroupContinuationButtons) {
                      return _buildContinuationButtons();
                    }
                    if (controller.isCurrentImage) {
                      return _buildTextInput(context, enableImageBtn: true, typingEnabled: false);
                    }
                    if (controller.isCurrentDate) {
                      return _buildDatePickerButton(context);
                    }
                    if (controller.isCurrentTime) {
                      return _buildTimePickerButton(context);
                    }
                    if (controller.isCurrentHeight) {
                      return _HeightPicker(controller: controller);
                    }
                    if (controller.isCurrentWeight) {
                      return _WeightPicker(controller: controller);
                    }
                    if (controller.isCurrentChoice) {
                      return const SizedBox.shrink();
                    }

                    // TODO: DEMO CHECK
                    if (controller.isCurrentLocation ||
                        controller.currentQuestion?.id == 4) {
                      return InkWell(
                        onTap: () async {

                          final PlaceDetails? result =  await openLocationBottomSheet(controller, context);

                          if(result != null) {
                            controller.inputText.value = result.address ?? "";
                            controller.textController.text = result.address ?? "";
                            controller.send(controller.textController.text);
                          }
                        },
                        child: IgnorePointer(child: _buildTextInput(context)),
                      );
                    }
                    return _buildTextInput(context);

                  case OnboardingPhase.completed:
                    return _buildTextInput(context);
                }
              }),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildInitialTermsInput(BuildContext context) {
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
                  value: controller.hasAgreedToInitialTerms.value,
                  onChanged: controller.toggleInitialTermsAgreement,
                ),
              ),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                      const TextSpan(text: 'I agree to the '),
                      TextSpan(
                        text: 'Terms and Conditions',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          decoration: TextDecoration.underline,
                          decorationColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            CustomToast.showToast(
                              message: 'Terms and Conditions',
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Obx(
            () => ElevatedButton(
              onPressed: controller.hasAgreedToInitialTerms.value
                  ? controller.proceedAfterInitialTerms
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
  Future<PlaceDetails?> openLocationBottomSheet(TraineeOnboardingController controller, BuildContext context) async {
    final theme = Theme.of(context);
    final result = await Get.bottomSheet<PlaceDetails>(
      backgroundColor: theme.colorScheme.surface,
      SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.only(
            left: 12,
            right: 12,
            top: 12,
            bottom: MediaQuery.of(Get.context!).viewInsets.bottom + 16,
          ),
          child: SizedBox(
            height: Get.height * 0.5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: theme.iconTheme.color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Title
                const Text(
                  'Choose a location',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),

                SearchableLocationDropdown(
                  hintText: 'Search a city, area, or place',
                  debounce: const Duration(milliseconds: 300),
                  fetchSuggestions: controller.locationService.placesAutocomplete,
                  onChanged: (suggestion) async {
                    if (suggestion == null) return;

                    try {
                      final details = await controller.locationService.places
                          .placeDetails(suggestion.id);

                      if (details == null) {
                        CustomToast.showErrorToast(
                          'Unable to fetch details. Please try another place.',
                        );
                        return;
                      }
                      // Close the sheet and return the details to the caller
                      if (context.mounted) {
                        Navigator.pop(context, details);
                      }
                    } catch (e) {
                     CustomToast.showErrorToast(
                        'Failed to load place details.'

                      );
                    }
                  },

                ),

                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
      elevation: 8,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    );

    return result;
  }


  Widget _buildDatePickerButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
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

  Widget _buildTextInput(
      BuildContext context, {
        bool enableImageBtn = false,
        bool typingEnabled = true,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
      child: TextField(
        controller: controller.textController,
        readOnly: !typingEnabled,
        enableInteractiveSelection: typingEnabled,
        showCursor: typingEnabled,
        mouseCursor:
        typingEnabled ? SystemMouseCursors.text : SystemMouseCursors.forbidden,
        onTap: () {
          if (!typingEnabled) {
            // prevent focus from sticking / keyboard popping up on mobile
            FocusScope.of(context).unfocus();
          }
        },

        onChanged: (t) => controller.inputText.value = t,
        onSubmitted: (t) {
          controller.send(t);
        },
        decoration: InputDecoration(
          suffixIcon: Obx(() {
            final hasText = controller.inputText.value.trim().isNotEmpty;

            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              child: hasText
                  ? SizedBox(
                key: const ValueKey('send'),
                width: 56,
                child: IconButton(
                  tooltip: 'Send',
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.send_rounded, size: 20),
                  onPressed: () {
                    final msg = controller.textController.text.trim();
                    if (msg.isEmpty) return;
                    controller.send(msg);
                    controller.textController.clear();
                    controller.inputText.value = '';
                  },
                ),
              )
              // --- IDLE BUTTONS STATE ---
                  : SizedBox(
                key: const ValueKey('idle'),
                width: 120,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // MIC
                    Opacity(
                      opacity: enableImageBtn ? 0.5 : 1,
                      child: IconButton(
                        tooltip: 'Voice input',
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.mic_outlined, size: 20),
                        onPressed: enableImageBtn
                            ? null
                            : () {
                          CustomToast.showToast(
                              message: 'Coming soon');
                        },
                      ),
                    ),
                    // DOC
                    const Opacity(
                      opacity: 0.5,
                      child: IconButton(
                        tooltip: 'Insert link (disabled)',
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        icon: Icon(Icons.link_outlined, size: 20),
                        onPressed: null,
                      ),
                    ),
                    // CAMERA
                    Opacity(
                      opacity: enableImageBtn ? 1 : 0.5,
                      child: IconButton(
                        tooltip: 'Attach photo',
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.camera_alt_outlined, size: 20),
                        onPressed: () => _showImageSourceDialog(context),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          suffixIconConstraints: const BoxConstraints(
            minWidth: 0,
            minHeight: 0,
          ),

          hintText: _hintFor(),
          border: const OutlineInputBorder(),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
        ),

        keyboardType: () {
          if (controller.onboardingPhase.value == OnboardingPhase.awaitingEmail) {
            return TextInputType.emailAddress;
          }
          final qType = controller.currentQuestion?.type;
          if (qType == QAType.number) return TextInputType.number;
          if (qType == QAType.phoneNumber) return TextInputType.phone;
          return TextInputType.text;
        }(),
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

  String _hintFor() {
    switch (controller.onboardingPhase.value) {
      case OnboardingPhase.awaitingEmail:
        return "Enter your email address";
      case OnboardingPhase.completed:
        return "Type anything to restart";
      case OnboardingPhase.askingQuestions:
        final q = controller.currentQuestion;
        if (q == null) {
          return "Just a moment...";
        }
        if (q.type == QAType.multipleChoice) {
          return "Choose an option above";
        }
        return q.hint ?? "Type your answer";
      default:
        return "";
    }
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

class _StatusImageBubble extends StatelessWidget {
  final String imagePath;
  final Sender from;
  final Rx<MessageStatus> status;

  const _StatusImageBubble({
    required this.imagePath,
    required this.from,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUser = from == Sender.user;

    final imageWidget = ClipRRect(
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
    );

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
      child: isUser
          ? Obx(
              () => Stack(
                children: [
                  imageWidget,
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: _MessageStatusIcon(
                      status: status.value,
                      isForImage: true,
                    ),
                  ),
                ],
              ),
            )
          : imageWidget,
    );
  }
}

class _MessageStatusIcon extends StatelessWidget {
  final MessageStatus status;
  final bool isForImage;

  const _MessageStatusIcon({required this.status, this.isForImage = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    IconData iconData;
    Color iconColor;

    switch (status) {
      case MessageStatus.pending:
      case MessageStatus.sending:
        iconData = Icons.watch_later_outlined;
        // CHANGE: Use withOpacity instead of withValues
        iconColor = isForImage
            ? Colors.white
            : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7);
        break;
      case MessageStatus.delivered:
        iconData = Icons.done_all;
        iconColor = isForImage ? Colors.white : theme.colorScheme.primary;
        break;
      case MessageStatus.failed:
        iconData = Icons.error_outline;
        iconColor = isForImage ? Colors.white : theme.colorScheme.error;
        break;
    }

    final icon = Icon(iconData, size: isForImage ? 14 : 16, color: iconColor);

    if (isForImage) {
      return Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.4),
          shape: BoxShape.circle,
        ),
        child: icon,
      );
    }

    return icon;
  }
}

class _StatusMessageBubble extends StatelessWidget {
  final String text;
  final Sender from;
  final Rx<MessageStatus> status;

  const _StatusMessageBubble({
    required this.text,
    required this.from,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final bubble = MessageBubble(text: text, from: from);

    if (from != Sender.user) {
      return bubble;
    }

    return Obx(() {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          bubble,
          const SizedBox(width: 6),
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: _MessageStatusIcon(status: status.value),
          ),
        ],
      );
    });
  }
}
