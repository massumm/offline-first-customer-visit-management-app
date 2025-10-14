import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SuperTextField extends StatefulWidget {
  const SuperTextField({
    super.key,
    required this.controller,
    this.labelText,
    this.hintText,
    this.errorText, // If you pass validator, prefer leaving this null so Form handles it.
    this.keyboardType,
    this.textInputAction,
    this.isPassword = false,
    this.obscureText, // If provided, acts as a controlled prop.
    this.onTogglePasswordVisibility, // Required when obscureText is controlled (recommended).
    this.prefixIcon,
    this.suffixIcon, // Will be shown alongside the eye button when isPassword = true.
    this.onChanged,
    this.onTapOutside,
    this.maxLines = 1, // Ignored for passwords (forced to 1).
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
    this.showClearButton = false, // Only for non-password fields.
    this.suffixIconConstraints,
  });

  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final String? errorText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool isPassword;
  final bool? obscureText;
  final VoidCallback? onTogglePasswordVisibility;

  // Decoration
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? contentPadding;
  final BoxConstraints? suffixIconConstraints;

  // Behavior
  final ValueChanged<String>? onChanged;
  final void Function(PointerDownEvent)? onTapOutside;

  // Layout & style
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
  final String obscuringCharacter;

  // Extras
  final bool showClearButton;

  @override
  State<SuperTextField> createState() => _SuperTextFieldState();
}

class _SuperTextFieldState extends State<SuperTextField> {
  late bool _internalObscure;

  bool get _usesExternalObscure => widget.obscureText != null;

  @override
  void initState() {
    super.initState();
    _internalObscure = widget.isPassword;
    // Safety: if user provides controlled obscure, recommend a toggle callback.
    assert(
      !(widget.isPassword &&
          widget.obscureText != null &&
          widget.onTogglePasswordVisibility == null),
      'When using a controlled password field, provide onTogglePasswordVisibility.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bool isObscured = widget.isPassword
        ? (widget.obscureText ?? _internalObscure)
        : false;

    // Passwords should be single line for UX + platform behavior.
    final int? effectiveMaxLines = widget.isPassword ? 1 : widget.maxLines;
    final int? effectiveMinLines = widget.isPassword ? 1 : widget.minLines;

    // Build suffix icon (can include: custom suffix, eye toggle, clear button)
    final Widget? suffix = _buildSuffix(context, isObscured);

    // Expand constraints if we’re rendering multiple icons.
    final bool multipleSuffix =
        (widget.isPassword && widget.suffixIcon != null) ||
        (!widget.isPassword && widget.showClearButton);
    final BoxConstraints suffixConstraints =
        widget.suffixIconConstraints ??
        (multipleSuffix
            ? const BoxConstraints.tightFor(height: 48, width: 96)
            : const BoxConstraints.tightFor(height: 48, width: 48));

    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      autofillHints: widget.autofillHints,
      validator: widget.validator,
      style: widget.style ?? theme.textTheme.bodyLarge,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
      onEditingComplete: widget.onEditingComplete,
      inputFormatters: widget.inputFormatters,
      maxLength: widget.maxLength,
      textCapitalization: widget.textCapitalization,
      obscureText: isObscured,
      obscuringCharacter: widget.obscuringCharacter,
      maxLines: effectiveMaxLines,
      minLines: effectiveMinLines,
      onTapOutside:
          widget.onTapOutside ??
          (_) => FocusManager.instance.primaryFocus?.unfocus(),
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        // Let theme drive colors; avoid hard-coded greys.
        // If you need specific colors, set them via your app's InputDecorationTheme.
        prefixIcon: widget.prefixIcon,
        suffixIcon: suffix,
        suffixIconConstraints: suffixConstraints,
        contentPadding:
            widget.contentPadding ??
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        errorText: widget.errorText,
        // Sensible defaults if no InputDecorationTheme provided:
        filled: Theme.of(context).inputDecorationTheme.filled,
        fillColor: Theme.of(context).inputDecorationTheme.fillColor,
        border:
            Theme.of(context).inputDecorationTheme.border ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
        enabledBorder: Theme.of(context).inputDecorationTheme.enabledBorder,
        focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
        errorBorder:
            Theme.of(context).inputDecorationTheme.errorBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: theme.colorScheme.error, width: 1),
            ),
        focusedErrorBorder:
            Theme.of(context).inputDecorationTheme.focusedErrorBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: theme.colorScheme.error, width: 2),
            ),
      ),
    );
  }

  Widget? _buildSuffix(BuildContext context, bool isObscured) {
    final List<Widget> parts = [];

    // Custom suffix (left-most)
    if (widget.suffixIcon != null) {
      parts.add(_iconWrapper(widget.suffixIcon!));
    }

    // Clear button for non-password fields
    if (!widget.isPassword && widget.showClearButton) {
      parts.add(
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: widget.controller,
          builder: (_, value, _) {
            final hasText = value.text.isNotEmpty && !(widget.readOnly);
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              child: hasText
                  ? IconButton(
                      key: const ValueKey('clear'),
                      splashRadius: 20,
                      icon: const Icon(Icons.clear),
                      onPressed: () => widget.controller.clear(),
                      tooltip: 'Clear',
                    )
                  : const SizedBox.shrink(key: ValueKey('no-clear')),
            );
          },
        ),
      );
    }

    // Password eye toggle (right-most)
    if (widget.isPassword) {
      parts.add(
        IconButton(
          splashRadius: 20,
          icon: Icon(isObscured ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            // If the field is externally controlled, call the provided callback.
            if (_usesExternalObscure) {
              // The assert in initState ensures this callback is provided
              // when obscureText is controlled.
              widget.onTogglePasswordVisibility?.call();
            } else {
              // Otherwise, toggle the internal state for the uncontrolled field.
              setState(() {
                _internalObscure = !_internalObscure;
              });
            }
          },
          tooltip: isObscured ? 'Show' : 'Hide',
        ),
      );
    }

    if (parts.isEmpty) return null;
    if (parts.length == 1) return parts.first;

    // Multiple icons – keep tight so InputDecorator can size it.
    return Row(mainAxisSize: MainAxisSize.min, children: parts);
  }

  Widget _iconWrapper(Widget icon) =>
      IconTheme.merge(data: const IconThemeData(size: 24), child: icon);
}
