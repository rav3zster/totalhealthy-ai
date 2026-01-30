import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../base/controllers/auth_controller.dart';

class AuthCheckMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // Check authentication status
    try {
      final authController = Get.find<AuthController>();
      if (!authController.isAuthenticated.value) {
        print("User not authenticated, redirecting to login");
        return const RouteSettings(name: "/login");
      }
    } catch (e) {
      print("AuthController not found or error: $e");
      return const RouteSettings(name: "/login");
    }

    return null;
  }
}
