import 'package:flutter/material.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import '../../core/values/app_colors.dart';
import '../../core/values/app_values.dart';
import 'elevated_container.dart';

class ChannelTransitionLoader extends StatefulWidget {
  const ChannelTransitionLoader({super.key, this.message});

  final String? message;

  @override
  State<ChannelTransitionLoader> createState() => _ChannelTransitionLoaderState();
}

class _ChannelTransitionLoaderState extends State<ChannelTransitionLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    _fade = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = widget.message ?? 'Switching channel...';
    final theme = Theme.of(context);

    return Center(
      child: ElevatedContainer(
        padding: EdgeInsets.all(AppValues.margin * 1.5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FadeTransition(
              opacity: _fade,
              child: Text(
                text,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.colorPrimary,
                ),
              ),
            ),
            16.height,
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Container(
                  height: 4,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: AppColors.colorPrimary.withValues(alpha: 0.2),
                  ),
                  alignment: Alignment.lerp(
                    Alignment.centerLeft,
                    Alignment.centerRight,
                    _controller.value,
                  ),
                  child: Container(
                    height: 4,
                    width: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: AppColors.colorPrimary,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
