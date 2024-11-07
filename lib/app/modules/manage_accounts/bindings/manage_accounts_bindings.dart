// bindings/manage_account_binding.dart
import 'package:get/get.dart';

import '../controllers/manage_accounts_controllers.dart';

class ManageAccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ManageAccountController>(() => ManageAccountController());
  }
}
