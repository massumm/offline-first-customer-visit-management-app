import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/core/theme/app_text_theme.dart';
import 'package:icon/app/modules/full_body_tracker/utils/theme_helpers.dart';

class SwitchButtonSelector {
  final String title;
  final String subtitle;
  final bool hasSwitch;
  final RxBool? switchValue;
  final Function(bool)? onChanged;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  const SwitchButtonSelector({
    required this.title,
    required this.subtitle,
    this.hasSwitch = false,
    this.switchValue,
    this.onChanged,
    this.titleStyle,
    this.subtitleStyle,
  });
}

class DisplayOptionsSelector extends StatelessWidget {
  const DisplayOptionsSelector({
    super.key,
    required this.options,
    this.title = 'Display options',
    this.description = 'Customize the visual experience',
  });

  final List<SwitchButtonSelector> options;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: ThemeHelpers.primaryCardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.transparent),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              title,
              style: AppTextTheme.titleSmallSemiBold,
            ), //16 px, semi bold, black
            subtitle: Text(
              description,
              style: AppTextTheme.bodyMediumRegular,
            ), //12 px, regular, secondary text color
            contentPadding: EdgeInsets.zero,
          ),
          ...options.map((option) {
            if (option.hasSwitch) {
              return ListTile(
                title: Text(
                  option.title,
                  style: option.titleStyle ?? AppTextTheme.titleSmallSemiBold,
                ),
                subtitle: Text(
                  option.subtitle,
                  style: option.subtitleStyle ?? AppTextTheme.bodyMediumRegular,
                ),
                contentPadding: EdgeInsets.zero,
                trailing: Obx(
                  () => Transform.scale(
                    scale: 0.8,
                    child: Switch(
                      value: option.switchValue?.value ?? false,
                      onChanged: option.onChanged,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                    ),
                  ),
                ),
              );
            } else {
              return ListTile(
                title: Text(
                  option.title,
                  style: option.titleStyle ?? AppTextTheme.titleSmallSemiBold,
                ),
                subtitle: Text(
                  option.subtitle,
                  style: option.subtitleStyle ?? AppTextTheme.bodyMediumRegular,
                ),
                contentPadding: EdgeInsets.zero,
              );
            }
          }),
        ],
      ),
    );
  }
}
