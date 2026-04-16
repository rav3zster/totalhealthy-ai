import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/group_meal_plan_model.dart';
import '../../../data/models/meal_model.dart';
import '../../../data/services/group_meal_plans_firestore_service.dart';
import '../../../data/services/meals_firestore_service.dart';
import '../../../core/base/controllers/auth_controller.dart';

class GroupMealCalendarController extends GetxController {
  final GroupMealPlansFirestoreService _mealPlansService =
      GroupMealPlansFirestoreService();
  final MealsFirestoreService _mealsService = MealsFirestoreService();

  final mealPlans = <GroupMealPlanModel>[].obs;
  final availableMeals = <MealModel>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;

  String? groupId;
  String? groupName;
  bool isAdmin = false;

  // View state
  final isWeekView = true.obs;
  final selectedDate = Rx<DateTime>(DateTime.now());
  final currentWeekStart = Rx<DateTime>(DateTime.now());
  final currentMonth = Rx<DateTime>(DateTime.now());

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      groupId = args['id'] ?? args['groupId'];
      groupName = args['name'] ?? 'Group';
      isAdmin = args['isAdmin'] ?? false;
    }

    // Initialize week start to Monday of current week
    currentWeekStart.value = _getWeekStart(DateTime.now());
    currentMonth.value = DateTime(DateTime.now().year, DateTime.now().month, 1);

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

    final startDate = isWeekView.value
        ? currentWeekStart.value
        : DateTime(currentMonth.value.year, currentMonth.value.month, 1);

    final endDate = isWeekView.value
        ? currentWeekStart.value.add(const Duration(days: 6))
        : DateTime(currentMonth.value.year, currentMonth.value.month + 1, 0);

    mealPlans.bindStream(
      _mealPlansService.getGroupMealPlansStream(groupId!, startDate, endDate),
    );
  }

  void toggleView() {
    isWeekView.value = !isWeekView.value;
    _loadMealPlans();
  }

  void previousPeriod() {
    if (isWeekView.value) {
      currentWeekStart.value = currentWeekStart.value.subtract(
        const Duration(days: 7),
      );
    } else {
      currentMonth.value = DateTime(
        currentMonth.value.year,
        currentMonth.value.month - 1,
        1,
      );
    }
    _loadMealPlans();
  }

  void nextPeriod() {
    if (isWeekView.value) {
      currentWeekStart.value = currentWeekStart.value.add(
        const Duration(days: 7),
      );
    } else {
      currentMonth.value = DateTime(
        currentMonth.value.year,
        currentMonth.value.month + 1,
        1,
      );
    }
    _loadMealPlans();
  }

  void goToToday() {
    if (isWeekView.value) {
      currentWeekStart.value = _getWeekStart(DateTime.now());
    } else {
      currentMonth.value = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        1,
      );
    }
    selectedDate.value = DateTime.now();
    _loadMealPlans();
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
        backgroundColor: const Color(0xFFC2D86A).withValues(alpha: 0.8),
        colorText: Colors.black,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update meal: $e',
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> duplicateDayMeals(
    DateTime sourceDate,
    DateTime targetDate,
  ) async {
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

      Get.snackbar(
        'Success',
        'Meals duplicated successfully',
        backgroundColor: const Color(0xFFC2D86A).withValues(alpha: 0.8),
        colorText: Colors.black,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to duplicate meals: $e',
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> applyWeekTemplate(
    DateTime weekStart,
    String? breakfastMealId,
    String? lunchMealId,
    String? dinnerMealId,
  ) async {
    if (groupId == null || !isAdmin) return;

    try {
      isLoading.value = true;
      final authController = Get.find<AuthController>();
      final userId = authController.firebaseUser.value?.uid ?? '';
      final userData = authController.userdataget();
      final userName =
          '${userData['firstName'] ?? ''} ${userData['lastName'] ?? ''}'.trim();

      await _mealPlansService.applyWeekTemplate(
        groupId!,
        weekStart,
        breakfastMealId,
        lunchMealId,
        dinnerMealId,
        userId,
        userName.isEmpty ? 'Admin' : userName,
      );

      Get.back(); // Close dialog

      Get.snackbar(
        'Success',
        'Week template applied successfully',
        backgroundColor: const Color(0xFFC2D86A).withValues(alpha: 0.8),
        colorText: Colors.black,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to apply template: $e',
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  MealModel? getMealById(String? mealId) {
    if (mealId == null) return null;
    return availableMeals.firstWhereOrNull((meal) => meal.id == mealId);
  }
}
