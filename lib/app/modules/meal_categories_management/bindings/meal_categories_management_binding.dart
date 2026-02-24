import 'package:get/get.dart';
import '../controllers/meal_categories_management_controller.dart';

class MealCategoriesManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MealCategoriesManagementController>(
      () => MealCategoriesManagementController(),
    );
  }
}
