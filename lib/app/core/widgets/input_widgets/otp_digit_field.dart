import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icon/app/core/widgets/input_widgets/adaptive_text_field.dart';

class OtpDigitField extends StatelessWidget {
  const OtpDigitField({
    super.key,
    required this.controller,
    this.focusNode,
    this.autoFocus = false,
    this.errorText,
    this.onChanged,
    this.onFilled,
    this.onBackspace,
    this.onTapOutside,
    this.isFirst = false,
    this.isLast = false,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final bool autoFocus;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilled;
  final VoidCallback? onBackspace;
  final void Function(PointerDownEvent)? onTapOutside;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return AdaptiveSuperTextField(
      controller: controller,
      focusNode: focusNode,
      maxLength: 1,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      errorText: errorText,
      onTapOutside: onTapOutside ?? _defaultTapOutside,
      textAlign: TextAlign.center,
      autofocus: autoFocus,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(1),
      ],
      onChanged: (value) {
        onChanged?.call(value);

        if (value.length == 1) {
          onFilled?.call();
          if (!isLast) {
            FocusScope.of(context).nextFocus();
          }
        } else if (value.isEmpty) {
          onBackspace?.call();
          if (!isFirst) {
            FocusScope.of(context).previousFocus();
          }
        }
      },
    );
  }

  void _defaultTapOutside(PointerDownEvent _) {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
