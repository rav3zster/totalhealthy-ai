import 'package:get/get.dart';

import '../controllers/client_dashboard_controllers.dart';







class ClientDashboardBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClientDashboardControllers>(
            () => ClientDashboardControllers()
    );
  }
}
