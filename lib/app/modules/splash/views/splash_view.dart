import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import '../../../../generated/assets.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/widgets/super_image.dart';
import '../../../routes/app_pages.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.colorPrimary,
        elevation: 0,
        surfaceTintColor: AppColors.colorPrimary,
        actions: [
          TrainerBadgeWithPopup(),
        ],
      ),
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.colorPrimary, Color(0xffFF8869)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(),
                Center(child: SuperImage(Assets.imagesIconLogo)),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 32.0,
                    left: 16.0,
                    right: 16.0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Get.toNamed(Routes.ONBOARDING);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Text('Begin',
                            style: TextStyle(color: Colors.black)),
                      ),
                      8.height,
                      Text.rich(
                        TextSpan(
                          text: 'Have an account? ',
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text: 'Login',
                              style: TextStyle(
                                color: Colors.white,
                                decorationColor: Colors.white,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.toNamed(Routes.LOGIN);
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Positioned(
            //   top: 8,
            //   right: 12,
            //   child: ,
            // ),
          ],
        ),
      ),
    );
  }
}

/// Small “Trainer?” pill that reveals a speech-bubble popup using an Overlay.
/// Uses CompositedTransformTarget/Follower so the bubble stays anchored even
/// when the layout changes.
class TrainerBadgeWithPopup extends StatefulWidget {
  const TrainerBadgeWithPopup({
    super.key,
    this.buttonLabel = 'Trainer?',
    this.title = 'Trainer Setup',
    this.body =
    'Create a user account, submit a trainer application via the profile section',
  });

  final String buttonLabel;
  final String title;
  final String body;

  @override
  State<TrainerBadgeWithPopup> createState() => _TrainerBadgeWithPopupState();
}

class _TrainerBadgeWithPopupState extends State<TrainerBadgeWithPopup> {
  final LayerLink _link = LayerLink();
  OverlayEntry? _entry;

  void _show() {
    if (_entry != null) return;

    final overlay = Overlay.of(context);

    _entry = OverlayEntry(
      builder: (context) {
        // Full-screen Stack to allow a tap-outside barrier
        return Stack(
          children: [
            // Tap outside to close
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _hide,
                child: const SizedBox.shrink(),
              ),
            ),
            // The anchored bubble
            CompositedTransformFollower(
              link: _link,
              // Use anchors for robust positioning instead of a hardcoded offset.
              // This aligns the top-right of the popup to the bottom-right
              // of the "Trainer?" button.
              targetAnchor: Alignment.bottomRight,
              followerAnchor: Alignment.topRight,
              offset: const Offset(0, 8), // Add some space below the button
              showWhenUnlinked: false,
              child: _SpeechBubbleCard(
                title: widget.title,
                body: widget.body,
                onClose: _hide,
              ),
            ),
          ],
        );
      },
    );

    overlay.insert(_entry!);
  }

  void _hide() {
    _entry?.remove();
    _entry = null;
  }

  @override
  void dispose() {
    _hide();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _link,
      child: TextButton(
        onPressed: _show,
        child: Text(
          widget.buttonLabel,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }
}

/// White rounded card with a small pointer tail (speech bubble look).
class _SpeechBubbleCard extends StatelessWidget {
  const _SpeechBubbleCard({
    required this.title,
    required this.body,
    required this.onClose,
  });

  final String title;
  final String body;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    // Card size similar to the screenshot
    const double width = 260;
    const double tailSize = 10;

    return Material(
      color: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Bubble body
          Container(
            width: width,
            height: 120,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          )),
                      const SizedBox(height: 6),
                      Text(
                        body,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.35,
                          color: Colors.black.withValues(alpha: 0.75),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Optional close icon
                InkWell(
                  onTap: onClose,
                  child: const Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Icon(Icons.close, size: 18, color: Colors.black54),
                  ),
                ),
              ],
            ),
          ),

          // Little tail pointing up-right towards the badge
          Positioned(
            right: 18,
            top: -tailSize + 1,
            child: CustomPaint(
              size: const Size(tailSize * 2, tailSize),
              painter: _BubbleTailPainter(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

/// Draws a small triangular tail that aligns with the card’s top edge.
class _BubbleTailPainter extends CustomPainter {
  _BubbleTailPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width, size.height) // right-bottom
      ..lineTo(size.width * 0.45, 0) // tip (top)
      ..lineTo(0, size.height) // left-bottom
      ..close();

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // soft shadow under the tail for depth
    canvas.drawShadow(path, Colors.black.withValues(alpha: 0.2), 3, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _BubbleTailPainter oldDelegate) =>
      oldDelegate.color != color;
}