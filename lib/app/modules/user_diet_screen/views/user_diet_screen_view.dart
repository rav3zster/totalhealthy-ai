import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:totalhealthy/app/modules/user_diet_screen/controllers/user_diet_screen_controllers.dart';

import '../../../widgets/user_diet_page.dart';

class UserDietScreen extends GetView<UserDietScreenController> {
  const UserDietScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String id = Get.parameters["id"] ?? "";
    return UserDietPage(id: id, controller: controller);
  }
}
