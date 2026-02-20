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
  final availableMeals =
      <MealModel>[].obs; // For meal selection (admin's personal + group)
  final assignedMeals =
      <MealModel>[].obs; // For displaying in planner (group only)
  final isLoading = false.obs;

  // Track which days are expanded (by date string)
  final expandedDays = <String>{}.obs;

  // Available meal categories from group meals
  final availableCategories = <String>[].obs;

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

    print('=== WEEKLY MEAL PLANNER INIT ===');
    print('👤 User Role: ${isAdmin ? "ADMIN" : "MEMBER"}');
    print('🏢 Group ID: $groupId');
    print('📛 Group Name: $groupName');
    print('📦 Arguments received: $args');
    print('=================================');

    currentWeekStart.value = _getWeekStart(DateTime.now());

    // Initialize categories immediately with standard categories
    _updateAvailableCategories();

    if (groupId != null) {
      _loadAvailableMeals();
      _loadMealPlans();
    } else {
      print('⚠️ WARNING: groupId is NULL! Cannot load meal plans.');
    }
  }

  void _loadAvailableMeals() {
    final authController = Get.find<AuthController>();
    final userId = authController.firebaseUser.value?.uid;

    if (userId != null && groupId != null) {
      if (isAdmin) {
        // Admin: Load their personal meals for selection
        // These are the meals they can choose from to assign
        print('Admin loading personal meals for user: $userId');
        availableMeals.bindStream(_mealsService.getUserMealsStream(userId));
      } else {
        // Member: Load group meals for viewing
        // These are meals that have been assigned to the group
        print('Member loading group meals for group: $groupId');
        availableMeals.bindStream(_mealsService.getMealsStream(groupId!));
      }

      // BOTH admin and members load assigned meals from the group
      // This is what shows up in the planner itself
      print('Loading assigned meals from group: $groupId');
      assignedMeals.bindStream(_mealsService.getMealsStream(groupId!));

      // Extract unique categories from available meals
      ever(availableMeals, (_) {
        print('Available meals updated: ${availableMeals.length} meals');
        _updateAvailableCategories();
      });

      // Track assigned meals updates
      ever(assignedMeals, (_) {
        print('Assigned meals updated: ${assignedMeals.length} meals');
      });
    }
  }

  void _updateAvailableCategories() {
    // Use the SAME categories as Create Meal screen
    // These are the standard categories available in the app
    final standardCategories = [
      'Breakfast',
      'Morning Snacks',
      'Lunch',
      'Preworkout',
      'Post Workout',
      'Dinner',
    ];

    // Also include any custom categories from existing meals
    final allCategories = <String>{};
    allCategories.addAll(standardCategories);

    // Add any additional categories from user's meals
    for (var meal in availableMeals) {
      allCategories.addAll(meal.categories);
    }

    // Sort: standard categories first (in order), then alphabetically
    final sortedCategories = <String>[];
    for (var category in standardCategories) {
      if (allCategories.contains(category)) {
        sortedCategories.add(category);
        allCategories.remove(category);
      }
    }

    // Add remaining custom categories alphabetically
    sortedCategories.addAll(allCategories.toList()..sort());

    availableCategories.value = sortedCategories;
  }

  void _loadMealPlans() {
    if (groupId == null) return;

    final startDate = currentWeekStart.value;
    final endDate = startDate.add(const Duration(days: 6));

    print('=== LOADING MEAL PLANS ===');
    print('👤 User Role: ${isAdmin ? "ADMIN" : "MEMBER"}');
    print('🏢 Group ID for query: $groupId');
    print(
      '📅 Date range: ${_formatDateOnly(startDate)} to ${_formatDateOnly(endDate)}',
    );
    print('🔍 Firestore Query:');
    print('   - Collection: group_meal_plans');
    print('   - WHERE groupId == $groupId');
    print('   - WHERE date >= ${_formatDateOnly(startDate)}');
    print('   - WHERE date <= ${_formatDateOnly(endDate)}');
    print('==========================');

    // CRITICAL: Load meal plans from group_meal_plans collection
    // Data path: group_meal_plans where groupId == currentGroupId
    // Both admin and members load from the SAME collection
    // Real-time updates via snapshots() ensure UI stays in sync
    mealPlans.bindStream(
      _mealPlansService.getGroupMealPlansStream(groupId!, startDate, endDate),
    );

    // Track meal plan updates
    ever(mealPlans, (plans) {
      print('=== MEAL PLANS STREAM UPDATE ===');
      print('👤 User Role: ${isAdmin ? "ADMIN" : "MEMBER"}');
      print('📊 Plans loaded: ${plans.length}');
      for (var plan in plans) {
        print('📄 Plan Document:');
        print('   - ID: ${plan.id}');
        print('   - Date: ${_formatDateOnly(plan.date)}');
        print('   - GroupId: ${plan.groupId}');
        print('   - MealSlots: ${plan.mealSlots}');
        print('   - Meal Count: ${plan.mealCount}');
      }
      print('================================');
    });
  }

  String _formatDateOnly(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
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
    if (mealId == null) {
      print('getMealById: mealId is null');
      return null;
    }
    print('getMealById: Looking for meal $mealId');
    print('  - assignedMeals count: ${assignedMeals.length}');
    print('  - availableMeals count: ${availableMeals.length}');

    // First check assigned meals (what's in the planner)
    var meal = assignedMeals.firstWhereOrNull((meal) => meal.id == mealId);
    if (meal != null) {
      print('  - Found in assignedMeals: ${meal.name}');
      return meal;
    }

    // Fallback to available meals (for admin's personal meals)
    meal = availableMeals.firstWhereOrNull((meal) => meal.id == mealId);
    if (meal != null) {
      print('  - Found in availableMeals: ${meal.name}');
      return meal;
    }

    print('  - Meal NOT FOUND in either list!');
    print(
      '  - assignedMeals IDs: ${assignedMeals.map((m) => m.id).join(", ")}',
    );
    print(
      '  - availableMeals IDs: ${availableMeals.map((m) => m.id).join(", ")}',
    );
    return null;
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

      print('=== ASSIGNING MEAL TO PLANNER ===');
      print('Date: $date');
      print('Meal Type: $mealType');
      print('Meal ID: $mealId');
      print('Group ID: $groupId');

      if (mealId != null) {
        // Verify the meal exists
        final meal = getMealById(mealId);
        if (meal == null) {
          throw Exception('Meal not found. Please ensure the meal exists.');
        }

        print('✓ Meal found: ${meal.name}');
        print('  - Meal groupId: ${meal.groupId}');
        print('  - Target groupId: $groupId');

        // CRITICAL FIX: If meal doesn't have correct groupId, update it
        if (meal.groupId != groupId) {
          print('⚠️ Meal groupId mismatch, updating meal document...');

          try {
            // Create updated meal with correct groupId
            final updatedMeal = MealModel(
              id: meal.id,
              userId: meal.userId,
              groupId: groupId!, // Update to target group
              name: meal.name,
              description: meal.description,
              kcal: meal.kcal,
              protein: meal.protein,
              carbs: meal.carbs,
              fat: meal.fat,
              categories: meal.categories,
              imageUrl: meal.imageUrl,
              ingredients: meal.ingredients,
              instructions: meal.instructions,
              createdAt: meal.createdAt,
              prepTime: meal.prepTime,
              difficulty: meal.difficulty,
            );

            // Update the meal's groupId to match the group
            await _mealsService.updateMeal(updatedMeal);
            print('✓ Meal groupId updated to: $groupId');
          } catch (e) {
            print('✗ Failed to update meal groupId: $e');
            throw Exception(
              'Failed to assign meal to group. Please try again.',
            );
          }
        }

        print('✓ Meal verified: ${meal.name} (groupId: $groupId)');
      }

      // Save only the mealId reference to the planner
      await _mealPlansService.updateMealSlot(
        groupId!,
        date,
        mealType,
        mealId, // Just the ID reference
        userId,
        userName.isEmpty ? 'Admin' : userName,
      );

      print('✓ Meal slot updated successfully');
      print('=== END ASSIGNMENT ===');

      Get.snackbar(
        'Success',
        'Meal updated successfully',
        backgroundColor: const Color(0xFFC2D86A).withValues(alpha: 0.8),
        colorText: Colors.black,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('✗ ERROR in updateMealSlot: $e');
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

  Future<void> duplicateDay(DateTime sourceDate, DateTime targetDate) async {
    if (groupId == null || !isAdmin) return;

    try {
      isLoading.value = true;
      print('Controller: duplicateDay called');
      print('  - sourceDate: $sourceDate');
      print('  - targetDate: $targetDate');

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
        backgroundColor: const Color(0xFFC2D86A).withValues(alpha: 0.8),
        colorText: Colors.black,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('✗ Controller error in duplicateDay: $e');
      Get.snackbar(
        'Error',
        'Failed to duplicate day: $e',
        backgroundColor: Colors.red.withValues(alpha: 0.8),
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
        backgroundColor: const Color(0xFFC2D86A).withValues(alpha: 0.8),
        colorText: Colors.black,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to duplicate to week: $e',
        backgroundColor: Colors.red.withValues(alpha: 0.8),
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

    // Iterate through all meal slots dynamically
    for (var mealId in plan.mealSlots.values) {
      final meal = getMealById(mealId);
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

  void toggleDayExpansion(DateTime date) {
    final dateKey = _formatDateKey(date);
    if (expandedDays.contains(dateKey)) {
      expandedDays.remove(dateKey);
    } else {
      expandedDays.add(dateKey);
    }
  }

  bool isDayExpanded(DateTime date) {
    return expandedDays.contains(_formatDateKey(date));
  }

  String _formatDateKey(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }
}
