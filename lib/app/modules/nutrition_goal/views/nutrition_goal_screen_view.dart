import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/nutrition_goal_controller.dart';
import 'nutrition_goal_screen.dart';

class NutritionGoalScreenView extends GetView<NutritionGoalController> {
  const NutritionGoalScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    return NutritionGoalsScreen();
  }
}
