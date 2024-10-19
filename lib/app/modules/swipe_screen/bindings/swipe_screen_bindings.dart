import 'package:get/get.dart';

import '../controllers/swipe_screen_controllers.dart';

class SwipeScreenBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SwipeScreenController>(
          () => SwipeScreenController()
    );
  }
}
