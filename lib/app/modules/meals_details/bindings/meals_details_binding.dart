import 'package:get/get.dart';

import '../controllers/meals_details_controller.dart';

class MealsDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MealsDetailsController>(
      () => MealsDetailsController(),
    );
  }
}
