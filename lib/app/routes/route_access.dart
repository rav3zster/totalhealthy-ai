import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/base/controllers/auth_controller.dart';
import 'app_pages.dart';

class AppRouteAccess {
  //var checkPermission = CheckPermission();

  static RouteSettings? handleRedirect(String currentRoute,
      {bool? isAuthChange = false}) {
    if (Get.find<AuthController>().isAuthenticated.value) {
      return RouteSettings(name: currentRoute);
    } else {
      return const RouteSettings(name: Routes.Login);
    }
  }
}
