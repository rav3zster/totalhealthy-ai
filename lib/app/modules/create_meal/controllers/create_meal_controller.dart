import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../routes/app_pages.dart';

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

  final RxString mealImage = ''.obs;

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

  var isEditing = false.obs;
  String? editingMealId;

  // Track hidden fields from source meal when editing/copying
  String _instructions = "No instructions provided";
  String _prepTime = "15 min";
  String _difficulty = "Easy";

  // Initialize controller with existing meal data for editing
  void populateForEdit(MealModel meal) {
    print("Populating form for edit: ${meal.name} (${meal.id})");
    isEditing.value = true;
    editingMealId = meal.id;

    // Populate text controllers
    fullNameController.text = meal.name;
    descriptionController.text = meal.description;
    kcalController.text = meal.kcal;
    carbsController.text = meal.carbs;
    proteinController.text = meal.protein;
    fatsController.text = meal.fat;

    // Populate image
    mealImage.value = meal.imageUrl;

    // Populate hidden fields
    _instructions = meal.instructions;
    _prepTime = meal.prepTime;
    _difficulty = meal.difficulty;

    // Populate categories
    selectedCategories.assignAll(meal.categories);

    // Populate ingredients
    ingredientControllers.clear();
    for (var ingredient in meal.ingredients) {
      ingredientControllers.add({
        'name': TextEditingController(text: ingredient.name),
        'amount': TextEditingController(text: ingredient.amount),
        'unit': TextEditingController(text: ingredient.unit),
      });
    }

    // Use existing prep time and difficulty if available (or defaults)
    // Note: Creating separate controllers for these if needed in future
  }

  // Populate controller with existing meal data for copying (creates new meal)
  void populateForCopy(MealModel meal) {
    print("Populating form for copy from: ${meal.name}");
    isEditing.value = false;
    editingMealId = null;

    // Populate text controllers
    fullNameController.text = "${meal.name} (Copy)"; // Append copy
    descriptionController.text = meal.description;
    kcalController.text = meal.kcal;
    carbsController.text = meal.carbs;
    proteinController.text = meal.protein;
    fatsController.text = meal.fat;

    // Populate image
    mealImage.value = meal.imageUrl;

    // Populate hidden fields
    _instructions = meal.instructions;
    _prepTime = meal.prepTime;
    _difficulty = meal.difficulty;

    // Populate categories
    selectedCategories.assignAll(meal.categories);

    // Populate ingredients
    ingredientControllers.clear();
    for (var ingredient in meal.ingredients) {
      ingredientControllers.add({
        'name': TextEditingController(text: ingredient.name),
        'amount': TextEditingController(text: ingredient.amount),
        'unit': TextEditingController(text: ingredient.unit),
      });
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

        // Extract userId from various possible locations
        final firebaseUid = authController.firebaseUser.value?.uid;
        final storageUserId = userId?.toString() ?? "";

        final finalUserId = storageUserId.isNotEmpty
            ? storageUserId
            : (firebaseUid ?? "unknown_user");

        print("DEBUG: Final UserID for upload: $finalUserId");
        print("DEBUG: Firebase UID: $firebaseUid");
        print("DEBUG: Argument UserID: $userId");

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
          id: isEditing.value ? editingMealId : null,
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
          imageUrl: mealImage.value.isEmpty
              ? "https://example.com/meal_placeholder.png"
              : mealImage.value,
          ingredients: cleanIngredients,
          instructions: _instructions,
          createdAt: DateTime.now(),
          prepTime: _prepTime,
          difficulty: _difficulty,
        );

        if (isEditing.value) {
          print("Updating Meal in Firestore: ${meal.toJson()}");
          await _mealsService.updateMeal(meal);

          Get.offAllNamed("${Routes.ClientDashboard}?id=$finalUserId");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Meal Updated Successfully!'),
              backgroundColor: Colors.blue,
            ),
          );
        } else {
          print("Creating New Meal in Firestore: ${meal.toJson()}");
          await _mealsService.addMeal(meal);

          // Check for 'from' parameter to determine navigation
          final fromRoute = Get.parameters['from'];

          if (fromRoute == 'group_details') {
            // Navigate back to group details
            Get.back();
          } else {
            // Default behavior
            Get.offAllNamed("${Routes.ClientDashboard}?id=$finalUserId");
          }

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Meal Created Successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      print("Error in submitUser: $e");
      String errorMessage = 'Error: $e';

      if (e.toString().contains('permission-denied')) {
        errorMessage = 'Permission Denied: Check Firestore Security Rules.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
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

  Future<void> pickAndUploadMealImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxWidth: 512,
        maxHeight: 512,
      );

      if (image != null) {
        final File file = File(image.path);
        final bytes = await file.readAsBytes();

        // Firestore limit check (aim for < 200KB for meal images)
        if (bytes.lengthInBytes > 500000) {
          Get.snackbar(
            'Error',
            'Image is too large. Please choose a smaller image.',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }

        mealImage.value = 'data:image/jpeg;base64,${base64Encode(bytes)}';
        Get.snackbar(
          'Success',
          'Meal image added',
          backgroundColor: const Color(0xFFC2D86A),
          colorText: Colors.black,
        );
      }
    } catch (e) {
      print('Error picking meal image: $e');
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
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
