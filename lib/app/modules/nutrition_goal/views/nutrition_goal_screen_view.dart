import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:totalhealthy/app/widgets/base_screen.dart';

import '../controllers/nutrition_goal_controller.dart';
import '../widgets/nutrition_goal_screen.dart';

class NutritionGoalScreenView extends GetView<NutritionGoalController> {
  const NutritionGoalScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    return NutritionGoalsScreen();
  }
}
