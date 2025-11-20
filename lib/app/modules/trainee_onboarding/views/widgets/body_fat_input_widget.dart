import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icon/app/core/widgets/super_image.dart';
import 'package:icon/generated/assets.dart';

import '../../../../core/widgets/input_widgets/adaptive_text_field.dart';

class BodyFatInputWidget extends StatefulWidget {
  const BodyFatInputWidget({super.key, required this.onNext});

  final void Function(BodyFatOption selectedOption, String customValue) onNext;

  @override
  State<BodyFatInputWidget> createState() => _BodyFatInputWidgetState();
}

class _BodyFatInputWidgetState extends State<BodyFatInputWidget> {
  final TextEditingController _customValueController = TextEditingController();

  final List<BodyFatOption> options = const [
    BodyFatOption(
      title: 'High',
      subtitle: '25%+',
      image: Assets.bodyFatBodyFatHigh,
    ),
    BodyFatOption(
      title: 'Moderate',
      subtitle: '15–25%',
      image: Assets.bodyFatBodyFatModerate,
    ),
    BodyFatOption(
      title: 'Low',
      subtitle: '10–15%',
      image: Assets.bodyFatBodyFatLow,
    ),
    BodyFatOption(
      title: 'Very Low',
      subtitle: '5–10%',
      image: Assets.bodyFatBodyFatVeryLow,
    ),
  ];

  final FixedExtentScrollController _wheelController =
      FixedExtentScrollController(initialItem: 0);

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // --- Theme-aware colors ---
    const red = Color(0xFFE4583D);
    final cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final subtitleColor = isDarkMode
        ? Colors.grey.shade400
        : Colors.grey.shade600;
    final iconColor = isDarkMode ? Colors.white70 : Colors.black54;
    final unselectedBorderColor = isDarkMode
        ? Colors.transparent
        : Colors.grey.shade300;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ------- WHEEL LIST -------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SizedBox(
                height: 320,
                child: ClipRect(
                  clipBehavior: Clip.none,
                  child: ListWheelScrollView.useDelegate(
                    controller: _wheelController,
                    itemExtent: 66,
                    perspective: 0.004,
                    diameterRatio: 1.6,
                    physics: const FixedExtentScrollPhysics(),
                    onSelectedItemChanged: (index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: options.length,
                      builder: (context, index) {
                        final option = options[index];
                        final isSelected = _selectedIndex == index;

                        return AnimatedScale(
                          duration: const Duration(milliseconds: 180),
                          scale: isSelected ? 1 : 0.95,
                          child: _BodyFatCard(
                            option: option,
                            isSelected: isSelected,
                            cardColor: cardColor,
                            textColor: textColor,
                            subtitleColor: subtitleColor,
                            iconColor: iconColor,
                            selectedBorderColor: red,
                            unselectedBorderColor: unselectedBorderColor,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // ------- CUSTOM VALUE -------
            Row(
              children: [
                Expanded(
                  child: AdaptiveSuperTextField(
                    controller: _customValueController,
                    hintText: "7%",
                    labelText: 'Add Custom Value',
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9%]')),
                    ],
                    errorText: null,
                    onTapOutside: (_) => FocusScope.of(context).unfocus(),
                    onChanged: (value) {},
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  height: 42,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: red, width: 1.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 0,
                      ),
                      foregroundColor: red,
                    ),
                    onPressed: () {
                      debugPrint(
                        'Custom value: ${_customValueController.text}',
                      );
                    },
                    child: const Text(
                      'Add',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ------- NEXT BUTTON -------
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                final selected = options[_selectedIndex];
                widget.onNext(selected, _customValueController.text);
              },
              child: const Text(
                'Next',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BodyFatCard extends StatelessWidget {
  final BodyFatOption option;
  final bool isSelected;
  final Color cardColor;
  final Color textColor;
  final Color subtitleColor;
  final Color iconColor;
  final Color selectedBorderColor;
  final Color unselectedBorderColor;

  const _BodyFatCard({
    required this.option,
    required this.isSelected,
    required this.cardColor,
    required this.textColor,
    required this.subtitleColor,
    required this.iconColor,
    required this.selectedBorderColor,
    required this.unselectedBorderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isSelected ? selectedBorderColor : unselectedBorderColor,
          width: 1.2,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SuperImage(
              option.image,
              height: 52,
              width: 52,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  option.title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    // Corrected: use withOpacity
                    color: isSelected
                        ? textColor
                        : textColor.withValues(alpha: 0.7),
                  ),
                ),
                Text(
                  option.subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    // Corrected: use withOpacity
                    color: isSelected
                        ? subtitleColor
                        : subtitleColor.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: iconColor, size: 28),
        ],
      ),
    );
  }
}

class BodyFatOption {
  final String title;
  final String subtitle;
  final String image;

  const BodyFatOption({
    required this.title,
    required this.subtitle,
    required this.image,
  });
}
