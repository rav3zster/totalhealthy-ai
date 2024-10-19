import 'package:get/get.dart';
import 'package:totalhealthy/app/modules/swipe_screen/bindings/swipe_screen_bindings.dart';
import 'package:totalhealthy/app/modules/swipe_screen/views/swipe_screen_views.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/welcom_screen/bindings/welcome-screen-bindings.dart';
import '../modules/welcom_screen/views/welcome-screen-views.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.WelcomeScreen;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SwipeScreen,
      page: () => SwipeScreenView(),
      binding: SwipeScreenBindings(),
    ),
    GetPage(
      name: _Paths.WelcomeScreen,
      page: () => WelcomeScreenView(),
      binding: WelcomeScreenBindings(),
    ),
  ];
}
