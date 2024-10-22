import 'package:get/get.dart';

class SignupController extends GetxController {
  // Gender selection state
  var isMaleSelected = false.obs;
  var isFemaleSelected = false.obs;

  // Form fields
  var fullName = ''.obs;
  var email = ''.obs;
  var password = ''.obs;

  // Toggle gender selection
  void selectMale() {
    isMaleSelected.value = true;
    isFemaleSelected.value = false;
  }

  void selectFemale() {
    isMaleSelected.value = false;
    isFemaleSelected.value = true;
  }

  // Validate and process the signup form
  void submitSignupForm() {
    if (fullName.value.isNotEmpty && email.value.isNotEmpty && password.value.isNotEmpty) {
      // Process the signup logic here
      print("Sign up successful");
    } else {
      // Handle form validation failure
      print("Please fill all the fields");
    }
  }
}
