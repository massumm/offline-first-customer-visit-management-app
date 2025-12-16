import 'package:flutter/material.dart';

/// A reusable, animated pill-shaped button that provides satisfying
/// visual feedback on tap. It's designed to look more premium
/// than a standard chip or button.
class ActionPill extends StatefulWidget {
  final String? label;

  final VoidCallback? onTap;

  final IconData? icon;

  final double? height;

  final double? width;

  final double? iconSize;

  const ActionPill({
    super.key,
    this.onTap,
    this.label,
    this.icon,
    this.height,
    this.width,
    this.iconSize,
  });

  const ActionPill.compact({super.key, this.onTap, this.icon})
    : height = 24,
      width = 24,
      label = null,
      iconSize = 16;

  @override
  State<ActionPill> createState() => _ActionPillState();
}

class _ActionPillState extends State<ActionPill>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse().whenComplete(() {
      if (widget.onTap != null) {
        widget.onTap!();
      }
    });
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIconOnly = widget.label == null;

    // Determine the content of the pill (either Icon or Text)
    Widget child;
    if (isIconOnly) {
      child = Center(
        child: Icon(
          widget.icon ?? Icons.arrow_back_ios_new_rounded,
          size: widget.iconSize ?? 16.0,
        ),
      );
    } else {
      child = Center(
        child: Text(
          widget.label!,
          style: theme.textTheme.titleSmall,
          textAlign: TextAlign.center,
        ),
      );
    }

    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: Material(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(
            isIconOnly ? (widget.height ?? 24) / 2 : 999,
          ),
          child: Container(
            height: widget.height,
            width: widget.width,
            alignment: Alignment.center,
            padding: (widget.height != null || widget.width != null)
                ? EdgeInsets.zero
                : const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: child,
          ),
        ),
      ),
    );
  }
}
