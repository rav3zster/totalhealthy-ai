import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/views/login_view.dart';

// Import the main app_pages to use Routes and _Paths
import 'app_pages.dart';

class AppPagesSimple {
  AppPagesSimple._();

  static const initial = Routes.Login;

  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.Login,
      page: () => LoginView(),
    ),
  ];
}
