import 'package:flutter/material.dart';

import '../../../core/base/views/base_view.dart';

import 'generate_ai_screen.dart';

class GenerateAiView extends BaseView {
  GenerateAiView({super.key});

  @override
  Widget vBuilderTablet() {
    return const GenerateAiScreen();
  }

  @override
  Widget vBuilderDesktop() {
    return const GenerateAiScreen();
  }

  @override
  Widget vBuilderPhone() {
    return const GenerateAiScreen();
  }
}
