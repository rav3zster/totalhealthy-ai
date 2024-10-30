import 'package:get/get.dart';

import '../controllers/nutrition_goal_controller.dart';

class NutritionGoalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NutritionGoalController>(
      () => NutritionGoalController(),
    );
  }
}
