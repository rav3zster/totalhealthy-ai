import 'package:get/get.dart';

import '../controllers/welcome_screen_controllers.dart';

class WelcomeScreenBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WelcomeScreenController>(() => WelcomeScreenController());
  }
}
