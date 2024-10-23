import 'package:get/get.dart';
<<<<<<< HEAD
import 'package:totalhealthy/app/modules/login/bindings/login_binding.dart';
import 'package:totalhealthy/app/modules/registration/bindings/registration_binding.dart';
import 'package:totalhealthy/app/modules/registration/views/registration_view.dart';
=======
import 'package:totalhealthy/app/modules/Create_Screen/Create_view.dart';
import 'package:totalhealthy/app/modules/Onboarding_Screen/Onboarding_view.dart';
//import 'package:totalhealthy/app/modules/Login_Screen/Login_controller.dart';
//import 'package:totalhealthy/app/modules/Login_Screen/Login_view.dart';
import 'package:totalhealthy/app/modules/Registration_Screen/Registration_view.dart';
import 'package:totalhealthy/app/modules/Signup_Screen/Signup_view.dart';
import 'package:totalhealthy/app/modules/home/widgets/home_screen.dart';
//import 'package:totalhealthy/app/modules/login_screen/login_controller.dart';
>>>>>>> 4a283684da58155a80dc6a1f20ce59857f949406

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
<<<<<<< HEAD
      page: () => HomeView(),
=======
      page: () => CreateView(),
>>>>>>> 4a283684da58155a80dc6a1f20ce59857f949406
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
