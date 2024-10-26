import 'package:get/get.dart';

import '../controllers/create_meal_controller.dart';

class CreateMealBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize the CreateController
    Get.lazyPut<CreateMealController>(() => CreateMealController());
  }
}
