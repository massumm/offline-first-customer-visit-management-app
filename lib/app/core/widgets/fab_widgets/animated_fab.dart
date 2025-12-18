import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/core/values/app_colors.dart';

import '../../enums/fav_enum.dart';

class AnimatedFab extends StatefulWidget {
  final FabActionType actionType;
  final RxBool isOpen;
  const AnimatedFab({
    super.key,
    required this.actionType,
    required this.isOpen,
  });

  @override
  State<AnimatedFab> createState() => _AnimatedFabState();
}

class _AnimatedFabState extends State<AnimatedFab>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _scale = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack, // visible bounce
      ),
    );
  }

  Color _fabColor() {
    switch (widget.actionType) {
      case FabActionType.addMeal:
        return AppColors.deepGreenFavBgColor;
      case FabActionType.activityRecoverLog:
        return Colors.blueAccent;
      case FabActionType.recoveryLog:
        return Colors.orangeAccent;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: FloatingActionButton(
        elevation: 6,
        backgroundColor: _fabColor(),
        shape: const CircleBorder(),
        onPressed: () {
          widget.isOpen.value = !widget.isOpen.value;
          widget.isOpen.refresh();
          log(widget.isOpen.value.toString());
          if (widget.isOpen.value) {
            _controller.forward();
          } else {
            _controller.reverse();
          }
        },
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, child) {
            return Transform.rotate(
              angle: _controller.value * 0.785398,
              child: child,
            );
          },
          child: const Icon(Icons.add, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}
