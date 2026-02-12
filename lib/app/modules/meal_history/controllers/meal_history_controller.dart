import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../core/base/controllers/auth_controller.dart';
import '../../../data/models/meal_model.dart';
import '../../../data/services/meals_firestore_service.dart';

class MealHistoryController extends GetxController {
  final _mealsService = MealsFirestoreService();
  final meals = <MealModel>[].obs;
  final filteredMeals = <MealModel>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;

  // Selected Category (Breakfast, Lunch, Dinner, etc.)
  final selectedCategory = 'Breakfast'.obs;

  // Track selected meals for copying
  final selectedMealIds = <String>{}.obs;

  // Header data
  final userName = 'User'.obs;
  final dietGoal = 'Weight Loss'.obs;

  @override
  void onInit() {
    super.onInit();
    final authController = Get.find<AuthController>();
    final groupId = authController.groupgetId();

    // Set user data from AuthController
    final currentUser = authController.getCurrentUser();
    userName.value = currentUser.firstName.isNotEmpty
        ? currentUser.firstName
        : currentUser.username;
    dietGoal.value = currentUser.primaryGoal;

    fetchMeals(groupId);

    // Setup search and category listeners
    debounce(
      searchQuery,
      (_) => _filterMeals(),
      time: const Duration(milliseconds: 300),
    );

    ever(selectedCategory, (_) => _filterMeals());
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
    var result = meals.where((meal) {
      // Category filter
      bool matchesCategory = meal.categories.contains(selectedCategory.value);

      // Search filter
      bool matchesSearch = true;
      if (searchQuery.value.isNotEmpty) {
        matchesSearch =
            meal.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
            meal.description.toLowerCase().contains(
              searchQuery.value.toLowerCase(),
            );
      }

      return matchesCategory && matchesSearch;
    }).toList();

    filteredMeals.assignAll(result);
  }

  void updateSearch(String query) {
    searchQuery.value = query;
  }

  void setCategory(String category) {
    selectedCategory.value = category;
  }

  void toggleMealSelection(String? mealId) {
    if (mealId == null) return;
    if (selectedMealIds.contains(mealId)) {
      selectedMealIds.remove(mealId);
    } else {
      selectedMealIds.add(mealId);
    }
    selectedMealIds.refresh();
  }

  void continueSelection() {
    if (selectedMealIds.isEmpty) {
      Get.snackbar(
        "No Selection",
        "Please select at least one meal to copy",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    // Identify the first selected meal for the edit/copy flow
    final firstSelectedId = selectedMealIds.first;
    final mealToCopy = meals.firstWhereOrNull((m) => m.id == firstSelectedId);

    if (mealToCopy != null) {
      print("Continuing with meal: ${mealToCopy.name}");

      // Navigate to Create Meal page in 'copy' mode
      final authController = Get.find<AuthController>();
      final userData = authController.userdataget();
      final userId = userData != null
          ? (userData['id'] ?? userData['_id'] ?? "")
          : "";

      Get.toNamed(
        "${Routes.CreateMeal}?id=$userId",
        arguments: {'mode': 'copy', 'meal': mealToCopy},
      );
    } else {
      Get.snackbar(
        "Error",
        "Could not find selected meal data",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
