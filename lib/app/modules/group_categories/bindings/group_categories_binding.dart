import 'package:get/get.dart';
import '../controllers/group_categories_controller.dart';

class GroupCategoriesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GroupCategoriesController>(() => GroupCategoriesController());
  }
}
