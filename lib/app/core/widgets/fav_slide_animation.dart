import 'package:flutter/material.dart';
import 'package:icon/app/core/values/app_colors.dart';
import '../enums/fav_enum.dart';


class AnimatedFab extends StatefulWidget {
  const AnimatedFab({
    super.key,
    required this.actionType,
  });

  final FabActionType actionType;

  @override
  State<AnimatedFab> createState() => _AnimatedFabState();
}

class _AnimatedFabState extends State<AnimatedFab>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  PersistentBottomSheetController? _bottomSheetController;
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
    if (isOpen) {
      _closeSheet();
    } else {
      _openSheet();
    }
  }

  void _openSheet() {
    isOpen = true;
    _controller.forward();

  }


  void _closeSheet() {
    _bottomSheetController?.close();
    _bottomSheetController = null;
  }



  Color _fabColor() {
    switch (widget.actionType) {
      case FabActionType.addMeal:
        return AppColors.greenColor;
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
    return SizedBox(
      width: 56,
      height: 56,
      child: FloatingActionButton(
        elevation: 6,
        backgroundColor: _fabColor(),
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
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }
}
