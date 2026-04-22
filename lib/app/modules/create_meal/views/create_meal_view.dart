import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/create_meal_controller.dart';
import 'create_meal_page.dart';
import 'create_meal_web_view.dart';

class CreateMealScreen extends GetView<CreateMealController> {
  const CreateMealScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String id = Get.parameters["id"] ?? "";
    // Use web layout on wide screens or web platform
    final isWide = MediaQuery.of(context).size.width >= 900;
    if (kIsWeb || isWide) {
      return CreateMealWebView(id: id, controller: controller);
    }
    return CreateMealPage(id: id, controller: controller);
  }
}
