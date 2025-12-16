import 'package:flutter/material.dart';
import 'package:icon/app/core/values/app_colors.dart';

class AnimatedFab extends StatefulWidget {
  const AnimatedFab({
    super.key,
    this.onOpen,
    this.onClose,
  });
  final VoidCallback? onOpen;
  final VoidCallback? onClose;
  @override
  State<AnimatedFab> createState() => _AnimatedFabState();
}

class _AnimatedFabState extends State<AnimatedFab>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  void _toggle() {
    setState(() {
      isOpen = !isOpen;
      if (isOpen) {
        _controller.forward();
        widget.onOpen?.call();
      } else {
        _controller.reverse();
        widget.onClose?.call();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      height: 56,
      child: FloatingActionButton(
        elevation: 6,
        backgroundColor: AppColors.deepGreenFavBgColor,
        shape: const CircleBorder(),
        onPressed: _toggle,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, child) {
            return Transform.rotate(
              angle: _controller.value * 0.785398,
              child: child,
            );
          },
          child: const Icon(
            Icons.add,
            size: 28,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
