import 'package:get/get.dart';
import 'package:totalhealthy/app/modules/Login_Screen/login_controller.dart';




class SwipeScreenBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(
            () => LoginController(),
    );
  }
}
