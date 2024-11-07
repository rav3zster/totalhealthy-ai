import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManageAccountController extends GetxController {
  final TextEditingController userNameController = TextEditingController(text: "ayushshukla123");
  final TextEditingController emailController = TextEditingController(text: "ayushshukla@gmail.com");
  final TextEditingController contactController = TextEditingController(text: "9876543210");
  final TextEditingController passwordController = TextEditingController(text: "...........o09");

  // Save data method (placeholder for actual save functionality)
  void saveData() {
    // Implement save logic, like updating backend or local storage
    Get.snackbar("Success", "Account information saved successfully.");
  }

  @override
  void onClose() {
    userNameController.dispose();
    emailController.dispose();
    contactController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
