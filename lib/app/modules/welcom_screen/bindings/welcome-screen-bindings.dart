import 'package:get/get.dart';

import '../controllers/welcome-screen-controllers.dart';



class WelcomeScreenBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WelcomeScreenController>(
            () => WelcomeScreenController()
    );
  }
}
