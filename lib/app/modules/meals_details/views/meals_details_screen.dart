import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/meals_details_controller.dart';
import 'meals_details_page.dart';

class MealsDetailsScreen extends GetView<MealsDetailsController> {
  const MealsDetailsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    String id = Get.parameters["id"] ?? "";

    return MealsDetailsPage(id: id, controller: controller);
  }
}
