import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/base/controllers/auth_controller.dart';
import '../../../services/ai_service.dart';

class GenerateAiController extends GetxController {
  // ── Dietary Goals ──────────────────────────────────────────────────────────
  final RxString selectedGoal = ''.obs;
  final currentWeightController = TextEditingController();
  final targetWeightController = TextEditingController();
  final kcalController = TextEditingController();
  final carbsController = TextEditingController();
  final proteinController = TextEditingController();
  final fatsController = TextEditingController();

  // ── Diet Preference ────────────────────────────────────────────────────────
  final RxString dietType = ''.obs;
  final RxList<String> selectedAllergies = <String>[].obs;
  final RxString preferredCuisine = ''.obs;

  // ── Meal Preference ────────────────────────────────────────────────────────
  final RxInt mealsPerDay = 2.obs;
  final RxList<String> selectedMealTypes = <String>[].obs;
  final specificFoodsController = TextEditingController();
  final foodsToAvoidController = TextEditingController();

  // ── Physical Activity ──────────────────────────────────────────────────────
  final RxString exerciseFrequency = ''.obs;
  final RxString exerciseType = ''.obs;
  final RxString prePostWorkoutNutrition = ''.obs;

  // ── Additional Info ────────────────────────────────────────────────────────
  final medicalConditionController = TextEditingController();
  final Rx<DateTime?> preferredStartDate = Rx<DateTime?>(null);
  final specialInstructionsController = TextEditingController();

  // ── AI State ───────────────────────────────────────────────────────────────
  final RxBool isGenerating = false.obs;
  final RxBool hasResult = false.obs;
  final RxList<AiGeneratedMeal> generatedMeals = <AiGeneratedMeal>[].obs;
  final RxString errorMessage = ''.obs;

  // ── Options ────────────────────────────────────────────────────────────────
  final List<String> goals = [
    'Weight Loss',
    'Weight Gain',
    'Maintenance',
    'Muscle Build',
  ];
  final List<String> dietTypes = [
    'Vegetarian',
    'Vegan',
    'Keto',
    'Paleo',
    'Mediterranean',
    'Not Specific',
  ];
  final List<String> allergies = [
    'Gluten',
    'Dairy',
    'Nuts',
    'Shellfish',
    'Meat',
    'Not Specific',
  ];
  final List<String> cuisines = ['Indian', 'Italian', 'Chinese', 'Thai'];
  final List<String> mealTypesList = [
    'Breakfast',
    'Morning Snacks',
    'Lunch',
    'Preworkout',
    'Post Workout',
    'Dinner',
  ];
  final List<String> exerciseFrequencies = [
    '1-2 Days/Week',
    '3-4 Days/Week',
    '5 Days/Week',
    '5-7 Days/Week',
  ];
  final List<String> exerciseTypes = [
    'Cardio',
    'Strength Training',
    'Calisthenics',
    'Zumba',
    'Powerlifting',
    'Mixed',
  ];

  // ── Selectors ──────────────────────────────────────────────────────────────
  void selectGoal(String goal) => selectedGoal.value = goal;
  void selectDietType(String type) => dietType.value = type;
  void selectCuisine(String cuisine) => preferredCuisine.value = cuisine;
  void selectFrequency(String freq) => exerciseFrequency.value = freq;
  void selectExerciseType(String type) => exerciseType.value = type;
  void selectPrePostNutrition(String v) => prePostWorkoutNutrition.value = v;
  void selectDate(DateTime date) => preferredStartDate.value = date;
  void incrementMeals() {
    if (mealsPerDay.value < 8) mealsPerDay.value++;
  }

  void decrementMeals() {
    if (mealsPerDay.value > 1) mealsPerDay.value--;
  }

  void toggleAllergy(String allergy) {
    if (selectedAllergies.contains(allergy)) {
      selectedAllergies.remove(allergy);
    } else {
      if (allergy == 'Not Specific') {
        selectedAllergies.clear();
      } else {
        selectedAllergies.remove('Not Specific');
      }
      selectedAllergies.add(allergy);
    }
  }

  void toggleMealType(String type) {
    if (selectedMealTypes.contains(type)) {
      selectedMealTypes.remove(type);
    } else {
      selectedMealTypes.add(type);
    }
  }

  // ── MAIN: Generate Plan ────────────────────────────────────────────────────
  Future<void> generatePlan() async {
    if (isGenerating.value) return;
    errorMessage.value = '';
    isGenerating.value = true;
    hasResult.value = false;
    generatedMeals.clear();

    try {
      final meals = await AiService.instance.generateMealWithAI(
        _buildPayload(),
      );
      generatedMeals.assignAll(meals);
      hasResult.value = true;
    } catch (e) {
      errorMessage.value = 'Failed to generate meal plan. Please try again.';
    } finally {
      isGenerating.value = false;
    }
  }

  // ── Save all generated meals to Firestore ──────────────────────────────────
  Future<void> saveAllMeals() async {
    if (generatedMeals.isEmpty) return;
    try {
      final auth = Get.find<AuthController>();
      final userId = auth.firebaseUser.value?.uid ?? '';
      final groupId = auth.groupgetId();

      final batch = FirebaseFirestore.instance.batch();
      for (final meal in generatedMeals) {
        final ref = FirebaseFirestore.instance.collection('meals').doc();
        batch.set(ref, meal.toFirestoreMap(userId: userId, groupId: groupId));
      }
      await batch.commit();

      Get.snackbar(
        'Saved',
        '${generatedMeals.length} meals saved to your plan',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFC2D86A),
        colorText: Colors.black,
      );
    } catch (e) {
      Get.snackbar(
        'Save Failed',
        'Could not save meals: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFF4444),
        colorText: Colors.white,
      );
    }
  }

  // ── Build API payload ──────────────────────────────────────────────────────
  Map<String, dynamic> _buildPayload() => {
    'goal': selectedGoal.value,
    'currentWeight': currentWeightController.text.trim(),
    'targetWeight': targetWeightController.text.trim(),
    'calories': kcalController.text.trim(),
    'protein': proteinController.text.trim(),
    'carbs': carbsController.text.trim(),
    'fats': fatsController.text.trim(),
    'dietType': dietType.value,
    'allergies': selectedAllergies.toList(),
    'cuisine': preferredCuisine.value,
    'mealsPerDay': mealsPerDay.value,
    'mealTypes': selectedMealTypes.isNotEmpty
        ? selectedMealTypes.toList()
        : mealTypesList.take(mealsPerDay.value).toList(),
    'includeFoods': specificFoodsController.text.trim(),
    'avoidFoods': foodsToAvoidController.text.trim(),
    'exerciseFrequency': exerciseFrequency.value,
    'exerciseType': exerciseType.value,
    'prePostWorkoutNutrition': prePostWorkoutNutrition.value,
    'medicalConditions': medicalConditionController.text.trim(),
    'specialInstructions': specialInstructionsController.text.trim(),
    'preferredStartDate': preferredStartDate.value?.toIso8601String(),
  };

  @override
  void onClose() {
    currentWeightController.dispose();
    targetWeightController.dispose();
    kcalController.dispose();
    carbsController.dispose();
    proteinController.dispose();
    fatsController.dispose();
    specificFoodsController.dispose();
    foodsToAvoidController.dispose();
    medicalConditionController.dispose();
    specialInstructionsController.dispose();
    super.onClose();
  }
}
