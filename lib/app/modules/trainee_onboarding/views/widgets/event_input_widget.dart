import 'package:flutter/material.dart';
import 'package:icon/app/modules/trainee_onboarding/controllers/trainee_onboarding_controller.dart';

class EventInputWidget extends StatefulWidget {
  final TraineeOnboardingController controller;

  const EventInputWidget({super.key, required this.controller});

  @override
  State<EventInputWidget> createState() => _EventInputWidgetState();
}

class _EventInputWidgetState extends State<EventInputWidget> {
  bool isYesSelected = true;
  DateTime? selectedDate;
  final TextEditingController _eventNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-select today's date and a default event name for better UX.
    selectedDate = DateTime.now();
    _eventNameController.text = "Wedding";
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 10),
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: ColorScheme.dark(
              primary: colorScheme.primary,
              surface: colorScheme.surface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && mounted) {
      setState(() => selectedDate = picked);
    }
  }

  String get _formattedDate {
    if (selectedDate == null) return "Select date";
    return "${selectedDate!.day.toString().padLeft(2, '0')} "
        "${_monthName(selectedDate!.month)}, "
        "${selectedDate!.year}";
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        // Use MainAxisSize.min because the parent has unconstrained height.
        mainAxisSize: MainAxisSize.min,
        // Stretch children to fill the width, fixing the Expanded issue.
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // YES / NO toggle
          Row(
            children: [
              _buildToggleOption(
                text: "Yes",
                isSelected: isYesSelected,
                onTap: () => setState(() => isYesSelected = true),
              ),
              const SizedBox(width: 12),
              _buildToggleOption(
                text: "No",
                isSelected: !isYesSelected,
                onTap: () => setState(() => isYesSelected = false),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Show these fields ONLY when Yes is selected
          if (isYesSelected) ...[
            Text("Date", style: textTheme.labelLarge),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickDate,
              child: AbsorbPointer(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: _formattedDate,
                    suffixIcon: const Icon(Icons.calendar_today_outlined),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text("Event name", style: textTheme.labelLarge),
            const SizedBox(height: 8),
            TextField(
              controller: _eventNameController,
              decoration: const InputDecoration(hintText: "Wedding"),
            ),
          ],

          const SizedBox(height: 16),

          // Next button
          ElevatedButton(
            onPressed: () {
              final String response = isYesSelected
                  ? 'Event: ${_eventNameController.text}, Date: $_formattedDate'
                  : 'No upcoming event';
              widget.controller.send(response);
            },
            child: const Text("Next"),
          ),
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
