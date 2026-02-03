import 'package:get/get.dart';

import '../controllers/setting_controller.dart';
import '../controllers/account_password_controller.dart';

class SettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingController>(() => SettingController());
    Get.lazyPut<AccountPasswordController>(() => AccountPasswordController());
  }
}
