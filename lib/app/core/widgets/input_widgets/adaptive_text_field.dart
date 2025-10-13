import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'cupertino_super_text_field.dart';
import 'super_text_field.dart';

/// Which look to use.
enum SuperTextFieldPlatform { auto, material, cupertino }

/// Drop-in adaptive wrapper:
/// - On iOS/macOS: uses CupertinoSuperTextField
/// - Else: uses your (Material) SuperTextField
class AdaptiveSuperTextField extends StatelessWidget {
  const AdaptiveSuperTextField({
    super.key,
    required this.controller,
    this.platform = SuperTextFieldPlatform.auto,
    // shared props
    this.labelText,
    this.hintText,
    this.errorText,
    this.keyboardType,
    this.textInputAction,
    this.isPassword = false,
    this.obscureText,
    this.onTogglePasswordVisibility,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onTapOutside,
    this.maxLines = 1,
    this.minLines,
    this.style,
    this.validator,
    this.autofillHints,
    this.focusNode,
    this.enabled,
    this.readOnly = false,
    this.autofocus = false,
    this.onFieldSubmitted,
    this.onEditingComplete,
    this.inputFormatters,
    this.maxLength,
    this.textCapitalization = TextCapitalization.none,
    this.contentPadding,
    this.obscuringCharacter = '•',
    this.showClearButton = false,
    this.suffixIconConstraints,
  });

  final SuperTextFieldPlatform platform;
  final TextEditingController controller;

  // shared props (match your Material SuperTextField API)
  final String? labelText;
  final String? hintText;
  final String? errorText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool isPassword;
  final bool? obscureText;
  final VoidCallback? onTogglePasswordVisibility;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final void Function(PointerDownEvent)? onTapOutside;
  final int? maxLines;
  final int? minLines;
  final TextStyle? style;
  final String? Function(String?)? validator;
  final Iterable<String>? autofillHints;
  final FocusNode? focusNode;
  final bool? enabled;
  final bool readOnly;
  final bool autofocus;
  final ValueChanged<String>? onFieldSubmitted;
  final VoidCallback? onEditingComplete;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final TextCapitalization textCapitalization;
  final EdgeInsetsGeometry? contentPadding;
  final String obscuringCharacter;
  final bool showClearButton;
  final BoxConstraints? suffixIconConstraints;

  bool _isCupertino(BuildContext context) {
    if (platform == SuperTextFieldPlatform.cupertino) return true;
    if (platform == SuperTextFieldPlatform.material) return false;
    final target = Theme.of(context).platform;
    return target == TargetPlatform.iOS || target == TargetPlatform.macOS;
  }

  @override
  Widget build(BuildContext context) {
    if (_isCupertino(context)) {
      return CupertinoSuperTextField(
        controller: controller,
        labelText: labelText,
        hintText: hintText,
        errorText: errorText,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        isPassword: isPassword,
        obscureText: obscureText,
        onTogglePasswordVisibility: onTogglePasswordVisibility,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        onChanged: onChanged,
        maxLines: maxLines,
        minLines: minLines,
        style: style,
        validator: validator,
        autofillHints: autofillHints,
        focusNode: focusNode,
        readOnly: readOnly,
        autofocus: autofocus,
        onFieldSubmitted: onFieldSubmitted,
        onEditingComplete: onEditingComplete,
        inputFormatters: inputFormatters,
        maxLength: maxLength,
        textCapitalization: textCapitalization,
        contentPadding: contentPadding,
        obscuringCharacter: obscuringCharacter,
        showClearButton: showClearButton,
        enabled: enabled,
      );
    }

    // Falls back to your Material implementation (the optimized one I sent).
    return SuperTextField(
      controller: controller,
      labelText: labelText,
      hintText: hintText,
      errorText: errorText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      isPassword: isPassword,
      obscureText: obscureText,
      onTogglePasswordVisibility: onTogglePasswordVisibility,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      onChanged: onChanged,
      onTapOutside: onTapOutside,
      maxLines: maxLines,
      minLines: minLines,
      style: style,
    );
  }
}

