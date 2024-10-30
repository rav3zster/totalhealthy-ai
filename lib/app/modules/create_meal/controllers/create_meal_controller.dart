import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/base/apiservice/api_endpoints.dart';
import '../../../core/base/apiservice/api_status.dart';
import '../../../core/base/apiservice/base_methods.dart';
import '../../../core/base/controllers/auth_controller.dart';

class CreateMealController extends GetxController {
  final fullNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final kcalController = TextEditingController();
  final carbsController = TextEditingController();
  final proteinController = TextEditingController();
  final fatsController = TextEditingController();

  var ingredientControllers = <Map<String, dynamic>>[].obs;
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

  GlobalKey<FormState> key = GlobalKey<FormState>();

  var isLoading = false.obs;
//  {"name": "string", "amount": "string", "unit": "string"}
  submitUser(context, userId) async {
    DateTime now = DateTime.now();
    int timestamp = now.millisecondsSinceEpoch;
    try {
      String id = userId.toString();
      if (key.currentState!.validate()) {
        isLoading.value = true;

        Map<String, dynamic> data = {
          "groupId": Get.find<AuthController>().groupId.value,
          "userId": id,
          "from_date": "2024-10-29T10:08:30.384Z",
          "to_date": "2024-10-29T10:08:30.384Z",
          "imageUrl": "https://example.com/",
          "categorys": selectedCategories,
          "name": fullNameController.text.trim(),
          "description": descriptionController.text.trim(),
          "ingredients": ingredientControllers,
          "created_at": "$timestamp"
        };

        print(data);

        await APIMethods.post
            .post(url: APIEndpoints.createData.createMeal, map: data)
            .then((value) {
          if (APIStatus.success(value.statusCode)) {
            // clearDetails();

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Create Meal Successful!'),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            // printError("Auth Controller", "Signup", value.data);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Meals not created'),
                backgroundColor: Colors.red,
              ),
            );
          }
        });
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
    // if (_formKey.currentState!.validate()) {
  }

  void addIngredientRow() {
    ingredientControllers.add({
      'name': TextEditingController(),
      'amount': TextEditingController(),
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
          "Name: ${controller['name']!.text}, Amount: ${controller['amount']!.text}");
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
