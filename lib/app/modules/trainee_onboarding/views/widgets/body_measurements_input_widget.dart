import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/modules/trainee_onboarding/controllers/trainee_onboarding_controller.dart';
import 'package:icon/app/modules/trainee_onboarding/models/onboarding_qa_model.dart';
class BodyMeasurementsInputWidget extends StatefulWidget {
  const BodyMeasurementsInputWidget({super.key});

  @override
  State<BodyMeasurementsInputWidget> createState() =>
      _BodyMeasurementsInputWidgetState();
}

class _BodyMeasurementsInputWidgetState
    extends State<BodyMeasurementsInputWidget> {
  final controller = Get.find<TraineeOnboardingController>();
  late final QAItem question;
  final Map<String, TextEditingController> _controllers = {};
  late final List<String> _fieldKeys;
  String _selectedUnit = 'cm'; // Default unit

  @override
  void initState() {
    super.initState();

    // Get the current question configuration from the controller
    question = controller.currentQuestion!;

    final responseFields = question.type.responseFields;
    _fieldKeys =
    responseFields.keys.where((k) => k != 'unit').toList(growable: true)
      ..sort();

    // Set default unit from the question's example data, if available
    final exampleAnswer =
    question.type.examples['example_1']?['answer'] as Map<String, dynamic>?;
    _selectedUnit = exampleAnswer?['unit']?.toString().toLowerCase() ?? 'cm';

    // Create a TextEditingController for each measurement field
    for (final key in _fieldKeys) {
      _controllers[key] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _submitMeasurements() {
    final measurements = <String, String>{
      'unit': _selectedUnit,
    };

    // Collect data from controllers, ignoring empty fields
    _controllers.forEach((key, textController) {
      if (textController.text.trim().isNotEmpty) {
        measurements[key] = textController.text.trim();
      }
    });

    // Call the controller's submission method
    controller.saveBodyMeasurements(measurements);
  }

  @override
  Widget build(BuildContext context) {
    // Use a SingleChildScrollView to prevent overflow on smaller screens
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildUnitToggle(), // UPDATED: Using the new custom toggle
          16.height,
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _fieldKeys.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 78, // Controls the height of each grid item
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              final key = _fieldKeys[index];
              return _buildMeasurementField(
                _formatLabel(key),
                _controllers[key]!,
              );
            },
          ),
          24.height,
          ElevatedButton(
            onPressed: _submitMeasurements,
            child: const Text('Submit Measurements'),
          ),
        ],
      ),
    );
  }


  void _setUnit(String unit) {
    if (_selectedUnit == unit) return;
    setState(() {
      _selectedUnit = unit;
    });
  }

  Widget _buildUnitToggle() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final activeColor = colorScheme.primary;
    final inactiveColor = colorScheme.onSurface.withValues(alpha: 0.6);

    Widget tab(String label, String unit) {
      final isActive = _selectedUnit == unit;
      return Expanded(
        child: GestureDetector(
          onTap: () => _setUnit(unit),
          behavior: HitTestBehavior.opaque,
          child: Container(
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border(
                bottom: BorderSide(
                  color: isActive ? activeColor : theme.dividerColor,
                  width: 2,
                ),
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: isActive ? activeColor : inactiveColor,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        tab('cm', 'cm'),
        12.width,
        tab('Inches', 'in'),
      ],
    );
  }

  Widget _buildMeasurementField(
      String label, TextEditingController textController) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelLarge,
          overflow: TextOverflow.ellipsis,
        ),
        6.height,
        TextField(
          controller: textController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            filled: true,
            fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: colorScheme.outline.withValues(alpha: 0.5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: colorScheme.primary, width: 2.0),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            suffixText: _selectedUnit,
            suffixStyle: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
        ),
      ],
    );
  }

  String _formatLabel(String key) {
    return key
        .split('_')
        .map((p) =>
    p.isEmpty ? p : '${p[0].toUpperCase()}${p.substring(1).toLowerCase()}')
        .join(' ');
  }
}
