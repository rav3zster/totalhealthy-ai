import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateMealController extends GetxController {
  final fullNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final kcalController = TextEditingController();
  final carbsController = TextEditingController();
  final proteinController = TextEditingController();
  final fatsController = TextEditingController();

  var ingredientControllers = <Map<String, TextEditingController>>[].obs;
  var selectedCategories = <String>[].obs;
  var calculateAutomatically = false.obs;

  final List<String> categories = [
    "Breakfast",
    "Lunch",
    "Morning Snacks",
    "Preworkout",
    "Post Workout",
    "Dinner",
  ];

  void addIngredientRow() {
    ingredientControllers.add({
      'name': TextEditingController(),
      'amount': TextEditingController(),
    });
  }

  void removeIngredientRow(int index) {
    ingredientControllers.removeAt(index);
  }

  void printMealData() {
    print("Meal Name: ${fullNameController.text}");
    print("Description: ${descriptionController.text}");
    print("Selected Categories: $selectedCategories");
    print("Ingredients:");
    for (var controller in ingredientControllers) {
      print("Name: ${controller['name']!.text}, Amount: ${controller['amount']!.text}");
    }
    if (calculateAutomatically.value) {
      print("Nutritional Info: Calculated Automatically");
    } else {
      print("kcal: ${kcalController.text}");
      print("Carbs: ${carbsController.text}");
      print("Protein: ${proteinController.text}");
      print("Fats: ${fatsController.text}");
    }
  }
}
