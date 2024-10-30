import 'package:get/get.dart';

class RegistrationController extends GetxController {
  var isMaleSelected = false.obs;
  var isFemaleSelected = false.obs;

  void selectMale() {
    isMaleSelected.value = true;
    isFemaleSelected.value = false;
  }

  void selectFemale() {
    isFemaleSelected.value = true;
    isMaleSelected.value = false;
  }

  void goToSignup() {
    Get.toNamed('/signup'); // Adjust the route as per your project
  }
}
