import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';

class ActionButton extends StatefulWidget {
  final String? label;
  final VoidCallback? onTap;
  final IconData? icon;
  final double? height;
  final double? width;
  final double? iconSize;
  final Color? bgColor;
  final BorderRadius? borderRadius;

  const ActionButton({
    super.key,
    this.onTap,
    this.label,
    this.icon,
    this.height,
    this.width,
    this.iconSize,
    this.bgColor,
    this.borderRadius,
  });

  // Specific for AppBar Icon
  const ActionButton.compact({
    super.key,
    this.onTap,
    this.icon,
    this.bgColor,
    this.borderRadius,
  })  : height = 24,
        width = 24,
        label = null,
        iconSize = 16;

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final bool _isIOS;

  static const double _pressedValue = 1.0;
  static const double _releasedValue = 0.0;

  @override
  void initState() {
    super.initState();

    // Safe platform detection
    _isIOS = defaultTargetPlatform == TargetPlatform.iOS;

    _controller = AnimationController.unbounded(vsync: this)
      ..value = _releasedValue
      ..addListener(() {
        setState(() {}); // Triggers rebuild for animation frames
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _animateTo(double target, {double velocity = 0}) {
    final spring = SpringDescription(
      mass: 1.0,
      stiffness: _isIOS ? 320 : 180,
      damping: _isIOS ? 32 : 18,
    );

    _controller.animateWith(
      SpringSimulation(
        spring,
        _controller.value,
        target,
        velocity,
      ),
    );
  }

  void _onPointerDown(PointerDownEvent event) {
    if (widget.onTap == null || event.buttons != kPrimaryButton) return;

    _animateTo(_pressedValue, velocity: 2);

    // Haptic feedback for mobile
    if (_isIOS || defaultTargetPlatform == TargetPlatform.android) {
      HapticFeedback.selectionClick();
    }
  }

  void _onPointerUp(PointerUpEvent event) {
    if (widget.onTap == null) return;

    _animateTo(_releasedValue);
    widget.onTap?.call();
  }

  void _onPointerCancel(PointerCancelEvent event) {
    if (widget.onTap == null) return;

    _animateTo(_releasedValue);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIconOnly = widget.label == null;

    // Clamp controller value to avoid overshoot crashes
    final t = _controller.value.clamp(0.0, 1.0);

    final scale = lerpDouble(
      1.0,
      _isIOS ? 0.965 : 0.92,
      t,
    )!;

    final elevation =
    _isIOS ? 0.0 : lerpDouble(6, 0, t)!;

    final opacity = lerpDouble(
      1.0,
      _isIOS ? 0.97 : 0.94,
      t,
    )!;

    final content = isIconOnly
        ? Icon(
      widget.icon ?? Icons.arrow_back_ios_new_rounded,
      size: widget.iconSize ?? 16,
    )
        : Text(
      widget.label!,
      style: theme.textTheme.titleSmall,
      textAlign: TextAlign.center,
    );

    return Semantics(
      button: true,
      enabled: widget.onTap != null,
      child: Listener(
        behavior: HitTestBehavior.opaque,
        onPointerDown: _onPointerDown,
        onPointerUp: _onPointerUp,
        onPointerCancel: _onPointerCancel,
        child: Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: opacity,
            child: Material(
              elevation: elevation,
              shadowColor: _isIOS
                  ? Colors.transparent
                  : (widget.bgColor ?? Colors.black).withValues(alpha: 0.25),
              color: widget.bgColor ??
                  theme.colorScheme.surfaceContainerHighest,
              borderRadius: widget.borderRadius ??
                  BorderRadius.circular(
                    isIconOnly ? (widget.height ?? 24) / 2 : 999,
                  ),
              child: Container(
                height: widget.height,
                width: widget.width,
                alignment: Alignment.center,
                padding: (widget.height != null || widget.width != null)
                    ? EdgeInsets.zero
                    : const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: content,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
