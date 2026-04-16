import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../base/controllers/auth_controller.dart';

class AuthCheckMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // Check authentication status
    try {
      final authController = Get.find<AuthController>();
      // Use direct access to the boolean value without reactive subscription
      // since middleware doesn't need reactive updates
      final isAuth = authController.isAuthenticated.value;
      if (!isAuth) {
        debugPrint("User not authenticated, redirecting to login");
        return const RouteSettings(name: "/login");
      }
    } catch (e) {
      debugPrint("AuthController not found or error: $e");
      return const RouteSettings(name: "/login");
    }

    return null;
  }
}
