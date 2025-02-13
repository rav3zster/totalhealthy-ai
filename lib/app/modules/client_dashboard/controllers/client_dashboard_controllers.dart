import 'package:get/get.dart';
import 'package:totalhealthy/app/core/base/controllers/auth_controller.dart';

class ClientDashboardControllers extends GetxController {
  //TODO: Implement HomeController

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    // Get.find<AuthController>().fetchAndScheduleNotifications();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
