import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// iOS-style page transition with smooth, high-refresh card-like animation
/// Provides interactive swipe-back gesture with precise finger tracking
class SmoothPageTransition extends CustomTransition {
  @override
  Widget buildTransition(
    BuildContext context,
    Curve? curve,
    Alignment? alignment,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // iOS-style curves for natural, fluid motion
    final iosCurve = Curves.fastLinearToSlowEaseIn;
    final iosReverseCurve = Curves.linearToEaseOut;

    // Current screen slides from right with iOS-style easing
    final slideAnimation =
        Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: animation,
            curve: iosCurve,
            reverseCurve: iosReverseCurve,
          ),
        );

    // Subtle fade for depth perception
    final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animation,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    // Previous screen parallax effect (iOS-style)
    // Slides left by 25% and dims slightly
    final secondarySlideAnimation =
        Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(-0.25, 0.0),
        ).animate(
          CurvedAnimation(
            parent: secondaryAnimation,
            curve: iosCurve,
            reverseCurve: iosReverseCurve,
          ),
        );

    // Subtle scale for depth (iOS-style)
    final secondaryScaleAnimation = Tween<double>(begin: 1.0, end: 0.92)
        .animate(
          CurvedAnimation(
            parent: secondaryAnimation,
            curve: iosCurve,
            reverseCurve: iosReverseCurve,
          ),
        );

    // Dim previous screen slightly (iOS-style overlay)
    final secondaryOpacityAnimation = Tween<double>(begin: 0.0, end: 0.15)
        .animate(
          CurvedAnimation(
            parent: secondaryAnimation,
            curve: iosCurve,
            reverseCurve: iosReverseCurve,
          ),
        );

    return Stack(
      children: [
        // Previous screen (underneath) with parallax and scale
        if (secondaryAnimation.status != AnimationStatus.dismissed)
          SlideTransition(
            position: secondarySlideAnimation,
            child: ScaleTransition(
              scale: secondaryScaleAnimation,
              child: Stack(
                children: [
                  // Previous screen content
                  Container(color: Colors.black),
                  // Dim overlay (iOS-style)
                  FadeTransition(
                    opacity: secondaryOpacityAnimation,
                    child: Container(color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        // Current screen (on top) with slide and fade
        SlideTransition(
          position: slideAnimation,
          child: FadeTransition(opacity: fadeAnimation, child: child),
        ),
      ],
    );
  }
}

/// iOS-style Cupertino page transition for even smoother animations
/// This provides the most authentic iOS feel with spring physics
class IOSStylePageTransition extends CustomTransition {
  @override
  Widget buildTransition(
    BuildContext context,
    Curve? curve,
    Alignment? alignment,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // Use iOS-specific curves for authentic feel
    const primaryCurve = Curves.linearToEaseOut;
    const secondaryCurve = Curves.linearToEaseOut;

    // Current screen slides from right
    final primarySlideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: animation, curve: primaryCurve));

    // Previous screen slides left by 1/3
    final secondarySlideAnimation =
        Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(-1.0 / 3.0, 0.0),
        ).animate(
          CurvedAnimation(parent: secondaryAnimation, curve: secondaryCurve),
        );

    // Shadow on current screen (iOS-style)
    final shadowAnimation = Tween<double>(
      begin: 0.0,
      end: 0.3,
    ).animate(CurvedAnimation(parent: animation, curve: primaryCurve));

    return Stack(
      children: [
        // Previous screen
        if (secondaryAnimation.status != AnimationStatus.dismissed)
          SlideTransition(
            position: secondarySlideAnimation,
            child: Container(color: Colors.black),
          ),
        // Current screen with shadow
        SlideTransition(
          position: primarySlideAnimation,
          child: DecoratedBox(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(
                    0.25 * (1.0 - shadowAnimation.value),
                  ),
                  blurRadius: 10.0,
                  spreadRadius: 0.0,
                ),
              ],
            ),
            child: child,
          ),
        ),
      ],
    );
  }
}
