import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';
import '../core/theme/theme_helper.dart';
import 'error_state_widget.dart';

class BaseScreenWrapper extends StatelessWidget {
  final Widget child;
  final bool requiresAuth;
  final bool showLoadingOverlay;
  final String? title;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final bool extendBodyBehindAppBar;
  final PreferredSizeWidget? appBar;
  final Widget? drawer;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;

  const BaseScreenWrapper({
    super.key,
    required this.child,
    this.requiresAuth = true,
    this.showLoadingOverlay = false,
    this.title,
    this.actions,
    this.floatingActionButton,
    this.extendBodyBehindAppBar = false,
    this.appBar,
    this.drawer,
    this.bottomNavigationBar,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? context.backgroundColor,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      appBar: appBar ?? (title != null ? _buildDefaultAppBar(context) : null),
      drawer: drawer,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      body: requiresAuth ? _buildAuthenticatedBody() : _buildBody(),
    );
  }

  PreferredSizeWidget _buildDefaultAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(gradient: context.headerGradient),
      ),
      title: Text(
        title!,
        style: TextStyle(
          color: context.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      actions: actions,
      iconTheme: IconThemeData(color: context.textPrimary),
    );
  }

  Widget _buildAuthenticatedBody() {
    return GetBuilder<UserController>(
      init: Get.find<UserController>(),
      builder: (userController) {
        final showInlineError =
            userController.error.isNotEmpty &&
            userController.currentUser == null;

        return Stack(
          children: [
            _buildBody(),
            if (showInlineError)
              Positioned(
                top: 12,
                left: 16,
                right: 16,
                child: InlineErrorWidget(
                  error: userController.error,
                  onRetry: () => userController.refreshUserData(),
                  compact: true,
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [
        // Main content
        child,

        // Loading overlay if requested
        if (showLoadingOverlay)
          GetBuilder<UserController>(
            builder: (userController) {
              if (userController.isLoading) {
                return Container(
                  color: Colors.black.withValues(alpha: 0.3),
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFFC2D86A),
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
      ],
    );
  }
}

// Extension for smooth page transitions
class SmoothPageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final Duration duration;

  SmoothPageRoute({
    required this.child,
    this.duration = const Duration(milliseconds: 300),
  }) : super(
         pageBuilder: (context, animation, secondaryAnimation) => child,
         transitionDuration: duration,
         reverseTransitionDuration: duration,
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           const begin = Offset(1.0, 0.0);
           const end = Offset.zero;
           const curve = Curves.easeInOutCubic;

           var tween = Tween(
             begin: begin,
             end: end,
           ).chain(CurveTween(curve: curve));

           var offsetAnimation = animation.drive(tween);

           return SlideTransition(
             position: offsetAnimation,
             child: FadeTransition(opacity: animation, child: child),
           );
         },
       );
}

// Custom GetX page with smooth transitions
class SmoothGetPage extends GetPage {
  SmoothGetPage({
    required String name,
    required GetPageBuilder page,
    String? title,
    Bindings? binding,
    List<Bindings>? bindings,
    Map<String, String>? parameters,
    bool participatesInRootNavigator = false,
    bool preventDuplicates = true,
    Transition? transition,
    Duration? transitionDuration,
    bool opaque = true,
    bool? popGesture,
    CustomTransition? customTransition,
    List<GetPage>? children,
    List<GetMiddleware>? middlewares,
  }) : super(
         name: name,
         page: page,
         title: title,
         binding: binding,
         bindings: bindings ?? [],
         parameters: parameters,
         participatesInRootNavigator: participatesInRootNavigator,
         preventDuplicates: preventDuplicates,
         transition: transition ?? Transition.rightToLeftWithFade,
         transitionDuration:
             transitionDuration ?? const Duration(milliseconds: 300),
         opaque: opaque,
         popGesture: popGesture,
         customTransition: customTransition,
         children: children ?? [],
         middlewares: middlewares,
       );
}
