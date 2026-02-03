import 'package:get/get.dart';
import '../controllers/user_controller.dart';
import '../data/services/users_firestore_service.dart';
import '../data/services/meals_firestore_service.dart';
import '../modules/client_dashboard/controllers/client_dashboard_controllers.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Core services - Initialize first
    Get.lazyPut<UsersFirestoreService>(
      () => UsersFirestoreService(),
      fenix: true,
    );
    Get.lazyPut<MealsFirestoreService>(
      () => MealsFirestoreService(),
      fenix: true,
    );

    // Core controllers - Initialize after services
    Get.lazyPut<UserController>(() => UserController(), fenix: true);

    // Feature controllers
    Get.lazyPut<ClientDashboardControllers>(
      () => ClientDashboardControllers(),
      fenix: true,
    );
  }
}

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    // Essential services that need to be available immediately
    Get.put<UsersFirestoreService>(UsersFirestoreService(), permanent: true);
    Get.put<MealsFirestoreService>(MealsFirestoreService(), permanent: true);
    Get.put<UserController>(UserController(), permanent: true);
  }
}
