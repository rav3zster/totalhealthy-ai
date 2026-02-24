import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../../meal_categories/controllers/meal_categories_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<MealCategoriesController>(() => MealCategoriesController());
  }
}
