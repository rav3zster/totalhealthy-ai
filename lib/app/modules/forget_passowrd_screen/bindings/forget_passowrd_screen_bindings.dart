import 'package:get/get.dart';

import '../controllers/forget_password_screen_controllers.dart';


class ForgetPasswordScreenBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgetPasswordScreenControllers>(
          () => ForgetPasswordScreenControllers(),
    );
  }
}
