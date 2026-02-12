import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GenerateAiController extends GetxController {
  // Dietary Goals
  final RxString selectedGoal = ''.obs;
  final currentWeightController = TextEditingController();
  final targetWeightController = TextEditingController();
  final kcalController = TextEditingController();
  final carbsController = TextEditingController();
  final proteinController = TextEditingController();
  final fatsController = TextEditingController();

  // Diet Preference And Restriction
  final RxString dietType = ''.obs;
  final RxList<String> selectedAllergies = <String>[].obs;
  final RxString preferredCuisine = ''.obs;

  // Meal Preference
  final RxInt mealsPerDay = 2.obs;
  final RxList<String> selectedMealTypes = <String>[].obs;
  final specificFoodsController = TextEditingController();
  final foodsToAvoidController = TextEditingController();

  // Physical Activity
  final RxString exerciseFrequency = ''.obs;
  final RxString exerciseType = ''.obs;
  final RxString prePostWorkoutNutrition = ''.obs;

  // Additional Info
  final medicalConditionController = TextEditingController();
  final Rx<DateTime?> preferredStartDate = Rx<DateTime?>(null);
  final specialInstructionsController = TextEditingController();

  // Options Data
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

  void selectGoal(String goal) => selectedGoal.value = goal;

  void selectDietType(String type) => dietType.value = type;

  void toggleAllergy(String allergy) {
    if (selectedAllergies.contains(allergy)) {
      selectedAllergies.remove(allergy);
    } else {
      if (allergy == 'Not Specific')
        selectedAllergies.clear();
      else
        selectedAllergies.remove('Not Specific');
      selectedAllergies.add(allergy);
    }
  }

  void selectCuisine(String cuisine) => preferredCuisine.value = cuisine;

  void incrementMeals() {
    if (mealsPerDay.value < 8) mealsPerDay.value++;
  }

  void decrementMeals() {
    if (mealsPerDay.value > 1) mealsPerDay.value--;
  }

  void toggleMealType(String type) {
    if (selectedMealTypes.contains(type)) {
      selectedMealTypes.remove(type);
    } else {
      selectedMealTypes.add(type);
    }
  }

  void selectFrequency(String freq) => exerciseFrequency.value = freq;

  void selectExerciseType(String type) => exerciseType.value = type;

  void selectPrePostNutrition(String value) =>
      prePostWorkoutNutrition.value = value;

  void selectDate(DateTime date) => preferredStartDate.value = date;

  void generatePlan() {
    // Logic for AI generation will go here
    print("Generating Plan...");
  }

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
