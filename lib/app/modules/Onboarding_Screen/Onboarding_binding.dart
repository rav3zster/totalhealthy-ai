import 'package:get/get.dart';
import 'package:totalhealthy/app/modules/Onboarding_Screen/Onboarding_controller.dart';
import 'package:totalhealthy/app/modules/Registration_Screen/Registration_controller.dart';




class SwipeScreenBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingController>(
          () => OnboardingController()
      ,
    );
  }
}
