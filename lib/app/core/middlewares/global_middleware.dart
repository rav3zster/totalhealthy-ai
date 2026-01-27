import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../base/controllers/auth_controller.dart';

class AuthCheckMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // Mock authentication check - always allow access for demo
    // In a real app, this would check authentication status
    
    try {
      if (!Get.find<AuthController>().isAuthenticated.value) {
        print("User not authenticated, redirecting to login");
        return RouteSettings(name: "/login");
      }
    } catch (e) {
      // If AuthController is not initialized, allow access
      print("AuthController not found, allowing access");
    }
    
    return null;
  }
}
