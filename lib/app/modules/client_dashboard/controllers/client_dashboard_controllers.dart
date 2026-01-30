import 'package:get/get.dart';
import '../../../core/base/controllers/auth_controller.dart';
import '../../../data/models/meal_model.dart';
import '../../../data/services/dummy_data_service.dart';
import '../../../data/services/meals_firestore_service.dart';

class ClientDashboardControllers extends GetxController {
  final MealsFirestoreService _mealsService = MealsFirestoreService();

  final meals = <MealModel>[].obs;
  final isLoading = true.obs;
  final selectedCategory = 'Breakfast'.obs;

  @override
  void onInit() {
    super.onInit();
    _initData();
  }

  Future<void> _initData() async {
    isLoading.value = true;
    final authController = Get.find<AuthController>();
    final groupId = authController.groupgetId();
    print(
      "DEBUG: ClientDashboardControllers - Fetching meals for groupId: $groupId",
    );

    // Seed dummy data if Firestore is empty
    await DummyDataService.uploadDummyMealsToFirestore();

    // Listen to real-time updates filtered by group
    meals.bindStream(_mealsService.getMealsStream(groupId));

    // We can assume loading is done once we get first data or after a short delay
    ever(meals, (List<MealModel> updatedMeals) {
      print(
        "DEBUG: ClientDashboardControllers - Received ${updatedMeals.length} meals from Firestore",
      );
      for (var meal in updatedMeals) {
        print(
          "DEBUG: Meal: ${meal.name}, Categories: ${meal.categories}, Group: ${meal.groupId}",
        );
      }
      isLoading.value = false;
    });

    // Safety timeout for loading
    Future.delayed(const Duration(seconds: 5), () {
      if (isLoading.value) {
        print("DEBUG: ClientDashboardControllers - Loading timeout reached");
        isLoading.value = false;
      }
    });
  }

  List<MealModel> get filteredMeals {
    return meals
        .where((meal) => meal.categories.contains(selectedCategory.value))
        .toList();
  }

  void changeCategory(String category) {
    selectedCategory.value = category;
  }
}
