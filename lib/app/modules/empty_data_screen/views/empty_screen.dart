import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:totalhealthy/app/modules/empty_data_screen/controllers/empty_data_screen_controllers.dart';

import '../widgets/empty_page.dart';

class EmptyScreen extends GetView<EmptyScreenController> {
  const EmptyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String id = Get.parameters["id"] ?? "";
    return EmptyPage(id: id, controller: controller);
  }
}
