import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/base/controllers/auth_controller.dart';
import 'app_pages.dart';

class AppRouteAccess {
  //var checkPermission = CheckPermission();

  static RouteSettings? handleRedirect(
    String currentRoute, {
    bool? isAuthChange = false,
  }) {
    final authController = Get.find<AuthController>();
    // Use non-reactive access since this is not in a widget context
    // and we don't need reactive updates here
    if (authController.isAuthenticated.value) {
      return RouteSettings(name: currentRoute);
    } else {
      return const RouteSettings(name: Routes.login);
    }
  }
}
