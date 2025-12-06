import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/theme/app_text_theme.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/modules/app_settings/models/radio_button_option.dart';
import 'package:icon/app/modules/full_body_tracker/utils/theme_helpers.dart';

class RadioButtonSelector extends StatelessWidget {
  const RadioButtonSelector({
    super.key,
    required this.textSizeList,
    required this.selectedTextSize,
    this.title = 'Text size',
    this.description = 'Choose a comfortable text size for reading',
  });

  final List<RadioButtonOption> textSizeList;
  final RxString selectedTextSize;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      decoration: BoxDecoration(
        color: ThemeHelpers.primaryCardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.transparent),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              title,
              style: AppTextTheme.titleSmallSemiBold.copyWith(
                color: ThemeHelpers.primaryTextColor,
              ),
            ), //16px, semi bold, black
          ),
          8.height,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              description,
              style: AppTextTheme.bodyMediumRegular,
            ), //12px, regular, secondary text color
          ),
          8.height,
          ...textSizeList.asMap().entries.map((entry) {
            final index = entry.key;
            final textSize = entry.value;
            return Obx(
              () => RadioListTile<String>(
                value: textSize.title,
                groupValue: selectedTextSize.value,
                onChanged: (value) {
                  selectedTextSize.value = value!;
                },
                title: Text(
                  textSize.title,
                  style: selectedTextSize.value == textSize.title
                      ? textSize.textStyle.copyWith(
                          color: AppColors.colorPrimary,
                          fontWeight: FontWeight.w600,
                        )
                      : textSize.textStyle,
                ),
                contentPadding: EdgeInsets.zero,
                dense: true,
                visualDensity: VisualDensity(horizontal: -4, vertical: -4),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
