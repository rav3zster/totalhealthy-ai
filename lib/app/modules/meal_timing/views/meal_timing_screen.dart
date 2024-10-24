import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:totalhealthy/app/modules/meal_timing/widgets/meal_timing_page.dart';

import '../controllers/meal_timing_controller.dart';

class MealTimingScreen extends GetView<MealTimingController> {
  const MealTimingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return MealTimingPage();
  }
}
