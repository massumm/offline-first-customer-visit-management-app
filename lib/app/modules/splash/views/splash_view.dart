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
    return const Scaffold(
      backgroundColor: Colors.white,
      body: _AnimatedSplashBody(),
    );
  }
}

class _AnimatedSplashBody extends StatefulWidget {
  const _AnimatedSplashBody();

  @override
  __AnimatedSplashBodyState createState() => __AnimatedSplashBodyState();
}

class __AnimatedSplashBodyState extends State<_AnimatedSplashBody>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _logoFadeInAnim;
  late final Animation<double> _backgroundAndLogoColorAnim;
  late final Animation<double> _uiElementsAnim;
  late final Animation<Offset> _uiSlideAnim;
  late final Animation<Color?> _logoColorTween;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3500),
      vsync: this,
    );

    _logoFadeInAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.28, curve: Curves.easeOut),
      ),
    );


    _backgroundAndLogoColorAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.28, 0.71, curve: Curves.easeInOut),
      ),
    );
    _logoColorTween = ColorTween(
      begin: Colors.transparent,
      end: Colors.white,
    ).animate(_backgroundAndLogoColorAnim);


    final uiCurve = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.71, 1.0, curve: Curves.easeOutCubic),
    );
    _uiElementsAnim = Tween<double>(begin: 0.0, end: 1.0).animate(uiCurve);
    _uiSlideAnim = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(uiCurve);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FadeTransition(
          opacity: _backgroundAndLogoColorAnim,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.colorPrimary, const Color(0xffFF8869)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),

        // The main content
        SafeArea(
          child: Column(
            children: [
              // FadeTransition(
              //   opacity: _uiElementsAnim,
              //   child: Align(
              //     alignment: Alignment.centerRight,
              //     child: TrainerBadgeWithPopup(),
              //   ),
              // ),

              Expanded(
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          final opacity = _logoFadeInAnim.value * (1.0 - _backgroundAndLogoColorAnim.value);
                          return Opacity(
                            opacity: opacity.clamp(0.0, 1.0),
                            child: SuperImage(Assets.svgLogo),
                          );
                        },
                      ),

                      FadeTransition(
                        opacity: _backgroundAndLogoColorAnim,
                        child: AnimatedBuilder(
                          animation: _logoColorTween,
                          builder: (context, child) {
                            return ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                _logoColorTween.value ?? Colors.transparent,
                                BlendMode.srcATop,
                              ),
                              child: child,
                            );
                          },
                          child: SuperImage(Assets.svgAppIconWhite),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom UI Elements
              FadeTransition(
                opacity: _uiElementsAnim,
                child: SlideTransition(
                  position: _uiSlideAnim,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 32.0,
                      left: 16.0,
                      right: 16.0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () => Get.toNamed(Routes.ONBOARDING),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: const Text('Begin',
                              style: TextStyle(color: Colors.black)),
                        ),
                        8.height,
                        Text.rich(
                          TextSpan(
                            text: 'Have an account? ',
                            style: const TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: 'Login',
                                style: const TextStyle(
                                  color: Colors.white,
                                  decorationColor: Colors.white,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => Get.toNamed(Routes.LOGIN),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

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

class _TrainerBadgeWithPopupState extends State<TrainerBadgeWithPopup>
    with SingleTickerProviderStateMixin {
  final LayerLink _link = LayerLink();
  OverlayEntry? _entry;
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  void _show() {
    if (_entry != null) return;

    final overlay = Overlay.of(context);

    _entry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
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
              targetAnchor: Alignment.bottomRight,
              followerAnchor: Alignment.topRight,
              offset: const Offset(0, 8),
              showWhenUnlinked: false,
              child: FadeTransition(
                opacity: _animationController,
                child: ScaleTransition(
                  alignment: Alignment.topRight,
                  scale: CurvedAnimation(
                    parent: _animationController,
                    curve: Curves.easeOutBack,
                  ),
                  child: _SpeechBubbleCard(
                    title: widget.title,
                    body: widget.body,
                    onClose: _hide,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    overlay.insert(_entry!);
    _animationController.forward();
  }

  void _hide() {
    _animationController.reverse().then((_) {
      _entry?.remove();
      _entry = null;
    });
  }

  @override
  void dispose() {
    // Ensure the overlay entry is removed if the widget is disposed.
    if (_entry != null) {
      _entry?.remove();
    }
    _animationController.dispose();
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

    canvas.drawShadow(path, Colors.black.withValues(alpha: 0.2), 3, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _BubbleTailPainter oldDelegate) =>
      oldDelegate.color != color;
}
