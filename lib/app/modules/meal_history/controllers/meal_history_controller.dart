import 'package:get/get.dart';
import '../../../core/base/controllers/auth_controller.dart';
import '../../../data/models/meal_model.dart';
import '../../../data/services/meals_firestore_service.dart';

class MealHistoryController extends GetxController {
  final _mealsService = MealsFirestoreService();
  final meals = <MealModel>[].obs;
  final filteredMeals = <MealModel>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final authController = Get.find<AuthController>();
    final groupId = authController.groupgetId();
    fetchMeals(groupId);

    // Setup search listener
    debounce(
      searchQuery,
      (_) => _filterMeals(),
      time: const Duration(milliseconds: 300),
    );
  }

  void fetchMeals(String groupId) {
    isLoading.value = true;
    _mealsService
        .getMealsStream(groupId)
        .listen(
          (mealList) {
            meals.assignAll(mealList);
            _filterMeals();
            isLoading.value = false;
          },
          onError: (e) {
            print("Error fetching meals: $e");
            isLoading.value = false;
          },
        );
  }

  void _filterMeals() {
    if (searchQuery.value.isEmpty) {
      filteredMeals.assignAll(meals);
    } else {
      filteredMeals.assignAll(
        meals.where(
          (meal) =>
              meal.name.toLowerCase().contains(
                searchQuery.value.toLowerCase(),
              ) ||
              meal.description.toLowerCase().contains(
                searchQuery.value.toLowerCase(),
              ),
        ),
      );
    }
  }

  void updateSearch(String query) {
    searchQuery.value = query;
  }
}
