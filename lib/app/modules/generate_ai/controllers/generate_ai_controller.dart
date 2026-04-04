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

  @override
  void onInit() {
    super.onInit();
    _loadSavedPreferences();
  }

  Future<void> _loadSavedPreferences() async {
    final prefs = await AiService.instance.loadPreferences();
    if (prefs['goal']?.isNotEmpty == true) selectedGoal.value = prefs['goal']!;
    if (prefs['dietType']?.isNotEmpty == true)
      dietType.value = prefs['dietType']!;
    if (prefs['cuisine']?.isNotEmpty == true)
      preferredCuisine.value = prefs['cuisine']!;
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
      // Persist preferences for next session
      AiService.instance.savePreferences(
        goal: selectedGoal.value,
        dietType: dietType.value,
        cuisine: preferredCuisine.value,
      );
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isGenerating.value = false;
    }
  }

  // ── Save a single meal to Firestore ──────────────────────────────────────
  Future<void> saveSingleMeal(AiGeneratedMeal meal) async {
    try {
      final auth = Get.find<AuthController>();
      final userId = auth.firebaseUser.value?.uid ?? '';
      final groupId = auth.groupgetId();
      await FirebaseFirestore.instance
          .collection('meals')
          .add(meal.toFirestoreMap(userId: userId, groupId: groupId));
      Get.snackbar(
        'Saved',
        '${meal.name} added to your plan',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFC2D86A),
        colorText: Colors.black,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Save Failed',
        'Could not save meal: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFF4444),
        colorText: Colors.white,
      );
    }
  }

  // ── Regenerate a single meal in-place ─────────────────────────────────────
  final RxSet<int> swappingIndices = <int>{}.obs;

  Future<void> regenerateSingleMeal(AiGeneratedMeal meal) async {
    final idx = generatedMeals.indexOf(meal);
    if (idx < 0) return;

    swappingIndices.add(idx);
    try {
      final replacement = await AiService.instance.regenerateSingleMeal(
        excludeMealName: meal.name,
        category: meal.category,
        userInputs: _buildPayload(),
      );
      if (replacement != null) {
        // replaceRange triggers GetX reactivity correctly
        generatedMeals.replaceRange(idx, idx + 1, [replacement]);
      } else {
        Get.snackbar(
          'No result',
          'Could not find a different ${meal.category}.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF1A1A1A),
          colorText: Colors.white70,
        );
      }
    } catch (_) {
      Get.snackbar(
        'Failed',
        'Could not swap meal. Try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFF4444),
        colorText: Colors.white,
      );
    } finally {
      swappingIndices.remove(idx);
    }
  }

  // ── Explain why a meal fits the user's goal ────────────────────────────────
  Future<void> explainMeal(AiGeneratedMeal meal) async {
    Get.dialog(
      _ExplainDialog(
        mealName: meal.name,
        goal: selectedGoal.value,
        dietType: dietType.value,
      ),
      barrierDismissible: true,
    );
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
    // Send previously generated meal names so the backend avoids repeating them
    'previousMeals': generatedMeals.map((m) => m.name).toList(),
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

// ── Explain Meal Dialog ───────────────────────────────────────────────────────

class _ExplainDialog extends StatefulWidget {
  final String mealName;
  final String goal;
  final String dietType;
  const _ExplainDialog({
    required this.mealName,
    required this.goal,
    required this.dietType,
  });

  @override
  State<_ExplainDialog> createState() => _ExplainDialogState();
}

class _ExplainDialogState extends State<_ExplainDialog> {
  String? _explanation;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final result = await AiService.instance.explainMeal(
      mealName: widget.mealName,
      goal: widget.goal,
      dietType: widget.dietType,
    );
    if (mounted)
      setState(() {
        _explanation = result;
        _loading = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF141414),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.auto_awesome_rounded,
                  color: Color(0xFFC2D86A),
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.mealName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Why this meal?',
              style: TextStyle(color: Colors.white38, fontSize: 12),
            ),
            const SizedBox(height: 16),
            if (_loading)
              const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xFFC2D86A),
                  ),
                ),
              )
            else
              Text(
                _explanation ?? 'Could not generate explanation.',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC2D86A),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Got it',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
