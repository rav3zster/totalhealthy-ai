import 'package:get/get.dart';

import '../controllers/meal_timing_controller.dart';

class MealTimingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MealTimingController>(
      () => MealTimingController(),
    );
  }
}
