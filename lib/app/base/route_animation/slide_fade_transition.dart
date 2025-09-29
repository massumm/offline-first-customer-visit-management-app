import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SlideFadeTransition extends CustomTransition {
  @override
  Widget buildTransition(BuildContext context, Curve? curve, Alignment? alignment,
      Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    final curved = CurvedAnimation(parent: animation, curve: curve ?? Curves.easeOutCubic);
    final offsetTween = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero);
    final opacityTween = Tween<double>(begin: 0.0, end: 1.0);

    return FadeTransition(
      opacity: opacityTween.animate(curved),
      child: SlideTransition(
        position: offsetTween.animate(curved),
        child: child,
      ),
    );
  }
}
