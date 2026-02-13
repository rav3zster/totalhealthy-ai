import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';

class SplashController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GetStorage _storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    // Start immediately in onInit to prevent any other screen from showing
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    try {
      final User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        // User is logged in - navigate immediately (no delay)
        final userData = _storage.read('userdata');

        if (userData != null && userData is Map) {
          final role = userData['role'] as String?;

          // Navigate immediately based on role
          if (role == 'trainer' || role == 'admin' || role == 'advisor') {
            Get.offAllNamed('/trainerdashboard');
          } else {
            Get.offAllNamed('/clientdashboard');
          }
        } else {
          // No role data, default to client dashboard
          Get.offAllNamed('/clientdashboard');
        }
      } else {
        // User not logged in - show splash briefly then navigate to onboarding
        await Future.delayed(const Duration(milliseconds: 2000));
        Get.offAllNamed('/onboarding');
      }
    } catch (e) {
      // Error occurred - show splash briefly then navigate to onboarding
      await Future.delayed(const Duration(milliseconds: 2000));
      Get.offAllNamed('/onboarding');
    }
  }
}
