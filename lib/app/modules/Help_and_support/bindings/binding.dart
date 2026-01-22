import 'package:get/get.dart';

import '../controllers/controller.dart';



class HelpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HelpController>(
          () => HelpController(),
    );
  }
}