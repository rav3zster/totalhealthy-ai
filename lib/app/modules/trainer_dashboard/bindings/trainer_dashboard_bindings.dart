import 'package:get/get.dart';

import '../controllers/trainer_dashboard_controller.dart';

class TrainerDashboardBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrainerDashboardControllers>(
            () => TrainerDashboardControllers()
    );
  }
}
