import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final int? maxLines;
  final ValueNotifier<String?>? errorNotifier;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final VoidCallback? onEditingComplete;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.maxLines,
    this.errorNotifier,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.onEditingComplete,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: errorNotifier ?? ValueNotifier<String?>(null),
      builder: (context, errorText, _) {
        return TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          maxLines: maxLines,
          onChanged: (value) {
            if (errorNotifier != null && errorNotifier!.value != null) {
              errorNotifier!.value = null;
            }
          },
          onEditingComplete: onEditingComplete,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            labelText: label,
            labelStyle: const TextStyle(color: Colors.grey),
            // Add this line
            alignLabelWithHint: maxLines != null && maxLines! > 1 ? true : null,
            filled: true,
            fillColor: Colors.grey[900],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            errorText: errorText,
            errorStyle: const TextStyle(color: Colors.redAccent),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.redAccent, width: 2),
            ),
          ),
        );
      },
    );
  }
}
