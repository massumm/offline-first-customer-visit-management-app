import 'dart:math';

import 'package:flutter/material.dart';

class SingleGradientStackCircularProgressBar extends StatefulWidget {
  /// Size of circle
  final double size;

  /// start circle progress point
  final double startAngle;

  /// max progress value
  final double maxValue;

  /// Progress line thickness.
  final double progressStrokeWidth;

  /// padding between  bars
  final double strokeSpacePadding;

  /// Background circle line thickness.
  final double backStrokeWidth;

  /// Backgound color
  final Color backColor;

  ///progress color
  final List<Color> barColores;

  ///progress value
  final double barValue;

  /// Animate pogress time
  final Duration animationDuration;

  /// progress done color
  final Color fullProgressColor;

  /// If is true then single color will applied after progress done
  final bool mergeMode;

  /// middel text show hide
  final bool isTextShow;

  ///TextStyle of middle text
  final TextStyle textStyle;

  const SingleGradientStackCircularProgressBar({
    Key? key,
    this.size = 100,
    this.startAngle = 0,
    this.barValue = 55,
    this.isTextShow = true,
    this.textStyle = const TextStyle(color: Colors.black, fontSize: 20),
    this.maxValue = 100,
    this.fullProgressColor = Colors.blue,
    this.barColores = const [Colors.red, Colors.blue],
    this.progressStrokeWidth = 15,
    this.strokeSpacePadding = 10,
    this.backStrokeWidth = 15,
    this.backColor = const Color(0xFF16262D),
    this.animationDuration = const Duration(seconds: 3),
    this.mergeMode = false,
  }) : super(key: key);

  @override
  _SingleGradientStackCircularProgressBarState createState() =>
      _SingleGradientStackCircularProgressBarState();
}

class _SingleGradientStackCircularProgressBarState
    extends State<SingleGradientStackCircularProgressBar>
    with TickerProviderStateMixin {
  final double minSweepAngle = 0.015;
  late double circleLength;
  late double widgetSize;
  late double startAngle;
  late double correctAngle;
  late SweepGradient sweepGradient;
  late AnimationController animationController;
  late ValueNotifier<double> valueNotifier;

  /// root of widget
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: _circular(),
    );
  }

  //update widget
  @override
  void didUpdateWidget(
    covariant SingleGradientStackCircularProgressBar oldWidget,
  ) {
    _disposeAnim();
    _initController();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _disposeAnim();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initController();
  }

  //return main circle widget
  Widget _circular() {
    return ValueListenableBuilder(
      valueListenable: valueNotifier,
      builder: (BuildContext context, double value, Widget? child) {
        if (value > widget.maxValue) {
          value = widget.maxValue;
        } else if (value < 0) {
          value = 0;
        }
        if (value < animationController.value) {
          animationController.forward();
        } else {
          animationController.animateTo(value);
        }
        return AnimatedBuilder(
          animation: animationController,
          builder: (context, snapshot) {
            if ((value != animationController.upperBound) &&
                (animationController.value >= animationController.upperBound)) {
              animationController.reset();
              animationController.animateTo(value);
            }
            double sweepAngle;
            final reducedValue = animationController.value / widget.maxValue;
            if (animationController.value == 0) {
              sweepAngle = 0;
            } else {
              sweepAngle = (doublePi * reducedValue) - correctAngle;

              if (sweepAngle <= 0) {
                sweepAngle = minSweepAngle;
              }
            }
            final currentLength = reducedValue * circleLength;
            final isFullProgress =
                widget.mergeMode &
                (animationController.value == animationController.upperBound);
            return Stack(
              alignment: Alignment.center,
              children: [
                Transform.rotate(
                  angle: degToRad(widget.startAngle - 90),
                  child: CustomPaint(
                    size: Size(widgetSize, widgetSize),
                    painter: GradientCircularProgressBarPainter(
                      progressStrokeWidth: widget.progressStrokeWidth,
                      backStrokeWidth: widget.backStrokeWidth,
                      startAngle: startAngle,
                      sweepAngle: sweepAngle,
                      currentLength: currentLength,
                      frontGradient: sweepGradient,
                      backColor: widget.backColor,
                      fullProgressColor: widget.fullProgressColor,
                      isFullProgress: isFullProgress,
                    ),
                  ),
                ),
                widget.isTextShow
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${animationController.value.round()} %",
                            style: widget.textStyle.copyWith(
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            'Complete',
                            style: TextStyle(
                              color: const Color(0xFF5A5A5A),
                              fontSize: 12,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(),
              ],
            );
          },
        );
      },
    );
  }

  /// dispose animation
  void _disposeAnim() {
    animationController.dispose();
  }

  /// called it in init
  /// initialize animation controller
  /// fill sweep gradient
  /// initialize valueNotifier
  void _initController() {
    animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
      value: 0.0,
      upperBound: widget.maxValue,
    );
    sweepGradient = SweepGradient(
      tileMode: TileMode.decal,
      colors: widget.barColores,
    );
    valueNotifier = ValueNotifier(widget.barValue);

    widgetSize = (widget.size <= 0) ? 100.0 : widget.size;
    circleLength = pi * widgetSize;
    final k = doublePi / circleLength;
    correctAngle = widget.progressStrokeWidth * k;
    startAngle = (correctAngle / 2);
  }
}

/// Painter to draw the progress bar.
class GradientCircularProgressBarPainter extends CustomPainter {
  /// Progress line thickness.
  final double progressStrokeWidth;

  /// Background circle line thickness.
  final double backStrokeWidth;

  /// Start angle. In this position there will be a zero value.
  final double startAngle;
  final double sweepAngle;
  final double currentLength;

  /// Foreground gradient sweep
  final SweepGradient frontGradient;

  /// Background circle line Color
  final Color backColor;

  /// It's color applied after progress done
  final Color fullProgressColor;

  /// Single color appiled() if it's true
  final bool isFullProgress;

  GradientCircularProgressBarPainter({
    required this.progressStrokeWidth,
    required this.backStrokeWidth,
    required this.startAngle,
    required this.sweepAngle,
    required this.currentLength,
    required this.frontGradient,
    required this.backColor,
    required this.fullProgressColor,
    required this.isFullProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (isFullProgress && (progressStrokeWidth > 0)) {
      _drawFullProgress(canvas, size);
      return;
    }

    if (backStrokeWidth > 0) {
      _drawBack(canvas, size);
    }

    if (progressStrokeWidth <= 0) {
      return;
    } else if (progressStrokeWidth >= currentLength) {
      _drawLessArcPart(canvas, size);
    } else {
      _drawArcPart(canvas, size);
    }
  }

  @override
  bool shouldRepaint(GradientCircularProgressBarPainter oldDelegate) {
    return oldDelegate.currentLength != currentLength;
  }

  /// Draw main arc (~ 1% - 100%).
  void _drawArcPart(Canvas canvas, Size size) {
    final Rect arcRect = Offset.zero & size;

    final Paint arcPaint = Paint()
      ..shader = frontGradient.createShader(arcRect)
      ..strokeWidth = progressStrokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawArc(arcRect, startAngle, sweepAngle, false, arcPaint);
  }

  /// Draw background circle for progress bar
  void _drawBack(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = backColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = backStrokeWidth;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2, paint);
  }

  void _drawFullProgress(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = fullProgressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = progressStrokeWidth;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2, paint);
  }

  void _drawLessArcPart(Canvas canvas, Size size) {
    double angle = 0;
    double height = 0;

    if (currentLength < progressStrokeWidth / 2) {
      angle = 180;
      height = progressStrokeWidth - currentLength * 2;
    } else if (currentLength < progressStrokeWidth) {
      angle = 0;
      height = currentLength * 2 - progressStrokeWidth;
    } else {
      return;
    }

    final Paint pathPaint = Paint()
      ..shader = frontGradient.createShader(Offset.zero & size)
      ..style = PaintingStyle.fill;

    final Offset circleOffset = Offset(
      (size.width / 2) * cos(startAngle) + size.center(Offset.zero).dx,
      (size.width / 2) * sin(startAngle) + size.center(Offset.zero).dy,
    );

    canvas.drawPath(
      Path.combine(
        PathOperation.xor,
        Path()..addArc(
          Rect.fromLTWH(
            circleOffset.dx - progressStrokeWidth / 2,
            circleOffset.dy - progressStrokeWidth / 2,
            progressStrokeWidth,
            progressStrokeWidth,
          ),
          degToRad(180),
          degToRad(180),
        ),
        Path()..addArc(
          Rect.fromCenter(
            center: circleOffset,
            width: progressStrokeWidth,
            height: height,
          ),
          degToRad(angle),
          degToRad(180),
        ),
      ),
      pathPaint,
    );
  }
}

const double doublePi = 2 * pi;

const double piDiv180 = pi / 180;

double degToRad(double degree) {
  return degree * piDiv180;
}

// getStrokeSpace count the space between two bars
double getStrokeSpace(index, strokWidth, strokSpace) =>
    ((strokWidth + strokSpace) * index);

// getStrokeValue function return the bar value
double getStrokeValue(double value) => value / 100;

//Sample bar colors
class BarColor {
  static const black = Colors.black;
  static const blue = Colors.blue;
  static const green = Colors.green;
  static const purple = Colors.purple;
  static const red = Colors.red;
  static const white = Colors.white;
  static const yellow = Colors.yellow;
}
