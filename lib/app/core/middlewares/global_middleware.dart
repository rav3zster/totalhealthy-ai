import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../routes/route_access.dart';
import '../base/controllers/auth_controller.dart';

class AuthCheckMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // Custom redirection logic

    if (Get.find<AuthController>().isAuthenticated.value) {
      print(Get.find<AuthController>().isAuthenticated.value);
      return AppRouteAccess.handleRedirect(route ?? "/");
    }
    return null;
  }
}
