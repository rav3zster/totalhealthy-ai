import 'package:get/get.dart';

import '../controllers/meal_history_controller.dart';

class MealHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MealHistoryController>(
      () => MealHistoryController(),
    );
  }
}
