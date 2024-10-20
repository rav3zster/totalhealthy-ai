import 'package:get/get.dart';
import 'package:totalhealthy/app/modules/Profile_Details_screen/Profile_controller.dart';



class SwipeScreenBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(
            () => ProfileController(),
    );
  }
}
