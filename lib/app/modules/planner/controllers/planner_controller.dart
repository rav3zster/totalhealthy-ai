import 'dart:async';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../data/models/meal_model.dart';
import '../../../data/services/meals_firestore_service.dart';

class PlannerController extends GetxController {
  final _mealsService = MealsFirestoreService();

  // Reactive properties for the UI
  final selectedTab = 1.obs; // Index 1 is 'Week'
  final expandedDays = <int>{1}.obs; // Tuesday (index 1) is expanded
  final currentRecipeIndex = 0.obs;
  final isLoading = true.obs;

  // Real data from Firestore
  final meals = <MealModel>[].obs;
  final weeklyPlan = <Map<String, dynamic>>[].obs;
  final recipes = <Map<String, dynamic>>[].obs;

  StreamSubscription? _mealsSubscription;

  @override
  void onInit() {
    super.onInit();
    _initData();
  }

  @override
  void onClose() {
    _mealsSubscription?.cancel();
    super.onClose();
  }

  void _initData() {
    isLoading.value = true;
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Listen to real-time updates from Firestore
      _mealsSubscription = _mealsService
          .getUserMealsStream(user.uid)
          .listen(
            (mealList) {
              meals.assignAll(mealList);
              _generateWeeklyPlan();
              _generateRecipes();
              isLoading.value = false;
            },
            onError: (e) {
              print("Error fetching meals for planner: $e");
              isLoading.value = false;
            },
          );
    } else {
      isLoading.value = false;
    }
  }

  void _generateWeeklyPlan() {
    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    // Group available meals by category (Breakfast, Lunch, Dinner, etc.)
    Map<String, List<String>> mealsByCategory = {};
    for (var meal in meals) {
      for (var cat in meal.categories) {
        mealsByCategory.putIfAbsent(cat, () => []).add(meal.name);
      }
    }

    final List<Map<String, dynamic>> plan = [];
    for (int i = 0; i < days.length; i++) {
      // If there are no specific plans yet, we show the system's meal categories as a guide
      plan.add({
        'day': days[i],
        'dishesCount': meals.length,
        'summary': _generateSummaryText(),
        'meals': meals.isEmpty ? {} : mealsByCategory,
      });
    }
    weeklyPlan.assignAll(plan);
  }

  String _generateSummaryText() {
    if (meals.isEmpty) return "No meals assigned yet";
    final topThree = meals.take(3).map((m) => m.name).join(' • ');
    final remaining = meals.length > 3 ? " +${meals.length - 3}" : "";
    return "$topThree$remaining";
  }

  void _generateRecipes() {
    final List<Map<String, dynamic>> result = [];

    // Use actual meals for the recipe carousel
    for (var meal in meals.take(5)) {
      result.add({
        'title': meal.name,
        'image': meal.imageUrl.isNotEmpty
            ? meal.imageUrl
            : 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=2070&auto=format&fit=crop',
        'color': 0xFFCDE26D,
        'mealData': meal,
      });
    }

    // Fallback card if no meals exist
    if (result.isEmpty) {
      result.add({
        'title': 'Start by adding your first meal!',
        'image':
            'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=2070&auto=format&fit=crop',
        'color': 0xFFCDE26D,
      });
    }
    recipes.assignAll(result);
  }

  void toggleDay(int index) {
    if (expandedDays.contains(index)) {
      expandedDays.remove(index);
    } else {
      expandedDays.add(index);
    }
  }

  void setTab(int index) {
    selectedTab.value = index;
  }

  // Placeholder actions for UI interactivity
  void viewRecipe(Map<String, dynamic> recipe) {
    if (recipe['mealData'] != null) {
      // Could navigate to meal details
    }
  }

  void addToMealPlan(Map<String, dynamic> recipe) {
    // Action to add to specific day
  }
}
