import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/meal_timing_controller.dart';

class MealTimingScreen extends GetView<MealTimingController> {
  const MealTimingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MealTimingView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'MealTimingView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
