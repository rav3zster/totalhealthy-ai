import 'package:get/get.dart';
import '../controllers/user_controller.dart';
import '../data/services/users_firestore_service.dart';
import '../data/services/meals_firestore_service.dart';
import '../data/services/group_meal_plans_firestore_service.dart';
import '../modules/client_dashboard/controllers/client_dashboard_controllers.dart';
import '../modules/group/controllers/group_controller.dart';

import '../data/services/storage_service.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Core services - Initialize first (already done in InitialBindings)
    if (!Get.isRegistered<UsersFirestoreService>()) {
      Get.put<UsersFirestoreService>(UsersFirestoreService(), permanent: true);
    }
    if (!Get.isRegistered<MealsFirestoreService>()) {
      Get.put<MealsFirestoreService>(MealsFirestoreService(), permanent: true);
    }
    if (!Get.isRegistered<GroupMealPlansFirestoreService>()) {
      Get.put<GroupMealPlansFirestoreService>(
        GroupMealPlansFirestoreService(),
        permanent: true,
      );
    }
    if (!Get.isRegistered<StorageService>()) {
      Get.put<StorageService>(StorageService(), permanent: true);
    }

    // Core controllers - Initialize immediately, not lazily
    if (!Get.isRegistered<UserController>()) {
      Get.put<UserController>(UserController(), permanent: true);
    }

    // Feature controllers - Initialize immediately for dashboard
    if (!Get.isRegistered<ClientDashboardControllers>()) {
      Get.put<ClientDashboardControllers>(
        ClientDashboardControllers(),
        permanent: true,
      );
    }

    // Groups controller - Initialize for groups functionality
    if (!Get.isRegistered<GroupController>()) {
      Get.put<GroupController>(GroupController(), permanent: true);
    }
  }
}

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    // Essential services that need to be available immediately
    Get.put<UsersFirestoreService>(UsersFirestoreService(), permanent: true);
    Get.put<MealsFirestoreService>(MealsFirestoreService(), permanent: true);
    Get.put<GroupMealPlansFirestoreService>(
      GroupMealPlansFirestoreService(),
      permanent: true,
    );
    Get.put<StorageService>(StorageService(), permanent: true);
    Get.put<UserController>(UserController(), permanent: true);
  }
}
