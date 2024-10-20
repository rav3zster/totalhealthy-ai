import 'package:get/get.dart';
import 'package:totalhealthy/app/modules/Profile_Details_screen/Profile_view.dart';
import 'package:totalhealthy/app/modules/home/widgets/home_screen.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => Profile_details(),
      binding: HomeBinding(),
    ),
  ];
}
