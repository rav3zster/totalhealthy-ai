import 'package:get/get.dart';
import 'package:totalhealthy/app/modules/registration/controllers/registration_controller.dart';

class RegistrationBinding extends Bindings {
  @override
  void dependencies() {
    // LazyPut means the controller is created only when it's used for the first time
    Get.lazyPut<RegistrationController>(() => RegistrationController());
  }
}
