import 'package:flutter/material.dart';

import '../../../core/base/views/base_view.dart';
import 'nutrition_goal_screen_view.dart';

class NutritionGoalView extends BaseView {
  NutritionGoalView({super.key});

  @override
  Widget vBuilderTablet() {
    return const NutritionGoalScreenView();
  }

  @override
  Widget vBuilderDesktop() {
    return const NutritionGoalScreenView();
  }

  @override
  Widget vBuilderPhone() {
    return const NutritionGoalScreenView();
  }
}
