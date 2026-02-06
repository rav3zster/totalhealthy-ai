import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

/// Custom page route that provides interactive swipe-back gesture
/// Mimics native Android card-style navigation with edge swipe
class SwipeBackPageRoute<T> extends PageRoute<T> {
  SwipeBackPageRoute({
    required this.builder,
    RouteSettings? settings,
    this.maintainState = true,
    bool fullscreenDialog = false,
  }) : super(settings: settings, fullscreenDialog: fullscreenDialog);

  final WidgetBuilder builder;

  @override
  final bool maintainState;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool canTransitionFrom(TransitionRoute<dynamic> previousRoute) {
    return previousRoute is SwipeBackPageRoute;
  }

  @override
  bool canTransitionTo(TransitionRoute<dynamic> nextRoute) {
    return nextRoute is SwipeBackPageRoute && !nextRoute.fullscreenDialog;
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final result = builder(context);
    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: result,
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return _SwipeBackTransition(
      primaryRouteAnimation: animation,
      secondaryRouteAnimation: secondaryAnimation,
      child: child,
      linearTransition: false,
    );
  }
}

/// Transition widget that handles the swipe-back animation
class _SwipeBackTransition extends StatelessWidget {
  const _SwipeBackTransition({
    required this.primaryRouteAnimation,
    required this.secondaryRouteAnimation,
    required this.child,
    required this.linearTransition,
  });

  final Animation<double> primaryRouteAnimation;
  final Animation<double> secondaryRouteAnimation;
  final Widget child;
  final bool linearTransition;

  @override
  Widget build(BuildContext context) {
    return _SwipeBackGestureDetector(
      enabledCallback: () => _isPopGestureEnabled(context),
      onStartPopGesture: () => _startPopGesture(context),
      child: Stack(
        children: [
          // Previous screen (underneath) - slides in from left and scales up
          if (secondaryRouteAnimation.status != AnimationStatus.dismissed)
            SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(-0.3, 0.0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: secondaryRouteAnimation,
                      curve: Curves.easeOutCubic,
                      reverseCurve: Curves.easeInCubic,
                    ),
                  ),
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.9, end: 1.0).animate(
                  CurvedAnimation(
                    parent: secondaryRouteAnimation,
                    curve: Curves.easeOutCubic,
                    reverseCurve: Curves.easeInCubic,
                  ),
                ),
                child: Container(color: Colors.black),
              ),
            ),
          // Current screen (on top) - slides from right
          SlideTransition(
            position:
                Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: primaryRouteAnimation,
                    curve: Curves.easeOutCubic,
                    reverseCurve: Curves.easeInCubic,
                  ),
                ),
            child: FadeTransition(
              opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: primaryRouteAnimation,
                  curve: const Interval(0.0, 0.3, curve: Curves.easeInOut),
                ),
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  bool _isPopGestureEnabled(BuildContext context) {
    final route = ModalRoute.of(context);
    return route?.canPop ?? false;
  }

  _SwipeBackGestureController _startPopGesture(BuildContext context) {
    return _SwipeBackGestureController(
      navigator: Navigator.of(context),
      controller: ModalRoute.of(context)!.controller!,
    );
  }
}

/// Gesture detector that handles edge swipe for back navigation
class _SwipeBackGestureDetector extends StatefulWidget {
  const _SwipeBackGestureDetector({
    required this.enabledCallback,
    required this.onStartPopGesture,
    required this.child,
  });

  final ValueGetter<bool> enabledCallback;
  final ValueGetter<_SwipeBackGestureController> onStartPopGesture;
  final Widget child;

  @override
  State<_SwipeBackGestureDetector> createState() =>
      _SwipeBackGestureDetectorState();
}

class _SwipeBackGestureDetectorState extends State<_SwipeBackGestureDetector> {
  _SwipeBackGestureController? _backGestureController;
  HorizontalDragGestureRecognizer? _recognizer;

  @override
  void initState() {
    super.initState();
    _recognizer = HorizontalDragGestureRecognizer(debugOwner: this)
      ..onStart = _handleDragStart
      ..onUpdate = _handleDragUpdate
      ..onEnd = _handleDragEnd
      ..onCancel = _handleDragCancel;
  }

  @override
  void dispose() {
    _recognizer?.dispose();
    super.dispose();
  }

  void _handleDragStart(DragStartDetails details) {
    assert(mounted);
    assert(_backGestureController == null);
    _backGestureController = widget.onStartPopGesture();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    assert(mounted);
    assert(_backGestureController != null);
    _backGestureController!.dragUpdate(
      _convertToLogical(details.primaryDelta! / context.size!.width),
    );
  }

  void _handleDragEnd(DragEndDetails details) {
    assert(mounted);
    assert(_backGestureController != null);
    _backGestureController!.dragEnd(
      _convertToLogical(
        details.velocity.pixelsPerSecond.dx / context.size!.width,
      ),
    );
    _backGestureController = null;
  }

  void _handleDragCancel() {
    assert(mounted);
    _backGestureController?.dragEnd(0.0);
    _backGestureController = null;
  }

  double _convertToLogical(double value) {
    switch (Directionality.of(context)) {
      case TextDirection.rtl:
        return -value;
      case TextDirection.ltr:
        return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        widget.child,
        // Edge detection area (left 50 pixels)
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          width: 50,
          child: Listener(
            onPointerDown: (event) {
              if (widget.enabledCallback()) {
                _recognizer!.addPointer(event);
              }
            },
            behavior: HitTestBehavior.translucent,
          ),
        ),
      ],
    );
  }
}

/// Controller that manages the swipe-back gesture animation
class _SwipeBackGestureController {
  _SwipeBackGestureController({
    required this.navigator,
    required this.controller,
  }) {
    navigator.didStartUserGesture();
  }

  final AnimationController controller;
  final NavigatorState navigator;

  void dragUpdate(double delta) {
    controller.value -= delta;
  }

  void dragEnd(double velocity) {
    const double _kMinFlingVelocity = 1.0;
    const double _kBackGestureWidth = 20.0;

    bool animateForward;

    if (velocity.abs() >= _kMinFlingVelocity) {
      animateForward = velocity <= 0;
    } else {
      animateForward = controller.value > 0.5;
    }

    if (animateForward) {
      final droppedPageForwardAnimationTime = min(
        lerpDouble(800, 0, controller.value)!.toInt(),
        300,
      );
      controller.animateTo(
        1.0,
        duration: Duration(milliseconds: droppedPageForwardAnimationTime),
        curve: Curves.easeOutCubic,
      );
    } else {
      navigator.pop();
      if (controller.isAnimating) {
        final droppedPageBackAnimationTime = lerpDouble(
          0,
          800,
          controller.value,
        )!.toInt();
        controller.animateBack(
          0.0,
          duration: Duration(milliseconds: droppedPageBackAnimationTime),
          curve: Curves.easeOutCubic,
        );
      }
    }

    if (controller.isAnimating) {
      late AnimationStatusListener animationStatusCallback;
      animationStatusCallback = (status) {
        navigator.didStopUserGesture();
        controller.removeStatusListener(animationStatusCallback);
      };
      controller.addStatusListener(animationStatusCallback);
    } else {
      navigator.didStopUserGesture();
    }
  }

  double? lerpDouble(num a, num b, double t) {
    return a + (b - a) * t;
  }

  int min(int a, int b) => a < b ? a : b;
}
