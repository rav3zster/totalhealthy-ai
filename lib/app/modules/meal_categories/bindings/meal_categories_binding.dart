import 'package:get/get.dart';
import '../controllers/meal_categories_controller.dart';

class MealCategoriesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MealCategoriesController>(() => MealCategoriesController());
  }
}
