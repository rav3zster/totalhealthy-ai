import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../routes/app_pages.dart';

import '../base/controllers/auth_controller.dart';

class AuthCheckMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // Custom redirection logic
    bool isAuthenticated = Get.find<AuthController>().isAuthenticated.value;

    if (!isAuthenticated && route != Routes.Login) {
      return const RouteSettings(name: Routes.Login);
    }
    return null;
  }
}
