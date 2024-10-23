import 'package:get/get.dart';
import 'package:totalhealthy/app/modules/login/bindings/login_binding.dart';
import 'package:totalhealthy/app/modules/registration/bindings/registration_binding.dart';
import 'package:totalhealthy/app/modules/registration/views/registration_view.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/views/login_view.dart';
import '../modules/trainer_dashboard/bindings/trainer_dashboard_bindings.dart';
import '../modules/trainer_dashboard/views/trainer_dashboard_views.dart';
import '../modules/user_diet_screen/bindings/user_diet_screen_bindings.dart';
import '../modules/user_diet_screen/views/user_diet_screen_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.UserDiet;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
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
    GetPage(
      name: _Paths.TrainerDashboard,
      page: () => TrainerDashboardView(),
      binding: TrainerDashboardBindings(),
    ),
    GetPage(
      name: _Paths.UserDiet,
      page: () => UserDietScreen(),
      binding: UserDietScreenBindings(),
    ),
  ];
}
