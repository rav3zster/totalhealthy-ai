import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../data/models/group_meal_plan_model.dart';
import '../../../data/models/meal_model.dart';
import '../../../data/services/group_meal_plans_firestore_service.dart';
import '../../../data/services/meals_firestore_service.dart';
import '../../../core/base/controllers/auth_controller.dart';

class WeeklyMealPlannerController extends GetxController {
  final GroupMealPlansFirestoreService _mealPlansService =
      GroupMealPlansFirestoreService();
  final MealsFirestoreService _mealsService = MealsFirestoreService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final mealPlans = <GroupMealPlanModel>[].obs;
  final availableMeals =
      <MealModel>[].obs; // For meal selection (admin's personal + group)
  final assignedMeals =
      <MealModel>[].obs; // For displaying in planner (group only)
  final isLoading = false.obs;

  // Track which days are expanded (by date string)
  final expandedDays = <String>{}.obs;

  // Available meal categories from group's category
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

    debugPrint('=== WEEKLY MEAL PLANNER INIT ===');
    debugPrint('👤 User Role: ${isAdmin ? "ADMIN" : "MEMBER"}');
    debugPrint('🏢 Group ID: $groupId');
    debugPrint('📛 Group Name: $groupName');
    debugPrint('📦 Arguments received: $args');
    debugPrint('=================================');

    currentWeekStart.value = _getWeekStart(DateTime.now());

    if (groupId != null) {
      // Load meal categories from group's category
      _loadGroupMealCategories();
      _loadAvailableMeals();
      _loadMealPlans();
    } else {
      debugPrint('⚠️ WARNING: groupId is NULL! Cannot load meal plans.');
    }
  }

  void _loadAvailableMeals() {
    final authController = Get.find<AuthController>();
    final userId = authController.firebaseUser.value?.uid;

    if (userId != null && groupId != null) {
      if (isAdmin) {
        // Admin: Load their personal meals for selection
        // These are the meals they can choose from to assign
        debugPrint('Admin loading personal meals for user: $userId');
        availableMeals.bindStream(_mealsService.getUserMealsStream(userId));
      } else {
        // Member: Load group meals for viewing
        // These are meals that have been assigned to the group
        debugPrint('Member loading group meals for group: $groupId');
        availableMeals.bindStream(_mealsService.getMealsStream(groupId!));
      }

      // BOTH admin and members load assigned meals from the group
      // This is what shows up in the planner itself
      debugPrint('Loading assigned meals from group: $groupId');
      assignedMeals.bindStream(_mealsService.getMealsStream(groupId!));

      // Track assigned meals updates
      ever(assignedMeals, (_) {
        debugPrint('Assigned meals updated: ${assignedMeals.length} meals');
      });
    }
  }

  /// Load meal categories from the group's category
  Future<void> _loadGroupMealCategories() async {
    if (groupId == null) return;

    try {
      // Get the group to find its groupCategoryId
      final groupDoc = await _firestore.collection('groups').doc(groupId).get();

      if (!groupDoc.exists) {
        availableCategories.value = [];
        return;
      }

      final groupData = groupDoc.data();
      final groupCategoryId = groupData?['group_category_id'] as String?;

      if (groupCategoryId == null) {
        availableCategories.value = [];
        return;
      }

      // Get the current user ID
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        availableCategories.value = [];
        return;
      }

      // Load meal categories from Firestore
      final categoriesSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('group_categories')
          .doc(groupCategoryId)
          .collection('meal_categories')
          .orderBy('order')
          .get();

      final categoryNames = categoriesSnapshot.docs
          .map((doc) {
            final data = doc.data();
            return data['name'] as String? ?? '';
          })
          .where((name) => name.isNotEmpty)
          .toList();

      availableCategories.value = categoryNames;
    } catch (e) {
      debugPrint('❌ PLANNER: Error loading meal categories: $e');
      availableCategories.value = [];
    }
  }

  void _loadMealPlans() {
    if (groupId == null) return;

    final startDate = currentWeekStart.value;
    final endDate = startDate.add(const Duration(days: 6));

    debugPrint('=== LOADING MEAL PLANS ===');
    debugPrint('👤 User Role: ${isAdmin ? "ADMIN" : "MEMBER"}');
    debugPrint('🏢 Group ID for query: $groupId');
    debugPrint(
      '📅 Date range: ${_formatDateOnly(startDate)} to ${_formatDateOnly(endDate)}',
    );
    debugPrint('🔍 Firestore Query:');
    debugPrint('   - Collection: group_meal_plans');
    debugPrint('   - WHERE groupId == $groupId');
    debugPrint('   - WHERE date >= ${_formatDateOnly(startDate)}');
    debugPrint('   - WHERE date <= ${_formatDateOnly(endDate)}');
    debugPrint('==========================');

    // CRITICAL: Load meal plans from group_meal_plans collection
    // Data path: group_meal_plans where groupId == currentGroupId
    // Both admin and members load from the SAME collection
    // Real-time updates via snapshots() ensure UI stays in sync
    mealPlans.bindStream(
      _mealPlansService.getGroupMealPlansStream(groupId!, startDate, endDate),
    );

    // Track meal plan updates
    ever(mealPlans, (plans) {
      debugPrint('=== MEAL PLANS STREAM UPDATE ===');
      debugPrint('👤 User Role: ${isAdmin ? "ADMIN" : "MEMBER"}');
      debugPrint('📊 Plans loaded: ${plans.length}');
      for (var plan in plans) {
        debugPrint('📄 Plan Document:');
        debugPrint('   - ID: ${plan.id}');
        debugPrint('   - Date: ${_formatDateOnly(plan.date)}');
        debugPrint('   - GroupId: ${plan.groupId}');
        debugPrint('   - MealSlots: ${plan.mealSlots}');
        debugPrint('   - Meal Count: ${plan.mealCount}');
      }
      debugPrint('================================');
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
      debugPrint('getMealById: mealId is null');
      return null;
    }
    debugPrint('getMealById: Looking for meal $mealId');
    debugPrint('  - assignedMeals count: ${assignedMeals.length}');
    debugPrint('  - availableMeals count: ${availableMeals.length}');

    // First check assigned meals (what's in the planner)
    var meal = assignedMeals.firstWhereOrNull((meal) => meal.id == mealId);
    if (meal != null) {
      debugPrint('  - Found in assignedMeals: ${meal.name}');
      return meal;
    }

    // Fallback to available meals (for admin's personal meals)
    meal = availableMeals.firstWhereOrNull((meal) => meal.id == mealId);
    if (meal != null) {
      debugPrint('  - Found in availableMeals: ${meal.name}');
      return meal;
    }

    debugPrint('  - Meal NOT FOUND in either list!');
    debugPrint(
      '  - assignedMeals IDs: ${assignedMeals.map((m) => m.id).join(", ")}',
    );
    debugPrint(
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

      debugPrint('=== ASSIGNING MEAL TO PLANNER ===');
      debugPrint('Date: $date');
      debugPrint('Meal Type: $mealType');
      debugPrint('Meal ID: $mealId');
      debugPrint('Group ID: $groupId');

      if (mealId != null) {
        // Verify the meal exists
        final meal = getMealById(mealId);
        if (meal == null) {
          throw Exception('Meal not found. Please ensure the meal exists.');
        }

        debugPrint('✓ Meal found: ${meal.name}');
        debugPrint('  - Meal groupId: ${meal.groupId}');
        debugPrint('  - Target groupId: $groupId');

        // CRITICAL FIX: If meal doesn't have correct groupId, update it
        if (meal.groupId != groupId) {
          debugPrint('⚠️ Meal groupId mismatch, updating meal document...');

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
            debugPrint('✓ Meal groupId updated to: $groupId');
          } catch (e) {
            debugPrint('✗ Failed to update meal groupId: $e');
            throw Exception(
              'Failed to assign meal to group. Please try again.',
            );
          }
        }

        debugPrint('✓ Meal verified: ${meal.name} (groupId: $groupId)');
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

      debugPrint('✓ Meal slot updated successfully');
      debugPrint('=== END ASSIGNMENT ===');

      Get.snackbar(
        'Success',
        'Meal updated successfully',
        backgroundColor: const Color(0xFFC2D86A).withValues(alpha: 0.8),
        colorText: Colors.black,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      debugPrint('✗ ERROR in updateMealSlot: $e');
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
      debugPrint('Controller: duplicateDay called');
      debugPrint('  - sourceDate: $sourceDate');
      debugPrint('  - targetDate: $targetDate');

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
      debugPrint('✗ Controller error in duplicateDay: $e');
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
