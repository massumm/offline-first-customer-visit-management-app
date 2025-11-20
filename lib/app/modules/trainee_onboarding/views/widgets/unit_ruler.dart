import 'package:flutter/material.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';

enum HeightUnit { cm, inch }

typedef OnUnitChanged = void Function(double heightCm, HeightUnit unit);

class UnitRuler extends StatelessWidget {
  const UnitRuler({
    super.key,
    this.minHeightCm = 120,
    this.maxHeightCm = 250,
    this.initialHeightCm = 170,
    required this.onChanged,
    required this.onSubmit,
  });

  final double minHeightCm;
  final double maxHeightCm;
  final double initialHeightCm;
  final OnUnitChanged onChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          UnitPicker(
            minHeightCm: minHeightCm,
            maxHeightCm: maxHeightCm,
            initialHeightCm: initialHeightCm,
            onChanged: onChanged,
          ),
          12.height,
          ElevatedButton(onPressed: onSubmit, child: const Text('Continue')),
        ],
      ),
    );
  }
}

class UnitPicker extends StatefulWidget {
  final double minHeightCm;
  final double maxHeightCm;
  final double initialHeightCm;
  final OnUnitChanged? onChanged;

  const UnitPicker({
    super.key,
    this.minHeightCm = 120,
    this.maxHeightCm = 250,
    this.initialHeightCm = 170,
    this.onChanged,
  });

  @override
  State<UnitPicker> createState() => _UnitPickerState();
}

class _UnitPickerState extends State<UnitPicker> {
  static const double _pixelsPerCm = 8.0;

  late double _heightCm;
  HeightUnit _unit = HeightUnit.cm;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _heightCm = widget.initialHeightCm.clamp(
      widget.minHeightCm,
      widget.maxHeightCm,
    );
    _scrollController = ScrollController(
      initialScrollOffset: (_heightCm - widget.minHeightCm) * _pixelsPerCm,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // --- Helpers --------------------------------------------------------------

  void _updateHeightFromOffset(double offset) {
    final cm = widget.minHeightCm + offset / _pixelsPerCm;
    final clamped = cm.clamp(widget.minHeightCm, widget.maxHeightCm);

    if (clamped == _heightCm) return;

    setState(() {
      _heightCm = clamped;
    });
    widget.onChanged?.call(_heightCm, _unit);
  }

  String get _formattedValue {
    if (_unit == HeightUnit.cm) {
      return '${_heightCm.round()}cm';
    } else {
      final totalInches = _heightCm / 2.54;
      final rounded = totalInches.round();
      final feet = rounded ~/ 12;
      final inches = rounded % 12;
      return "$feet'$inches\"";
    }
  }

  void _setUnit(HeightUnit unit) {
    if (_unit == unit) return;
    setState(() {
      _unit = unit;
    });
    // 3. Also notify the parent when the unit changes.
    widget.onChanged?.call(_heightCm, _unit);
  }

  // --- UI -------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildUnitToggle(),
        const SizedBox(height: 16),
        Text(
          _formattedValue,
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 110,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final viewportWidth = constraints.maxWidth;
              final padding = viewportWidth / 2;
              final totalWidth =
                  viewportWidth +
                  (widget.maxHeightCm - widget.minHeightCm) * _pixelsPerCm;

              return Stack(
                alignment: Alignment.center,
                children: [
                  NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification.metrics.axis != Axis.horizontal) {
                        return false;
                      }

                      if (notification is ScrollUpdateNotification) {
                        _updateHeightFromOffset(notification.metrics.pixels);
                      } else if (notification is ScrollEndNotification) {
                        // snap to nearest cm
                        final offset = _scrollController.offset;
                        final maxIndex =
                            (widget.maxHeightCm - widget.minHeightCm).round();
                        final targetIndex = (offset / _pixelsPerCm)
                            .round()
                            .clamp(0, maxIndex);
                        final targetOffset = targetIndex * _pixelsPerCm;
                        if ((targetOffset - offset).abs() > 0.5) {
                          _scrollController.animateTo(
                            targetOffset,
                            duration: const Duration(milliseconds: 120),
                            curve: Curves.easeOut,
                          );
                        }
                      }
                      return false;
                    },
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: CustomPaint(
                        size: Size(totalWidth, 80),
                        painter: HeightRulerPainter(
                          minValue: widget.minHeightCm,
                          maxValue: widget.maxHeightCm,
                          pixelsPerCm: _pixelsPerCm,
                          padding: padding,
                          isCm: _unit == HeightUnit.cm,
                          majorTickColor: colorScheme.onSurface,
                          // Note: Replaced non-standard `withValues` with `withOpacity`.
                          minorTickColor: colorScheme.onSurface.withValues(alpha:
                            0.5,
                          ),
                          labelColor: colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                  ),
                  // Center indicator
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Container(
                        width: 2,
                        height: 48,
                        color: colorScheme.primary,
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        _buildMinMaxRow(),
      ],
    );
  }

  Widget _buildUnitToggle() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final activeColor = colorScheme.primary;
    final inactiveColor = colorScheme.onSurface.withValues(alpha: 0.6);

    Widget tab(String label, HeightUnit unit) {
      final isActive = _unit == unit;
      return GestureDetector(
        onTap: () => _setUnit(unit),
        child: Container(
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border(
              bottom: BorderSide(
                color: isActive ? activeColor : theme.dividerColor,
                width: 2,
              ),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? activeColor : inactiveColor,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        Expanded(child: tab('cm', HeightUnit.cm)),
        12.width,
        Expanded(child: tab('Inches', HeightUnit.inch)),
      ],
    );
  }

  Widget _buildMinMaxRow() {
    final labelColor = Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: 0.7);
    final minText = _unit == HeightUnit.cm
        ? 'Min height: ${widget.minHeightCm.toInt()} cm'
        : 'Min height: ${(widget.minHeightCm / 2.54).round()} in';

    final maxText = _unit == HeightUnit.cm
        ? 'Max height: ${widget.maxHeightCm.toInt()} cm'
        : 'Max height: ${(widget.maxHeightCm / 2.54).round()} in';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(minText, style: TextStyle(color: labelColor, fontSize: 12)),
        Text(maxText, style: TextStyle(color: labelColor, fontSize: 12)),
      ],
    );
  }
}

// Custom painter that draws the ruler ticks & numbers

class HeightRulerPainter extends CustomPainter {
  final double minValue;
  final double maxValue;
  final double pixelsPerCm;
  final double padding;
  final bool isCm;
  final Color majorTickColor;
  final Color minorTickColor;
  final Color labelColor;

  HeightRulerPainter({
    required this.minValue,
    required this.maxValue,
    required this.pixelsPerCm,
    required this.padding,
    required this.isCm,
    required this.majorTickColor,
    required this.minorTickColor,
    required this.labelColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint majorPaint = Paint()
      ..color = majorTickColor
      ..strokeWidth = 2;
    final Paint minorPaint = Paint()
      ..color = minorTickColor
      ..strokeWidth = 1;

    final double bottom = size.height;
    const double minorHeight = 16;
    const double mediumHeight = 24;
    const double majorHeight = 32;

    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    final int totalSteps = (maxValue - minValue).round();

    // base line
    canvas.drawLine(Offset(0, bottom), Offset(size.width, bottom), minorPaint);

    for (int i = 0; i <= totalSteps; i++) {
      final double x = padding + i * pixelsPerCm;
      final double valueCm = minValue + i;

      final bool isMajorTick = valueCm % 10 == 0;
      final bool isMediumTick = !isMajorTick && valueCm % 5 == 0;

      double tickHeight;
      Paint paint;

      if (isMajorTick) {
        tickHeight = majorHeight;
        paint = majorPaint;
      } else if (isMediumTick) {
        tickHeight = mediumHeight;
        paint = minorPaint;
      } else {
        tickHeight = minorHeight;
        paint = minorPaint;
      }

      canvas.drawLine(Offset(x, bottom), Offset(x, bottom - tickHeight), paint);

      if (isMajorTick) {
        final String label;
        if (isCm) {
          label = valueCm.toInt().toString();
        } else {
          final inches = valueCm / 2.54;
          label = inches.toStringAsFixed(0);
        }

        textPainter.text = TextSpan(
          text: label,
          style: TextStyle(color: labelColor, fontSize: 12),
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(x - textPainter.width / 2, bottom - tickHeight - 20),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant HeightRulerPainter oldDelegate) {
    return oldDelegate.isCm != isCm ||
        oldDelegate.minValue != minValue ||
        oldDelegate.maxValue != maxValue ||
        oldDelegate.pixelsPerCm != pixelsPerCm ||
        oldDelegate.padding != padding ||
        oldDelegate.majorTickColor != majorTickColor ||
        oldDelegate.minorTickColor != minorTickColor ||
        oldDelegate.labelColor != labelColor;
  }
}
