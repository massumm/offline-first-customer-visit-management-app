import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ChatRoomShimmer extends StatefulWidget {
  const ChatRoomShimmer({
    super.key,
    // required this.controller,
  });

  // final ChatController controller;

  @override
  State<ChatRoomShimmer> createState() => _ChatRoomShimmerState();
}

class _ChatRoomShimmerState extends State<ChatRoomShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final int _itemCount = 20; // Number of shimmer items
  final Duration _itemAnimationDuration =
  const Duration(milliseconds: 375); // Duration for each item's animation
  final Duration _delayBetweenItems =
  const Duration(milliseconds: 75); // Stagger delay

  @override
  void initState() {
    super.initState();
    // Calculate total duration for the controller to accommodate all staggered animations
    final totalDuration = Duration(
      milliseconds: (_itemCount - 1) * _delayBetweenItems.inMilliseconds +
          _itemAnimationDuration.inMilliseconds,
    );

    _animationController = AnimationController(
      vsync: this,
      duration: totalDuration,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildAnimatedItem(BuildContext context, int index) {
    final bool isLeftAlign = index % 2 == 0;

    final double animationStartPercent =
        (index * _delayBetweenItems.inMilliseconds) /
            _animationController.duration!.inMilliseconds;
    final double animationEndPercent = animationStartPercent +
        (_itemAnimationDuration.inMilliseconds /
            _animationController.duration!.inMilliseconds);

    // Ensure the interval values are clamped between 0.0 and 1.0
    final Interval animationInterval = Interval(
      animationStartPercent.clamp(0.0, 1.0),
      animationEndPercent.clamp(0.0, 1.0),
      curve: Curves.easeOut,
    );

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.5),
        end: Offset.zero,
      ).animate(CurvedAnimation(
          parent: _animationController, curve: animationInterval)),
      child: FadeTransition(
        opacity: CurvedAnimation(
            parent: _animationController, curve: animationInterval),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 4.0,
            horizontal: 8,
          ),
          child: Align(
            alignment: isLeftAlign ? Alignment.topLeft : Alignment.topRight,
            child: CustomPaint(
              painter: ChatBubble(
                color: Colors.grey.shade300, // Base for the shimmer
                alignment: isLeftAlign ? Alignment.topLeft : Alignment.topRight,
              ),
              child: _ShimmerMessageContent(
                isShort: index % 3 == 0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      period: const Duration(milliseconds: 1500),
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      enabled: true,
      child: ListView.builder(
        reverse: true,
        itemCount: _itemCount,
        itemBuilder: (context, index) => _buildAnimatedItem(context, index),
      ),
    );
  }
}

class _ShimmerMessageContent extends StatelessWidget {
  final bool isShort;

  const _ShimmerMessageContent({required this.isShort});

  @override
  Widget build(BuildContext context) {
    final placeholderColor = Colors.white.withValues(alpha: 0.6);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 10.0,
            width: isShort ? 60.0 : 120.0,
            decoration: BoxDecoration(
              color: placeholderColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(height: 6.0),
          Container(
            height: 10.0,
            width: isShort ? 90.0 : 80.0,
            decoration: BoxDecoration(
              color: placeholderColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends CustomPainter {
  final Color color;
  final Alignment alignment;

  ChatBubble({required this.color, required this.alignment});

  final _radius = 10.0;
  final _x = 10.0;
  final _shadowColor = Colors.black12; // Shadow color

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = _shadowColor
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3.0);

    RRect bubbleRRect;

    if (alignment == Alignment.topRight) {
      bubbleRRect = RRect.fromLTRBAndCorners(
        0,
        0,
        size.width - 8,
        size.height,
        bottomLeft: Radius.circular(_radius),
        topRight: Radius.circular(_radius),
        topLeft: Radius.circular(_radius),
      );

      // Draw shadow first
      canvas.drawRRect(bubbleRRect.shift(Offset(2, 2)), shadowPaint);

      // Draw the bubble
      canvas.drawRRect(bubbleRRect, paint);

      var path = Path();
      path.moveTo(size.width - _x, size.height - 20);
      path.lineTo(size.width - _x, size.height);
      path.lineTo(size.width, size.height);
      canvas.clipPath(path);
      canvas.drawRRect(
        RRect.fromLTRBAndCorners(
          size.width - _x,
          0.0,
          size.width,
          size.height,
          topRight: Radius.circular(_radius),
        ),
        paint,
      );
    } else {
      bubbleRRect = RRect.fromLTRBAndCorners(
        _x,
        0,
        size.width - 8,
        size.height,
        bottomRight: Radius.circular(_radius),
        topRight: Radius.circular(_radius),
        topLeft: Radius.circular(_radius),
      );

      // Draw shadow first
      canvas.drawRRect(bubbleRRect.shift(Offset(2, 2)), shadowPaint);

      // Draw the bubble
      canvas.drawRRect(bubbleRRect, paint);

      var path = Path();
      path.moveTo(0, size.height);
      path.lineTo(_x, size.height);
      path.lineTo(_x, size.height - 20);
      canvas.clipPath(path);
      canvas.drawRRect(
        RRect.fromLTRBAndCorners(
          0,
          0.0,
          _x,
          size.height,
          topRight: Radius.circular(_radius),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}



