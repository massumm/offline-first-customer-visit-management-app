import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../base/base_view.dart';
import '../../../core/values/app_text_styles.dart' as appBarTheme;
import '../../../core/widgets/action_button.dart';
import '../controllers/recovery_tracker_controller.dart';
import '../models/activity_type_model.dart';

class LogRecoveryEntryView extends BaseView<RecoveryTrackerController> {
  const LogRecoveryEntryView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      title: Text('Log Recovery', style: appBarTheme.titleTextStyle),
      centerTitle: true,

      leading: Padding(
        padding: EdgeInsets.all(6),
        child: ActionButton.compact(onTap: Get.back),
      ),
    );
  }

  @override
  Widget body(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label('Activity Name'),
            const SizedBox(height: 8),
            _textField(hint: 'Evening Yoga', enabled: false),
            const SizedBox(height: 20),

            _label('Activity Type'),
            const SizedBox(height: 8),
            _dropdownField(),
            const SizedBox(height: 20),

            _label('Duration (minutes)'),
            const SizedBox(height: 8),
            _textField(hint: '20', keyboardType: TextInputType.number),

            const Spacer(),

            _primaryButton(
              title: 'Log Repair',
              onTap: () {
                // TODO: Submit action
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _textField({
    required String hint,
    bool enabled = true,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      enabled: enabled,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
        filled: true,
        fillColor: const Color(0xFF1C1C1E),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _dropdownField() {
    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E),
          borderRadius: BorderRadius.circular(14),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            value: controller.selectedActivityType.value,
            dropdownColor: const Color(0xFF1C1C1E),
            hint: Text(
              'Select type',
              style: TextStyle(color: Colors.white.withAlpha(127)),
            ),
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white70),
            selectedItemBuilder: (BuildContext context) {
              return controller.activityTypes.map<Widget>((
                ActivityTypeModel activityType,
              ) {
                return Row(
                  children: [
                    Text(
                      activityType.name!,
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              }).toList();
            },
            items: controller.activityTypes.map<DropdownMenuItem<String>>((
              ActivityTypeModel activityType,
            ) {
              return DropdownMenuItem<String>(
                value: activityType.name!,
                child: Text(
                  activityType.name!,
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }).toList(),
            onChanged: (value) {
              controller.selectedActivityType.value = value;
            },
          ),
        ),
      ),
    );
  }

  Widget _primaryButton({required String title, required VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2F6DB5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
