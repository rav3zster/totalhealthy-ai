import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/meal_history_controller.dart';
import 'meal_history_page.dart';

class MealHistoryScreen extends GetView<MealHistoryController> {
  const MealHistoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const MealHistoryPage();
  }
}
