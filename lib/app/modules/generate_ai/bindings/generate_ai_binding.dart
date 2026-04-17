import 'package:get/get.dart';

import '../controllers/generate_ai_controller.dart';

class GenerateAiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GenerateAiController>(
      () => GenerateAiController(),
      fenix: true,
    );
  }
}
