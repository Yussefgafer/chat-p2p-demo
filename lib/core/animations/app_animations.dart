import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Collection of app-wide animations and transitions
class AppAnimations {
  // Animation durations
  static const Duration fastAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration slowAnimation = Duration(milliseconds: 500);
  static const Duration splashDuration = Duration(milliseconds: 2000);

  // Animation curves
  static const defaultCurve = Curves.easeInOut;
  static const bounceCurve = Curves.bounceOut;
  static const elasticCurve = Curves.elasticOut;

  /// Fade transition animation
  static Widget fadeTransition({
    required Widget child,
    required Animation<double> animation,
    Duration duration = mediumAnimation,
  }) {
    return FadeTransition(opacity: animation, child: child);
  }

  /// Slide transition from bottom
  static Widget slideFromBottom({
    required Widget child,
    required Animation<double> animation,
  }) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: defaultCurve)),
      child: child,
    );
  }

  /// Slide transition from right
  static Widget slideFromRight({
    required Widget child,
    required Animation<double> animation,
  }) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: defaultCurve)),
      child: child,
    );
  }

  /// Scale transition animation
  static Widget scaleTransition({
    required Widget child,
    required Animation<double> animation,
  }) {
    return ScaleTransition(
      scale: CurvedAnimation(parent: animation, curve: elasticCurve),
      child: child,
    );
  }

  /// Rotation transition animation
  static Widget rotationTransition({
    required Widget child,
    required Animation<double> animation,
  }) {
    return RotationTransition(turns: animation, child: child);
  }

  /// Combined fade and scale transition
  static Widget fadeScaleTransition({
    required Widget child,
    required Animation<double> animation,
  }) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: Tween<double>(
          begin: 0.8,
          end: 1.0,
        ).animate(CurvedAnimation(parent: animation, curve: defaultCurve)),
        child: child,
      ),
    );
  }

  /// Staggered list animation
  static Widget staggeredListAnimation({
    required Widget child,
    required int index,
    required Animation<double> animation,
  }) {
    final delay = index * 0.1;

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final animationValue = Curves.easeOut.transform(
          (animation.value - delay).clamp(0.0, 1.0),
        );

        return Transform.translate(
          offset: Offset(0, 50 * (1 - animationValue)),
          child: Opacity(opacity: animationValue, child: child),
        );
      },
      child: child,
    );
  }

  /// Shimmer loading animation
  static Widget shimmerAnimation({
    required Widget child,
    required Animation<double> animation,
  }) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: const [
                Colors.transparent,
                Colors.white54,
                Colors.transparent,
              ],
              stops: [
                animation.value - 0.3,
                animation.value,
                animation.value + 0.3,
              ].map((stop) => stop.clamp(0.0, 1.0)).toList(),
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: child,
    );
  }

  /// Pulse animation for buttons
  static Widget pulseAnimation({
    required Widget child,
    required Animation<double> animation,
  }) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (animation.value * 0.1),
          child: child,
        );
      },
      child: child,
    );
  }

  /// Typing indicator animation
  static Widget typingIndicator({
    required Animation<double> animation,
    Color color = Colors.grey,
  }) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            final delay = index * 0.2;
            final animationValue = ((animation.value - delay) % 1.0).clamp(
              0.0,
              1.0,
            );

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              child: Transform.translate(
                offset: Offset(
                  0,
                  -10 * Curves.easeInOut.transform(animationValue),
                ),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  /// Progress wave animation
  static Widget progressWave({
    required Animation<double> animation,
    required double progress,
    Color color = Colors.blue,
  }) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return CustomPaint(
          painter: WaveProgressPainter(
            progress: progress,
            waveAnimation: animation.value,
            color: color,
          ),
          child: child,
        );
      },
    );
  }

  /// Page transition builder
  static Widget pageTransition({
    required BuildContext context,
    required Animation<double> animation,
    required Animation<double> secondaryAnimation,
    required Widget child,
    PageTransitionType type = PageTransitionType.slideFromRight,
  }) {
    switch (type) {
      case PageTransitionType.fade:
        return fadeTransition(child: child, animation: animation);
      case PageTransitionType.slideFromBottom:
        return slideFromBottom(child: child, animation: animation);
      case PageTransitionType.slideFromRight:
        return slideFromRight(child: child, animation: animation);
      case PageTransitionType.scale:
        return scaleTransition(child: child, animation: animation);
      case PageTransitionType.fadeScale:
        return fadeScaleTransition(child: child, animation: animation);
    }
  }
}

/// Page transition types
enum PageTransitionType {
  fade,
  slideFromBottom,
  slideFromRight,
  scale,
  fadeScale,
}

/// Custom wave progress painter
class WaveProgressPainter extends CustomPainter {
  final double progress;
  final double waveAnimation;
  final Color color;

  WaveProgressPainter({
    required this.progress,
    required this.waveAnimation,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final waveHeight = size.height * 0.1;
    final progressWidth = size.width * progress;

    path.moveTo(0, size.height);

    for (double x = 0; x <= progressWidth; x += 1) {
      final y =
          size.height -
          (size.height * progress) +
          waveHeight *
              math.sin(
                (x / size.width * 4 * math.pi) + (waveAnimation * 2 * math.pi),
              );
      path.lineTo(x, y);
    }

    path.lineTo(progressWidth, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Animation controller mixin for easy management
mixin AnimationControllerMixin<T extends StatefulWidget>
    on State<T>, TickerProviderStateMixin<T> {
  late AnimationController _primaryController;
  late AnimationController _secondaryController;

  AnimationController get primaryController => _primaryController;
  AnimationController get secondaryController => _secondaryController;

  @override
  void initState() {
    super.initState();
    _primaryController = AnimationController(
      duration: AppAnimations.mediumAnimation,
      vsync: this,
    );
    _secondaryController = AnimationController(
      duration: AppAnimations.fastAnimation,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _primaryController.dispose();
    _secondaryController.dispose();
    super.dispose();
  }

  void startPrimaryAnimation() => _primaryController.forward();
  void reversePrimaryAnimation() => _primaryController.reverse();
  void resetPrimaryAnimation() => _primaryController.reset();

  void startSecondaryAnimation() => _secondaryController.forward();
  void reverseSecondaryAnimation() => _secondaryController.reverse();
  void resetSecondaryAnimation() => _secondaryController.reset();
}
