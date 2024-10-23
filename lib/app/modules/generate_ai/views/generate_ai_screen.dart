import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/generate_ai_controller.dart';
import '../widgets/generate_ai_page.dart';

class GenerateAiScreen extends GetView<GenerateAiController> {
  const GenerateAiScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return GenerateAiPage();
  }
}
