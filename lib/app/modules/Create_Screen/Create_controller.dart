// controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateController extends GetxController {
  // TextEditingControllers for text fields
  final recipeNameController = TextEditingController();
  final categoryController = TextEditingController();
  final descriptionController = TextEditingController();
  final ingredientController1 = TextEditingController();
  final ingredientController2 = TextEditingController();
  final ingredientController3 = TextEditingController();
  final qtyController1 = TextEditingController();
  final qtyController2 = TextEditingController();
  final qtyController3 = TextEditingController();

  // Reactive integer values for increment/decrement fields
  var value1 = 500.obs;
  var value2 = 500.obs;
  var value3 = 500.obs;
  var value4 = 500.obs;

  // Reactive boolean values for pressed states
  var isDecrementPressed1 = false.obs;
  var isIncrementPressed1 = false.obs;
  var isDecrementPressed2 = false.obs;
  var isIncrementPressed2 = false.obs;
  var isDecrementPressed3 = false.obs;
  var isIncrementPressed3 = false.obs;
  var isDecrementPressed4 = false.obs;
  var isIncrementPressed4 = false.obs;

  var isSwitched = false.obs;

  // Increment function
  void increment(int index) {
    switch (index) {
      case 1:
        value1.value++;
        isIncrementPressed1.value = true;
        Future.delayed(const Duration(milliseconds: 200), () {
          isIncrementPressed1.value = false;
        });
        break;
      case 2:
        value2.value++;
        isIncrementPressed2.value = true;
        Future.delayed(const Duration(milliseconds: 200), () {
          isIncrementPressed2.value = false;
        });
        break;
      case 3:
        value3.value++;
        isIncrementPressed3.value = true;
        Future.delayed(const Duration(milliseconds: 200), () {
          isIncrementPressed3.value = false;
        });
        break;
      case 4:
        value4.value++;
        isIncrementPressed4.value = true;
        Future.delayed(const Duration(milliseconds: 200), () {
          isIncrementPressed4.value = false;
        });
        break;
    }
  }

  // Decrement function
  void decrement(int index) {
    switch (index) {
      case 1:
        value1.value--;
        isDecrementPressed1.value = true;
        Future.delayed(const Duration(milliseconds: 200), () {
          isDecrementPressed1.value = false;
        });
        break;
      case 2:
        value2.value--;
        isDecrementPressed2.value = true;
        Future.delayed(const Duration(milliseconds: 200), () {
          isDecrementPressed2.value = false;
        });
        break;
      case 3:
        value3.value--;
        isDecrementPressed3.value = true;
        Future.delayed(const Duration(milliseconds: 200), () {
          isDecrementPressed3.value = false;
        });
        break;
      case 4:
        value4.value--;
        isDecrementPressed4.value = true;
        Future.delayed(const Duration(milliseconds: 200), () {
          isDecrementPressed4.value = false;
        });
        break;
    }
  }

  @override
  void onClose() {
    // Dispose controllers to free resources
    recipeNameController.dispose();
    categoryController.dispose();
    descriptionController.dispose();
    ingredientController1.dispose();
    ingredientController2.dispose();
    ingredientController3.dispose();
    qtyController1.dispose();
    qtyController2.dispose();
    qtyController3.dispose();
    super.onClose();
  }
}
