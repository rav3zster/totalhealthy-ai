import 'package:get/get.dart';
import 'package:totalhealthy/app/modules/Signup_Screen/Signup_controller.dart';




class SignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignupController>(
            () => SignupController(),
    );
  }
}
