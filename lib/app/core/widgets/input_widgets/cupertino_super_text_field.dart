import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

/// iOS-styled version mirroring your API, with proper Cupertino behaviors:
/// - Rounded, filled background that adapts to light/dark
/// - Built-in clear button (when `showClearButton` && not password)
/// - Eye toggle for passwords
/// - Optional validator via FormField wrapper
class CupertinoSuperTextField extends StatefulWidget {
  const CupertinoSuperTextField({
    super.key,
    required this.controller,
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
    this.maxLines = 1,
    this.minLines,
    this.style,
    this.validator,
    this.autofillHints,
    this.focusNode,
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
    this.enabled,
  });

  final TextEditingController controller;

  // Core props
  final String? labelText;
  final String? hintText; // Used as placeholder on iOS
  final String? errorText; // Optional external error
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool isPassword;
  final bool? obscureText; // Controlled if provided
  final VoidCallback? onTogglePasswordVisibility;

  // Decoration
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? contentPadding;

  // Behavior & style
  final ValueChanged<String>? onChanged;
  final int? maxLines;
  final int? minLines;
  final TextStyle? style;
  final String? Function(String?)? validator; // Form-style validation
  final Iterable<String>? autofillHints;
  final FocusNode? focusNode;
  final bool readOnly;
  final bool autofocus;
  final ValueChanged<String>? onFieldSubmitted;
  final VoidCallback? onEditingComplete;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final TextCapitalization textCapitalization;
  final String obscuringCharacter;
  final bool showClearButton;
  final bool? enabled;

  @override
  State<CupertinoSuperTextField> createState() =>
      _CupertinoSuperTextFieldState();
}

class _CupertinoSuperTextFieldState extends State<CupertinoSuperTextField> {
  late bool _internalObscure;

  bool get _usesExternalObscure => widget.obscureText != null;

  @override
  void initState() {
    super.initState();
    _internalObscure = widget.isPassword;
    assert(
      !(widget.isPassword &&
          widget.obscureText != null &&
          widget.onTogglePasswordVisibility == null),
      'When using a controlled password field, provide onTogglePasswordVisibility.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final cupertinoTheme = CupertinoTheme.of(context);
    final baseTextStyle = widget.style ?? cupertinoTheme.textTheme.textStyle;
    final placeholder = widget.hintText ?? widget.labelText;

    final isObscured = widget.isPassword
        ? (widget.obscureText ?? _internalObscure)
        : false;

    final maxLines = widget.isPassword ? 1 : widget.maxLines;
    final minLines = widget.isPassword ? 1 : widget.minLines;

    final field = FormField<String>(
      validator: widget.validator,
      autovalidateMode: widget.validator != null
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      builder: (formState) {
        final mergedError = widget.errorText ?? formState.errorText;
        final bg = CupertinoDynamicColor.resolve(
          CupertinoColors.secondarySystemFill,
          context,
        );
        final disabled = widget.enabled == false;

        final textField = IgnorePointer(
          ignoring: disabled,
          child: Opacity(
            opacity: disabled ? 0.6 : 1,
            child: CupertinoTextField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              autofocus: widget.autofocus,
              keyboardType: widget.keyboardType,
              textInputAction: widget.textInputAction,
              inputFormatters: widget.inputFormatters,
              maxLength: widget.maxLength,
              textCapitalization: widget.textCapitalization,
              obscureText: isObscured,
              obscuringCharacter: widget.obscuringCharacter,
              maxLines: maxLines,
              minLines: minLines,
              style: baseTextStyle,
              placeholder: placeholder,
              placeholderStyle: baseTextStyle.copyWith(
                color: CupertinoDynamicColor.resolve(
                  CupertinoColors.placeholderText,
                  context,
                ),
              ),
              padding:
                  (widget.contentPadding ??
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 14)),
              prefix: widget.prefixIcon == null
                  ? null
                  : Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: IconTheme.merge(
                        data: const IconThemeData(size: 20),
                        child: widget.prefixIcon!,
                      ),
                    ),
              suffix: _buildSuffix(context, isObscured),
              clearButtonMode: (!widget.isPassword && widget.showClearButton)
                  ? OverlayVisibilityMode.editing
                  : OverlayVisibilityMode.never,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(8),
              ),
              onChanged: (v) {
                formState.didChange(v);
                widget.onChanged?.call(v);
              },
              onSubmitted: widget.onFieldSubmitted,
              onEditingComplete: widget.onEditingComplete,
              autofillHints: widget.autofillHints,
              readOnly: widget.readOnly,
            ),
          ),
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.labelText != null && widget.hintText == null)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  widget.labelText!,
                  style: cupertinoTheme.textTheme.textStyle.copyWith(
                    fontSize: 12,
                    color: CupertinoDynamicColor.resolve(
                      CupertinoColors.secondaryLabel,
                      context,
                    ),
                  ),
                ),
              ),
            textField,
            if (mergedError != null)
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 4),
                child: Text(
                  mergedError,
                  style: cupertinoTheme.textTheme.textStyle.copyWith(
                    fontSize: 12,
                    color: CupertinoDynamicColor.resolve(
                      CupertinoColors.systemRed,
                      context,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );

    return field;
  }

  Widget? _buildSuffix(BuildContext context, bool isObscured) {
    final parts = <Widget>[];

    if (widget.suffixIcon != null) {
      parts.add(
        Padding(
          padding: const EdgeInsets.only(right: 4),
          child: IconTheme.merge(
            data: const IconThemeData(size: 20),
            child: widget.suffixIcon!,
          ),
        ),
      );
    }

    if (widget.isPassword) {
      parts.add(
        CupertinoButton(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          onPressed:
              widget.onTogglePasswordVisibility ??
              () {
                if (_usesExternalObscure) {
                  widget.onTogglePasswordVisibility?.call();
                } else {
                  setState(() => _internalObscure = !_internalObscure);
                }
              },
          minimumSize: Size(28, 28),
          child: Icon(
            isObscured ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
            size: 20,
          ),
        ),
      );
    }

    if (parts.isEmpty) return null;
    if (parts.length == 1) return parts.first;
    return Row(mainAxisSize: MainAxisSize.min, children: parts);
  }
}
