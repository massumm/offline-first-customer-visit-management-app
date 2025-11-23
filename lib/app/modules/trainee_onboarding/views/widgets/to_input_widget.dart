import 'dart:io';

import 'package:bodychart_heatmap/bodychart_heatmap.dart';
import 'package:bodychart_heatmap/src/bodychart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/widgets/input_widgets/date_input_field.dart';
import 'package:icon/app/modules/trainee_onboarding/controllers/trainee_onboarding_controller.dart';
import 'package:icon/app/modules/trainee_onboarding/views/widgets/minutes_wheel_list.dart';
import 'package:icon/app/modules/trainee_onboarding/views/widgets/unit_ruler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../base/widgets/custom_toast.dart';
import '../../../../core/values/app_colors.dart';
import '../../../../core/widgets/input_widgets/custom_phone_field.dart';
import '../../../../core/widgets/search_location_dropdown.dart';
import 'agent_loading_indicator.dart';
import 'body_fat_input_widget.dart';
import 'body_measurements_input_widget.dart';
import 'event_input_widget.dart';
import 'range_slider_input_widget.dart';
import 'wheel_list.dart';

class ToInputWidget extends GetView<TraineeOnboardingController> {
  const ToInputWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        // Make sure old and new are stacked during the swap
        layoutBuilder: (currentChild, previousChildren) => Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            ...previousChildren,
            if (currentChild != null) currentChild,
          ],
        ),
        transitionBuilder: (Widget child, Animation<double> animation) {
          // New child slides up from the bottom and fades in.
          final slideIn =
              Tween<Offset>(
                begin: const Offset(0.0, 0.6),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              );

          // Old child slides up toward the top and fades out.
          final slideOut =
              Tween<Offset>(
                begin: const Offset(0.0, -0.6),
                // Final position (off-screen top)
                end: Offset.zero, // Initial position
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInCubic),
              );
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: animation.status == AnimationStatus.reverse
                  ? slideOut
                  : slideIn,
              child: child,
            ),
          );
        },
        child: SafeArea(
          key: ValueKey(
            '${controller.onboardingPhase.value}-${controller.currentQuestion?.id}',
          ),
          top: false,
          child: Obx(() {
            // ------------------- MESSAGE LOADING STATE --------
            if (controller.onboardingPhase.value ==
                OnboardingPhase.fetchingData) {
              return SizedBox.shrink();
              // return Column(
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [AgentLoadingIndicator(), 8.height],
              // );
            }

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
                  return _buildTextInput(
                    context,
                    enableImageBtn: true,
                    typingEnabled: false,
                  );
                }
                if (controller.isCurrentDate) {
                  return _buildDatePickerButton(context);
                }
                if (controller.isCurrentTime) {
                  return _buildTimePickerButton(context);
                }
                if (controller.isCurrentHeight) {
                  // store the unit value
                  String unitQuantity = '170 cm';

                  return UnitRuler(
                    minHeightCm: 120,
                    maxHeightCm: 250,
                    initialHeightCm: 170,
                    onChanged: (double value, HeightUnit unit) {
                      unitQuantity = '$value ${unit.name}';
                    },
                    onSubmit: () => controller.selectHeight(unitQuantity),
                  );
                }
                if (controller.isCurrentWeight) {
                  return _WeightPicker(controller: controller);
                }
                if (controller.isCurrentPhoneNumber) {
                  return _buildPhoneField();
                }

                if (controller.isCurrentReminder) {
                  return _buildReminder(context);
                }

                if (controller.isCurrentBodyMeasurements) {
                  return const BodyMeasurementsInputWidget();
                }

                if (controller.isCurrentNumber) {
                  // Handle Minutes
                  if (controller.currentQuestion?.questionFieldName ==
                      'session_duration') {
                    return MinutesWheelList(
                      onNext: (int range) {
                        controller.selectNumber(range.toString());
                      },
                    );
                  }
                  List<String> items = List.generate(
                    10,
                    (index) => (index + 1).toString(),
                  );

                  bool showCustomNumberField = false;

                  if (controller.currentQuestion?.questionFieldName ==
                      'daily_step_goal') {
                    items = ['2,500', '5,000', '7,500', '10,000', '12,500'];
                    showCustomNumberField = true;
                  }
                  return WheelListWidget(
                    items: items,
                    showCustomNumberField: showCustomNumberField,
                    onNext: (String range) {
                      controller.selectNumber(range);
                    },
                  );
                }

                if (controller.isCurrentBodyFat) {
                  return BodyFatInputWidget(
                    onNext: (BodyFatOption selectedOption, String customValue) {
                      "Calling the method".log();
                      controller.selectBodyFat(selectedOption, customValue);
                    },
                  );
                }

                if (controller.isCurrentBodyPart) {
                  return BodyPartInputWidget(controller: controller);
                }

                if (controller.isCurrentDateWithDescription) {
                  return EventInputWidget(controller: controller);
                }

                if (controller.isCurrentNumericRange) {
                  return NumericRangeInputWidget(
                    value: controller.numericRangeValue.value,
                    maxTitle:
                        controller.currentQuestion?.metadata?.labelMax ??
                        'Fast',
                    minTitle:
                        controller.currentQuestion?.metadata?.labelMin ??
                        'Gradual',
                    max:
                        controller.currentQuestion?.metadata?.maxValue
                            ?.toDouble() ??
                        10.0,
                    min:
                        controller.currentQuestion?.metadata?.minValue
                            ?.toDouble() ??
                        1,
                    onChanged: (double value) {
                      controller.numericRangeValue.value = value;
                    },
                    onNext: () {
                      controller.selectNumericRange();
                    },
                  );
                }

                // Handle for choice options selection
                if (controller.isCurrentChoice ||
                    controller.isCurrentMultiplePlusOther ||
                    controller.isCurrentMultiplePlusOtherWithAdd) {
                  // Handle for other options selection
                  if (controller.isOtherOptionSelected.isTrue) {
                    return _buildTextInput(context);
                  }

                  // Enable wheel for these keys
                  final List<String> wheelListQuestionFields = [
                    'desired_sleep_hours',
                    'current_sleep_hours',
                    'sources_of_stress',
                  ];
                  final currentFieldName =
                      controller.currentQuestion?.questionFieldName;

                  // Handle for extra input field
                  bool enableTextField = false;
                  if (controller.isCurrentMultiplePlusOtherWithAdd) {
                    enableTextField = true;
                  }
                  if (currentFieldName != null &&
                      wheelListQuestionFields.contains(currentFieldName)) {
                    return WheelListWidget(
                      items:
                          controller.currentQuestion?.metadata?.options ??
                          controller
                              .currentQuestion
                              ?.metadata
                              ?.predefinedOptions ??
                          [],
                      showCustomTextField: enableTextField,
                      onNext: (String value) {
                        controller.send(value);
                      },
                    );
                  }
                  return const SizedBox.shrink();
                }

                if (controller.isCurrentLocation ||
                    controller.currentQuestion?.id == 4) {
                  return InkWell(
                    onTap: () async {
                      final PlaceDetails? result =
                          await openLocationBottomSheet(controller, context);

                      if (result != null) {
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
    );
  }

  Future<PlaceDetails?> openLocationBottomSheet(
    TraineeOnboardingController controller,
    BuildContext context,
  ) async {
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
                  fetchSuggestions:
                      controller.locationService.placesAutocomplete,
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
                        'Failed to load place details.',
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

  Obx _buildReminder(BuildContext context) {
    return Obx(() {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              ActionChip(
                label: Text('Yes'),
                onPressed: () {
                  controller.onReminder('Yes');
                  controller.enableReminderTimePicker(true);
                },
              ),
              ActionChip(
                label: Text('No'),
                onPressed: () {
                  controller.onReminder('No');
                  controller.enableReminderTimePicker(false);
                },
              ),
            ],
          ),
          AnimatedCrossFade(
            secondChild: SizedBox.shrink(),
            firstChild: Column(
              mainAxisSize: MainAxisSize.min,
              children: [8.height, _buildTimePickerButton(context)],
            ),
            crossFadeState: controller.enableReminderTimePicker.isTrue
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 300),
          ),
          8.height,
        ],
      );
    });
  }

  Padding _buildPhoneField() {
    String phoneNumber = '';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
      child: PhoneField(
        suffixIcon: IconButton(
          tooltip: 'Voice input',
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
          icon: Icon(Icons.send, size: 20),
          onPressed: () {
            if (phoneNumber.isEmpty) {
              CustomToast.showToast(message: 'Please type a valid input');
              return;
            }
            controller.send(phoneNumber);
          },
        ),
        onInputChanged: (PhoneNumber number) {
          phoneNumber = number.international;
        },
      ),
    );
  }

  Widget _buildInitialTermsInput(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Obx(() {
                  if (Platform.isIOS) {
                    return CupertinoSwitch(
                      value: controller.hasAgreedToInitialTerms.value,
                      onChanged: controller.toggleInitialTermsAgreement,
                    );
                  }
                  // For Android, use the Material Checkbox.
                  return Checkbox(
                    value: controller.hasAgreedToInitialTerms.value,
                    onChanged: controller.toggleInitialTermsAgreement,
                  );
                }),
                const SizedBox(width: 8),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Platform.isIOS
                            ? CupertinoTheme.of(
                                context,
                              ).textTheme.textStyle.color
                            : null,
                      ),
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
                            ..onTap = () async {
                              // Launch the Terms and Conditions URL.
                              Uri uri = Uri.parse(
                                'https://github.com/IconFitness-App/IconTraining-Terms-Conditions/blob/main/Termify-Terms-and-Conditions.pdf',
                              );

                              if (!await launchUrl(uri)) {
                                throw Exception('Could not launch $uri');
                              }
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Obx(() {
              final onPressed = controller.hasAgreedToInitialTerms.value
                  ? controller.proceedAfterInitialTerms
                  : null;

              if (Platform.isIOS) {
                return CupertinoButton.filled(
                  onPressed: onPressed,
                  child: const Text('Continue'),
                );
              }
              return ElevatedButton(
                onPressed: onPressed,
                child: const Text('Continue'),
              );
            }),
          ],
        ),
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
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DatePickerInputField(
        firstDate: DateTime(1920),
        lastDate: DateTime.now(),
        onSelectDate: controller.selectDate,
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
    // Common suffix widget for both text fields
    final Widget suffix = Obx(() {
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
                                CustomToast.showToast(message: 'Coming soon');
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
    });

    // Common keyboard type for both text fields
    final keyboardType = () {
      if (controller.onboardingPhase.value == OnboardingPhase.awaitingEmail) {
        return TextInputType.emailAddress;
      }
      final qType = controller.currentQuestion?.type;
      if (qType?.name == "number") return TextInputType.number;
      if (qType?.name == "phone_number") return TextInputType.phone;
      return TextInputType.text;
    }();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
      // ADD MATERIAL ANCESTOR HERE
      child: Material(
        color: Colors.transparent,
        child: Platform.isAndroid
            // ANDROID IMPLEMENTATION
            ? TextField(
                controller: controller.textController,
                readOnly: !typingEnabled,
                enableInteractiveSelection: typingEnabled,
                showCursor: typingEnabled,
                mouseCursor: typingEnabled
                    ? SystemMouseCursors.text
                    : SystemMouseCursors.forbidden,
                onTap: () {
                  if (!typingEnabled) {
                    FocusScope.of(context).unfocus();
                  }
                },
                onChanged: (t) => controller.inputText.value = t,
                onSubmitted: (t) {
                  controller.send(t);
                },
                decoration: InputDecoration(
                  suffixIcon: suffix,
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
                keyboardType: keyboardType,
              )
            // IOS IMPLEMENTATION
            : CupertinoTextField(
                controller: controller.textController,
                readOnly: !typingEnabled,
                enableInteractiveSelection: typingEnabled,
                showCursor: typingEnabled,
                onTap: () {
                  if (!typingEnabled) {
                    FocusScope.of(context).unfocus();
                  }
                },
                onChanged: (t) => controller.inputText.value = t,
                onSubmitted: (t) {
                  controller.send(t);
                },
                placeholder: _hintFor(),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: CupertinoColors.inactiveGray,
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
                suffix: suffix,
                keyboardType: keyboardType,
              ),
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
        if (q.type.name == "select_multiple") {
          return "Choose an option above";
        }
        return q.hint ?? "Type your answer";
      default:
        return "";
    }
  }
}

class BodyPartInputWidget extends StatelessWidget {
  const BodyPartInputWidget({super.key, required this.controller});

  final TraineeOnboardingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        6.height,
        BodyChart(
          selectedParts: controller.selectedBodyParts,
          selectedColor: AppColors.colorPrimary,
          unselectedColor: Colors.grey.shade300,
          viewType: BodyViewType.both,
          width: 250,
        ),
        6.height,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: [
            ActionChip(
              label: Text('Full Body'),
              onPressed: () => controller.selectedBodyParts.add('full body'),
            ),
            ActionChip(
              label: Text('Chest'),
              onPressed: () => controller.selectedBodyParts.add('chest'),
            ),
            ActionChip(
              label: Text('Arm'),
              onPressed: () => controller.selectedBodyParts.add('arm'),
            ),
            ActionChip(
              label: Text('Abs'),
              onPressed: () => controller.selectedBodyParts.add('abs'),
            ),
            ActionChip(
              label: Text('Neck'),
              onPressed: () => controller.selectedBodyParts.add('neck'),
            ),
            ActionChip(
              label: Text('Shoulder'),
              onPressed: () => controller.selectedBodyParts.add('shoulder'),
            ),
            ActionChip(
              label: Text('Back'),
              onPressed: () => controller.selectedBodyParts.add('back'),
            ),
            ActionChip(
              label: Text('Glutes'),
              onPressed: () => controller.selectedBodyParts.add('glutes'),
            ),
            ActionChip(
              label: Text('Calves'),
              onPressed: () => controller.selectedBodyParts.add('calves'),
            ),
            ActionChip(
              label: Text('Quads'),
              onPressed: () => controller.selectedBodyParts.add('quads'),
            ),
            ActionChip(
              label: Text('Other'),
              onPressed:
                  () => //TODO: HANDLE THIS.
                      controller.selectedBodyParts.add('other'),
            ),
          ],
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
