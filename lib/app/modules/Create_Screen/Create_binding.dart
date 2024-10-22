import 'package:get/get.dart';
import 'package:totalhealthy/app/modules/Create_Screen/Create_controller.dart';


class CreateBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize the CreateController
    Get.lazyPut<CreateController>(() => CreateController());}
  }