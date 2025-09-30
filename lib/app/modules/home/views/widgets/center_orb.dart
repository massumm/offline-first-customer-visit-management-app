import 'package:flutter/material.dart';

class CenterOrb extends StatelessWidget {
  const CenterOrb({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      height: 72,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const SweepGradient(
            colors: [
              Color(0xFFFF7A7A), // warm reds/pinks
              Color(0xFFFFC96B),
              Color(0xFF72E6FF),
              Color(0xFFA77BFF),
              Color(0xFFFF7A7A),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFC7B7B).withValues(alpha: 0.35),
              blurRadius: 24,
              spreadRadius: 2,
            )
          ],
        ),
        child: Center(
          child: Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                radius: 0.9,
                colors: [Colors.white, Color(0x80FFFFFF), Colors.transparent],
                stops: [0.0, 0.45, 1.0],
              ),
            ),
            child: const Icon(Icons.bolt_rounded, size: 34, color: Colors.white),
          ),
        ),
      ),
    );
  }
}