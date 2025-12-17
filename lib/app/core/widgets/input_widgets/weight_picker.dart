import 'package:flutter/material.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';

enum WeightUnit { kg, lbs, stone }

typedef OnUnitChanged = void Function(double weightKg, WeightUnit unit);

class WeightPicker extends StatelessWidget {
  const WeightPicker({
    super.key,
    this.minWeightKg = 30,
    this.maxWeightKg = 200,
    this.initialWeightKg = 60,
    required this.onChanged,
  });

  final double minWeightKg;
  final double maxWeightKg;
  final double initialWeightKg;
  final OnUnitChanged onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          WeightRuler(
            minWeightKg: minWeightKg,
            maxWeightKg: maxWeightKg,
            initialWeightKg: initialWeightKg,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class WeightRuler extends StatefulWidget {
  final double minWeightKg;
  final double maxWeightKg;
  final double initialWeightKg;
  final OnUnitChanged? onChanged;

  const WeightRuler({
    super.key,
    this.minWeightKg = 30,
    this.maxWeightKg = 200,
    this.initialWeightKg = 60,
    this.onChanged,
  });

  @override
  State<WeightRuler> createState() => _WeightRulerState();
}

class _WeightRulerState extends State<WeightRuler> {
  static const double _pixelsPerCm = 8.0;

  late double _weightKg;
  WeightUnit _unit = WeightUnit.kg;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _weightKg = widget.initialWeightKg.clamp(
      widget.minWeightKg,
      widget.maxWeightKg,
    );
    _scrollController = ScrollController(
      initialScrollOffset: (_weightKg - widget.minWeightKg) * _pixelsPerCm,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // --- Helpers --------------------------------------------------------------

  void _updateWeightFromOffset(double offset) {
    final kg = widget.minWeightKg + offset / _pixelsPerCm;
    final clamped = kg.clamp(widget.minWeightKg, widget.maxWeightKg);

    if (clamped == _weightKg) return;

    setState(() {
      _weightKg = clamped;
    });
    widget.onChanged?.call(_weightKg, _unit);
  }

  String get _formattedValue {
    switch (_unit) {
      case WeightUnit.kg:
        return '${_weightKg.round()}kg';
      case WeightUnit.lbs:
        final totalPounds = _weightKg * 2.20462;
        return '${totalPounds.round()} lbs';
      case WeightUnit.stone:
        final totalPounds = _weightKg * 2.20462;
        final rounded = totalPounds.round();
        final stones = rounded ~/ 14;
        final pounds = rounded % 14;
        return "$stones st $pounds lbs";
    }
  }

  void _setUnit(WeightUnit unit) {
    if (_unit == unit) return;
    setState(() {
      _unit = unit;
    });
    // 3. Also notify the parent when the unit changes.
    widget.onChanged?.call(_weightKg, _unit);
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
                  (widget.maxWeightKg - widget.minWeightKg) * _pixelsPerCm;

              return Stack(
                alignment: Alignment.center,
                children: [
                  NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification.metrics.axis != Axis.horizontal) {
                        return false;
                      }

                      if (notification is ScrollUpdateNotification) {
                        _updateWeightFromOffset(notification.metrics.pixels);
                      } else if (notification is ScrollEndNotification) {
                        // snap to nearest cm
                        final offset = _scrollController.offset;
                        final maxIndex =
                            (widget.maxWeightKg - widget.minWeightKg).round();
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
                        painter: WeightRulerPainter(
                          minValue: widget.minWeightKg,
                          maxValue: widget.maxWeightKg,
                          pixelsPerCm: _pixelsPerCm,
                          padding: padding,
                          unit: _unit,
                          majorTickColor: colorScheme.onSurface,
                          minorTickColor: colorScheme.onSurface.withAlpha(128),
                          labelColor: colorScheme.onSurface.withAlpha(179),
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

    Widget tab(String label, WeightUnit unit) {
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
        Expanded(child: tab('kg', WeightUnit.kg)),
        12.width,
        Expanded(child: tab('lbs', WeightUnit.lbs)),
        12.width,
        Expanded(child: tab('stone', WeightUnit.stone)),
      ],
    );
  }

  Widget _buildMinMaxRow() {
    final labelColor = Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: 0.7);
    final minText = _unit == WeightUnit.kg
        ? 'Min weight: ${widget.minWeightKg.toInt()} kg'
    // Corrected conversion from division to multiplication
        : 'Min weight: ${(widget.minWeightKg * 2.20462).round()} lbs';

    final maxText = _unit == WeightUnit.kg
        ? 'Max weight: ${widget.maxWeightKg.toInt()} kg'
    // Corrected conversion from division to multiplication
        : 'Max weight: ${(widget.maxWeightKg * 2.20462).round()} lbs';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(minText, style: TextStyle(color: labelColor, fontSize: 12)),
        Text(maxText, style: TextStyle(color: labelColor, fontSize: 12)),
      ],
    );
  }
}

class WeightRulerPainter extends CustomPainter {
  final double minValue;
  final double maxValue;
  final double pixelsPerCm;
  final double padding;
  final WeightUnit unit;
  final Color majorTickColor;
  final Color minorTickColor;
  final Color labelColor;

  WeightRulerPainter({
    required this.minValue,
    required this.maxValue,
    required this.pixelsPerCm,
    required this.padding,
    required this.unit,
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
      final double valueKg = minValue + i;

      final bool isMajorTick = valueKg % 10 == 0;
      final bool isMediumTick = !isMajorTick && valueKg % 5 == 0;

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
        String label;
        if (unit == WeightUnit.kg) {
          label = valueKg.toInt().toString();
        } else if (unit == WeightUnit.lbs) {
          final lbs = (valueKg * 2.20462).round();
          label = lbs.toString();
        } else {
          // stone
          final totalLbs = valueKg * 2.20462;
          final st = totalLbs ~/ 14;
          final lbs = (totalLbs - st * 14).round();
          label = '${st}st$lbs';
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
  bool shouldRepaint(covariant WeightRulerPainter oldDelegate) {
    return oldDelegate.unit != unit ||
        oldDelegate.minValue != minValue ||
        oldDelegate.maxValue != maxValue ||
        oldDelegate.pixelsPerCm != pixelsPerCm ||
        oldDelegate.padding != padding ||
        oldDelegate.majorTickColor != majorTickColor ||
        oldDelegate.minorTickColor != minorTickColor ||
        oldDelegate.labelColor != labelColor;
  }
}
