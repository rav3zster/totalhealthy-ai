import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/group_meal_plan_model.dart';
import '../../../data/models/meal_model.dart';
import '../../../data/services/group_meal_plans_firestore_service.dart';
import '../../../data/services/meals_firestore_service.dart';
import '../../../core/base/controllers/auth_controller.dart';

class WeeklyMealPlannerController extends GetxController {
  final GroupMealPlansFirestoreService _mealPlansService =
      GroupMealPlansFirestoreService();
  final MealsFirestoreService _mealsService = MealsFirestoreService();

  final mealPlans = <GroupMealPlanModel>[].obs;
  final availableMeals = <MealModel>[].obs;
  final isLoading = false.obs;

  String? groupId;
  String? groupName;
  bool isAdmin = false;

  final currentWeekStart = Rx<DateTime>(DateTime.now());

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      groupId = args['id'] ?? args['groupId'];
      groupName = args['name'] ?? 'Group';
      isAdmin = args['isAdmin'] ?? false;
    }

    currentWeekStart.value = _getWeekStart(DateTime.now());

    if (groupId != null) {
      _loadAvailableMeals();
      _loadMealPlans();
    }
  }

  void _loadAvailableMeals() {
    final authController = Get.find<AuthController>();
    final userId = authController.firebaseUser.value?.uid;

    if (userId != null) {
      availableMeals.bindStream(_mealsService.getUserMealsStream(userId));
    }
  }

  void _loadMealPlans() {
    if (groupId == null) return;

    final startDate = currentWeekStart.value;
    final endDate = startDate.add(const Duration(days: 6));

    mealPlans.bindStream(
      _mealPlansService.getGroupMealPlansStream(groupId!, startDate, endDate),
    );
  }

  DateTime _getWeekStart(DateTime date) {
    final weekday = date.weekday;
    return date.subtract(Duration(days: weekday - 1));
  }

  GroupMealPlanModel? getMealPlanForDate(DateTime date) {
    return mealPlans.firstWhereOrNull(
      (plan) =>
          plan.date.year == date.year &&
          plan.date.month == date.month &&
          plan.date.day == date.day,
    );
  }

  MealModel? getMealById(String? mealId) {
    if (mealId == null) return null;
    return availableMeals.firstWhereOrNull((meal) => meal.id == mealId);
  }

  Future<void> updateMealSlot(
    DateTime date,
    String mealType,
    String? mealId,
  ) async {
    if (groupId == null || !isAdmin) return;

    try {
      isLoading.value = true;
      final authController = Get.find<AuthController>();
      final userId = authController.firebaseUser.value?.uid ?? '';
      final userData = authController.userdataget();
      final userName =
          '${userData['firstName'] ?? ''} ${userData['lastName'] ?? ''}'.trim();

      await _mealPlansService.updateMealSlot(
        groupId!,
        date,
        mealType,
        mealId,
        userId,
        userName.isEmpty ? 'Admin' : userName,
      );

      Get.snackbar(
        'Success',
        'Meal updated successfully',
        backgroundColor: const Color(0xFFC2D86A).withOpacity(0.8),
        colorText: Colors.black,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update meal: $e',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> duplicateDay(DateTime sourceDate, DateTime targetDate) async {
    if (groupId == null || !isAdmin) return;

    try {
      isLoading.value = true;
      final authController = Get.find<AuthController>();
      final userId = authController.firebaseUser.value?.uid ?? '';
      final userData = authController.userdataget();
      final userName =
          '${userData['firstName'] ?? ''} ${userData['lastName'] ?? ''}'.trim();

      await _mealPlansService.duplicateDayMeals(
        groupId!,
        sourceDate,
        targetDate,
        userId,
        userName.isEmpty ? 'Admin' : userName,
      );

      Get.back(); // Close dialog

      Get.snackbar(
        'Success',
        'Day duplicated successfully',
        backgroundColor: const Color(0xFFC2D86A).withOpacity(0.8),
        colorText: Colors.black,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to duplicate day: $e',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> duplicateDayToWeek(DateTime sourceDate) async {
    if (groupId == null || !isAdmin) return;

    try {
      isLoading.value = true;

      final sourcePlan = getMealPlanForDate(sourceDate);
      if (sourcePlan == null) {
        throw Exception('No meals found for this day');
      }

      final authController = Get.find<AuthController>();
      final userId = authController.firebaseUser.value?.uid ?? '';
      final userData = authController.userdataget();
      final userName =
          '${userData['firstName'] ?? ''} ${userData['lastName'] ?? ''}'.trim();

      // Apply to all 7 days of the week
      for (int i = 0; i < 7; i++) {
        final targetDate = currentWeekStart.value.add(Duration(days: i));

        // Skip the source date
        if (targetDate.day == sourceDate.day &&
            targetDate.month == sourceDate.month &&
            targetDate.year == sourceDate.year) {
          continue;
        }

        await _mealPlansService.duplicateDayMeals(
          groupId!,
          sourceDate,
          targetDate,
          userId,
          userName.isEmpty ? 'Admin' : userName,
        );
      }

      Get.back(); // Close dialog

      Get.snackbar(
        'Success',
        'Meals applied to entire week',
        backgroundColor: const Color(0xFFC2D86A).withOpacity(0.8),
        colorText: Colors.black,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to duplicate to week: $e',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, double> getDailyNutrition(DateTime date) {
    final plan = getMealPlanForDate(date);
    if (plan == null) {
      return {'calories': 0, 'protein': 0, 'carbs': 0, 'fat': 0};
    }

    double totalCalories = 0;
    double totalProtein = 0;
    double totalCarbs = 0;
    double totalFat = 0;

    final breakfast = getMealById(plan.breakfastMealId);
    final lunch = getMealById(plan.lunchMealId);
    final dinner = getMealById(plan.dinnerMealId);

    for (final meal in [breakfast, lunch, dinner]) {
      if (meal != null) {
        totalCalories += double.tryParse(meal.kcal) ?? 0;
        totalProtein += double.tryParse(meal.protein) ?? 0;
        totalCarbs += double.tryParse(meal.carbs) ?? 0;
        totalFat += double.tryParse(meal.fat) ?? 0;
      }
    }

    return {
      'calories': totalCalories,
      'protein': totalProtein,
      'carbs': totalCarbs,
      'fat': totalFat,
    };
  }

  void previousWeek() {
    currentWeekStart.value = currentWeekStart.value.subtract(
      const Duration(days: 7),
    );
    _loadMealPlans();
  }

  void nextWeek() {
    currentWeekStart.value = currentWeekStart.value.add(
      const Duration(days: 7),
    );
    _loadMealPlans();
  }

  void goToCurrentWeek() {
    currentWeekStart.value = _getWeekStart(DateTime.now());
    _loadMealPlans();
  }
}
