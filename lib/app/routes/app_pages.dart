import 'package:get/get.dart';
import 'package:totalhealthy/app/modules/Create_Screen/Create_view.dart';
import 'package:totalhealthy/app/modules/Onboarding_Screen/Onboarding_view.dart';
//import 'package:totalhealthy/app/modules/Login_Screen/Login_controller.dart';
//import 'package:totalhealthy/app/modules/Login_Screen/Login_view.dart';
import 'package:totalhealthy/app/modules/Registration_Screen/Registration_view.dart';
import 'package:totalhealthy/app/modules/Signup_Screen/Signup_view.dart';
import 'package:totalhealthy/app/modules/home/widgets/home_screen.dart';
//import 'package:totalhealthy/app/modules/login_screen/login_controller.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => CreateView(),
      binding: HomeBinding(),
    ),
  ];
}
