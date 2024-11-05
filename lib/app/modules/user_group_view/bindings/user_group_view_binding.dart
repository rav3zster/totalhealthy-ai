import 'package:get/get.dart';

import '../controllers/user_group_view_controller.dart';

class UserGroupViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserGroupViewController>(
      () => UserGroupViewController(),
    );
  }
}
