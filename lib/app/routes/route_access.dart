import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/base/controllers/auth_controller.dart';
import 'app_pages.dart';

class AppRouteAccess {
  //var checkPermission = CheckPermission();

  static RouteSettings? handleRedirect(String currentRoute,
      {bool? isAuthChange = false}) {
    if (Get.find<AuthController>().isAuthenticated.value) {
      print(currentRoute);
      print("ss ${Get.find<AuthController>().isAuthenticated.value}");

      return null;
    } else {
      print("ss ${Get.find<AuthController>().isAuthenticated.value}");

      if (isAuthChange == true) {}

      return const RouteSettings(name: Routes.HOME);
    }
  }
}
