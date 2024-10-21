import 'package:get/get.dart';
import 'package:totalhealthy/app/modules/login/bindings/login_binding.dart';
import 'package:totalhealthy/app/modules/registration/bindings/registration_binding.dart';
import 'package:totalhealthy/app/modules/registration/views/registration_view.dart';

import '../modules/Onboarding_Screen/Onboarding_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/views/login_view.dart';
import '../modules/swipe_screen/bindings/swipe_screen_bindings.dart';
import '../modules/swipe_screen/views/swipe_screen_views.dart';
import '../modules/welcom_screen/bindings/welcome-screen-bindings.dart';
import '../modules/welcom_screen/views/welcome-screen-views.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

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
    GetPage(
      name: _Paths.Registration,
      page: () => RegistrationView(),
      binding: RegistrationBinding(),
    ),
    GetPage(
      name: _Paths.Login,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
  ];
}
