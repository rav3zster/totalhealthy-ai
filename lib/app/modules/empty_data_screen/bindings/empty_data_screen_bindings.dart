import 'package:get/get.dart';

import '../controllers/empty_data_screen_controllers.dart';





class EmptyScreenBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmptyScreenController>(
            () => EmptyScreenController()
    );
  }
}
