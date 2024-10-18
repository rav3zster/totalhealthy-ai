import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../routes/app_pages.dart';

import '../../routes/route_access.dart';
import '../base/controllers/auth_controller.dart';

class AuthCheckMiddleware extends GetMiddleware {
  // final box = GetStorage();

  @override
  RouteSettings? redirect(String? route) {
    print("ddddd");
    return AppRouteAccess.handleRedirect(route ?? "/");
  }
}

class CheckPinMiddleware extends GetMiddleware {
  // final box = GetStorage();

  @override
  RouteSettings? redirect(String? route) {
    if (Get.find<AuthController>().isAuthenticated.value == false) {
      return const RouteSettings(name: Routes.HOME);
    }
    return null;
  }
}
