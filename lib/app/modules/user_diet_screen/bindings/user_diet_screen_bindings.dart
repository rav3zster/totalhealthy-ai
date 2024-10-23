import 'package:get/get.dart';

import '../controllers/user_diet_screen_controllers.dart';




class UserDietScreenBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserDietScreenController>(
            () => UserDietScreenController()
    );
  }
}
