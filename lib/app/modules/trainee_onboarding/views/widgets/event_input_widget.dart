import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/modules/trainee_onboarding/controllers/trainee_onboarding_controller.dart';

class EventInputWidget extends StatefulWidget {
  final TraineeOnboardingController controller;

  const EventInputWidget({super.key, required this.controller});

  @override
  State<EventInputWidget> createState() => _EventInputWidgetState();
}

class _EventInputWidgetState extends State<EventInputWidget> {
  bool isYesSelected = true;
  DateTime? selectedDate = DateTime.now();
  final TextEditingController _eventNameController = TextEditingController();

  @override
  void dispose() {
    _eventNameController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    // Show Cupertino Date Picker in modal
    DateTime tempDate = selectedDate ?? DateTime.now();

    await showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 300,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: selectedDate ?? DateTime.now(),
                minimumDate: DateTime(DateTime.now().year - 5),
                maximumDate: DateTime(DateTime.now().year + 10),
                onDateTimeChanged: (val) => tempDate = val,
              ),
            ),
            CupertinoButton(
              child: const Text("Done"),
              onPressed: () {
                setState(() => selectedDate = tempDate);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  String get _formattedDate {
    if (selectedDate == null) return "Select date";
    return "${selectedDate!.day.toString().padLeft(2, '0')} "
        "${_monthName(selectedDate!.month)}, ${selectedDate!.year}";
  }

  String _monthName(int m) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return months[m - 1];
  }

  void _submit() {
    String response;

    if (isYesSelected) {
      if (_eventNameController.text.trim().isEmpty) {
        final messenger = ScaffoldMessenger.maybeOf(context);
        messenger?.showSnackBar(
          const SnackBar(content: Text("Please enter the event name")),
        );
        return;
      }

      response =
          "Event: ${_eventNameController.text.trim()}, "
          "Date: $_formattedDate";
    } else {
      response = "No upcoming event";
    }

    widget.controller.send(response);
  }

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final toggleRow = Row(
      children: [
        _buildToggleOption(
          text: "Yes",
          isSelected: isYesSelected,
          onTap: () {
            setState(() => isYesSelected = true);
          },
        ),
        const SizedBox(width: 12),
        _buildToggleOption(
          text: "No",
          isSelected: !isYesSelected,
          onTap: () {
            setState(() => isYesSelected = false);
          },
        ),
      ],
    );

    final dateField = GestureDetector(
      onTap: _pickDate,
      child: AbsorbPointer(
        child: isIOS
            ? CupertinoTextField(
                placeholder: _formattedDate,
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                suffix: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(
                    CupertinoIcons.calendar,
                    color: AppColors.colorPrimary,
                    size: 18,
                  ),
                ),
              )
            : TextField(
                decoration: InputDecoration(
                  hintText: _formattedDate,
                  suffixIcon: const Icon(Icons.calendar_today_outlined),
                ),
              ),
      ),
    );

    final nextButton = isIOS
        ? CupertinoButton.filled(onPressed: _submit, child: const Text("Next"))
        : ElevatedButton(onPressed: _submit, child: const Text("Next"));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          toggleRow,
          const SizedBox(height: 20),

          if (isYesSelected) ...[
            Text("Date", style: textTheme.labelLarge),
            const SizedBox(height: 8),
            dateField,
            const SizedBox(height: 16),

            Text("Event name", style: textTheme.labelLarge),
            const SizedBox(height: 8),
            isIOS
                ? CupertinoTextField(
                    controller: _eventNameController,
                    placeholder: "Wedding",
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                  )
                : TextField(
                    controller: _eventNameController,
                    decoration: const InputDecoration(hintText: "Wedding"),
                  ),
          ],

          const SizedBox(height: 20),
          nextButton,
        ],
      ),
    );
  }

  Widget _buildToggleOption({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? Colors.transparent : colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? colorScheme.primary : Colors.transparent,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: textTheme.labelLarge?.copyWith(
              color: isSelected ? colorScheme.primary : colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
