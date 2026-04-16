import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
class LoginController extends GetxController {
  // Define reactive variables for email and password (you can track states here)
  var email = ''.obs;
  var password = ''.obs;

  // Function to handle login action
  void login() {
    // Handle login logic here, like making API calls
    debugPrint('Login with email: $email and password: $password');
  }

  void togglePasswordVisibility() {
    // Handle visibility toggle logic
  }
}
