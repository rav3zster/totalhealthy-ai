import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/base/controllers/auth_controller.dart';
import '../../../data/models/meal_model.dart';
import '../../../data/services/meals_firestore_service.dart';

class CreateMealController extends GetxController {
  final MealsFirestoreService _mealsService = MealsFirestoreService();
  final fullNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final kcalController = TextEditingController();
  final carbsController = TextEditingController();
  final proteinController = TextEditingController();
  final fatsController = TextEditingController();

  var ingredientControllers = <Map<String, dynamic>>[].obs;
  var selectedCategories = <String>[].obs;
  var calculateAutomatically = false.obs;
  var categoryError = ''.obs; // Add category error tracking

  final List<String> categories = [
    "Breakfast",
    "Lunch",
    "Morning Snacks",
    "Preworkout",
    "Post Workout",
    "Dinner",
  ];

  GlobalKey<FormState> key = GlobalKey<FormState>();

  var isLoading = false.obs;

  // Validate categories selection
  bool validateCategories() {
    if (selectedCategories.isEmpty) {
      categoryError.value = 'Please select at least one category';
      return false;
    }
    categoryError.value = '';
    return true;
  }

  // Clear category error when user selects a category
  void onCategoryChanged(String category, bool selected) {
    if (selected == true) {
      selectedCategories.add(category);
    } else {
      selectedCategories.remove(category);
    }

    // Clear error when user makes a selection
    if (selectedCategories.isNotEmpty && categoryError.value.isNotEmpty) {
      categoryError.value = '';
    }
  }

  //  {"name": "string", "amount": "string", "unit": "string"}
  submitUser(context, userId) async {
    try {
      // Validate form and categories
      bool isFormValid = key.currentState!.validate();
      bool areCategoriesValid = validateCategories();

      if (isFormValid && areCategoriesValid) {
        isLoading.value = true;

        final authController = Get.find<AuthController>();
        final groupId = authController.groupgetId();
        final finalUserId = (userId == null || userId.toString().isEmpty)
            ? (authController.firebaseUser.value?.uid ?? "unknown_user")
            : userId.toString();

        // Clean ingredients: Extract text from controllers and convert to plain list
        final List<IngredientModel> cleanIngredients = ingredientControllers
            .map((item) {
              return IngredientModel(
                name: item["name"] is TextEditingController
                    ? (item["name"] as TextEditingController).text
                    : item["name"].toString(),
                amount: item["amount"] is TextEditingController
                    ? (item["amount"] as TextEditingController).text
                    : item["amount"].toString(),
                unit: item["unit"] is TextEditingController
                    ? (item["unit"] as TextEditingController).text
                    : (item["unit"]?.toString() ?? ""),
              );
            })
            .toList();

        final meal = MealModel(
          userId: finalUserId,
          groupId: groupId,
          name: fullNameController.text.trim(),
          description: descriptionController.text.trim(),
          kcal: kcalController.text.trim().isEmpty
              ? "0"
              : kcalController.text.trim(),
          carbs: carbsController.text.trim().isEmpty
              ? "0"
              : carbsController.text.trim(),
          protein: proteinController.text.trim().isEmpty
              ? "0"
              : proteinController.text.trim(),
          fat: fatsController.text.trim().isEmpty
              ? "0"
              : fatsController.text.trim(),
          categories: selectedCategories.toList(),
          imageUrl:
              "https://example.com/meal_placeholder.png", // Default placeholder
          ingredients: cleanIngredients,
          instructions: "No instructions provided", // Default or empty
          createdAt: DateTime.now(),
          prepTime: "15 min", // Default value
          difficulty: "Easy", // Default value
        );

        print("Submitting Meal to Firestore: ${meal.toJson()}");

        await _mealsService.addMeal(meal);

        Get.back(); // Go back to the previous screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Meal Created Successfully in Firestore!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print("Error in submitUser: $e");
      String errorMessage = 'Error creating meal: $e';

      if (e.toString().contains('permission-denied')) {
        errorMessage =
            'Permission Denied: Please check your Firestore Security Rules in the Firebase Console and ensure you have write access to the "meals" collection.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'HELP',
            textColor: Colors.white,
            onPressed: () {
              Get.defaultDialog(
                title: "Permission Error",
                middleText:
                    "This error usually means your Firebase Firestore rules are blocking the save operation. Please ensure authenticated users have write access to the 'meals' collection.",
                textConfirm: "OK",
                confirmTextColor: Colors.white,
                onConfirm: () => Get.back(),
              );
            },
          ),
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void addIngredientRow() {
    ingredientControllers.add({
      'name': TextEditingController(),
      'amount': TextEditingController(),
      'unit': TextEditingController(),
    });
  }

  void removeIngredientRow(int index) {
    ingredientControllers.removeAt(index);
  }

  // GlobalKey<FormState> key = GlobalKey<FormState>();
  // bool isLoading = false;
  // Future<void> submitUser() async {
  //   try {
  //     if (key.currentState!.validate()) {
  //       setState(() {
  //         isLoading = true;
  //       });
  //       var data = {
  //         "groupId": fullNameController,
  //         "userId": "string",
  //         "from_date": "2024-10-28T09:58:53.243Z",
  //         "to_date": "2024-10-28T09:58:53.243Z",
  //         "imageUrl": "https://example.com/",
  //         "categorys": [
  //           "string"
  //         ],
  //         "name": "string",
  //         "description": descriptionController,
  //         "ingredients": [
  //           {
  //             "name": "string",
  //             "amount": "string",
  //             "unit": "string"
  //           }
  //         ],
  //         "created_at": "2024-10-28T09:58:53.243Z"
  //       };
  //       print(data);
  //       // signupUser(
  //       //   APIEndpoints.auth.signup,
  //       //   data,
  //       // );
  //       await APIMethods.post
  //           .post(url: APIEndpoints.auth.signup, map: data)
  //           .then((value) {
  //         if (APIStatus.success(value.statusCode)) {
  //           print(value.data);
  //           // clearDetails();
  //           Get.toNamed(Routes.Login);
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             const SnackBar(
  //               content: Text('Sign Up Successful!'),
  //               backgroundColor: Colors.green,
  //             ),
  //           );
  //         } else {
  //           printError("Error ", "Signup", value.data);
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             const SnackBar(
  //               content:
  //               Text('You must agree to the Terms & Privacy to sign up.'),
  //               backgroundColor: Colors.red,
  //             ),
  //           );
  //         }
  //       });
  //     }
  //   } catch (e) {
  //     print(e);
  //   } finally {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  //   // if (_formKey.currentState!.validate()) {
  // }
  void printMealData() {
    print("Meal Name: ${fullNameController.text}");
    print("Description: ${descriptionController.text}");
    print("Selected Categories: $selectedCategories");
    print("Ingredients:");
    print(ingredientControllers);
    for (var controller in ingredientControllers) {
      print(
        "Name: ${controller['name']!.text}, Amount: ${controller['amount']!.text}",
      );
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
