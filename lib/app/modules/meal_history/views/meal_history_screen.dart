import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/meal_history_controller.dart';
import '../widgets/meal_history_page.dart';

class MealHistoryScreen extends GetView<MealHistoryController> {
  const MealHistoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    String id = Get.parameters["id"] ?? '';
    return MealHistoryPage(id: id, controller: controller);
  }
}
