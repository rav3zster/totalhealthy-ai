import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/create_meal_controller.dart';
import 'create_meal_page.dart';

class CreateMealScreen extends GetView<CreateMealController> {
  const CreateMealScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CreateMealPage(
      controller: controller,
    );
  }
}
